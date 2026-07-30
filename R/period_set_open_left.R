#' Specify Open Period
#'
#' @description
#' Define a factor level representing an open period.
#' Replace existing periods where necessary.
#'
#' - `period_set_open_left()` defines a period with no lower limit.
#' - `period_set_open_right()` defines a period with no upper limit.
#'
#' @inheritSection period_lower Rules for interpreting inputs
#'
#' @inheritParams period_lower
#' @param at Point at which intervals become open,
#' e.g. `2020` in `<2020` or `2030` in `2030+`.
#' @return Factor with the same length as `labels`.
#'
#' @seealso
#' - [age_set_open_right()] Specify age group open on right
#' - [cohort_set_open_left()] Specify cohort open on left
#' - [cohort_set_open_right()] Specify cohort open on right
#' - [period_is_open_left()] Identify periods open on left
#' - [period_is_open_right()] Identify periods open on right
#'
#' @examples
#' labels <- c("2020-2024", "2025-2029")
#' period_set_open_left(labels, at = 2020)
#'
#' labels <- c("2020-2024", "2025-2029", "2030")
#' period_set_open_right(labels, at = 2030)
#' @export

period_set_open_left <- function(labels,
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
    label_type = "period",
    interpret_single = interpret_single,
    interpret_multi = interpret_multi,
    interpret_fail = interpret_fail
  )
}
