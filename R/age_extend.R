
#' Extend a Set of Age Groups
#'
#' Add `n` age groups to an existing set of labels `x`.
#' The width of the age groups is derived from the
#' `width` argument, or from the width of the last
#' label in `x`.
#'
#' @inheritParams age_lower
#' @param n The number of age groups to add.
#' Default is `1`.
#' @param include_x Should the return value
#' include `x`? Default is `TRUE`.
#'
#' @returns
#' If `x` is a factor, then the return value is
#' a factor; otherwise it is a character vector.
#'
#' @examples
#' x <- c("0-4", "5-9")
#' age_extend(x, n = 2)
#' age_extend(x, n = 2, width = 10)
#' age_extend(x, n = 2, include_x = FALSE)
#' @export
age_extend <- function(x,
                       n = 1L,
                       width = NULL,
                       include_x = TRUE,
                       x_fail = c("error", "warn", "silent")) {
  x_fail <- match.arg(x_fail)
  inner_extend(x = x,
               n = n,
               width = width,
               include_x = include_x,
               label_type = "age",
               x_one = "lower",
               x_multi = "exclude",
               x_fail = x_fail)
}



