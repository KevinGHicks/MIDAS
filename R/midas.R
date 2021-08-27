#' \code{MIDAS} package
#'
#' @docType package
#' @name midas
#'
#' @description R functions for working with MIDAS experiments
#'
#' @importFrom dplyr %>%
#' @import ggplot2
utils::globalVariables(c(
  ".",
  "abundance",
  "background_protein",
  "log2_abundance",
  "log2_abundance_corrected",
  "log2_threshold",
  "met_mean",
  "met_sd",
  "metabolite",
  "pool",
  "post_PCA",
  "protein",
  "q_value",
  "query_protein",
  "variable",
  "x",
  "y"
))

#' MIDAS MPIs
#'
#' MIDAS Metabolite-Protein Interactions produced by running the vignette, pipeline.Rmd.
#'
#' @format A tibble with 52,614 rows and 8 columns:
#' \describe{
#'   \item{metabolite}{Metabolite name (indistinguishable metabolites are lumped)}
#'   \item{query_protein}{Protein name. Anonymous proteins are named MIDASXXXX.}
#'   \item{log2_abundance}{Raw fold-changes between protein-present and protein-absent compartments}
#'   \item{log2_abundance_corrected}{Fold-changes corrected for non-specific MPIs using PCA}
#'   \item{p_value}{P-value for enrichment/depletion}
#'   \item{q_value}{P-values corrected for multiple hypotheses using PMID: 12883005 }
#' }
"midas_mpis"
