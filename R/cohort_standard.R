
## HAS_TESTS
#' Standardize Cohort Labels
#'
#' Convert cohort labels to a 'standard' format.
#'
#' @inheritParams cohort_lower
#'
#' @return A modified version of `x`.
#'
#' @examples
#' x <- c("2025to2030", "1910--1914", " < 2022 ")
#' cohort_standard(x)
#' @export
cohort_standard <- function(x,
                            parse_one = c("lower", "upper"),
                            parse_multi = c("include", "exclude"),
                            parse_fail = c("error", "warn", "silent")) {
  parse_one <- match.arg(parse_one)
  parse_multi <- match.arg(parse_multi)
  parse_fail <- match.arg(parse_fail)
  inner_standard(x = x,
                 label_type = "cohort",
                 parse_one = parse_one,
                 parse_multi = parse_multi,
                 parse_fail = parse_fail)
}


