FROM rocker/geospatial:latest
MAINTAINER noam.ross@gmail.com

RUN install2.r \
  argparse \
  fs \
  shiny \
  goodpractice \
  spelling \
  DT \
  formattable \
 && installGithub.r \
   hrbrmstr/cloc \
   hrbrmstr/fileio \
   r-lib/devtools \
   r-lib/pkgdepends@6b992405f449a9ba963104892b4929296071a90b \
   ropenscilabs/pkgreviewr

WORKDIR /home/rstudio/pkg

COPY pkgtest.R /usr/local/bin
COPY coverage-report-widget.R /home/rstudio
COPY pkg-report.Rmd /home/rstudio

CMD pkgtest.R .


