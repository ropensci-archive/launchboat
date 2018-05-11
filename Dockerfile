FROM rocker/geospatial:latest
MAINTAINER noam.ross@gmail.com

# RUN Rscript -e "remove.packages(setdiff(rownames(installed.packages(priority = 'NA')), c('devtools', 'roxygen2', 'goodpractice', unique(unlist(tools::package_dependencies(c('devtools', 'roxygen2', 'goodpractice'), recursive = TRUE))))))" \

RUN install2.r \
  argparse \
  fs \
  shiny \
  goodpractice \
 && installGithub.r \
   hrbrmstr/cloc \
   hrbrmstr/fileio \
   r-lib/devtools \
   r-lib/pkgdepends@6b992405f449a9ba963104892b4929296071a90b \
   ropenscilabs/pkgreviewr

WORKDIR /home/rstudio/pkg

COPY pkgtest.R /usr/local/bin

CMD pkgtest.R .


