#' Open Right Age Group Level
#'
#' Add an open age group level, i.e. an age group with no upper limit.
#' Replace existing age groups where necessary.
#'
#' @inheritParams age_lower
#' @param lower_open Lower limit of open age group.
#' @return Factor with the same length as `labels`.
#'
#' @seealso
#' - [cohort_set_open_left()] Open cohort levels on the left
#' - [cohort_set_open_right()] Open cohort levels on the right
#'
#' @examples
#' labels <- c("20-24", "80-84", "100+")
#' age_set_open_right(labels, lower_open = 80)
#' age_set_open_right(labels, lower_open = 50)
#' age_set_open_right(c("0-4", "60-64"), lower_open = 70)
#' @export

age_set_open_right <- function(labels,
                                  lower_open,
                                  interpret_fail = c("error", "warn", "silent")) {
  interpret_fail <- match.arg(interpret_fail)
  inner_levels_set_open(
    labels = labels,
    open_boundary = lower_open,
    nm_open_boundary = "lower_open",
    make_open_left = FALSE,
    make_open_right = TRUE,
    label_type = "age",
    interpret_single = "lower",
    interpret_multi = "exclude",
    interpret_fail = interpret_fail
  )
}
