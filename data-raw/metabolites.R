# map from metabolite metadata to the ambiguous metabolites measured by MIDAS
# save this file as an onboard .rda file

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

# check for misalignment of measured metabolites and metabolite metadata
measured_not_annotated <- measured_metabolites %>%
  dplyr::anti_join(raw_metabolite_metadata, by = "Metabolite")

annotated_not_measured <- raw_metabolite_metadata %>%
  dplyr::anti_join(measured_metabolites, by = "Metabolite")

if (nrow(measured_not_annotated) == 0 | nrow(annotated_not_measured) == 0) {
  error_msg <- glue::glue({
    "
    {nrow(measured_not_annotated)} metabolites were measured but not annotated
    {nrow(annotated_not_measured)} metabolites were annotated but not measured
    1-1 matchs are currently required
    "
  })
  stop(error_msg)
}

# read raw metabolite annotations
metabolites <- measured_metabolites %>%
  dplyr::left_join(raw_metabolite_metadata, by = "Metabolite") %>%
  dplyr::rename(metabolite = metabolite_ambiguous, metabolite_component = Metabolite)

usethis::use_data(metabolites, overwrite = TRUE)

