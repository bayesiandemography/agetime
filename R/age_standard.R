
## HAS_TESTS
#' Standardize Age Group Labels
#'
#' Convert age group labels to a 'standard' format.
#'
#' @inheritParams age_lower
#'
#' @return
#' A vector the same length as `x` with standardized labels.
#'
#' If `x` is a character vector, returns a character vector.
#' If `x` is a factor, returns a factor with the same length and
#' `ordered` attribute as `x`. Element values and `levels(x)` are
#' standardized; level order is unchanged except where two or more
#' levels collapse to the same string after standardization (the first
#' occurrence in `levels(x)` is kept).
#' When `length(x) == 0`, standardized `levels(x)` are still applied.
#'
#' With `x_fail = "silent"`, labels that cannot be parsed are mapped to
#' `NA` (including in `levels()` for factors).
#'
#' @examples
#' x <- c("5to9", "10--14", "100plus")
#' age_standard(x)
#'
#' ## factor input: factor in, factor out
#' age_standard(factor(c("5to9", "10--14")))
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


