#' Sort Age Groups
#'
#' @description 
#' If `x` is not a factor, convert it
#' to one, then sort its levels.
#' sort its levels. Sorting is based
#' on lower limits, with upper limits
#' used to resolve ties.
#'
#' `"Total"`s come last, and NAs second-to-last
#' (unless `decreasing = TRUE`).
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

