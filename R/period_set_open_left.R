#' Open Period Levels
#'
#' Add an open period level.
#' Replace existing periods where necessary.
#'
#' - `period_set_open_left()` adds a period with no lower limit.
#' - `period_set_open_right()` adds a period with no upper limit.
#'
#' @inheritSection period_lower Controlling how period labels are interpreted
#'
#' @inheritParams period_lower
#' @param upper_open Upper limit of open period.
#' @param lower_open Lower limit of open period.
#' @return Factor with the same length as `labels`.
#'
#' @seealso
#' - [cohort_set_open_left()] Open cohort levels
#' - [age_set_open_right()] Open age group levels on the right
#'
#' @examples
#' labels <- c("2020-2024", "2025-2029")
#' period_set_open_left(labels, upper_open = 2020)
#'
#' labels <- c("2020-2024", "2025-2029", "2030")
#' period_set_open_right(labels, lower_open = 2030)
#' @export

period_set_open_left <- function(labels,
                                    upper_open,
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
    open_boundary = upper_open,
    nm_open_boundary = "upper_open",
    make_open_left = TRUE,
    make_open_right = FALSE,
    label_type = "period",
    interpret_single = interpret_single,
    interpret_multi = interpret_multi,
    interpret_fail = interpret_fail
  )
}
