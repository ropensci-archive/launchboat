# launchboat: a vessel for onboarding

[![CircleCI](https://circleci.com/gh/noamross/launchboat.svg?style=svg)](https://circleci.com/gh/noamross/launchboat)
[![](https://images.microbadger.com/badges/image/noamross/launchboat.svg)](https://hub.docker.com/r/noamross/launchboat/)

In-progress work on a standard build environment and workflow for rOpenSci package review.  Goals and todos:

 - Standard docker container. Currently builds on rocker/geospatial to maximize system dependencies.
 - Zero-install. Run with a single docker command, get editor-check diagnostics and support files.
 - Get one HTML with everything, but also a folder of outputs - saved R objects for inspection, text outputs, etc. Currently saves `goodpractice::gp()` output text and objects (including R CMD Check outputs), a coverage report, **testthat** results, and package vignettes.  Will be adding `hrbrmstr/cloc` outputs and a package dependency graph.
 - Run on a local directory or give it a GitHub URL
 - Option to launch RStudio server once everything is run to continue to inspect package.
    -  Pre-run the **pkgreviewer** stuff, too - gives a standard review environment all set up.

To-dos:

 - Move R code into **pkgreviewer** so script is minimal
 - Do everything in temp directories so it doesn't matter where you run it and avoid
   need for file mounting unless desired.
   -  post main HTML output via file.io
 - Lots more

Try it now in a package directory with

     docker run -v "$(pwd):/home/rstudio/pkg" noamross/launchboat
     
It should make a an `ro-test` subdirectory with outputs.
