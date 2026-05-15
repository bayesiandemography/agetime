
#' Functions for Working with Age, Period, and Cohort Labels
#'
#' | Age                  | Period                 | Cohort                 | Description                  |
#' |----------------------|------------------------|------------------------|------------------------------|
#' | [age_lower()]        | [period_lower()]       | [cohort_lower()]       | Lower limits                 |
#' | [age_upper()]        | [period_upper()]       | [cohort_upper()]       | Upper limits                 |
#' | [age_width()]        | [period_width()]       | [cohort_width()]       | Widths                       |
#' | [age_mid()]          | [period_mid()]         | [cohort_mid()]         | Midpoints                    |
#' | [age_set_open()]     | -                      | [cohort_set_open()]    | Specify open interval        |
#' | [age_is_open()]      | -                      | [cohort_is_open()]     | Find open intervals          |
#' | [age_is_total()]     | [period_is_total()]    | [cohort_is_total()]    | Find totals                  |
#' | [age_convert()]      | [period_convert()]     | [cohort_convert()]     | Convert to new intervals     |
#' | [age_convert_five()] | [period_convert_five()]| [cohort_convert_five()]| Convert to 5-year intervals  | 
#' | [age_convert_ten()]  | [period_convert_ten()] | [cohort_convert_ten()] | Convert to 10-year intervals | 
#' | [age_convert_life()] | -                      | -                      | Convert to life table ages   |
#' | [age_extend()]       | [period_extend()]      | [cohort_extend()]      | Add extra labels at end      |
#' | [age_complete()]     | [period_complete()]    | [cohort_complete()]    | Fill in gaps                 |
#' | [age_standard()]     | [period_standard()]    | [cohort_standard()]    | Apply standard formatting    |
#' | [age_labels()]       | [period_labels()]      | [cohort_labels()]      | New labels                   |
#' | [age_labels_one()]   | [period_labels_one()]  | [cohort_labels_one()]  | New 1-year labels            |
#' | [age_labels_five()]  | [period_labels_five()] | [cohort_labels_five()] | New 5-year labels            |
#' | [age_labels_ten()]   | [period_labels_ten()]  | [cohort_labels_ten()]  | New 10-year labels           |
#' | [age_labels_life()]  | -                      | -                      | New lifetable labels         |
#' | [age_check()]        | [period_check()]       | [cohort_check()]       | Characterize intervals       |
#' | [age_assert()]       | [period_assert()]      | [cohort_assert()]      | Assertions about intervals   |
#' | [age_mapping()]      | [period_mapping()]     | [cohort_mapping()]     | Mapping between labels       |
#'
#' @docType package
#' @name agetime-package
#' @aliases agetime
"_PACKAGE"
