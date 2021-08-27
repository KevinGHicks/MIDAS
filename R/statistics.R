#' Generate Metabolite Z Scores
#'
#' Estimate the mean, and SD of abundances changes and resulting statistical
#'   significance based on a Wald test.
#'
#' @param met_data a tibble containing metabolite, protein and
#'   log2_abundance_corrected
#' @param sd_method method to use when estimating standard deviation:
#' \describe{
#'  \item{holdout}{For a given value, calculate SD by removing that value and
#'    calculating SD over all other measurements of that metabolite.
#'    Conservative when there are many enrichments or depletions of a given
#'    metabolite.}
#'  \item{central_quantiles}{Estimate SD from the central quantiles of the
#'  relative abundance distribution. For intuition, 66 \% of Normally-distribute
#'  observations are expected to fall within 1 SD of the mean. So, the range of
#'  the central 66 \% of the Normal distribution would approximate twice the
#'  standard deviation.}
#'  }
#' @param quantile_range For \code{central_quantiles}, fraction of relative
#'   abundance distribution to use when estimating SD.
#'
#' @return met_data containing estimates of the SD of an observation and p-values.
#'
#' @export
generate_met_z_scores <- function(
  met_data,
  sd_method = "holdout",
  quantile_range = 0.5
  ) {

  if (sd_method == "holdout") {

    # for every query_protein, compare to distribution of all other "background proteins"
    enrichment_background_distributions <- expand.grid(
      query_protein = met_data$protein,
      background_protein = met_data$protein,
      stringsAsFactors = FALSE
      ) %>%
      dplyr::as_tibble() %>%
      dplyr::filter(query_protein != background_protein) %>%
      dplyr::left_join(met_data, by = c("background_protein" = "protein")) %>%
      dplyr::group_by(query_protein) %>%
      dplyr::summarize(
        met_mean = mean(log2_abundance_corrected),
        met_sd = stats::sd(log2_abundance_corrected)
        )

    enrichment_parameters <- enrichment_background_distributions %>%
      dplyr::left_join(met_data, by = c("query_protein" = "protein"))

  } else if (sd_method == "central_quantiles") {

    stopifnot(
      class(quantile_range) == "numeric",
      length(quantile_range) == 1,
      quantile_range > 0,
      quantile_range < 1
      )

    enrichment_background_distributions <- met_data %>%
      # using median here as a more robust measure of the null distribution's mean
      dplyr::summarize(
        met_mean = stats::median(log2_abundance_corrected),
        # estimate sd from central quantiles as a robust measure of the null
        # distribution's dispersion
        met_sd = sd_from_quantiles(
          log2_abundance_corrected,
          quantile_range = quantile_range
          )
        )

    enrichment_parameters <- met_data %>%
      tidyr::crossing(enrichment_background_distributions) %>%
      dplyr::rename(query_protein = protein)

  } else {
    stop (sd_method, " not recongized as a sd_method")
  }

  enrichment_parameters %>%
    dplyr::mutate(p_value = stats::pnorm(
      q = -1*abs(log2_abundance_corrected - met_mean),
      mean = 0,
      sd = met_sd
      ) * 2)
}

sd_from_quantiles <- function(x, quantile_range = 0.5) {
  # simulation to demonstrate consistency
  # hist(replicate(1000, sd_from_quantiles(rnorm(1000))))
  unname(
    diff(stats::quantile(x, probs = 0.5 + c(-0.5,0.5)*quantile_range))/
      (stats::qnorm(p = 0.5 + 0.5*quantile_range)*2)
    )
}
