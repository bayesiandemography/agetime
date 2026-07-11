#' Specify Open Age Group
#'
#' Add a factor level representing an age group that is
#' open on the right (has no upper limit).
#' Replace existing age groups where necessary.
#'
#' @inheritParams age_lower
#' @param at Point at which intervals become open,
#' e.g. `80` in `80+`.
#' @return Factor with the same length as `labels`.
#'
#' @seealso
#' - [cohort_set_open_left()] Specify cohort open on left
#' - [cohort_set_open_right()] Specify cohort open on right
#' - [period_set_open_left()] Specify period open on left
#' - [period_set_open_right()] Specify period open on right
#' - [cohort_is_open_left()] Identify cohorts open on left
#' - [cohort_is_open_right()] Identify cohorts open on right
#' - [period_is_open_left()] Identify periods open on left
#' - [period_is_open_right()] Identify periods open on right
#' - [age_is_open_right()] Identify age groups open on right
#'
#' @examples
#' labels <- c("20-24", "80-84", "100+")
#' age_set_open_right(labels, at = 80)
#' age_set_open_right(labels, at = 50)
#' age_set_open_right(c("0-4", "60-64"), at = 70)
#' @export

age_set_open_right <- function(labels,
                                  at,
                                  interpret_fail = c("error", "warn", "silent")) {
  interpret_fail <- match.arg(interpret_fail)
  inner_levels_set_open(
    labels = labels,
    open_boundary = at,
    nm_open_boundary = "at",
    make_open_left = FALSE,
    make_open_right = TRUE,
    label_type = "age",
    interpret_single = "lower",
    interpret_multi = "exclude",
    interpret_fail = interpret_fail
  )
}
