#' Extend a Set of Age Groups
#'
#' Add new age groups at the end of `x`.
#'
#' By default, the width of the new age groups
#' is derived from the last element of `x`,
#' but a value can be specified through the
#' `width` arugment.
#'
#' @inheritParams age_lower
#' @param n Number of age groups to add.
#' Default is `1`.
#' @param width Width of the age groups
#' to be added.
#' @param include_x Should the return value
#' include `x`? Default is `TRUE`.
#' @return Character vector or factor.
#' Length is `n`, or `length(x) + n` when `include_x` is `TRUE`.
#'
#' @seealso
#' - [period_extend()] Period equivalent of `age_extend()`
#' - [cohort_extend()] Cohort equivalent of `age_extend()`
#'
#' @examples
#' x <- c("0-4", "5-9")
#' age_extend(x, n = 2)
#' age_extend(x, n = 2, width = 10)
#' age_extend(x, n = 2, include_x = FALSE)
#' @export

# When length(x) == 0, throws an error (no interval to extend from).
age_extend <- function(x,
                       n = 1L,
                       width = NULL,
                       include_x = TRUE,
                       x_fail = c("error", "warn", "silent")) {
  x_fail <- match.arg(x_fail)
  inner_extend(
    x = x,
    n = n,
    width = width,
    include_x = include_x,
    label_type = "age",
    x_one = "lower",
    x_multi = "exclude",
    x_fail = x_fail
  )
}
