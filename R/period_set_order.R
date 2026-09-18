#' Set Order of Period Levels
#'
#' Modify the `levels` attribute of `labels` so that periods
#' are ordered by their lower limits.
#'
#' If `labels` is not a factor, and so
#' does not have levels, it is converted to a factor
#' before the ordering is performed.
#'
#' `period_set_order()` has no effect on the
#' values of `labels`. Only the levels are changed.
#'
#' When two periods have the same lower limit,
#' the period with the smallest upper limit comes first.
#' Labels for missing values come second-to-last in the ordering,
#' and totals come last.
#'
#' @inheritSection period_lower Rules for interpreting inputs
#'
#' @inheritParams period_lower
#' @param decreasing Whether order is
#' increasing or decreasing. Default
#' is `FALSE`.
#' @return Factor with the same length as `labels`.
#'
#' @seealso
#' - [age_set_order()] Age equivalent of `period_set_order()`
#' - [cohort_set_order()] Cohort equivalent of `period_set_order()`
#'
#' @examples
#' labels <- c("2020-2025", "2050", "Total", NA, "2025-2050")
#' period_set_order(labels)
#' @export

# When length(labels) == 0 and there are no levels to order,
# returns an empty factor.
# When length(labels) == 0 but labels is a factor with levels,
# levels() are still ordered.
# The ordered attribute is preserved when labels is an ordered factor.
period_set_order <- function(labels,
                             decreasing = FALSE,
                             interpret_single = c("lower", "upper"),
                             interpret_multi = c("include", "exclude"),
                             interpret_fail = c("error", "warn", "silent")) {
  interpret_single <- match.arg(interpret_single)
  interpret_multi <- match.arg(interpret_multi)
  interpret_fail <- match.arg(interpret_fail)
  inner_levels_set_order(
    labels = labels,
    decreasing = decreasing,
    label_type = "period",
    interpret_single = interpret_single,
    interpret_multi = interpret_multi,
    interpret_fail = interpret_fail
  )
}
