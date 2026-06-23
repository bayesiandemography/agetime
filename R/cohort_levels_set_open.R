#' Set Open Cohort Level
#'
#' Add an open cohort level, i.e. a cohort with no lower limit.
#' Replace existing cohorts where necessary.
#'
#' @inheritParams cohort_lower
#' @param upper_open Upper limit of open cohort.
#' @return Factor with the same length as `x`.
#'
#' @seealso
#' - [parsing_cohort_labels()] Details for `x_one`, `x_multi`, and `x_fail`
#' - [age_levels_set_open()] Set open age group levels (right-open)
#'
#' @examples
#' x <- c("2020-2024", "<2000", "2015")
#' cohort_levels_set_open(x, upper_open = 2020)
#' cohort_levels_set_open(x, upper_open = 2005)
#' cohort_levels_set_open(c("2000-2004", "2010-2014"), upper_open = 1990)
#' @export

cohort_levels_set_open <- function(x,
                                   upper_open,
                                   x_one = c("lower", "upper"),
                                   x_multi = c("include", "exclude"),
                                   x_fail = c("error", "warn", "silent")) {
  x_fail <- match.arg(x_fail)
  x_one <- match.arg(x_one)
  x_multi <- match.arg(x_multi)
  inner_levels_set_open(
    x = x,
    open_boundary = upper_open,
    nm_open_boundary = "upper_open",
    make_open_left = TRUE,
    make_open_right = FALSE,
    label_type = "cohort",
    x_one = x_one,
    x_multi = x_multi,
    x_fail = x_fail
  )
}
