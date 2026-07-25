#' Work with Age, Period, and Cohort Labels
#'
#' Functions for working with
#' labels for age groups, periods, and cohorts.
#'
#' @section Functions:
#'
#' **Extract lower limits, upper limits, widths, midpoints**
#' |                  |                  |                  |
#' |------------------|------------------|------------------|
#' | [age_lower()]    | [period_lower()] | [cohort_lower()] |
#' | [age_upper()]    | [period_upper()] | [cohort_upper()] |
#' | [age_width()]    | [period_width()] | [cohort_width()] |
#' | [age_mid()]      | [period_mid()]   | [cohort_mid()]   |
#'
#' **Identify open intervals, totals, and missing**
#'
#' |                  |                   |                   |
#' |------------------|-------------------|-------------------|
#' |  | [period_is_open_left()] | [cohort_is_open_left()] |
#' | [age_is_open_right()] | [period_is_open_right()] | [cohort_is_open_right()] |
#' | [age_is_total()] | [period_is_total()] | [cohort_is_total()] |
#' | [age_is_missing()] | [period_is_missing()] | [cohort_is_missing()] |
#'
#' **Use agetime default format**
#'
#' |                  |                     |                     |
#' |------------------|---------------------|---------------------|
#' | [age_standard()] | [period_standard()] | [cohort_standard()] |
#'
#' **Coarsen intervals**
#'
#' |                     |                      |                      |
#' |---------------------|----------------------|----------------------|
#' | [age_coarsen()]      | [period_coarsen()]    | [cohort_coarsen()]    |
#' | [age_coarsen_five()] | [period_coarsen_five()] | [cohort_coarsen_five()] |
#' | [age_coarsen_ten()]  | [period_coarsen_ten()] | [cohort_coarsen_ten()] |
#' | [age_coarsen_life()] |                      |                      |
#'
#' **Continue series**
#'
#' |                 |                   |                   |
#' |-----------------|-------------------|-------------------|
#' | [age_extend()]  | [period_extend()] | [cohort_extend()] |
#'
#' **Fill in gaps in levels**
#'
#' |                          |                           |                           |
#' |--------------------------|---------------------------|---------------------------|
#' | [age_fill()]      | [period_fill()]    | [cohort_fill()]    |
#' | [age_fill_one()]  | [period_fill_one()] | [cohort_fill_one()] |
#' | [age_fill_five()] | [period_fill_five()] | [cohort_fill_five()] |
#' | [age_fill_ten()]  | [period_fill_ten()] | [cohort_fill_ten()] |
#' | [age_fill_life()] |                           |                           |
#'
#' **Define open intervals**
#'
#' |                     |                       |                       |
#' |---------------------|-----------------------|-----------------------|
#' |  | [period_set_open_left()] | [cohort_set_open_left()] |
#' | [age_set_open_right()] | [period_set_open_right()] | [cohort_set_open_right()] |
#'
#' **Put levels in order**
#'
#' |                     |                         |                         |
#' |---------------------|-------------------------|-------------------------|
#' | [age_sort()] | [period_sort()] | [cohort_sort()] |
#'
#' **Create new labels**
#'
#' |                     |                         |                         |
#' |---------------------|-------------------------|-------------------------|
#' | [age_labels()]      | [period_labels()]       | [cohort_labels()]       |
#' | [age_labels_one()]  | [period_labels_one()]   | [cohort_labels_one()]   |
#' | [age_labels_five()] | [period_labels_five()]  | [cohort_labels_five()]  |
#' | [age_labels_ten()]  | [period_labels_ten()]   | [cohort_labels_ten()]   |
#' | [age_labels_life()] |                         |                         |
#'
#' **Characterise labels or make assertions**
#'
#' |                |                   |                   |
#' |----------------|-------------------|-------------------|
#' | [age_check()]  | [period_check()]  | [cohort_check()]  |
#' | [age_assert()] | [period_assert()] | [cohort_assert()] |
#'
#' **Create mappings between labels**
#'
#' |                 |                    |                    |
#' |-----------------|--------------------|--------------------|
#' | [age_mapping()] | [period_mapping()] | [cohort_mapping()] |
#'
#'
#' @docType package
#' @name agetime-package
#' @aliases agetime
"_PACKAGE"
