#' Heatmap Plot
#'
#' Creates a heatmap with hierarchically clusters rows and columns.
#'
#' @param dat A matrix of abundances
#'
#' @return a grob
#'
#' @export
heatmap_plot <- function (dat) {

  cluster_rows <- rownames(dat)[stats::hclust(stats::dist(dat), method = "ward.D2")$order]
  cluster_cols <- colnames(dat)[stats::hclust(stats::dist(t(dat)), method = "ward.D2")$order]

  matrix_to_tibble(dat) %>%
    dplyr::mutate(protein = factor(protein, levels = cluster_rows),
                  metabolite = factor(metabolite, levels = cluster_cols),
                  log2_threshold = pmax(pmin(log2_abundance_corrected, 3), -3)) %>%
    ggplot(aes(x = metabolite, y = protein, fill = log2_threshold)) +
    geom_raster() +
    scale_fill_gradient2(expression(log[2] ~ abundance), low = "steelblue1", mid = "black", high = "yellow", midpoint = 0) +
    theme_bw() +
    theme(axis.text.x = element_blank(), axis.text.y = element_blank(),
          axis.ticks = element_blank())

}

#' Matrix Summary Plots
#'
#' Create heatmaps of raw abundances, the PCA projection, and corrected abundances for a given pool
#'
#' @param which_pool Pool number of analyze
#' @param pool_data tibble containing pool-wise results from \code{\link{correct_pool}}
#'
#' @return grob
#'
#' @export
matrix_summary_plots <- function (which_pool, pool_data) {

  one_pool <- pool_data %>%
    dplyr::filter(pool == which_pool)

  hm1 = heatmap_plot(one_pool$pool_log2_matrix[[1]]) + ggtitle(glue::glue("Pool {which_pool} - Raw pool"))
  hm2 = heatmap_plot(one_pool$top_pc_fit[[1]]) + ggtitle(glue::glue("Pool {which_pool} - Correlated noise"))
  hm3 = heatmap_plot(one_pool$log2_pc_projection[[1]]) + ggtitle(glue::glue("Pool {which_pool} - Corrected pool"))

  gridExtra::grid.arrange(hm1, hm2, hm3)
}


#' MIDAS Barplot
#'
#' @param midas_data \code{\link{midas_pmis}} with any filters applied
#' @param facet_by Variable to facet by, either protein or metabolite
#' @param FDR_cutoff cutoff used for labeling discoveries
#'
#' @return a grob
#'
#' @examples
#'
#' library(dplyr)
#' library(ggplot2)
#'
#' midas_pmis %>%
#'   dplyr::filter(query_protein %in%
#'     sample(unique(midas_pmis$query_protein), 3)) %>%
#'   midas_barplot(FDR_cutoff = 0.1) +
#'   theme(axis.text.x = element_blank())
#'
#' @export
midas_barplot <- function (midas_data, facet_by = "protein", FDR_cutoff = 0.1) {

  transformed_midas_data <- midas_data %>%
    dplyr::select(metabolite, query_protein, raw = log2_abundance, post_PCA = log2_abundance_corrected, q_value) %>%
    tidyr::gather(variable, abundance, raw, post_PCA)

  if (facet_by == "protein") {

    midas_grob <-  try(transformed_midas_data %>%
                         dplyr::mutate(metabolite = stringr::str_wrap(metabolite, width = 30, indent = 2)) %>%
                         ggplot(aes(x = metabolite, y = abundance, fill = variable, alpha = q_value < FDR_cutoff)) +
                         geom_bar(stat = "identity", position = "dodge") +
                         facet_wrap(~ query_protein, scales = "free", ncol = 1) +
                         scale_fill_brewer("Measurement", palette = "Set2") +
                         scale_alpha_manual("Is discovery?", values = c("TRUE" = 1, "FALSE" = 0.5)) +
                         theme_bw() +
                         theme(axis.text.x = element_text(angle = 90, size = 10, hjust = 1)),
                       silent = TRUE)

  } else if (facet_by == "metabolite") {

    midas_grob <-  try(transformed_midas_data %>%
                         dplyr::mutate(query_protein = stringr::str_wrap(query_protein, width = 30, indent = 2)) %>%
                         ggplot(aes(x = query_protein, y = abundance, fill = variable, alpha = q_value < FDR_cutoff)) +
                         geom_bar(stat = "identity", position = "dodge") +
                         facet_wrap(~ metabolite, scales = "free", ncol = 1) +
                         scale_fill_brewer("Measurement", palette = "Set2") +
                         scale_alpha_manual("Is discovery?", values = c("TRUE" = 1, "FALSE" = 0.5)) +
                         theme_bw() +
                         theme(axis.text.x = element_text(angle = 90, size = 10, hjust = 1)),
                       silent = TRUE)

  } else {
    stop (facet_by, " is not a valid value for \"facet_by\", valid values are protein and metabolite")
  }

  if (nrow(transformed_midas_data) == 0 || "try-error" %in% class(midas_grob)) {
    ggplot(data.frame(x = 0, y = 0), aes(x = x, y = y)) + geom_text(label = "No data within range", size = 15) +
      theme(text = element_blank(), line = element_blank())
  } else {
    midas_grob
  }
}



