#' Identify Cohort Labels for Totals
#'
#' Find "total" categories in  cohort labels.
#'
#' @inheritSection cohort_lower Controlling how cohort labels are interpreted
#'
#' @inheritParams cohort_lower
#'
#' @return Logical vector with the same length as `labels`.
#'
#' @seealso
#' - [cohort_is_open_left()] Find left-open cohorts
#' - [cohort_is_open_right()] Find right-open cohorts
#' - [age_is_total()] Age equivalent of `cohort_is_total()`
#' - [period_is_total()] Period equivalent of `cohort_is_total()`
#'
#' @examples
#' labels <- c("2020-2025", "Total", "1999", "ALL")
#' cohort_is_total(labels)
#' @export

# When length(labels) == 0, returns logical(0).
cohort_is_total <- function(labels,
                            interpret_single = c("lower", "upper"),
                            interpret_multi = c("include", "exclude"),
                            interpret_fail = c("error", "warn", "silent")) {
  interpret_fail <- match.arg(interpret_fail)
  inner_is_total(
    labels = labels,
    label_type = "cohort",
    interpret_single = interpret_single,
    interpret_multi = interpret_multi,
    interpret_fail = interpret_fail
  )
}


#' Identify Cohorts Open on Left
#'
#' Find cohorts that are open on the left, i.e., that have no lower limit.
#'
#' @inheritSection cohort_lower Controlling how cohort labels are interpreted
#'
#' @inheritParams cohort_lower
#'
#' @return Logical vector with the same length as `labels`.
#'
#' @seealso
#' - [cohort_is_total()] Find cohort labels for totals
#' - [cohort_is_open_right()] Find right-open cohorts
#' - [period_is_open_left()] Period equivalent of `cohort_is_open_left()`
#'
#' @examples
#' labels <- c("2020", "<1900", "2040-2050", "2030+")
#' cohort_is_open_left(labels)
#' @export

# When length(labels) == 0, returns logical(0).
cohort_is_open_left <- function(labels,
                                interpret_single = c("lower", "upper"),
                                interpret_multi = c("include", "exclude"),
                                interpret_fail = c("error", "warn", "silent")) {
  interpret_fail <- match.arg(interpret_fail)
  inner_is_open(
    labels = labels,
    label_type = "cohort",
    interpret_single = interpret_single,
    interpret_multi = interpret_multi,
    interpret_fail = interpret_fail,
    check_open_left = TRUE,
    check_open_right = FALSE
  )
}


#' Identify Cohorts Open on Right
#'
#' Find cohorts that are open on the right, i.e., that have no upper limit.
#'
#' @inheritSection cohort_lower Controlling how cohort labels are interpreted
#'
#' @inheritParams cohort_lower
#'
#' @return Logical vector with the same length as `labels`.
#'
#' @seealso
#' - [cohort_is_total()] Find cohort labels for totals
#' - [cohort_is_open_left()] Find cohorts open on left
#' - [period_is_open_right()] Period equivalent of `cohort_is_open_right()`
#' - [age_is_open_right()] Age equivalent of `cohort_is_open_right()`
#'
#' @examples
#' labels <- c("2020", "<1900", "2040-2050", "2030+")
#' cohort_is_open_right(labels)
#' @export

# When length(labels) == 0, returns logical(0).
cohort_is_open_right <- function(labels,
                                 interpret_single = c("lower", "upper"),
                                 interpret_multi = c("include", "exclude"),
                                 interpret_fail = c("error", "warn", "silent")) {
  interpret_fail <- match.arg(interpret_fail)
  inner_is_open(
    labels = labels,
    label_type = "cohort",
    interpret_single = interpret_single,
    interpret_multi = interpret_multi,
    interpret_fail = interpret_fail,
    check_open_left = FALSE,
    check_open_right = TRUE
  )
}
