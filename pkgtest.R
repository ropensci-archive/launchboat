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

if(R.utils::isUrl(args$package)) {
  git2r::clone(url = args$package, local_path = args$local_dir)
  setwd(args$local_dir)
} else if ({
  setwd(args$package)
}

devtools::install_deps(dependencies = TRUE)
devtools::install(build_vignettes = args$build_vignettes)
if(args$build_vignettes) {
  devtools::build_vignettes()
}
report <- pkgreviewer:pkg_report()


