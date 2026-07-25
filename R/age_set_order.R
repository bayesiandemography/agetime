#' Set Order of Age Group Levels
#'
#' Set the order of levels in `labels` so that age groups
#' behave as expected with functions such as `sort()` and
#' `arrange()`.
#'
#' If `labels` is not a factor, and so
#' does not have levels, it is converted to a factor
#' before the ordering is performed.
#'
#' Levels are ordered on their lower limits.
#' When there are ties, upper limits are used.
#' `NA`s come second-to-last, and totals come last.
#'
#' Observed values are preserved; only the level order changes.
#'
#' @inheritParams age_lower
#' @param decreasing Whether order is
#' increasing or decreasing. Default
#' is `FALSE`.
#' @return Factor with the same length as `labels`.
#'
#' @seealso
#' - [period_set_order()] Period equivalent of `age_set_order()`
#' - [cohort_set_order()] Cohort equivalent of `age_set_order()`
#'
#' @examples
#' labels <- c("0-4", "50+", "Total", NA, "20-24")
#' age_set_order(labels)
#' @export

# When length(labels) == 0 and there are no levels to order,
# returns an empty factor.
# When length(labels) == 0 but labels is a factor with levels,
# levels() are still ordered.
# The ordered attribute is preserved when labels is an ordered factor.
age_set_order <- function(labels,
                          decreasing = FALSE,
                          interpret_fail = c("error", "warn", "silent")) {
  interpret_fail <- match.arg(interpret_fail)
  inner_levels_set_order(
    labels = labels,
    decreasing = decreasing,
    label_type = "age",
    interpret_single = "lower",
    interpret_multi = "exclude",
    interpret_fail = interpret_fail
  )
}
