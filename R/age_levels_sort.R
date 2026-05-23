#' Sort Age Group Levels
#'
#' Sort the levels of `x`.
#'
#' If `x` is not a factor, and so
#' does not have levels,
#' convert it to a factor before
#' sorting the levels.
#' 
#' Levels are sorted on their lower
#' limits. Upper limits are used
#' to resolve times. `NA`s come
#' second-to-last and totals come last.
#'
#' @inheritParams age_lower
#' @param decreasing Whether sort is
#' increasing or decreasing. Default
#' is `FALSE`.
#'
#' @returns
#' A factor, the same length as `x`.
#' 
#' @examples
#' x <- c("0-4", "50+", "Total", NA, "20-24")
#' age_levels_sort(x)
#' @export
age_levels_sort <- function(x,
                            decreasing = FALSE,
                            x_fail = c("error", "warn", "silent")) {
  x_fail <- match.arg(x_fail)
  inner_levels_sort(x = x,
                    decreasing = decreasing,
                    label_type = "age",
                    x_one = "lower",
                    x_multi = "exclude",
                    x_fail = x_fail)
}

