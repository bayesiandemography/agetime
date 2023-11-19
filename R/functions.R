#' @section For end users:
#'
#'
#' - [age_lower()], [age_mid()], [age_upper()] Limits and midpoints of age groups.
#'
#'
#' - [age_reformat()] Reformat age group labels.
#' - [age_convert()] Convert to more aggregate age group labels.
#' - [age_create()] Create age labels.
#' - [age_oldest()] Specify oldest age group.
#'
#'
#' @section For developers:
#'
#' - [age_type()] Infer type of age group label.
#' - [age_check()] Validity checks for age group labels.
#'
#' - [period_lower()], [period_mid()], [period_upper()] Limits and midpoints of period groups.
#'
#'
#' - [period_reformat()] Reformat period labels.
#' - [period_convert()] Convert to more aggregate period labels.
#' - [period_create()] Create period labels.
#' - [period_extend()] Add extra periods
#'
#'
#' @section For developers:
#'
#' - [period_type()] Infer type of period label.
#' - [period_check()] Validity checks for period labels.
#'
#'
#' @section For end users:
#'
#' - [cohort_lower()], [cohort_mid()], [cohort_upper()] Limits and midpoints of cohort.
#'
#' - [cohort_reformat()] Reformat cohort labels.
#' - [cohort_convert()] Convert to more aggregate cohort labels.
#' - [cohort_create()] Create cohort labels.
#' - [cohort_oldest()] Create cohort consisting of people born before specified date.
#' - [cohort_extend()] Create cohort consisting of people born before specified date.
#'
#'
#' @section For developers:
#'
#' - [cohort_type()] Infer type of cohort label.
#' - [cohort_check()] Validity checks for cohort labels.
#'
#'
#' Age types
#' - single
#' - five
#' - lifetable
#' - ten
#' *** plus can supply arbitrary labels provided they are exhaustive - most functions only work with predefined type (exceptions: age_mid, age_lower, age_upper, age_reformat)
#'
#' Period types
#' - single
#' - five
#' - ten
#' - quarter
#' - month
#' *** plus arbitrary exhaustive
#'
#' Cohort types
#' - single
#' - five
#' - ten
#' *** plus arbitrary exhaustive
#' 

