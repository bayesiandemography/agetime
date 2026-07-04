## HAS_TESTS
#' Standardize Cohort Labels
#'
#' Convert cohort labels to the default \pkg{agetime} format.
#'
#' @inheritSection cohort_lower Controlling how cohort labels are interpreted
#'
#' @inheritParams cohort_lower
#' @inherit age_standard return
#'
#' @seealso
#' - [cohort_labels()] Default \pkg{agetime} format
#' - [age_standard()] Age equivalent of `cohort_standard()`
#' - [period_standard()] Period equivalent of `cohort_standard()`
#'
#' @examples
#' labels <- c("2025to2030", "1910--1914", " < 2022 ")
#' cohort_standard(labels)
#' @export
cohort_standard <- function(labels,
                            interpret_single = c("lower", "upper"),
                            interpret_multi = c("include", "exclude"),
                            interpret_fail = c("error", "warn", "silent")) {
  interpret_single <- match.arg(interpret_single)
  interpret_multi <- match.arg(interpret_multi)
  interpret_fail <- match.arg(interpret_fail)
  inner_standard(
    labels = labels,
    label_type = "cohort",
    interpret_single = interpret_single,
    interpret_multi = interpret_multi,
    interpret_fail = interpret_fail
  )
}
