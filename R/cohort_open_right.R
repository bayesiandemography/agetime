#' Open Right Cohort Level
#'
#' Add an open cohort level, i.e. a cohort with no upper limit.
#' Replace existing cohorts where necessary.
#'
#' @inheritSection cohort_lower Controlling how cohort labels are interpreted
#'
#' @inheritParams cohort_lower
#' @param lower_open Lower limit of open cohort.
#' @return Factor with the same length as `labels`.
#'
#' @seealso
#' - [cohort_open_left()] Open cohort levels on the left
#' - [period_open_right()] Open period levels on the right
#'
#' @examples
#' labels <- c("2020-2024", "2025-2029", "2030")
#' cohort_open_right(labels, lower_open = 2030)
#' @export

cohort_open_right <- function(labels,
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
    label_type = "cohort",
    interpret_single = interpret_single,
    interpret_multi = interpret_multi,
    interpret_fail = interpret_fail
  )
}
