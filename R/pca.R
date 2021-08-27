#' Correct Pool
#'
#' Subtracts the top principal components from a matrix of proteins x metabolites
#'
#' @param pool_data tibble containing protein, metabolite, and log2_abundance
#' @param npcs number of principal components to subtract
#'
#' @return a list containing:
#' \describe{
#'  \item{pool_log2_matrix}{A matrix of uncorrected abundances}
#'  \item{scree_data}{Percent variance explained for each PC}
#'  \item{top_pc_fit}{Projection onto top principal components}
#'  \item{log2_pc_projection}{\code{pool_log2_matrix} - \code{top_pc_fit}}
#'  \item{log2_pc_projection_tbl}{tibble of log2_pc_projection}
#' }
#'
#' @export
correct_pool <- function (pool_data, npcs = 3) {

  pool_log2_matrix <- pool_data %>%
    reshape2::acast(formula = protein ~ metabolite, value.var = "log2_abundance")

  # drop metabolites with missing values
  missing_metabolites <- colnames(pool_log2_matrix)[colSums(is.na(pool_log2_matrix)) != 0]
  if (length(missing_metabolites) != 0) {
    print(glue::glue("{paste(missing_metabolites, collapse = ', ')} were dropped since they were missing for some proteins"))

    pool_log2_matrix <- pool_log2_matrix[,!(colnames(pool_log2_matrix) %in% missing_metabolites)]
  }

  pool_svd <- svd(pool_log2_matrix)

  scree_data <- tibble::tibble(
    PC = seq_along(pool_svd$d),
    VarEx = pool_svd$d^2 / sum(pool_svd$d^2)
    )

  top_pc_fit <- pool_svd$u[,1:npcs,drop = FALSE] %*%
    diag(x = pool_svd$d[1:npcs], nrow = npcs, ncol = npcs) %*%
    t(pool_svd$v[,1:npcs,drop = FALSE])
  rownames(top_pc_fit) <- rownames(pool_log2_matrix)
  colnames(top_pc_fit) <- colnames(pool_log2_matrix)

  log2_pc_projection <- pool_log2_matrix - top_pc_fit

  log2_pc_projection_tbl <- log2_pc_projection %>%
    as.data.frame(stringsAsFactors = FALSE) %>%
    dplyr::mutate(protein = rownames(.)) %>%
    tidyr::gather(metabolite, log2_abundance_corrected, -protein)

  output = list(
    pool_log2_matrix = pool_log2_matrix,
    scree_data = scree_data,
    top_pc_fit = top_pc_fit,
    log2_pc_projection = log2_pc_projection,
    log2_pc_projection_tbl = matrix_to_tibble(log2_pc_projection)
    )

  return (output)
}

matrix_to_tibble <- function (dat) {
  dat %>%
    as.data.frame(stringsAsFactors = FALSE) %>%
    dplyr::mutate(protein = rownames(.)) %>%
    tidyr::gather(metabolite, log2_abundance_corrected, -protein)
}
