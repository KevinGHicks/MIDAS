# MIDAS

The MIDAS R package reproduces the statistical analysis for the MIDAS study using a bundled vignette.

## Installation

The MIDAS R package and its vignette can package can be installed by running the following in R/Rstudio:

```r
install.packages("remotes")

remotes::install_bioc("qvalue")

remotes::install_github(
  "KevinGHicks/MIDAS",
  dependencies = TRUE,
  build_vignettes = TRUE
  )
```

To see the vignette, run:

```r
vignette(package = "midas", topic = "pipeline")
```

