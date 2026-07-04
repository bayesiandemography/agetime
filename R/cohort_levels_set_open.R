#' Set Open Cohort Level
#'
#' Add an open cohort level, i.e. a cohort with no lower limit.
#' Replace existing cohorts where necessary.
#'
#' @inheritSection cohort_lower Controlling how cohort labels are interpreted
#'
#' @inheritParams cohort_lower
#' @param upper_open Upper limit of open cohort.
#' @return Factor with the same length as `labels`.
#'
#' @seealso
#' - [age_levels_set_open()] Set open age group levels (right-open)
#'
#' @examples
#' labels <- c("2020-2024", "<2000", "2015")
#' cohort_levels_set_open(labels, upper_open = 2020)
#' cohort_levels_set_open(labels, upper_open = 2005)
#' cohort_levels_set_open(c("2000-2004", "2010-2014"), upper_open = 1990)
#' @export

cohort_levels_set_open <- function(labels,
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
    label_type = "cohort",
    interpret_single = interpret_single,
    interpret_multi = interpret_multi,
    interpret_fail = interpret_fail
  )
}
