FROM rocker/geospatial:latest
MAINTAINER noam.ross@gmail.com

# RUN Rscript -e "remove.packages(setdiff(rownames(installed.packages(priority = 'NA')), c('devtools', 'roxygen2', 'goodpractice', unique(unlist(tools::package_dependencies(c('devtools', 'roxygen2', 'goodpractice'), recursive = TRUE))))))" \

RUN install2.r argparse fs \
 && installGithub.r MangoTheCat/goodpractice hrbrmstr/cloc ropenscilabs/pkgreviewr

WORKDIR /home/rstudio/pkg

COPY pkgtest.R /usr/local/bin

CMD pkgtest.R .


