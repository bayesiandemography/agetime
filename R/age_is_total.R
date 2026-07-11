#' Identify Age Group Labels for Totals
#'
#' Find "total" categories in age group labels.
#'
#' @inheritParams age_lower
#'
#' @return Logical vector with the same length as `labels`.
#'
#' @seealso
#' - [period_is_total()] Period equivalent of `age_is_total()`
#' - [cohort_is_total()] Cohort equivalent of `age_is_total()`
#' - [age_is_open_right()] Identify age groups open on right
#'
#' @examples
#' labels <- c("overall", "20-24", "Total", "100+", "ALL")
#' age_is_total(labels)
#' @export

# When length(labels) == 0, returns logical(0).
age_is_total <- function(labels,
                         interpret_fail = c("error", "warn", "silent")) {
  interpret_fail <- match.arg(interpret_fail)
  inner_is_total(
    labels = labels,
    label_type = "age",
    interpret_single = "lower",
    interpret_multi = "exclude",
    interpret_fail = interpret_fail
  )
}


#' Identify Open Age Groups
#'
#' Find age groups that are open on the right, i.e., that have no upper limit.
#'
#' @inheritParams age_lower
#'
#' @return Logical vector with the same length as `labels`.
#'
#' @seealso
#' - [cohort_is_open_left()] Identify cohorts open on left
#' - [cohort_is_open_right()] Identify cohorts open on right
#' - [period_is_open_left()] Identify periods open on left
#' - [period_is_open_right()] Identify periods open on right
#' - [age_is_total()] Identify totals for age groups
#' - [age_set_open_right()] Specify age group open on right
#'
#' @examples
#' labels <- c("20+", "infant", "100+", "60to79", "80 years or more")
#' age_is_open_right(labels)
#' @export

# When length(labels) == 0, returns logical(0).
age_is_open_right <- function(labels,
                              interpret_fail = c("error", "warn", "silent")) {
  interpret_fail <- match.arg(interpret_fail)
  inner_is_open(
    labels = labels,
    label_type = "age",
    interpret_single = "lower",
    interpret_multi = "exclude",
    interpret_fail = interpret_fail,
    check_open_left = FALSE,
    check_open_right = TRUE
  )
}
