#' Sort Period Levels
#'
#' Sort the levels of `x`.
#'
#' If `x` is not a factor, and so
#' does not have  levels,
#' convert it to a factor first.
#'
#' Levels are sorted on their lower
#' limits. When there are ties,
#' upper limits are used. `NA`s come
#' second-to-last, and
#' totals come last.
#'
#' @inheritParams period_lower
#' @param decreasing Whether sort is
#' increasing or decreasing. Default
#' is `FALSE`.
#'
#' @returns
#' A factor, the same length as `x`.
#' 
#' @examples
#' x <- c("2020-2025", "2050", "Total", NA, "2025-2050")
#' period_levels_sort(x)
#' @export
period_levels_sort <- function(x,
                               decreasing = FALSE,
                               x_one = c("lower", "upper"),
                               x_multi = c("include", "exclude"),
                               x_fail = c("error", "warn", "silent")) {
  x_one <- match.arg(x_one)
  x_multi <- match.arg(x_multi)
  x_fail <- match.arg(x_fail)
  inner_levels_sort(x = x,
                    decreasing = decreasing,
                    label_type = "period",
                    x_one = x_one,
                    x_multi = x_multi,
                    x_fail = x_fail)
}

