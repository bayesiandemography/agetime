
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
#' @param x A vector of period labels.
#' @param parse_one Whether labels
#' for one-year periods are based on the
#' lower or upper limit of the period.
#' Default is `"lower"`.
#' @param parse_multi Whether
#' labels for multi-year periods
#' include or exclude the final
#' year of the period.
#' Default is `"include"`.
#' @param parse_fail Action if a label
#' cannot be interpreted. Choices are
#' `"error"` (the default), `"warn"`,
#' and `"silent"`.
#'
#' @return A numeric vector with same length as `x`.
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
#' ## 'parse_one' is "lower" (the default)
#' period_lower("2025")
#' period_upper("2025")
#' period_width("2025")
#'
#' ## 'parse_one' is "upper"
#' period_lower("2025", parse_one = "upper")
#' period_upper("2025", parse_one = "upper")
#' period_width("2025", parse_one = "upper")
#' 
#' ## 'parse_multi' is "include" (the default)
#' period_upper("2025-2030")
#' period_width("2025-2030")
#'
#' ## 'parse_multi' is "exclude"
#' period_upper("2025-2030", parse_multi = "exclude")
#' period_width("2025-2030", parse_multi = "exclude")
#'
#' ## no action when 'parse_fail' is "silent"
#' period_lower(c("2000-2005", "long time ago"),
#'              parse_fail = "silent")
#' @export
period_lower <- function(x,
                         parse_one = c("lower", "upper"),
                         parse_multi = c("include", "exclude"),
                         parse_fail = c("error", "warn", "silent")) {
  parse_one <- match.arg(parse_one)
  parse_multi <- match.arg(parse_multi)
  parse_fail <- match.arg(parse_fail)
  inner_lower(x = x,
              label_type = "period",
              parse_one = parse_one,
              parse_multi = parse_multi,
              parse_fail = parse_fail)
}


#' @export
#' @rdname period_lower
period_mid <- function(x,
                       parse_one = c("lower", "upper"),
                       parse_multi = c("include", "exclude"),
                       parse_fail = c("error", "warn", "silent")) {
  parse_one <- match.arg(parse_one)
  parse_multi <- match.arg(parse_multi)
  parse_fail <- match.arg(parse_fail)
  inner_mid(x = x,
            label_type = "period",
            parse_one = parse_one,
            parse_multi = parse_multi,
            parse_fail = parse_fail)
}


#' @export
#' @rdname period_lower
period_upper <- function(x,
                         parse_one = c("lower", "upper"),
                         parse_multi = c("include", "exclude"),
                         parse_fail = c("error", "warn", "silent")) {
  parse_one <- match.arg(parse_one)
  parse_multi <- match.arg(parse_multi)
  parse_fail <- match.arg(parse_fail)
  inner_upper(x = x,
              label_type = "period",
              parse_one = parse_one,
              parse_multi = parse_multi,
              parse_fail = parse_fail)
}


#' @export
#' @rdname period_lower
period_width <- function(x,
                         parse_one = c("lower", "upper"), ## redundant, but keep so interface constant
                         parse_multi = c("include", "exclude"),
                         parse_fail = c("error", "warn", "silent")) {
  parse_one <- match.arg(parse_one)
  parse_multi <- match.arg(parse_multi)
  parse_fail <- match.arg(parse_fail)
  inner_width(x = x,
              label_type = "period",
              parse_one = parse_one,
              parse_multi = parse_multi,
              parse_fail = parse_fail)
}
