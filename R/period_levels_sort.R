#' Sort Period Levels
#'
#' Sort the levels of `labels`.
#'
#' If `labels` is not a factor, and so
#' does not have  levels,
#' convert it to a factor first.
#'
#' Levels are sorted on their lower
#' limits. When there are ties,
#' upper limits are used. `NA`s come
#' second-to-last, and
#' totals come last.
#'
#' @inheritSection period_lower Controlling how period labels are interpreted
#'
#' @inheritParams period_lower
#' @param decreasing Whether sort is
#' increasing or decreasing. Default
#' is `FALSE`.
#' @return Factor with the same length as `labels`.
#'
#' @seealso
#' - [age_levels_sort()] Age equivalent of `period_levels_sort()`
#' - [cohort_levels_sort()] Cohort equivalent of `period_levels_sort()`
#'
#' @examples
#' labels <- c("2020-2025", "2050", "Total", NA, "2025-2050")
#' period_levels_sort(labels)
#' @export

# When length(labels) == 0 and there are no levels to sort,
# returns an empty factor.
# When length(labels) == 0 but labels is a factor with levels,
# levels() are still sorted.
# The ordered attribute is preserved when labels is an ordered factor.
period_levels_sort <- function(labels,
                               decreasing = FALSE,
                               interpret_single = c("lower", "upper"),
                               interpret_multi = c("include", "exclude"),
                               interpret_fail = c("error", "warn", "silent")) {
  interpret_single <- match.arg(interpret_single)
  interpret_multi <- match.arg(interpret_multi)
  interpret_fail <- match.arg(interpret_fail)
  inner_levels_sort(
    labels = labels,
    decreasing = decreasing,
    label_type = "period",
    interpret_single = interpret_single,
    interpret_multi = interpret_multi,
    interpret_fail = interpret_fail
  )
}
