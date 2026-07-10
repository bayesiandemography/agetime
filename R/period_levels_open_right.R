#' Open Right Period Level
#'
#' Add an open period level, i.e. a period with no upper limit.
#' Replace existing periods where necessary.
#'
#' @inheritSection period_lower Controlling how period labels are interpreted
#'
#' @inheritParams period_lower
#' @param lower_open Lower limit of open period.
#' @return Factor with the same length as `labels`.
#'
#' @seealso
#' - [period_levels_open_left()] Open period levels on the left
#' - [cohort_levels_open_right()] Open cohort levels on the right
#'
#' @examples
#' labels <- c("2020-2024", "2025-2029", "2030")
#' period_levels_open_right(labels, lower_open = 2030)
#' @export

period_levels_open_right <- function(labels,
                                     lower_open,
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
    open_boundary = lower_open,
    nm_open_boundary = "lower_open",
    make_open_left = FALSE,
    make_open_right = TRUE,
    label_type = "period",
    interpret_single = interpret_single,
    interpret_multi = interpret_multi,
    interpret_fail = interpret_fail
  )
}
