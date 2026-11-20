#' Diagnostics and Assertions for Periods
#'
#' @description
#' Check whether period labels meet conditions.
#' The `diagnose` functions report on each condition, and the
#' `assert` functions throw an error if a condition is not met.
#'
#' `period_diagnose_levels()` and `period_assert_levels()` check
#' the levels of `labels`, including any unused levels.
#' Both functions require `labels` to be a factor.
#'
#' Conditions include:
#'
#' - Not overlapping
#' - Not having gaps
#' - Having, or not having, totals, subtotals, or missing values
#' - Having, or not having, open periods
#'
#' @section Presence and absence checks:
#'
#' Arguments starting with `no_` require absence; arguments starting with
#' `has_` require at least one occurrence. `FALSE` means that the check
#' is not requested. On empty input, `no_` checks pass and `has_` checks fail.
#' A subtotal must be fully divided by two or more other intervals in the
#' labels being checked. For factor levels, this includes unused levels;
#' for observed-value checks, use [period_df_diagnose_values()].
#'
#' @inheritSection period_lower Rules for interpreting inputs
#'
#' @section Reporting trees:
#'
#' In a reporting tree, records are tabulated at different levels of
#' detail. A census table, for instance, might have detailed
#' periods, some broader periods for records with less detailed
#' information, and a category for records with no information.
#' The periods nest: any two either do not overlap, or one
#' contains the other. The most detailed periods (the leaves of
#' the tree) cover the full span, so that every broader period is
#' divided exactly into narrower ones. Leaves do not need to be
#' the same distance from the root: some broader periods can be
#' divided further than others.
#'
#' Some tables use a label such as `"Total"` to mean that the
#' period is not stated. Recode such labels to `"Missing"`,
#' for instance using `x[period_is_total(x)] <- "Missing"`,
#' so that they are not treated as totals (for instance
#' by `no_total`).
#'
#' To check observed values separately for each group, use [period_df_diagnose_values()].
#'
#' @inheritParams period_lower
#' @param no_overlap Check that no periods overlap.
#' Different labels that describe the same interval,
#' such as `"2020-2025"` and `"2020 to 2025"`, count as overlapping.
#' Totals and missing values, as defined by [period_is_total()]
#' and [period_is_missing()], are removed before checks
#' for overlaps are performed.
#' Default is `FALSE` (don't check).
#' @param no_gap Check that all periods between
#' the earliest and latest periods are included.
#' Default is `FALSE` (don't check).
#' @param no_total Check that there is no "total" category,
#' as defined by [period_is_total()].
#' Default is `FALSE` (don't check).
#' @param no_subtotal Check that there are no subtotals,
#' as defined by [period_is_subtotal()].
#' Subtotals are distinct from grand totals checked by `no_total`.
#' Default is `FALSE` (don't check).
#' @param no_missing Check that there is no "missing" category,
#' as defined by [period_is_missing()].
#' Default is `FALSE` (don't check).
#' @param no_open_left Check that no period
#' is open on the left (has no lower limit),
#' as defined by [period_is_open_left()].
#' Default is `FALSE` (don't check).
#' @param no_open_right Check that no period
#' is open on the right (has no upper limit),
#' as defined by [period_is_open_right()].
#' Default is `FALSE` (don't check).
#' @param has_total Check that there is at least one "total" category,
#' as defined by [period_is_total()].
#' Default is `FALSE` (don't check).
#' @param has_subtotal Check that there is at least one subtotal,
#' as defined by [period_is_subtotal()].
#' Default is `FALSE` (don't check).
#' @param has_missing Check that there is at least one "missing" category,
#' as defined by [period_is_missing()], including `NA` values.
#' Default is `FALSE` (don't check).
#' @param has_open_left Check that at least one period
#' is open on the left (has no lower limit),
#' as defined by [period_is_open_left()].
#' Default is `FALSE` (don't check).
#' @param has_open_right Check that at least one period
#' is open on the right (has no upper limit),
#' as defined by [period_is_open_right()].
#' Default is `FALSE` (don't check).
#' @param valid_tree Check that periods form a reporting tree:
#' any two periods either do not overlap, or one contains the other,
#' and the most detailed periods (those containing no other period)
#' cover the full span of the periods, with no gaps.
#' Totals and missing values, as defined by [period_is_total()]
#' and [period_is_missing()], are removed before the check.
#' Unlike `no_overlap`, repeated labels, and different labels
#' that describe the same interval, are allowed.
#' Whether the span is open on the left or right is checked by
#' `has_open_left` and `has_open_right`.
#' See the section on reporting trees.
#' Default is `FALSE` (don't check).
#' @param x_arg Name of `labels` to use in error and warning
#' messages, including messages about labels that cannot be
#' interpreted. Defaults to the expression supplied for `labels`.
#' A function that calls a `diagnose` or `assert` function can
#' supply its own name, such as `"data$age"`.
#' @param call Execution environment of the function
#' to be named in error messages from the `assert` functions.
#' The default is the `assert` function itself, so that errors
#' name, for instance, `period_assert_levels()`. A function that
#' calls an `assert` function can supply
#' `call = rlang::current_env()`, so that errors name that
#' function instead.
#'
#' @return
#' - `period_diagnose_levels()` returns a list with a logical `ok` flag
#'   and a `details` tibble containing `condition`, `passed`, and `comment`.
#' - `period_assert_levels()` returns `labels` invisibly, or raises an error.
#'
#' @seealso [period_df_diagnose_values()], [period_df_assert_values()]
#'
#' @examples
#' fac <- factor(c("2020-2025", "2025-2030", "2020-2025", "2025-2030"))
#' period_diagnose_levels(fac, no_gap = TRUE, no_overlap = TRUE)
#' period_assert_levels(fac, no_gap = TRUE)
#'
#' ## unused levels are checked too
#' fac <- factor("2020-2025",
#'               levels = c("2020-2025", "2025-2030", "2030-2035"))
#' period_diagnose_levels(fac, no_gap = TRUE)
#' @export

