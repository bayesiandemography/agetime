#' Diagnostics and Assertions for Age Groups
#'
#' @description
#' Check whether age group labels meet conditions.
#' The `diagnose` functions report on each condition, and the
#' `assert` functions throw an error if a condition is not met.
#'
#' - `age_diagnose_values()` and `age_assert_values()` check the
#'   elements of `labels`.
#' - `age_diagnose_levels()` and `age_assert_levels()` check
#'   the levels of `labels`, including any unused levels.
#'   Both functions require `labels` to be a factor.
#'
#' Conditions include:
#'
#' - Not overlapping
#' - Not having gaps
#' - Not having totals or missing values
#' - Having, or not having, open age groups
#' - Having an age group that starts at zero
#' - Only including age groups used by an abridged life table
#'
#' @section Abridged and complete life tables:
#'
#' - An abridged life table uses age groups `"0"`
#'   and `"1-4"`, followed by 5-year age groups such as `"5-9"` and `"10-14"`.
#' - A complete life table uses single-year age groups such as `"0"`, `"1"`, and `"2"`.
#' - Both types of life table usually have an open age group
#'   such as `"85+"` or `"100+"`.
#'
#' @section Reporting trees:
#'
#' In a reporting tree, records are tabulated at different levels of
#' detail. A census table, for instance, might have detailed
#' age groups, some broader age groups for records with less detailed
#' information, and a category for records with no information.
#' The age groups nest: any two either do not overlap, or one
#' contains the other. The most detailed age groups (the leaves of
#' the tree) cover the full span, so that every broader age group is
#' divided exactly into narrower ones. Leaves do not need to be
#' the same distance from the root: some broader age groups can be
#' divided further than others.
#'
#' Some tables use a label such as `"Total"` to mean that the
#' age is not stated. Recode such labels to `"Missing"`,
#' for instance using `x[age_is_total(x)] <- "Missing"`,
#' so that they are not treated as totals (for instance
#' by `no_total`).
#'
#' To check a complete age reporting tree, use `valid_tree = TRUE`,
#' `has_zero = TRUE`, `has_open_right = TRUE`, and `no_total = TRUE`. To
#' check trees separately for each sex or date, use [dplyr::group_by()].
#'
#' @inheritParams age_lower
#' @param no_overlap Check that no age groups overlap.
#' Different labels that describe the same interval,
#' such as `"0"` and `"infant"`, count as overlapping.
#' Totals and missing values, as defined by [age_is_total()]
#' and [age_is_missing()], are removed before checks
#' for overlaps are performed.
#' Default is `FALSE` (don't check).
#' @param no_gap Check that all ages between the
#' youngest and oldest age groups are included.
#' Default is `FALSE` (don't check).
#' @param no_total Check that there is no "total" category,
#' as defined by [age_is_total()].
#' Default is `FALSE` (don't check).
#' @param no_missing Check that there is no "missing" category,
#' as defined by [age_is_missing()].
#' Default is `FALSE` (don't check).
#' @param no_open_right Check that no age group
#' is open on the right (has no upper limit),
#' as defined by [age_is_open_right()].
#' Default is `FALSE` (don't check).
#' @param has_open_right Check that at least one age
#' group is open on the right (has no upper limit),
#' as defined by [age_is_open_right()].
#' Default is `FALSE` (don't check).
#' @param has_zero Check that at least one
#' age group has a lower limit of zero.
#' Default is `FALSE` (don't check).
#' @param valid_life Check that all labels are
#' valid for an abridged life table.
#' Default is `FALSE` (don't check).
#' @param valid_tree Check that age groups form a reporting tree:
#' any two age groups either do not overlap, or one contains the other,
#' and the most detailed age groups (those containing no other age group)
#' cover the full span of the age groups, with no gaps.
#' Totals and missing values, as defined by [age_is_total()]
#' and [age_is_missing()], are removed before the check.
#' Unlike `no_overlap`, repeated labels, and different labels
#' that describe the same interval, are allowed.
#' Whether the span starts at zero, or ends with an open age group, is
#' checked by `has_zero` and `has_open_right`.
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
#' name, for instance, `age_assert_values()`. A function that
#' calls an `assert` function can supply
#' `call = rlang::current_env()`, so that errors name that
#' function instead.
#'
#' @return
#' - `age_diagnose_levels()` and `age_diagnose_values()` return a list with
#'   a logical flag called `ok` and a [tibble][tibble::tibble()]
#'   called `details`.
#' - `age_assert_levels()` and `age_assert_values()` return `labels`
#'   invisibly, or raise an error.
#'
#' @seealso
#' - [period_assert_values()], [period_assert_levels()]
#' - [period_diagnose_values()], [period_diagnose_levels()]
#' - [cohort_assert_values()], [cohort_assert_levels()]
#' - [cohort_diagnose_values()], [cohort_diagnose_levels()]
#'
#' @examples
#' lab <- age_labels_life()
#' lab
#'
#' ## get info on everything
#' age_diagnose_values(
#'   labels = lab,
#'   no_overlap = TRUE,
#'   no_gap = TRUE,
#'   no_total = TRUE,
#'   no_missing = TRUE,
#'   has_open_right = TRUE,
#'   has_zero = TRUE,
#'   valid_life = TRUE
#' )
#'
#' ## throw error if overlap or gap
#' age_assert_values(
#'   labels = lab,
#'   no_overlap = TRUE,
#'   no_gap = TRUE
#' )
#'
#' ## check a complete reporting tree: detailed
#' ## ages, broad ages, and age not stated
#' tree <- c("0-4", "5-9", "10-14", "15+", "0-14", "Missing")
#' age_assert_values(
#'   labels = tree,
#'   valid_tree = TRUE,
#'   has_zero = TRUE,
#'   has_open_right = TRUE,
#'   no_total = TRUE
#' )
#'
#' ## broad age group not fully divided
#' age_diagnose_values(c("0-4", "5-9", "0-14"), valid_tree = TRUE)
#'
#' ## repeated labels count as overlapping...
#' df <- data.frame(
#'   age = c("0-4", "5-9", "0-4", "5-9"),
#'   sex = c("F", "F", "M", "M")
#' )
#' age_diagnose_values(df$age, no_overlap = TRUE)
#'
#' ## ...so check within groups
#' library(dplyr, warn.conflicts = FALSE)
#' df |>
#'   group_by(sex) |>
#'   mutate(age = age_assert_values(age, no_overlap = TRUE))
#'
#' ## factor with unused level
#' fac <- factor(
#'   x = "0-4",
#'   levels = c("0-4", "3-7")
#' )
#' fac
#' age_diagnose_levels(fac, no_overlap = TRUE)
#' age_diagnose_values(fac, no_overlap = TRUE)
#' @export

