#' Identify Age Group Labels for Totals
#'
#' Find "total" categories in age group labels.
#'
#' @inheritParams age_lower
#'
#' @return Logical vector with the same length as `labels`.
#'
#' @seealso
#' - [age_is_open()] Find open age groups
#' - [period_is_total()] Period equivalent of `age_is_total()`
#' - [cohort_is_total()] Cohort equivalent of `age_is_total()`
#'
#' @examples
#' labels <- c("20-24", "Total", "100+", "ALL")
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


#' Identify Age Labels for Open Age Groups
#'
#' Find open age groups, ie age groups with no upper limit.
#'
#' @inheritParams age_lower
#'
#' @return Logical vector with the same length as `labels`.
#'
#' @seealso
#' - [age_is_total()] Find age labels for totals
#' - [cohort_is_open()] Cohort equivalent of `age_is_open()`
#'
#' @examples
#' labels <- c("20+", "infant", "100+", "60to79")
#' age_is_open(labels)
#' @export

# When length(labels) == 0, returns logical(0).
age_is_open <- function(labels,
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
