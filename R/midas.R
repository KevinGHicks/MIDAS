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

#' MIDAS PMIs
#'
#' MIDAS Protein-Metabolite Interactions (PMIs) produced by running the vignette, pipeline.Rmd.
#'
#' @format A tibble with 52,614 rows and 6 columns:
#' \describe{
#'   \item{metabolite}{Metabolite name (indistinguishable metabolites are lumped)}
#'   \item{query_protein}{Protein name. Anonymous proteins are named MIDASXXXX.}
#'   \item{log2_abundance}{Raw fold-changes between protein-present and protein-absent compartments}
#'   \item{log2_abundance_corrected}{Fold-changes corrected for non-specific binding using PCA}
#'   \item{p_value}{P-value for enrichment/depletion}
#'   \item{q_value}{P-values corrected for multiple hypotheses using PMID: 12883005 }
#' }
"midas_pmis"

#' MIDAS Metabolites
#'
#' Metabolite metadata matching MIDAS measurements. Some measurements include
#' multiple ambiguous compounds.
#'
#' @format A tibble with 400 rows and 8 columns:
#' \describe{
#'   \item{metabolite}{Metabolite name (indistinguishable metabolites are lumped) matching \code{midas_pmis}}
#'   \item{metabolite_component}{A unique metabolite constituent of the \code{metabolite}}
#'   \item{MIDAS_ID}{\code{metabolite_component}'s internal identifier}
#'   \item{Pool}{Metabolite pool \code{metabolite}/\code{metabolite_component} were run in}
#'   \item{KEGG_ID}{\code{metabolite_component}'s KEGG identifier}
#'   \item{HMDB_ID}{\code{metabolite_component}'s HMDB identifier}
#'   \item{SMILES}{\code{metabolite_component}'s isomeric SMILES encoding structure}
#'   \item{KEGG_pathway_association}{\code{metabolite_component}'s KEGG pathways}
#' }
"metabolites"
