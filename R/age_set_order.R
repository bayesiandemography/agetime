#' Set Order of Age Group Levels
#'
#' Modify the `levels` attribute of `labels` so that age groups
#' are ordered by their lower limits.
#'
#' `age_set_order()` fixes a common problem with age group labels,
#' where levels are ordered alphabetically rather than numerically,
#' so that, for instance, `"10-14"` comes before `"5-9"`.
#' Calling `age_set_order()` on age group
#' labels makes the labels behave sensibly
#' with functions such as `sort()`,
#' `order()`, and `arrange()`.
#'
#' If `labels` is not a factor, and so
#' does not have levels, it is converted to a factor
#' before the ordering is performed.
#'
#' `age_set_order()` has no effect on the
#' values of `labels`. Only the levels are changed.
#'
#' When two age groups have the same lower limit,
#' the age group with the smallest upper limit comes first.
#' Labels for missing values come second-to-last in the ordering,
#' and totals come last.
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
