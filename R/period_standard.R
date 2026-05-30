
## HAS_TESTS
#' Standardize Period Labels
#'
#' Convert period labels to a 'standard' format.
#'
#' @inheritParams period_lower
#' @inherit age_standard return
#'
#' @seealso
#' - [parsing_period_labels()] Details for `x_one`, `x_multi`, and `x_fail`
#' - [age_standard()] Age equivalent of `period_standard()`
#' - [cohort_standard()] Cohort equivalent of `period_standard()`
#'
#' @examples
#' x <- c("2025to2030", "1910--1914", " 2022 ")
#' period_standard(x)
#' @export
period_standard <- function(x,
                            x_one = c("lower", "upper"),
                            x_multi = c("include", "exclude"),
                            x_fail = c("error", "warn", "silent")) {
  x_one <- match.arg(x_one)
  x_multi <- match.arg(x_multi)
  x_fail <- match.arg(x_fail)
  inner_standard(x = x,
                 label_type = "period",
                 x_one = x_one,
                 x_multi = x_multi,
                 x_fail = x_fail)
}


