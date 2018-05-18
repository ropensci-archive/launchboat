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
args$local_dir <- normalizePath(args$local_dir)
if(R.utils::isUrl(args$package)) {
  git2r::clone(url = args$package, local_path = args$local_dir)
} else {
  args$local_dir <- args$package
}
setwd(args$local_dir)


devtools::install_deps(dependencies = TRUE, verbose = FALSE)
devtools::install(build_vignettes = args$build_vignettes, verbose = FALSE)
if(args$build_vignettes) {
  devtools::build_vignettes()
}

outfile <- file.path(tempdir(), "pkg-report.html")
rmarkdown::render("/home/rstudio/pkg-report.Rmd", params=list(pkgdir = args$local_dir),
                  output_file = outfile, envir = new.env(),
                  knit_root_dir = args$local_dir, quiet = FALSE)
#devtools::install_github("hrbrmstr/fileio")
fi_url <- fileio::fi_post_file(outfile)
cat(fi_url$link)