# When length(labels) == 0, checks on overlap, gaps, totals, NA, and life-table
# validity are vacuously satisfied. Checks that require at
# least one interval (has_*) fail.
age_diagnose_levels <- function(labels,
                      no_overlap = FALSE,
                      no_gap = FALSE,
                      no_total = FALSE,
                      no_missing = FALSE,
                      no_open_right = FALSE,
                      has_open_right = FALSE,
                      has_zero = FALSE,
                      valid_life = FALSE,
                      valid_tree = FALSE,
                      interpret_fail = c("error", "warn", "silent"),
                                x_arg = rlang::caller_arg(labels)) {
  local_caller(args = list(labels = x_arg), call = rlang::current_env())
  interpret_fail <- match.arg(interpret_fail)
  inner_diagnose(
    labels = labels,
    label_type = "age",
    interpret_single = "lower",
    interpret_multi = "below_upper",
    interpret_fail = interpret_fail,
    on = "levels",
    no_overlap = no_overlap,
    no_gap = no_gap,
    no_total = no_total,
    no_missing = no_missing,
    no_open_left = FALSE,
    no_open_right = no_open_right,
    has_zero = has_zero,
    has_open_left = FALSE,
    has_open_right = has_open_right,
    valid_life = valid_life,
    valid_tree = valid_tree
  )
}

