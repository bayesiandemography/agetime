#' Sort Cohort Levels
#'
#' Sort the levels of `x`.
#'
#' If `x` is not a factor, and so
#' does not have levels,
#' convert it to a factor first.
#'
#' Levels are sorted on their lower
#' limits. When there are ties,
#' upper limits are used. `NA`s come
#' second-to-last, and
#' totals come last.
#'
#' @inheritParams cohort_lower
#' @param decreasing Whether sort is
#' increasing or decreasing. Default
#' is `FALSE`.
#' @return Factor with the same length as `x`.
#'
#' @seealso
#' - [parsing_cohort_labels()] Details for `x_one`, `x_multi`, and `x_fail`
#' - [age_levels_sort()] Age equivalent of `cohort_levels_sort()`
#' - [period_levels_sort()] Period equivalent of `cohort_levels_sort()`
#'
#' @examples
#' x <- c("2020-2025", "<1990", "Total", NA, "2025-2050")
#' cohort_levels_sort(x)
#' @export

# When length(x) == 0 and there are no levels to sort, returns an empty factor.
# When length(x) == 0 but x is a factor with levels, levels() are still sorted.
# The ordered attribute is preserved when x is an ordered factor.
cohort_levels_sort <- function(x,
                               decreasing = FALSE,
                               x_one = c("lower", "upper"),
                               x_multi = c("include", "exclude"),
                               x_fail = c("error", "warn", "silent")) {
  x_one <- match.arg(x_one)
  x_multi <- match.arg(x_multi)
  x_fail <- match.arg(x_fail)
  inner_levels_sort(
    x = x,
    decreasing = decreasing,
    label_type = "cohort",
    x_one = x_one,
    x_multi = x_multi,
    x_fail = x_fail
  )
}
