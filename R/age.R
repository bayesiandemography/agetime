
## HAS_TESTS
#' Lower Limits, Upper Limits, Widths
#' and Midpoints of Age Groups
#'
#' Calculate lower limits, upper limits,
#' widths and midpoints for age groups.
#'
#' Lower and upper limits can be used
#' filter on age. See below for examples.
#'
#' `age_mid()` uses the formula
#' `age_lower(x) + 0.5 * age_width(x)`,
#' except for open age groups, such as `"100+"`,
#' where it uses `age_lower(x) + 0.5 * median_width`
#' where `median_width` is the median over
#' closed intervals.
#'
#' @param x A vector of age group labels.
#'
#' @return A numeric vector with same length as `x`.
#'
#' @examples
#' x <- c("5-9", "10-14", "100+")
#' age_lower(x)
#' age_upper(x)
#' age_width(x)
#' age_mid(x)
#'
#' ## use 'age_lower()' to filter on age
#' library(dplyr, warn.conflicts = FALSE)
#' df <- tribble(   ~age, ~count,
#'                 "5-9",     11,
#'               "10-14",     20,
#'                "100+",      7 )       
#' df
#' df |> filter(age_lower(age) >= 10)
#' @export
age_lower <- function(x) {
  obj <- make_intervals_age(x)
  get_lower(obj)
}

#' @export
#' @rdname age_lower
age_upper <- function(x) {
  obj <- make_intervals_age(x)
  get_upper(obj)
}

#' @export
#' @rdname age_lower
age_width <- function(x) {
  obj <- make_intervals_age(x)
  get_width(obj)
}

#' @export
#' @rdname age_lower
age_mid <- function(x) {
  obj <- make_intervals_age(x)
  get_mid(obj)
}

