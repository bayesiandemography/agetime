#' Check or Make Assertions About Cohorts
#'
#' @description
#' `cohort_check()` creates reports comparing
#' cohort labels against expectations.
#'
#' `cohort_assert()` throws an error if
#' cohort labels do not conform to expectations.
#'
#' If `labels` is a factor, then the tests are applied
#' to the `levels` attribute of `labels`.
#' Otherwise the tests are applied to the
#' elements of `labels`.
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
#' @param no_total Check that there is no "Total" label.
#' Default is `FALSE` (don't check).
#' @param no_na Check that there is no `NA` label.
#' Default is `FALSE` (don't check).
#' @param include_open Check that at least
#' one cohort has no lower limit.
#' Default is `FALSE` (don't check).
#'
#' @return
#' - `cohort_check()` returns a containing a logical flag
#'   called `ok` and a tibble][tibble::tibble()]
#'   called `details`.
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
#'   include_open = TRUE
#' )
#'
#' ## throw error if overlap or gap
#' cohort_assert(
#'   labels = lab,
#'   overlap = TRUE,
#'   no_gap = TRUE,
#' )
#' @export
# When length(labels) == 0, checks on overlap, gaps, totals,
# and NA are vacuously satisfied and include_open fails.
cohort_check <- function(labels,
                         no_overlap = FALSE,
                         no_gap = FALSE,
                         no_total = FALSE,
                         no_na = FALSE,
                         include_open = FALSE,
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
    include_zero = FALSE,
    include_open = include_open,
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
                          include_open = FALSE,
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
    include_zero = FALSE,
    include_open = include_open,
    valid_life = FALSE
  )
}
