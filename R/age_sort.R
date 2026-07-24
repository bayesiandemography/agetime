#' Sort Age Group Levels
#'
#' Sort the levels of `labels`.
#'
#' If `labels` is not a factor, and so
#' does not have levels, it is converted to a factor
#' before the sorting is performed.
#'
#' Levels are sorted on their lower limits.
#' When there are ties, upper limits are used.
#' `NA`s come second-to-last, and totals come last.
#'
#' @inheritParams age_lower
#' @param decreasing Whether sort is
#' increasing or decreasing. Default
#' is `FALSE`.
#' @return Factor with the same length as `labels`.
#'
#' @seealso
#' - [period_sort()] Period equivalent of `age_sort()`
#' - [cohort_sort()] Cohort equivalent of `age_sort()`
#'
#' @examples
#' labels <- c("0-4", "50+", "Total", NA, "20-24")
#' age_sort(labels)
#' @export

# When length(labels) == 0 and there are no levels to sort,
# returns an empty factor.
# When length(labels) == 0 but labels is a factor with levels,
# levels() are still sorted.
# The ordered attribute is preserved when labels is an ordered factor.
age_sort <- function(labels,
                            decreasing = FALSE,
                            interpret_fail = c("error", "warn", "silent")) {
  interpret_fail <- match.arg(interpret_fail)
  inner_levels_sort(
    labels = labels,
    decreasing = decreasing,
    label_type = "age",
    interpret_single = "lower",
    interpret_multi = "exclude",
    interpret_fail = interpret_fail
  )
}
