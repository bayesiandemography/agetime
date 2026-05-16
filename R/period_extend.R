
#' Extend a Set of Periods
#'
#' Create `n` new periods.
#' The width of the new periods
#' can be specified through the `width`
#' argument.  Otherwise it is derived from
#' the last element of `x`.
#'
#' @inheritParams period_lower
#' @param n Number of periods to add.
#' Default is `1`.
#' @param width Width of the periods
#' to be added. 
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



