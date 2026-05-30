
#' Extend a Set of Periods
#'
#' Add new periods at the end of `x`.
#'
#' By default, the width of the new periods
#' is derived from the last element of `x`,
#' but a value can be specified through the
#' `width` arugment.
#'
#' @inheritParams period_lower
#' @param n Number of periods to add.
#' Default is `1`.
#' @param width Width of the periods
#' to be added. 
#' @param include_x Should the return value
#' include `x`? Default is `TRUE`.
#'
#' @return
#' A factor if `x` is a factor; otherwise a character vector.
#'
#' When `length(x) == 0`, throws an error (there is no interval to extend from).
#' If `width` is `NULL`, the error suggests supplying `width` explicitly.
#'
#' @seealso
#' - [age_extend()] Age equivalent of `period_extend()`
#' - [cohort_extend()] Cohort equivalent of `period_extend()`
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



