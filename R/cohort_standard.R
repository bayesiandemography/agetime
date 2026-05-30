
## HAS_TESTS
#' Standardize Cohort Labels
#'
#' Convert cohort labels to a 'standard' format.
#'
#' @inheritParams cohort_lower
#' @inherit age_standard return
#'
#' @seealso
#' [age_standard()] Age equivalent of `cohort_standard()`
#' [period_standard()] Period equivalent of `cohort_standard()`
#'
#' @examples
#' x <- c("2025to2030", "1910--1914", " < 2022 ")
#' cohort_standard(x)
#' @export
cohort_standard <- function(x,
                            x_one = c("lower", "upper"),
                            x_multi = c("include", "exclude"),
                            x_fail = c("error", "warn", "silent")) {
  x_one <- match.arg(x_one)
  x_multi <- match.arg(x_multi)
  x_fail <- match.arg(x_fail)
  inner_standard(x = x,
                 label_type = "cohort",
                 x_one = x_one,
                 x_multi = x_multi,
                 x_fail = x_fail)
}


