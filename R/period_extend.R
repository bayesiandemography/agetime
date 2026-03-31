
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
#' @returns If `x` is a factor, `period_extend`
#' returns a factor; otherwise it returns
#' a character vector.
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
                          parse_one = c("lower", "upper"),
                          parse_multi = c("include", "exclude"),
                          parse_fail = c("error", "warn", "silent")) {
  parse_one <- match.arg(parse_one)
  parse_multi <- match.arg(parse_multi)
  parse_fail <- match.arg(parse_fail)
  inner_extend(x = x,
               n = n,
               width = width,
               include_x = include_x,
               label_type = "period",
               parse_one = parse_one,
               parse_multi = parse_multi,
               parse_fail = parse_fail)
}