# When length(labels) == 0, checks on overlap, gaps, totals,
# and NA are vacuously satisfied.
period_diagnose_levels <- function(labels,
                         no_overlap = FALSE,
                         no_gap = FALSE,
                         no_total = FALSE,
                         no_subtotal = FALSE,
                         no_missing = FALSE,
                         no_open_left = FALSE,
                         no_open_right = FALSE,
                         has_total = FALSE,
                         has_subtotal = FALSE,
                         has_missing = FALSE,
                         has_open_left = FALSE,
                         has_open_right = FALSE,
                         valid_tree = FALSE,
                         interpret_single = c("lower", "upper"),
                         interpret_multi = NULL,
                         interpret_fail = c("error", "warn", "silent"),
                                   x_arg = rlang::caller_arg(labels)) {
  local_caller(args = list(labels = x_arg), call = rlang::current_env())
  interpret_single <- match.arg(interpret_single)
  interpret_multi <- resolve_interpret_multi(
    interpret_multi = interpret_multi,
    labels = labels,
    labels_other = NULL,
    label_type = "period",
    interpret_single = interpret_single
  )
  interpret_fail <- match.arg(interpret_fail)
  inner_diagnose(
    labels = labels,
    label_type = "period",
    interpret_single = interpret_single,
    interpret_multi = interpret_multi,
    interpret_fail = interpret_fail,
    on = "levels",
    no_overlap = no_overlap,
    no_gap = no_gap,
    no_total = no_total,
    no_subtotal = no_subtotal,
    no_missing = no_missing,
    no_open_left = no_open_left,
    no_open_right = no_open_right,
    has_zero = FALSE,
    has_total = has_total,
    has_subtotal = has_subtotal,
    has_missing = has_missing,
    has_open_left = has_open_left,
    has_open_right = has_open_right,
    valid_life = FALSE,
    valid_tree = valid_tree
  )
}

#' @rdname period_diagnose_levels
#' @export
period_assert_levels <- function(labels,
                          no_overlap = FALSE,
                          no_gap = FALSE,
                          no_total = FALSE,
                          no_subtotal = FALSE,
                          no_missing = FALSE,
                          no_open_left = FALSE,
                          no_open_right = FALSE,
                          has_total = FALSE,
                          has_subtotal = FALSE,
                          has_missing = FALSE,
                          has_open_left = FALSE,
                          has_open_right = FALSE,
                          valid_tree = FALSE,
                          interpret_single = c("lower", "upper"),
                          interpret_multi = NULL,
                          interpret_fail = c("error", "warn", "silent"),
                          x_arg = rlang::caller_arg(labels),
                          call = rlang::current_env()) {
  local_caller(args = list(labels = x_arg), call = call)
  interpret_single <- match.arg(interpret_single)
  interpret_multi <- resolve_interpret_multi(
    interpret_multi = interpret_multi,
    labels = labels,
    labels_other = NULL,
    label_type = "period",
    interpret_single = interpret_single
  )
  interpret_fail <- match.arg(interpret_fail)
  inner_assert(
    labels = labels,
    label_type = "period",
    interpret_single = interpret_single,
    interpret_multi = interpret_multi,
    interpret_fail = interpret_fail,
    on = "levels",
    no_overlap = no_overlap,
    no_gap = no_gap,
    no_total = no_total,
    no_subtotal = no_subtotal,
    no_missing = no_missing,
    no_open_left = no_open_left,
    no_open_right = no_open_right,
    has_zero = FALSE,
    has_total = has_total,
    has_subtotal = has_subtotal,
    has_missing = has_missing,
    has_open_left = has_open_left,
    has_open_right = has_open_right,
    valid_life = FALSE,
    valid_tree = valid_tree,
    x_arg = x_arg,
    call = call
  )
}
