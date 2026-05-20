
#' Functions for Working with Age Group, Period, and Cohort Labels
#'
#' **Create new labels**
#'
#' | Age                  | Period                  | Cohort                  | Description                  |
#' |----------------------|-------------------------|-------------------------|------------------------------|
#' | [age_labels()]       | [period_labels()]       | [cohort_labels()]       | New labels                   |
#' | [age_labels_one()]   | [period_labels_one()]   | [cohort_labels_one()]   | New 1-year labels            |
#' | [age_labels_five()]  | [period_labels_five()]  | [cohort_labels_five()]  | New 5-year labels            |
#' | [age_labels_ten()]   | [period_labels_ten()]   | [cohort_labels_ten()]   | New 10-year labels           |
#' | [age_labels_life()]  | -                       | -                       | New life table labels        |
#'
#' **Tidy existing labels**
#'
#' | Age                  | Period                  | Cohort                  | Description                  |
#' |----------------------|-------------------------|-------------------------|------------------------------|
#' | [age_standard()]     | [period_standard()]     | [cohort_standard()]     | Apply standard formatting    |
#' 
#' **Extract information about intervals**
#'
#' | Age                  | Period                  | Cohort                  | Description                  |
#' |----------------------|-------------------------|-------------------------|------------------------------|
#' | [age_lower()]        | [period_lower()]        | [cohort_lower()]        | Lower limits                 |
#' | [age_upper()]        | [period_upper()]        | [cohort_upper()]        | Upper limits                 |
#' | [age_width()]        | [period_width()]        | [cohort_width()]        | Widths                       |
#' | [age_mid()]          | [period_mid()]          | [cohort_mid()]          | Midpoints                    |
#' | [age_is_open()]      | -                       | [cohort_is_open()]      | Find open intervals          |
#' | [age_is_total()]     | [period_is_total()]     | [cohort_is_total()]     | Find totals                  |
#'
#' **Modify intervals**
#'
#' | Age                  | Period                  | Cohort                  | Description                  |
#' |----------------------|-------------------------|-------------------------|------------------------------|
#' | [age_convert()]      | [period_convert()]      | [cohort_convert()]      | Convert to new intervals     |
#' | [age_convert_five()] | [period_convert_five()] | [cohort_convert_five()] | Convert to 5-year intervals  | 
#' | [age_convert_ten()]  | [period_convert_ten()]  | [cohort_convert_ten()]  | Convert to 10-year intervals | 
#' | [age_convert_life()] | -                       | -                       | Convert to life table        |
#' | [age_extend()]       | [period_extend()]       | [cohort_extend()]       | Add extra intervals          |
#' | [age_complete()]     | [period_complete()]     | [cohort_complete()]     | Fill in gaps                 |
#' | [age_complete_one()] | [period_complete_one()] | [cohort_complete_one()] | Fill in gaps with 1-year     |
#' | [age_complete_five()]| [period_complete_five()]| [cohort_complete_five()]| Fill in gaps with 5-year     |
#' | [age_complete_ten()] | [period_complete_ten()] | [cohort_complete_ten()] | Fill in gaps with 10-year    |
#' | [age_complete_life()]| -                       | -                       | Fill in gaps in life table   |
#' | [age_sort()]         | [period_sort()]         | [cohort_sort()]         | Order levels                 |
#'
#' **Programming**
#' 
#' | Age                  | Period                  | Cohort                  | Description                  |
#' |----------------------|-------------------------|-------------------------|------------------------------|
#' | [age_check()]        | [period_check()]        | [cohort_check()]        | Characterize intervals       |
#' | [age_assert()]       | [period_assert()]       | [cohort_assert()]       | Assertions about intervals   |
#' | [age_mapping()]      | [period_mapping()]      | [cohort_mapping()]      | Mapping between labels       |
#'
#' 
#' @docType package
#' @name agetime-package
#' @aliases agetime
"_PACKAGE"
