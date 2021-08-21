#' \code{MIDAS} package
#'
#' @docType package
#' @name midas
#'
#' @description R functions for working with MIDAS experiments
#'
#' @importFrom dplyr %>%
#' @import ggplot2
NULL

#' Find MIDAS Root Path
#'
#' From the current working directory, find the root of the MIDAS repo
#'
#' @param midas_root_rel_path relative path from working directory to root
#'
#' @return absolute path to MIDAS root
#'
#' @export
find_midas_root_path <- function (midas_root_rel_path) {

  wd = getwd()
  midas_root_path <- normalizePath(file.path(wd, midas_root_rel_path))

  if (!all(c("midas", "data", "analysis") %in% list.files(midas_root_path))) {
    stop(glue::glue("midas_root_rel_path of {midas_root_rel_path} results in an invalid absolute path to the midas repo: {midas_root_path}"))
  }

  return (midas_root_path)
}

#' Setup Examples
#'
#' @examples
#' \dontrun{
#'   setup_examples(midas_root_path = "~/Desktop/MIDAS")
#' }
setup_examples <- function (midas_root_path) {

  # fold changes
  fold_changes <- readr::read_delim(file.path(midas_root_path, "data", "fold_change", "20201028_MIDAS_Calico_Output.tsv"), delim = "\t") %>%
    dplyr::select(-met_mean, -met_sd)

  usethis::use_data(fold_changes, overwrite = TRUE)

}
