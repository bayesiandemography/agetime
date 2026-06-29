## HAS_TESTS
#' Standardize Period Labels
#'
#' Convert period labels to a 'standard' format.
#'
#' @inheritParams period_lower
#' @inherit age_standard return
#'
#' @seealso
#' - [parsing_period_labels()] Interpretation details for period labels
#' - [age_standard()] Age equivalent of `period_standard()`
#' - [cohort_standard()] Cohort equivalent of `period_standard()`
#'
#' @examples
#' labels <- c("2025to2030", "1910--1914", " 2022 ")
#' period_standard(labels)
#' @export
period_standard <- function(labels,
                            interpret_single = c("lower", "upper"),
                            interpret_range = c("include", "exclude"),
                            interpret_fail = c("error", "warn", "silent")) {
  interpret_single <- match.arg(interpret_single)
  interpret_range <- match.arg(interpret_range)
  interpret_fail <- match.arg(interpret_fail)
  inner_standard(
    labels = labels,
    label_type = "period",
    interpret_single = interpret_single,
    interpret_range = interpret_range,
    interpret_fail = interpret_fail
  )
}
