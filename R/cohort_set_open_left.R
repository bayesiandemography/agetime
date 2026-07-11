#' Specify Open Cohort
#'
#' Add a factor level representing an open cohort.
#' Replace existing cohorts where necessary.
#'
#' - `cohort_set_open_left()` adds a cohort open on the left
#'   (has no lower limit).
#' - `cohort_set_open_right()` adds a cohort open on the right
#'   (has no upper limit).
#'
#' @inheritSection cohort_lower Controlling how cohort labels are interpreted
#'
#' @inheritParams cohort_lower
#' @param at Point at which intervals become open,
#' e.g. `2020` in `<2020` or `2030` in `2030+`.
#' @return Factor with the same length as `labels`.
#'
#' @seealso
#' - [age_set_open_right()] Specify open age group
#' - [period_set_open_left()] Specify open period
#' - [cohort_is_open_left()] Identify open cohort
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
