#' Extend a Set of Age Group Labels
#'
#' Add new equal-width age group labels to the end of an existing set.
#'
#' The new age groups start at the highest upper limit
#' of the age groups in `labels`, including unused levels
#' if `labels` is a factor. By default, the width
#' of the new age groups is the width of the age group
#' with the highest upper limit, but a value can be
#' specified through the `width` argument.
#'
#' `labels` cannot include totals, missing values,
#' or age groups that are open on the right.
#'
#' @inheritParams age_lower
#' @param n Number of age groups to add.
#' Default is `1`.
#' @param width Width of the age groups
#' to be added.
#' @param include_labels Should the return value
#' include `labels`? Default is `TRUE`.
#' @return A factor if `labels` is a factor, and
#' a character vector otherwise. If `labels` is a factor,
#' the new age groups are added as levels, after the
#' existing levels.
#'
#' @seealso
#' - [period_extend()] Period equivalent of `age_extend()`
#' - [cohort_extend()] Cohort equivalent of `age_extend()`
#'
#' @examples
#' labels <- c("0-4", "5-9")
#' age_extend(labels, n = 2)
#' age_extend(labels, n = 2, width = 10)
#' age_extend(labels, n = 2, include_labels = FALSE)
#' @export

# When length(labels) == 0, throws an error (no interval to extend from).
age_extend <- function(labels,
                       n = 1L,
                       width = NULL,
                       include_labels = TRUE,
                       interpret_fail = c("error", "warn", "silent")) {
  interpret_fail <- match.arg(interpret_fail)
  inner_extend(
    labels = labels,
    n = n,
    width = width,
    include_labels = include_labels,
    label_type = "age",
    interpret_single = "lower",
    interpret_multi = "below_upper",
    interpret_fail = interpret_fail
  )
}
