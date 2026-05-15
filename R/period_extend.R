
#' Extend a Set of Periods
#'
#' Add `n` periods to an existing set of labels `x`.
#' The width of the periods is derived from the
#' `width` argument, or from the width of the last
#' label in `x`.
#'
#' @inheritParams period_lower
#' @param n The number of periods to add.
#' Default is `1`.
#' @param include_x Should the return value
#' include `x`? Default is `TRUE`.
#'
#' @returns
#' If `x` is a factor, then the return value is
#' a factor; otherwise it is a character vector.
#'
#' @examples
#' x <- c("2020-2025", "2025-2030")
#' period_extend(x, n = 2)
#' period_extend(x, n = 2, width = 10)
#' period_extend(x, n = 2, include_x = FALSE)
#' @export
period_extend <- function(x,
                          n = 1L,
                          width = NULL,
                          include_x = TRUE,
                          x_one = c("lower", "upper"),
                          x_multi = c("include", "exclude"),
                          x_fail = c("error", "warn", "silent")) {
  x_one <- match.arg(x_one)
  x_multi <- match.arg(x_multi)
  x_fail <- match.arg(x_fail)
  inner_extend(x = x,
               n = n,
               width = width,
               include_x = include_x,
               label_type = "period",
               x_one = x_one,
               x_multi = x_multi,
               x_fail = x_fail)
}



