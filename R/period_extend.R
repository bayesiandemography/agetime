
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
                          label_one = c("lower", "upper"),
                          label_multi = c("include", "exclude"),
                          unknown_label = c("error", "warn", "silent")) {
  label_one <- match.arg(label_one)
  label_multi <- match.arg(label_multi)
  unknown_label <- match.arg(unknown_label)
  inner_extend(x = x,
               n = n,
               width = width,
               include_x = include_x,
               label_type = "period",
               label_one = label_one,
               label_multi = label_multi,
               unknown_label = unknown_label)
}



