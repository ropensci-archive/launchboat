FROM rocker/geospatial:latest
MAINTAINER noam.ross@gmail.com

RUN apt-get update \
  && apt-get install -y --no-install-recommends \
    python3-dev python3-setuptools python3-pip
RUN pip3 install -U pip
RUN pip3 install mitmproxy
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
   ropenscilabs/defender \
   ropenscilabs/middlechild \
   ropenscilabs/pkgreviewr@pkgtests

WORKDIR /home/rstudio/pkg

COPY pkgtest.R /usr/local/bin
COPY coverage-report-widget.R /home/rstudio
COPY pkg-report.Rmd /home/rstudio

CMD pkgtest.R .


