#' Specify Open Cohort
#'
#' @description
#' Define a factor level representing an open cohort.
#' Replace existing cohorts where necessary.
#'
#' - `cohort_set_open_left()` defines a cohort with no lower limit.
#' - `cohort_set_open_right()` defines a cohort with no upper limit.
#'
#' @inheritSection cohort_lower Controlling how cohort labels are interpreted
#'
#' @inheritParams cohort_lower
#' @param at Point at which intervals become open,
#' e.g. `2020` in `<2020` or `2030` in `2030+`.
#' @return Factor with the same length as `labels`.
#'
#' @seealso
#' - [age_set_open_right()] Specify age group open on right
#' - [period_set_open_left()] Specify period open on left
#' - [period_set_open_right()] Specify period open on right
#' - [cohort_is_open_left()] Identify cohorts open on left
#' - [cohort_is_open_right()] Identify cohorts open on right
#' - [period_is_open_left()] Identify periods open on left
#' - [period_is_open_right()] Identify periods open on right
#' - [age_is_open_right()] Identify age groups open on right
#'
#' @examples
#' labels <- c("2020-2024", "<2000", "2015")
#' cohort_set_open_left(labels, at = 2020)
#' cohort_set_open_left(labels, at = 2005)
#' cohort_set_open_left(c("2000-2004", "2010-2014"), at = 1990)
#'
#' labels <- c("2020-2024", "2025-2029", "2030")
#' cohort_set_open_right(labels, at = 2030)
#' @export

cohort_set_open_left <- function(labels,
                                    at,
                                    interpret_single = c("lower", "upper"),
                                    interpret_multi = c("include", "exclude"),
                                    interpret_fail = c(
                                      "error", "warn", "silent"
                                    )) {
  interpret_fail <- match.arg(interpret_fail)
  interpret_single <- match.arg(interpret_single)
  interpret_multi <- match.arg(interpret_multi)
  inner_levels_set_open(
    labels = labels,
    open_boundary = at,
    nm_open_boundary = "at",
    make_open_left = TRUE,
    make_open_right = FALSE,
    label_type = "cohort",
    interpret_single = interpret_single,
    interpret_multi = interpret_multi,
    interpret_fail = interpret_fail
  )
}
