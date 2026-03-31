
## HAS_TESTS
#' Standardize Age Group Labels
#'
#' Convert age group labels to a 'standard' format.
#'
#' @inheritParams age_lower
#'
#' @return A modified version of `x`.
#'
#' @examples
#' x <- c("5to9", "10--14", "100plus")
#' age_standard(x)
#' @export
age_standard <- function(x,
                         parse_fail = c("error", "warn", "silent")) {
  parse_fail <- match.arg(parse_fail)
  inner_standard(x = x,
                 label_type = "age",
                 parse_one = "lower",
                 parse_multi = "exclude",
                 parse_fail = parse_fail)
}


