# launchboat: a vessel for onboarding

*This repository is no longer active.  Related work continues at <https://github.com/ropenscilabs/pkgcheck>.*

[![Project Status: Suspended – Initial development has started, but there has not yet been a stable, usable release; work has been stopped for the time being but the author(s) intend on resuming work.](https://www.repostatus.org/badges/latest/suspended.svg)](https://www.repostatus.org/#suspended)

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
   need for file mounting unless desired
-  Make a single HTML output with everything the editor would want
   -   DESCRIPTION
   -   License check
   -   CI and coverage checkes (via goodpracice)
   -   Coverage report
   -   R CMD check output
-  Use hrbrmstr/fileio to post the HTML file temporarily and output the URL
 - Lots more

Try it now in a package directory with

     docker run -v "$(pwd):/home/rstudio/pkg" noamross/launchboat
     
It should make a an `ro-test` subdirectory with outputs.
