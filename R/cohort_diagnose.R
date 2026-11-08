#' Diagnostics and Assertions for Cohorts
#'
#' @description
#' Check whether cohort labels meet conditions.
#' The `diagnose` functions report on each condition, and the
#' `assert` functions throw an error if a condition is not met.
#'
#' - `cohort_diagnose_values()` and `cohort_assert_values()` check the
#'   elements of `labels`.
#' - `cohort_diagnose_levels()` and `cohort_assert_levels()` check
#'   the levels of `labels`, including any unused levels.
#'   Both functions require `labels` to be a factor.
#'
#' Conditions include:
#'
#' - Not overlapping
#' - Not having gaps
#' - Not having totals or missing values
#' - Having, or not having, open cohorts
#'
#' @inheritSection cohort_lower Rules for interpreting inputs
#'
#' @section Reporting trees:
#'
#' In a reporting tree, records are tabulated at different levels of
#' detail. A census table, for instance, might have detailed
#' cohorts, some broader cohorts for records with less detailed
#' information, and a category for records with no information.
#' The cohorts nest: any two either do not overlap, or one
#' contains the other. The most detailed cohorts (the leaves of
#' the tree) cover the full span, so that every broader cohort is
#' divided exactly into narrower ones. Leaves do not need to be
#' the same distance from the root: some broader cohorts can be
#' divided further than others.
#'
#' Some tables use a label such as `"Total"` to mean that the
#' cohort is not stated. Recode such labels to `"Missing"`,
#' for instance using `x[cohort_is_total(x)] <- "Missing"`,
#' so that they are not treated as totals (for instance
#' by `no_total`).
#'
#' To check trees separately for each group, use [dplyr::group_by()].
#'
#' @inheritParams cohort_lower
#' @param no_overlap Check that no cohorts overlap.
#' Different labels that describe the same interval,
#' such as `"<2000"` and `"before 2000"`, count as overlapping.
#' Totals and missing values, as defined by [cohort_is_total()]
#' and [cohort_is_missing()], are removed before checks
#' for overlaps are performed.
#' Default is `FALSE` (don't check).
#' @param no_gap Check that all cohorts between
#' the earliest and latest cohort are
#' included.
#' Default is `FALSE` (don't check).
#' @param no_total Check that there is no "total" category,
#' as defined by [cohort_is_total()].
#' Default is `FALSE` (don't check).
#' @param no_missing Check that there is no "missing" category,
#' as defined by [cohort_is_missing()].
#' Default is `FALSE` (don't check).
#' @param no_open_left Check that no cohort
#' is open on the left (has no lower limit),
#' as defined by [cohort_is_open_left()].
#' Default is `FALSE` (don't check).
#' @param no_open_right Check that no cohort
#' is open on the right (has no upper limit),
#' as defined by [cohort_is_open_right()].
#' Default is `FALSE` (don't check).
#' @param has_open_left Check that at least
#' one cohort is open on the left (has no lower limit),
#' as defined by [cohort_is_open_left()].
#' Default is `FALSE` (don't check).
#' @param has_open_right Check that at least
#' one cohort is open on the right (has no upper limit),
#' as defined by [cohort_is_open_right()].
#' Default is `FALSE` (don't check).
#' @param valid_tree Check that cohorts form a reporting tree:
#' any two cohorts either do not overlap, or one contains the other,
#' and the most detailed cohorts (those containing no other cohort)
#' cover the full span of the cohorts, with no gaps.
#' Totals and missing values, as defined by [cohort_is_total()]
#' and [cohort_is_missing()], are removed before the check.
#' Unlike `no_overlap`, repeated labels, and different labels
#' that describe the same interval, are allowed.
#' Whether the span is open on the left or right is checked by
#' `has_open_left` and `has_open_right`.
#' See the section on reporting trees.
#' Default is `FALSE` (don't check).
#'
#' @return
#' - `cohort_diagnose_levels()` and `cohort_diagnose_values()` return a list
#'   with a logical flag called `ok` and a [tibble][tibble::tibble()]
#'   called `details`.
#' - `cohort_assert_levels()` and `cohort_assert_values()` return `labels`
#'   invisibly, or raise an error.
#'
#' @seealso
#' - [age_assert_values()], [age_assert_levels()]
#' - [age_diagnose_values()], [age_diagnose_levels()]
#' - [period_assert_values()], [period_assert_levels()]
#' - [period_diagnose_values()], [period_diagnose_levels()]
#'
#' @examples
#' lab <- cohort_labels_five(
#'   lower_first = 2020,
#'   lower_last = 2030
#' )
#' lab
#'
#' ## get info on everything
#' cohort_diagnose_values(
#'   labels = lab,
#'   no_overlap = TRUE,
#'   no_gap = TRUE,
#'   no_total = TRUE,
#'   no_missing = TRUE,
#'   has_open_left = TRUE,
#'   has_open_right = TRUE
#' )
#'
#' ## throw error if overlap or gap
#' cohort_assert_values(
#'   labels = lab,
#'   no_overlap = TRUE,
#'   no_gap = TRUE
#' )
#'
#' ## repeated labels count as overlapping...
#' df <- data.frame(
#'   cohort = c("2020-2025", "2025-2030", "2020-2025", "2025-2030"),
#'   sex = c("F", "F", "M", "M")
#' )
#' cohort_diagnose_values(df$cohort, no_overlap = TRUE)
#'
#' ## ...so check within groups
#' library(dplyr, warn.conflicts = FALSE)
#' df |>
#'   group_by(sex) |>
#'   mutate(cohort = cohort_assert_values(cohort, no_overlap = TRUE))
#'
#' ## factor with unused level
#' fac <- factor(
#'   x = "2020-2025",
#'   levels = c("2020-2025", "2030-2035")
#' )
#' fac
#' cohort_diagnose_levels(fac, no_gap = TRUE)
#' cohort_diagnose_values(fac, no_gap = TRUE)
#' @export
# When length(labels) == 0, checks on overlap, gaps, totals,
# and NA are vacuously satisfied and has_open_* checks fail.
cohort_diagnose_levels <- function(labels,
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
    label_type = "cohort",
    interpret_single = interpret_single
  )
  interpret_fail <- match.arg(interpret_fail)
  inner_diagnose(
    labels = labels,
    label_type = "cohort",
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

#' @rdname cohort_diagnose_levels
#' @export
cohort_assert_levels <- function(labels,
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
    label_type = "cohort",
    interpret_single = interpret_single
  )
  interpret_fail <- match.arg(interpret_fail)
  inner_assert(
    labels = labels,
    label_type = "cohort",
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

#' @rdname cohort_diagnose_levels
#' @export
cohort_diagnose_values <- function(labels,
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
    label_type = "cohort",
    interpret_single = interpret_single
  )
  interpret_fail <- match.arg(interpret_fail)
  inner_diagnose(
    labels = labels,
    label_type = "cohort",
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

#' @rdname cohort_diagnose_levels
#' @export
cohort_assert_values <- function(labels,
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
    label_type = "cohort",
    interpret_single = interpret_single
  )
  interpret_fail <- match.arg(interpret_fail)
  inner_assert(
    labels = labels,
    label_type = "cohort",
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
