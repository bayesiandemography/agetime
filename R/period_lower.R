
## HAS_TESTS
#' Lower Limits, Upper Limits, Widths,
#' and Midpoints of Periods
#'
#' Calculate lower limits, upper limits,
#' widths, and midpoints for periods.
#'
#' Lower and upper limits can be used
#' to filter on periods.
#' See below for examples.
#'
#' @param x Vector of period labels.
#' @param x_one How to interpret
#' labels in `x` that describe one-year periods.
#' Choices are `"lower"` (the default) and `"upper"`.
#' @param x_multi How to interpret
#' labels in `x` that describe multi-year periods.
#' Choices are `"include"` (the default) and
#' `"exclude"`.
#' @param x_fail Action if element of `x`
#' cannot be parsed: `"error"` (the default),
#' `"warn"`, or `"silent"`.
#' @return Numeric vector with the same length as `x`.
#'
#' @seealso
#' - [parsing_period_labels()] Details for `x_one`, `x_multi`, and `x_fail`
#' - [age_lower()] Age equivalent of `period_lower()`
#' - [cohort_lower()] Cohort equivalent of `period_lower()`
#'
#' @examples
#' x <- c("2025-2030", "2020-2025", "2030-2035")
#' period_lower(x)
#' period_upper(x)
#' period_width(x)
#' period_mid(x)
#'
#' ## use 'period_lower()' to filter on period
#' library(dplyr, warn.conflicts = FALSE)
#' df <- tribble(    ~period, ~count,
#'               "2020-2025",     20,
#'               "2025-2030",      5,
#'               "2030-2035",     11 )
#' df
#' df |> filter(period_lower(period) >= 2025)
#'
#' ## 'x_one' is "lower" (the default)
#' period_lower("2025")
#' period_upper("2025")
#' period_width("2025")
#'
#' ## 'x_one' is "upper"
#' period_lower("2025", x_one = "upper")
#' period_upper("2025", x_one = "upper")
#' period_width("2025", x_one = "upper")
#' 
#' ## 'x_multi' is "include" (the default)
#' period_upper("2025-2030")
#' period_width("2025-2030")
#'
#' ## 'x_multi' is "exclude"
#' period_upper("2025-2030", x_multi = "exclude")
#' period_width("2025-2030", x_multi = "exclude")
#'
#' ## no action when 'x_fail' is "silent"
#' period_lower(c("2000-2005", "long time ago"),
#'              x_fail = "silent")
#' @export

# When length(x) == 0, returns numeric(0).
period_lower <- function(x,
                         x_one = c("lower", "upper"),
                         x_multi = c("include", "exclude"),
                         x_fail = c("error", "warn", "silent")) {
  x_one <- match.arg(x_one)
  x_multi <- match.arg(x_multi)
  x_fail <- match.arg(x_fail)
  inner_lower(x = x,
              label_type = "period",
              x_one = x_one,
              x_multi = x_multi,
              x_fail = x_fail)
}


#' @export
#' @rdname period_lower
period_mid <- function(x,
                       x_one = c("lower", "upper"),
                       x_multi = c("include", "exclude"),
                       x_fail = c("error", "warn", "silent")) {
  x_one <- match.arg(x_one)
  x_multi <- match.arg(x_multi)
  x_fail <- match.arg(x_fail)
  inner_mid(x = x,
            label_type = "period",
            x_one = x_one,
            x_multi = x_multi,
            x_fail = x_fail)
}


#' @export
#' @rdname period_lower
period_upper <- function(x,
                         x_one = c("lower", "upper"),
                         x_multi = c("include", "exclude"),
                         x_fail = c("error", "warn", "silent")) {
  x_one <- match.arg(x_one)
  x_multi <- match.arg(x_multi)
  x_fail <- match.arg(x_fail)
  inner_upper(x = x,
              label_type = "period",
              x_one = x_one,
              x_multi = x_multi,
              x_fail = x_fail)
}


#' @export
#' @rdname period_lower
period_width <- function(x,
                         x_one = c("lower", "upper"), ## redundant, but keep so interface constant
                         x_multi = c("include", "exclude"),
                         x_fail = c("error", "warn", "silent")) {
  x_one <- match.arg(x_one)
  x_multi <- match.arg(x_multi)
  x_fail <- match.arg(x_fail)
  inner_width(x = x,
              label_type = "period",
              x_one = x_one,
              x_multi = x_multi,
              x_fail = x_fail)
}
