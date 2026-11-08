#' Diagnostics and Assertions for Periods
#'
#' @description
#' Check whether period labels meet conditions.
#' The `diagnose` functions report on each condition, and the
#' `assert` functions throw an error if a condition is not met.
#'
#' - `period_diagnose_values()` and `period_assert_values()` check the
#'   elements of `labels`.
#' - `period_diagnose_levels()` and `period_assert_levels()` check
#'   the levels of `labels`, including any unused levels.
#'   Both functions require `labels` to be a factor.
#'
#' Conditions include:
#'
#' - Not overlapping
#' - Not having gaps
#' - Not having totals or missing values
#' - Having, or not having, open periods
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
#' To check trees separately for each group, use [dplyr::group_by()].
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
#' @param x_arg Name of `labels`, used in error messages
#' from the `assert` functions.
#' Defaults to the expression supplied for `labels`.
#' Functions that call an `assert` function can
#' supply their own name.
#' @param call Execution environment of the function
#' to be named in error messages from the `assert` functions.
#' The default is the `assert` function itself, so that errors
#' name, for instance, `period_assert_values()`. A function that
#' calls an `assert` function can supply
#' `call = rlang::current_env()`, so that errors name that
#' function instead.
#'
#' @return
#' - `period_diagnose_levels()` and `period_diagnose_values()` return a list
#'   with a logical flag called `ok` and a [tibble][tibble::tibble()]
#'   called `details`.
#' - `period_assert_levels()` and `period_assert_values()` return `labels`
#'   invisibly, or raise an error.
#'
#' @seealso
#' - [age_assert_values()], [age_assert_levels()]
#' - [age_diagnose_values()], [age_diagnose_levels()]
#' - [cohort_assert_values()], [cohort_assert_levels()]
#' - [cohort_diagnose_values()], [cohort_diagnose_levels()]
#'
#' @examples
#' lab <- period_labels_five(
#'   lower_first = 2020,
#'   lower_last = 2030
#' )
#' lab
#'
#' ## get info on everything
#' period_diagnose_values(
#'   labels = lab,
#'   no_overlap = TRUE,
#'   no_gap = TRUE,
#'   no_total = TRUE,
#'   no_missing = TRUE
#' )
#'
#' ## throw error if overlap or gap
#' period_assert_values(
#'   labels = lab,
#'   no_overlap = TRUE,
#'   no_gap = TRUE
#' )
#'
#' ## repeated labels count as overlapping...
#' df <- data.frame(
#'   period = c("2020-2025", "2025-2030", "2020-2025", "2025-2030"),
#'   sex = c("F", "F", "M", "M")
#' )
#' period_diagnose_values(df$period, no_overlap = TRUE)
#'
#' ## ...so check within groups
#' library(dplyr, warn.conflicts = FALSE)
#' df |>
#'   group_by(sex) |>
#'   mutate(period = period_assert_values(period, no_overlap = TRUE))
#'
#' ## factor with unused level
#' fac <- factor(
#'   x = "2020-2025",
#'   levels = c("2020-2025", "2030-2035")
#' )
#' fac
#' period_diagnose_levels(fac, no_gap = TRUE)
#' period_diagnose_values(fac, no_gap = TRUE)
#' @export

# When length(labels) == 0, checks on overlap, gaps, totals,
# and NA are vacuously satisfied.
period_diagnose_levels <- function(labels,
                         no_overlap = FALSE,
                         no_gap = FALSE,
                         no_total = FALSE,
                         no_missing = FALSE,
                         no_open_left = FALSE,
                         no_open_right = FALSE,
                         has_open_left = FALSE,
                         has_open_right = FALSE,
                         valid_tree = FALSE,
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
    no_missing = no_missing,
    no_open_left = no_open_left,
    no_open_right = no_open_right,
    has_zero = FALSE,
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
                          no_missing = FALSE,
                          no_open_left = FALSE,
                          no_open_right = FALSE,
                          has_open_left = FALSE,
                          has_open_right = FALSE,
                          valid_tree = FALSE,
                          interpret_single = c("lower", "upper"),
                          interpret_multi = NULL,
                          interpret_fail = c("error", "warn", "silent"),
                          x_arg = rlang::caller_arg(labels),
                          call = rlang::current_env()) {
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
    no_missing = no_missing,
    no_open_left = no_open_left,
    no_open_right = no_open_right,
    has_zero = FALSE,
    has_open_left = has_open_left,
    has_open_right = has_open_right,
    valid_life = FALSE,
    valid_tree = valid_tree,
    x_arg = x_arg,
    call = call
  )
}

#' @rdname period_diagnose_levels
#' @export
period_diagnose_values <- function(labels,
                                   no_overlap = FALSE,
                                   no_gap = FALSE,
                                   no_total = FALSE,
                                   no_missing = FALSE,
                                   no_open_left = FALSE,
                                   no_open_right = FALSE,
                                   has_open_left = FALSE,
                                   has_open_right = FALSE,
                                   valid_tree = FALSE,
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
  inner_diagnose(
    labels = labels,
    label_type = "period",
    interpret_single = interpret_single,
    interpret_multi = interpret_multi,
    interpret_fail = interpret_fail,
    on = "values",
    no_overlap = no_overlap,
    no_gap = no_gap,
    no_total = no_total,
    no_missing = no_missing,
    no_open_left = no_open_left,
    no_open_right = no_open_right,
    has_zero = FALSE,
    has_open_left = has_open_left,
    has_open_right = has_open_right,
    valid_life = FALSE,
    valid_tree = valid_tree
  )
}

#' @rdname period_diagnose_levels
#' @export
period_assert_values <- function(labels,
                                 no_overlap = FALSE,
                                 no_gap = FALSE,
                                 no_total = FALSE,
                                 no_missing = FALSE,
                                 no_open_left = FALSE,
                                 no_open_right = FALSE,
                                 has_open_left = FALSE,
                                 has_open_right = FALSE,
                                 valid_tree = FALSE,
                                 interpret_single = c("lower", "upper"),
                                 interpret_multi = NULL,
                                 interpret_fail = c("error", "warn", "silent"),
                                 x_arg = rlang::caller_arg(labels),
                                 call = rlang::current_env()) {
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
    on = "values",
    no_overlap = no_overlap,
    no_gap = no_gap,
    no_total = no_total,
    no_missing = no_missing,
    no_open_left = no_open_left,
    no_open_right = no_open_right,
    has_zero = FALSE,
    has_open_left = has_open_left,
    has_open_right = has_open_right,
    valid_life = FALSE,
    valid_tree = valid_tree,
    x_arg = x_arg,
    call = call
  )
}
