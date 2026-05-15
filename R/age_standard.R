
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
                         x_fail = c("error", "warn", "silent")) {
  x_fail <- match.arg(x_fail)
  inner_standard(x = x,
                 label_type = "age",
                 x_one = "lower",
                 x_multi = "exclude",
                 x_fail = x_fail)
}


