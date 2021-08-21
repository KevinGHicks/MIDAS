# MIDAS

## Installation

Run the following in R/Rstudio:

```r
remotes::install_github(
  "KevinGHicks/MIDAS",
  subdir = "midas",
  dependencies = TRUE,
  build_vignettes = TRUE
  )

remotes::install_bioc("qvalue")
```

Install Quartz if you're using a Mac and want to view the vignettes at: [link](https://www.xquartz.org/)
