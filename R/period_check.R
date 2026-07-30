#' Check or Make Assertions About Periods
#'
#' @description
#' `period_check()` reports whether period labels
#' meet conditions.
#'
#' `period_assert()` throws an error if conditions are not met.
#'
#' Conditions include:
#'
#' - Not overlapping
#' - Not having gaps
#' - Having totals or NAs
#' - Having open periods
#'
#' @inheritSection period_lower Rules for interpreting inputs
#'
#' @inheritParams period_lower
#' @param no_overlap Check that no periods overlap.
#' Default is `FALSE` (don't check).
#' @param no_gap Check that all periods between
#' the earliest and latest periods are included.
#' Default is `FALSE` (don't check).
#' @param no_total Check that there is no total category.
#' Default is `FALSE` (don't check).
#' @param no_na Check that there is no `NA` category.
#' Default is `FALSE` (don't check).
#' @param has_open_left Check that at least one period
#' is open on the left (has no lower limit).
#' Default is `FALSE` (don't check).
#' @param has_open_right Check that at least one period
#' is open on the right (has no upper limit).
#' Default is `FALSE` (don't check).
#'
#' @return
#' - `period_check()` returns a list with a logical flag
#'   called `ok` and a [tibble][tibble::tibble()] called `details`.
#' - `period_assert()` returns `labels` invisibly,
#'   or raises an error.
#'
#' @seealso
#' - [age_check()] Age equivalent of `period_check()`
#' - [cohort_check()] Cohort equivalent of `period_check()`
#'
#' @examples
#' lab <- period_labels_five(
#'   lower_first = 2020,
#'   lower_last = 2030
#' )
#' lab
#'
#' ## get info on everything
#' period_check(
#'   labels = lab,
#'   no_overlap = TRUE,
#'   no_gap = TRUE,
#'   no_total = TRUE,
#'   no_na = TRUE
#' )
#'
#' ## throw error if overlap or gap
#' period_assert(
#'   labels = lab,
#'   no_overlap = TRUE,
#'   no_gap = TRUE
#' )
#' @export

# When length(labels) == 0, checks on overlap, gaps, totals,
# and NA are vacuously satisfied.
period_check <- function(labels,
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
    label_type = "period",
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

#' @rdname period_check
#' @export
period_assert <- function(labels,
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
    label_type = "period",
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
