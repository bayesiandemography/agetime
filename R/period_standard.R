## HAS_TESTS
#' Standardize Period Labels
#'
#' Convert period labels to the default \pkg{agetime} format.
#'
#' @inheritSection period_lower Controlling how period labels are interpreted
#'
#' @inheritParams period_lower
#' @inherit age_standard return
#'
#' @seealso
#' - [age_standard()] Age equivalent of `period_standard()`
#' - [cohort_standard()] Cohort equivalent of `period_standard()`
#'
#' @examples
#' labels <- c("2025to2030", "1910--1914", " 2022 ")
#' period_standard(labels)
#' @export
period_standard <- function(labels,
                            interpret_single = c("lower", "upper"),
                            interpret_multi = c("include", "exclude"),
                            interpret_fail = c("error", "warn", "silent")) {
  interpret_single <- match.arg(interpret_single)
  interpret_multi <- match.arg(interpret_multi)
  interpret_fail <- match.arg(interpret_fail)
  inner_standard(
    labels = labels,
    label_type = "period",
    interpret_single = interpret_single,
    interpret_multi = interpret_multi,
    interpret_fail = interpret_fail
  )
}
