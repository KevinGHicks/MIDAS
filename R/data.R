prepare_metabolites <- function() {

  # read measurement file
  midas_input_data_path <- system.file("extdata", "MIDAS_input_dataset.txt", package = "midas")

  raw_data <- read_delim(midas_input_data_path, delim = "\t") %>%
    rename(protein = Metabolite)

  measured_metabolites <- raw_data %>%
    dplyr::select(-c(Protein_name:protein)) %>%
    {tibble::tibble(metabolite_ambiguous = colnames(.))} %>%
    dplyr::mutate(Metabolite = metabolite_ambiguous) %>%
    tidyr::separate_rows(Metabolite, sep = ";")

  midas_metabolites_path <- system.file("extdata", "MIDAS_metabolites.txt", package = "midas")

  raw_metabolite_metadata <- read_delim(midas_metabolites_path, delim = "\t")

  measured_metabolites %>%
    dplyr::left_join(raw_metabolite_metadata, by = "Metabolite")

  measured_metabolites %>%
    dplyr::anti_join(raw_metabolite_metadata, by = "Metabolite") %>%
    View()

  raw_metabolite_metadata %>%
    dplyr::anti_join(measured_metabolites, by = "Metabolite") %>%
    View()

  # read raw metabolite annotations

}
