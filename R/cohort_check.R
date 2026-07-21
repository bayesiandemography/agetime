#' Check or Make Assertions About Cohorts
#'
#' @description
#' `cohort_check()` reports whether cohort labels
#' meet conditions.
#'
#' `cohort_assert()` throws an error if conditions are not met.
#'
#' Conditions include:
#'
#' - Not overlapping
#' - Not having gaps
#' - Having totals or NAs
#' - Having open cohorts
#'
#' @inheritSection cohort_lower Controlling how cohort labels are interpreted
#'
#' @inheritParams cohort_lower
#' @param no_overlap Check that no cohorts overlap.
#' Default is `FALSE` (don't check).
#' @param no_gap Check that all cohorts between
#' the earliest and latest cohort are
#' included.
#' Default is `FALSE` (don't check).
#' @param no_total Check that there is no total category.
#' Default is `FALSE` (don't check).
#' @param no_na Check that there is no `NA` category.
#' Default is `FALSE` (don't check).
#' @param has_open_left Check that at least
#' one cohort is open on the left (has no lower limit).
#' Default is `FALSE` (don't check).
#' @param has_open_right Check that at least
#' one cohort is open on the right (has no upper limit).
#' Default is `FALSE` (don't check).
#'
#' @return
#' - `cohort_check()` returns a list with a logical flag
#'   called `ok` and a [tibble][tibble::tibble()] called `details`.
#' - `cohort_assert()` returns `labels` invisibly,
#'   or raises an error.
#'
#' @seealso
#' - [age_check()] Age equivalent of `cohort_check()`
#' - [period_check()] Period equivalent of `cohort_check()`
#'
#' @examples
#' lab <- cohort_labels_five(
#'   lower_first = 2020,
#'   lower_last = 2030
#' )
#' lab
#'
#' ## get info on everything
#' cohort_check(
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
#' cohort_assert(
#'   labels = lab,
#'   no_overlap = TRUE,
#'   no_gap = TRUE
#' )
#' @export
# When length(labels) == 0, checks on overlap, gaps, totals,
# and NA are vacuously satisfied and has_open_* checks fail.
cohort_check <- function(labels,
                         no_overlap = FALSE,
                         no_gap = FALSE,
                         no_total = FALSE,
                         no_na = FALSE,
                         has_open_left = FALSE,
                         has_open_right = FALSE,
                         interpret_single = c("lower", "upper"),
                         interpret_multi = c("include", "exclude"),
                         interpret_fail = c("error", "warn", "silent")) {
  interpret_single <- match.arg(interpret_single)
  interpret_multi <- match.arg(interpret_multi)
  interpret_fail <- match.arg(interpret_fail)
  inner_check(
    labels = labels,
    label_type = "cohort",
    interpret_single = interpret_single,
    interpret_multi = interpret_multi,
    interpret_fail = interpret_fail,
    no_overlap = no_overlap,
    no_gap = no_gap,
    no_total = no_total,
    no_na = no_na,
    has_zero = FALSE,
    has_open_left = has_open_left,
    has_open_right = has_open_right,
    valid_life = FALSE
  )
}

#' @rdname cohort_check
#' @export
cohort_assert <- function(labels,
                          no_overlap = FALSE,
                          no_gap = FALSE,
                          no_total = FALSE,
                          no_na = FALSE,
                          has_open_left = FALSE,
                          has_open_right = FALSE,
                          interpret_single = c("lower", "upper"),
                          interpret_multi = c("include", "exclude"),
                          interpret_fail = c("error", "warn", "silent")) {
  interpret_single <- match.arg(interpret_single)
  interpret_multi <- match.arg(interpret_multi)
  interpret_fail <- match.arg(interpret_fail)
  inner_assert(
    labels = labels,
    label_type = "cohort",
    interpret_single = interpret_single,
    interpret_multi = interpret_multi,
    interpret_fail = interpret_fail,
    no_overlap = no_overlap,
    no_gap = no_gap,
    no_total = no_total,
    no_na = no_na,
    has_zero = FALSE,
    has_open_left = has_open_left,
    has_open_right = has_open_right,
    valid_life = FALSE
  )
}
