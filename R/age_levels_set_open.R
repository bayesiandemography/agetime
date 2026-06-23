#' Set Open Age Group Level
#'
#' Add an open age group level, i.e. an age group with no upper limit.
#' Replace existing age groups where necessary.
#'
#' @inheritParams age_lower
#' @param lower_open Lower limit of open age group.
#' @return Factor with the same length as `x`.
#'
#' @seealso
#' - [cohort_levels_set_open()] Set open cohort levels (left-open)
#'
#' @examples
#' x <- c("20-24", "80-84", "100+")
#' age_levels_set_open(x, lower_open = 80)
#' age_levels_set_open(x, lower_open = 50)
#' age_levels_set_open(c("0-4", "60-64"), lower_open = 70)
#' @export

age_levels_set_open <- function(x,
                                lower_open,
                                x_fail = c("error", "warn", "silent")) {
  x_fail <- match.arg(x_fail)
  inner_levels_set_open(
    x = x,
    open_boundary = lower_open,
    nm_open_boundary = "lower_open",
    make_open_left = FALSE,
    make_open_right = TRUE,
    label_type = "age",
    x_one = "lower",
    x_multi = "exclude",
    x_fail = x_fail
  )
}
