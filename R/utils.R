#' Util - Pretty Knitr Head
#'
#' @param tbl a data.frame or tibble
#' @param nrows the max number of rows to show
#' @inheritParams knitr::kable
#'
#' @return an html knitr table
#'
#' @export
#'
#' @examples
#' util_pretty_khead(mtcars, nrows = 5, caption = "cars!")
util_pretty_khead <- function(tbl, nrows = 10, caption = NULL) {
  checkmate::assertDataFrame(tbl)
  checkmate::assertNumber(nrows, lower = 1)

  tbl %>%
    dplyr::slice(1:nrows) %>%
    knitr::kable(caption = caption) %>%
    kableExtra::kable_styling(
      position = "left",
      bootstrap_options = "striped"
    )
}
