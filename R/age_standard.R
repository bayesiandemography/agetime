## HAS_TESTS
#' Standardize Age Group Labels
#'
#' Convert age group labels to a 'standard' format.
#'
#' @inheritParams age_lower
#'
#' @return Character vector or factor with the same length as `x`.
#'
#' @seealso
#' - [period_standard()] Period equivalent of `age_standard()`
#' - [cohort_standard()] Cohort equivalent of `age_standard()`
#'
#' @examples
#' x <- c("5to9", "10--14", "100plus")
#' age_standard(x)
#'
#' ## factor input: factor in, factor out
#' age_standard(factor(c("5to9", "10--14")))
#' @export

# Character input returns character; factor input returns factor with the same
# length and ordered attribute. Element values and levels(x) are standardized.
# When length(x) == 0, returns character(0); for factors, standardized
# levels are still applied. With x_fail = "silent", unparseable labels
# become NA.
age_standard <- function(x,
                         x_fail = c("error", "warn", "silent")) {
  x_fail <- match.arg(x_fail)
  inner_standard(
    x = x,
    label_type = "age",
    x_one = "lower",
    x_multi = "exclude",
    x_fail = x_fail
  )
}
