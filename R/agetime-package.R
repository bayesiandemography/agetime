
#' Functions for Working with Age, Period, and Cohort Labels
#'
#' | Age                 | Period                 | Cohort                 | Description                |
#' |---------------------|------------------------|------------------------|----------------------------|
#' | [age_lower()]       | [period_lower()]       | [cohort_lower()]       | Lower limits               |
#' | [age_upper()]       | [period_upper()]       | [cohort_upper()]       | Upper limits               |
#' | [age_width()]       | [period_width()]       | [cohort_width()]       | Widths                     |
#' | [age_mid()]         | [period_mid()]         | [cohort_mid()]         | Midpoints                  |
#' | [age_set_open()]    | -                      | [cohort_set_open()]    | Specify open interval      |
#' | [age_is_open()]     | -                      | [cohort_is_open()]     | Find open intervals        |
#' | [age_is_total()]    | [period_is_total()]    | [cohort_is_total()]    | Find totals                |
#' | [age_to()]          | [period_to()]          | [cohort_to()]          | Recode labels              |
#' | [age_to_one()]      | [period_to_one()]      | [cohort_to_one()]      | Recode to 1-year           | 
#' | [age_to_five()]     | [period_to_five()]     | [cohort_to_five()]     | Recode to 5-year           | 
#' | [age_to_ten()]      | [period_to_ten()]      | [cohort_to_ten()]      | Recode to 10-year          | 
#' | [age_to_life()]     | -                      | -                      | Recode to lifetable ages   |
#' | [age_to_labor()]    | -                      | -                      | Recode to labor force ages |
#' | [age_extend()]      | [period_extend()]      | [cohort_extend()]      | Add extra labels           |
#' | [age_standard()]    | [period_standard()]    | [cohort_standard()]    | Convert to standard format |
#' | [age_labels()]      | [period_labels()]      | [cohort_labels()]      | New labels                 |
#' | [age_labels_one()]  | [period_labels_one()]  | [cohort_labels_one()]  | New 1-year labels          |
#' | [age_labels_five()] | [period_labels_five()] | [cohort_labels_five()] | New 5-year labels          |
#' | [age_labels_ten()]  | [period_labels_ten()]  | [cohort_labels_ten()]  | New 10-year labels         |
#' | [age_labels_life()] | -                      | -                      | New lifetable labels       |
#' | [age_labels_labor()]| -                      | -                      | New labor force labels     |
#' | [age_check()]       | [period_check()]       | [cohort_check()]       | Characterize intervals     |
#' | [age_assert()]      | [period_assert()]      | [cohort_assert()]      | Assertions about intervals |
#' | [age_mapping()]     | [period_mapping()]     | [cohort_mapping()]     | Mapping between labels     |
#'
#' @docType package
#' @name agetime
#' @aliases agetime-package
"_PACKAGE"
