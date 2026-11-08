#' Set Order of Period Levels for a Reporting Tree
#'
#' Modify the `levels` attribute of `labels` so that periods
#' are ordered as a reporting tree: the most detailed periods
#' first, then broader periods, then period not stated.
#'
#' In a reporting tree, periods nest: any two periods
#' either do not overlap, or one contains the other.
#' Reporting trees arise, for instance, in
#' census tables of year of arrival, where most records have detailed periods (`"2015-2020"`), some have only broad periods (`"<2010"`), and some have no period at all (`"Missing"`).
#'
#' Levels are ordered as follows:
#'
#' 1. Leaves, that is, periods that contain no other period,
#'    ordered by lower limit.
#' 2. Broader periods, ordered so that each period comes
#'    after all periods inside it, and before any period
#'    entirely above it.
#' 3. Labels that could not be interpreted, if `interpret_fail`
#'    is `"warn"` or `"silent"`.
#' 4. Labels for missing values, as defined by [period_is_missing()].
#'
#' Different labels that describe the same period are placed
#' next to each other, in the order in which they first appear.
#' Leaves do not need to lie at the same depth in the tree.
#'
#' `period_set_order_tree()` checks only that the periods nest.
#' It does not check, for instance, that the leaves cover the
#' full span. Labels for totals, as defined by [period_is_total()], are
#' not part of a reporting tree, and cause an error.
#' Some tables use `"Total"` to mean period not stated. In such
#' cases, recode the total to `"Missing"` before calling
#' `period_set_order_tree()`, for instance using
#' `x[period_is_total(x)] <- "Missing"`.
#'
#' `period_set_order_tree()` has no effect on the
#' values of `labels`. Only the levels are changed.
#'
#' @inheritSection period_lower Rules for interpreting inputs
#'
#' @inheritParams period_lower
#' @return Factor with the same length as `labels`.
#'
#' @seealso
#' - [period_set_order()] Order periods by lower limit
#' - [age_set_order_tree()] Age equivalent of `period_set_order_tree()`
#' - [cohort_set_order_tree()] Cohort equivalent of `period_set_order_tree()`
#'
#' @examples
#' ## year of arrival: detailed periods, arrival
#' ## known only as before 2010, and not stated
#' labels <- c("2015-2020", "2010-2015", "<2000", "2000-2010",
#'             "<2010", "Missing")
#' period_set_order_tree(labels)
#' @export
period_set_order_tree <- function(labels,
                         interpret_single = c("lower", "upper"),
                         interpret_multi = NULL,
                         interpret_fail = c("error", "warn", "silent")) {
  interpret_single <- match.arg(interpret_single)
  interpret_multi <- resolve_interpret_multi(
    interpret_multi = interpret_multi,
    labels = labels,
    labels_other = NULL,
    label_type = "period",
    interpret_single = interpret_single
  )
  interpret_fail <- match.arg(interpret_fail)
  inner_levels_set_order_tree(
    labels = labels,
    label_type = "period",
    interpret_single = interpret_single,
    interpret_multi = interpret_multi,
    interpret_fail = interpret_fail
  )
}
