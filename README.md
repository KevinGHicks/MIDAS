# MIDAS

The MIDAS R package reproduces the statistical analysis for the MIDAS study using a bundled vignette.

## Installation

If you are on a Mac then you should install Quartz to support rasterization of some of the large plots. It can be downloaded at: [link](https://www.xquartz.org/)

The MIDAS R package and its vignette can package can be installed by running the following in R/Rstudio:

```r
install.packages("remotes")

remotes::install_bioc("qvalue")

remotes::install_github(
  "KevinGHicks/MIDAS",
  subdir = "midas",
  dependencies = TRUE,
  build_vignettes = TRUE
  )
```

To see the vignette, run:

```r
vignette(package = "midas", topic = "pipeline")
```