#' @rdname age_diagnose_levels
#' @export
age_assert_levels <- function(labels,
                       no_overlap = FALSE,
                       no_gap = FALSE,
                       no_total = FALSE,
                       no_missing = FALSE,
                       no_open_right = FALSE,
                       has_open_right = FALSE,
                       has_zero = FALSE,
                       valid_life = FALSE,
                       valid_tree = FALSE,
                       interpret_fail = c("error", "warn", "silent"),
                       x_arg = rlang::caller_arg(labels),
                       call = rlang::current_env()) {
  local_caller(args = list(labels = x_arg), call = call)
  interpret_fail <- match.arg(interpret_fail)
  inner_assert(
    labels = labels,
    label_type = "age",
    interpret_single = "lower",
    interpret_multi = "below_upper",
    interpret_fail = interpret_fail,
    on = "levels",
    no_overlap = no_overlap,
    no_gap = no_gap,
    no_total = no_total,
    no_missing = no_missing,
    no_open_left = FALSE,
    no_open_right = no_open_right,
    has_zero = has_zero,
    has_open_left = FALSE,
    has_open_right = has_open_right,
    valid_life = valid_life,
    valid_tree = valid_tree,
    x_arg = x_arg,
    call = call
  )
}

#' @rdname age_diagnose_levels
#' @export
age_diagnose_values <- function(labels,
                                no_overlap = FALSE,
                                no_gap = FALSE,
                                no_total = FALSE,
                                no_missing = FALSE,
                                no_open_right = FALSE,
                                has_open_right = FALSE,
                                has_zero = FALSE,
                                valid_life = FALSE,
                                valid_tree = FALSE,
                                interpret_fail = c("error", "warn", "silent"),
                                x_arg = rlang::caller_arg(labels)) {
  local_caller(args = list(labels = x_arg), call = rlang::current_env())
  interpret_fail <- match.arg(interpret_fail)
  inner_diagnose(
    labels = labels,
    label_type = "age",
    interpret_single = "lower",
    interpret_multi = "below_upper",
    interpret_fail = interpret_fail,
    on = "values",
    no_overlap = no_overlap,
    no_gap = no_gap,
    no_total = no_total,
    no_missing = no_missing,
    no_open_left = FALSE,
    no_open_right = no_open_right,
    has_zero = has_zero,
    has_open_left = FALSE,
    has_open_right = has_open_right,
    valid_life = valid_life,
    valid_tree = valid_tree
  )
}

#' @rdname age_diagnose_levels
#' @export
age_assert_values <- function(labels,
                              no_overlap = FALSE,
                              no_gap = FALSE,
                              no_total = FALSE,
                              no_missing = FALSE,
                              no_open_right = FALSE,
                              has_open_right = FALSE,
                              has_zero = FALSE,
                              valid_life = FALSE,
                              valid_tree = FALSE,
                              interpret_fail = c("error", "warn", "silent"),
                              x_arg = rlang::caller_arg(labels),
                              call = rlang::current_env()) {
  local_caller(args = list(labels = x_arg), call = call)
  interpret_fail <- match.arg(interpret_fail)
  inner_assert(
    labels = labels,
    label_type = "age",
    interpret_single = "lower",
    interpret_multi = "below_upper",
    interpret_fail = interpret_fail,
    on = "values",
    no_overlap = no_overlap,
    no_gap = no_gap,
    no_total = no_total,
    no_missing = no_missing,
    no_open_left = FALSE,
    no_open_right = no_open_right,
    has_zero = has_zero,
    has_open_left = FALSE,
    has_open_right = has_open_right,
    valid_life = valid_life,
    valid_tree = valid_tree,
    x_arg = x_arg,
    call = call
  )
}
