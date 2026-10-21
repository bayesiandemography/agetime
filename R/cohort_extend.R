#' Extend a Set of Cohort Labels
#'
#' Add new equal-width cohort labels to the end of an existing set.
#'
#' By default, the width of the new cohorts
#' is derived from the last element of `labels`,
#' but a value can be specified through the
#' `width` argument.
#'
#' @inheritSection cohort_lower Rules for interpreting inputs
#'
#' @inheritParams cohort_lower
#' @param n Number of cohorts to add.
#' Default is `1`.
#' @param width Width of the cohorts
#' to be added.
#' @param include_labels Should the return value
#' include `labels`? Default is `TRUE`.
#' @return Character vector or factor.
#'
#' @seealso
#' - [age_extend()] Age equivalent of `cohort_extend()`
#' - [period_extend()] Period equivalent of `cohort_extend()`
#'
#' @examples
#' labels <- c("2020-2025", "2025-2030")
#' cohort_extend(labels, n = 2)
#' cohort_extend(labels, n = 2, width = 10)
#' cohort_extend(labels, n = 2, include_labels = FALSE)
#' @export

# When length(labels) == 0, throws an error (no interval to extend from).
cohort_extend <- function(labels,
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
    label_type = "cohort",
    interpret_single = interpret_single
  )
  interpret_fail <- match.arg(interpret_fail)
  inner_extend(
    labels = labels,
    n = n,
    width = width,
    include_labels = include_labels,
    label_type = "cohort",
    interpret_single = interpret_single,
    interpret_multi = interpret_multi,
    interpret_fail = interpret_fail
  )
}
