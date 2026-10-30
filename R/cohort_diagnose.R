#' Diagnostics and Assertions for Cohorts
#'
#' @description
#' Check whether cohort labels meet conditions.
#' The `diagnose` functions report on each condition, and the
#' `assert` functions throw an error if a condition is not met.
#'
#' - `cohort_diagnose_levels()` and `cohort_assert_levels()` check the
#'   levels of a factor, including unused levels.
#' - `cohort_diagnose_values()` and `cohort_assert_values()` check the
#'   elements of `labels`, treating each element as a separate cohort.
#'
#' Conditions include:
#'
#' - Not overlapping
#' - Not having gaps
#' - Not having totals or NAs
#' - Having, or not having, open cohorts
#'
#' @inheritSection cohort_lower Rules for interpreting inputs
#'
#' @inheritParams cohort_lower
#' @param no_overlap Check that no cohorts overlap.
#' Different labels that describe the same interval,
#' such as `"<2000"` and `"before 2000"`, count as overlapping.
#' Default is `FALSE` (don't check).
#' @param no_gap Check that all cohorts between
#' the earliest and latest cohort are
#' included.
#' Default is `FALSE` (don't check).
#' @param no_total Check that there is no total category.
#' Default is `FALSE` (don't check).
#' @param no_na Check that there is no `NA` category.
#' Default is `FALSE` (don't check).
#' @param no_open_left Check that no cohort
#' is open on the left (has no lower limit).
#' Default is `FALSE` (don't check).
#' @param no_open_right Check that no cohort
#' is open on the right (has no upper limit).
#' Default is `FALSE` (don't check).
#' @param has_open_left Check that at least
#' one cohort is open on the left (has no lower limit).
#' Default is `FALSE` (don't check).
#' @param has_open_right Check that at least
#' one cohort is open on the right (has no upper limit).
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
#' - [age_diagnose_levels()] Age equivalent of `cohort_diagnose_levels()`
#' - [period_diagnose_levels()] Period equivalent of `cohort_diagnose_levels()`
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
#'   no_na = TRUE,
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
                         no_na = FALSE,
                         no_open_left = FALSE,
                         no_open_right = FALSE,
                         has_open_left = FALSE,
                         has_open_right = FALSE,
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
    no_na = no_na,
    no_open_left = no_open_left,
    no_open_right = no_open_right,
    has_zero = FALSE,
    has_open_left = has_open_left,
    has_open_right = has_open_right,
    valid_life = FALSE
  )
}

#' @rdname cohort_diagnose_levels
#' @export
cohort_assert_levels <- function(labels,
                          no_overlap = FALSE,
                          no_gap = FALSE,
                          no_total = FALSE,
                          no_na = FALSE,
                          no_open_left = FALSE,
                          no_open_right = FALSE,
                          has_open_left = FALSE,
                          has_open_right = FALSE,
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
    no_na = no_na,
    no_open_left = no_open_left,
    no_open_right = no_open_right,
    has_zero = FALSE,
    has_open_left = has_open_left,
    has_open_right = has_open_right,
    valid_life = FALSE
  )
}

#' @rdname cohort_diagnose_levels
#' @export
cohort_diagnose_values <- function(labels,
                                   no_overlap = FALSE,
                                   no_gap = FALSE,
                                   no_total = FALSE,
                                   no_na = FALSE,
                                   no_open_left = FALSE,
                                   no_open_right = FALSE,
                                   has_open_left = FALSE,
                                   has_open_right = FALSE,
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
    no_na = no_na,
    no_open_left = no_open_left,
    no_open_right = no_open_right,
    has_zero = FALSE,
    has_open_left = has_open_left,
    has_open_right = has_open_right,
    valid_life = FALSE
  )
}

#' @rdname cohort_diagnose_levels
#' @export
cohort_assert_values <- function(labels,
                                 no_overlap = FALSE,
                                 no_gap = FALSE,
                                 no_total = FALSE,
                                 no_na = FALSE,
                                 no_open_left = FALSE,
                                 no_open_right = FALSE,
                                 has_open_left = FALSE,
                                 has_open_right = FALSE,
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
    no_na = no_na,
    no_open_left = no_open_left,
    no_open_right = no_open_right,
    has_zero = FALSE,
    has_open_left = has_open_left,
    has_open_right = has_open_right,
    valid_life = FALSE
  )
}
