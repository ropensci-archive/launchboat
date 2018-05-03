#!/usr/bin/env Rscript

# Parse Inputs

suppressPackageStartupMessages(library("argparse"))
parser <- ArgumentParser()
parser$add_argument("package", nargs=1, help="file path or github repo link", default = ".")
parser$add_argument("--local_dir", nargs=1, help="if cloning a package, where to put it, defaults to package name", default = ".")
parser$add_argument("--outdir", nargs=1, help="location for output results", default = "ro-check")
parser$add_argument("--rstudio", nargs=1, help="whether to launch an RStudio server", default = TRUE)
parser$add_argument("--build_vignettes", nargs=1, help="whether to build vignettes", default = TRUE)
args <- parser$parse_args()

# Fetch or find the package and paths

message('Fetching package')
if(!dir.exists(args$package)) {
  git2r::clone(url = args$package, local_path = args$local_dir)
  setwd(args$local_dir)
} else {
  setwd(args$package)
}

if(!dir.exists(args$outdir)) dir.create(args$outdir)

# Install the package dependencies
message('Installing Dependencies')

devtools::install_deps(dependencies = TRUE)

# Run all the things
message('Running all the checks')

gp_obj <- goodpractice::gp()

tests <- devtools::test(reporter = testthat::ListReporter)

# Eventually show the package dependency tree
#deps <- pkgdepends::remotes$new("r-lib/usethis", lib = tempfile())
#deps$solve()
#r$draw_tree()

# Eventually show analysis of lines of code
# pkg_lines <- cloc::cloc(package_loc)
# file_lines <- cloc::cloc_by_file(package_loc

# Save all the things
pkgname <- gp_obj$package
if(dir.exists(args$outdir)) unlink(args$outdir, recursive = TRUE, force = TRUE)
dir.create(args$outdir)
tp <- function(suffix, mydir = args$outdir, pkg = gp_obj$package) {
  file.path(mydir, paste0(pkg, suffix))
}

saveRDS(tests, file = tp("-testresults.rds"))

tcf <- file.path(tempdir(), "covr-report.html")
covr::report(x = gp_obj$covr$coverage,
             file = tcf,
             browse = FALSE)
fs::file_copy(tcf, tp("-coverage.html"), overwrite = TRUE)

cat(gp_obj$rcmdcheck$output$stderr,
    file = tp("-rcmdcheck.txt"))
cat("\n----------\n",
    file = tp("-rcmdcheck.txt"),
    append = TRUE)
cat(gp_obj$rcmdcheck$output$stdout,
    file = tp("-rcmdcheck.txt"),
    append = TRUE)

saveRDS(gp_obj,
        file = tp("-goodpractice.rds"))

cat(capture.output(print(gp_obj)), sep = "\n",
    file = tp("-goodpractice.txt"))


# Build vignettes if needed
if(args$build_vignettes) {
  devtools::build_vignettes()
  if(fs::dir_exists("inst/doc")) fs::dir_copy("inst/doc", fs::path(args$outdir, "doc"))
}
