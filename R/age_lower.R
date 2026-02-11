
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
#' @param x Vector of age group labels.
#' @param invalid Action if meaning of label
#' unclear. Choices are `"error"` (the default),
#' `"warn"`, and `"silent"`.
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
#'
#' ## no action when label invalid
#' age_lower(c("0-4", "young people", "50plus"),
#'           invalid = "silent")
#' @export
age_lower <- function(x,
                      invalid = c("error", "warn", "silent")) {
  x <- to_character_or_factor(x = x, nm_x = "x")
  invalid <- match.arg(invalid)
  intervals <- intervals(labels = x,
                      type = "age",
                      invalid = invalid)
  get_lower(intervals)
}

#' @export
#' @rdname age_lower
age_upper <- function(x,
                      invalid = c("error", "warn", "silent")) {
  x <- to_character_or_factor(x = x, nm_x = "x")
  invalid <- match.arg(invalid)
  intervals <- intervals(labels = x,
                      type = "age",
                      invalid = invalid)
  get_upper(intervals)
}

#' @export
#' @rdname age_lower
age_width <- function(x,
                      invalid = c("error", "warn", "silent")) {
  x <- to_character_or_factor(x = x, nm_x = "x")
  invalid <- match.arg(invalid)
  intervals <- intervals(labels = x,
                      type = "age",
                      invalid = invalid)
  get_width(intervals)
}

#' @export
#' @rdname age_lower
age_mid <- function(x,
                    invalid = c("error", "warn", "silent")) {
  x <- to_character_or_factor(x = x, nm_x = "x")
  invalid <- match.arg(invalid)
  intervals <- intervals(labels = x,
                      type = "age",
                      invalid = invalid)
  get_mid(intervals)
}

