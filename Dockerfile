FROM rocker/geospatial:latest
MAINTAINER noam.ross@gmail.com

RUN Rscript -e "remove.packages(setdiff(rownames(installed.packages(priority = 'NA')), c('devtools', 'roxygen2', 'goodpractice', unique(unlist(tools::package_dependencies(c('devtools', 'roxygen2', 'goodpractice'), recursive = TRUE))))))" \
  && Rscript -e "install.packages(c('argparse'))"
  && Rscript -e "devtools::install_github(c('MangoTheCat/goodpractice', 'hrbrmstr/cloc'))"

CMD Rscript -e "cat(rownames(installed.packages()))"


