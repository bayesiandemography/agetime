#' Extend a Set of Period Labels
#'
#' Add new equal-width period labels to the end of an existing set.
#'
#' The new periods start at the highest upper limit
#' of the periods in `labels`, including unused levels
#' if `labels` is a factor. By default, the width
#' of the new periods is the width of the period
#' with the highest upper limit, but a value can be
#' specified through the `width` argument.
#'
#' `labels` cannot include totals, missing values,
#' or periods that are open on the right.
#'
#' @inheritSection period_lower Rules for interpreting inputs
#'
#' @inheritParams period_lower
#' @param n Number of periods to add.
#' Default is `1`.
#' @param width Width of the periods
#' to be added.
#' @param include_labels Should the return value
#' include `labels`? Default is `TRUE`.
#' @return A factor if `labels` is a factor, and
#' a character vector otherwise. If `labels` is a factor,
#' the new periods are added as levels, after the
#' existing levels.
#'
#' @seealso
#' - [age_extend()] Age equivalent of `period_extend()`
#' - [cohort_extend()] Cohort equivalent of `period_extend()`
#'
#' @examples
#' labels <- c("2020-2025", "2025-2030")
#' period_extend(labels, n = 2)
#' period_extend(labels, n = 2, width = 10)
#' period_extend(labels, n = 2, include_labels = FALSE)
#' @export

# When length(labels) == 0, throws an error (no interval to extend from).
period_extend <- function(labels,
                          n = 1L,
                          width = NULL,
                          include_labels = TRUE,
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
  inner_extend(
    labels = labels,
    n = n,
    width = width,
    include_labels = include_labels,
    label_type = "period",
    interpret_single = interpret_single,
    interpret_multi = interpret_multi,
    interpret_fail = interpret_fail
  )
}
