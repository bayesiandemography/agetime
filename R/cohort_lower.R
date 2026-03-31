
## HAS_TESTS
#' Lower Limits, Upper Limits, Widths,
#' and Midpoints of Cohorts
#'
#' Calculate lower limits, upper limits,
#' widths, and midpoints for cohorts.
#'
#' Lower and upper limits can be used
#' to filter on cohorts.
#' See below for examples.
#'
#' @param x A vector of cohort labels.
#' @param parse_one Whether labels
#' for one-year cohorts are based on the
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
#' x <- c("2025-2030", "<2025", "2030-2035")
#' cohort_lower(x)
#' cohort_upper(x)
#' cohort_width(x)
#' cohort_mid(x)
#'
#' ## use 'cohort_lower()' to filter on cohort
#' library(dplyr, warn.conflicts = FALSE)
#' df <- tribble(    ~cohort, ~count,
#'               "2025-2030",     20,
#'                   "<2025",      5,
#'               "2030-2035",     11 )
#' df
#' df |> filter(cohort_lower(cohort) >= 2025)
#'
#' ## 'parse_one' is "lower" (the default)
#' cohort_lower("2025")
#' cohort_upper("2025")
#' cohort_width("2025")
#'
#' ## 'parse_one' is "upper"
#' cohort_lower("2025", parse_one = "upper")
#' cohort_upper("2025", parse_one = "upper")
#' cohort_width("2025", parse_one = "upper")
#' 
#' ## 'parse_multi' is "include" (the default)
#' cohort_upper("2025-2030")
#' cohort_width("2025-2030")
#'
#' ## 'parse_multi' is "exclude"
#' cohort_upper("2025-2030", parse_multi = "exclude")
#' cohort_width("2025-2030", parse_multi = "exclude")
#'
#' ## no action when 'parse_fail' is "silent"
#' cohort_lower(c("2000-2005", "long time ago"),
#'              parse_fail = "silent")
#' @export
cohort_lower <- function(x,
                         parse_one = c("lower", "upper"),
                         parse_multi = c("include", "exclude"),
                         parse_fail = c("error", "warn", "silent")) {
  parse_one <- match.arg(parse_one)
  parse_multi <- match.arg(parse_multi)
  parse_fail <- match.arg(parse_fail)
  inner_lower(x = x,
              label_type = "cohort",
              parse_one = parse_one,
              parse_multi = parse_multi,
              parse_fail = parse_fail)
}


#' @export
#' @rdname cohort_lower
cohort_mid <- function(x,
                       parse_one = c("lower", "upper"),
                       parse_multi = c("include", "exclude"),
                       parse_fail = c("error", "warn", "silent")) {
  parse_one <- match.arg(parse_one)
  parse_multi <- match.arg(parse_multi)
  parse_fail <- match.arg(parse_fail)
  inner_mid(x = x,
            label_type = "cohort",
            parse_one = parse_one,
            parse_multi = parse_multi,
            parse_fail = parse_fail)
}


#' @export
#' @rdname cohort_lower
cohort_upper <- function(x,
                         parse_one = c("lower", "upper"),
                         parse_multi = c("include", "exclude"),
                         parse_fail = c("error", "warn", "silent")) {
  parse_one <- match.arg(parse_one)
  parse_multi <- match.arg(parse_multi)
  parse_fail <- match.arg(parse_fail)
  inner_upper(x = x,
              label_type = "cohort",
              parse_one = parse_one,
              parse_multi = parse_multi,
              parse_fail = parse_fail)
}


#' @export
#' @rdname cohort_lower
cohort_width <- function(x,
                         parse_one = c("lower", "upper"), ## redundant, but keep so interface constant
                         parse_multi = c("include", "exclude"),
                         parse_fail = c("error", "warn", "silent")) {
  parse_one <- match.arg(parse_one)
  parse_multi <- match.arg(parse_multi)
  parse_fail <- match.arg(parse_fail)
  inner_width(x = x,
              label_type = "cohort",
              parse_one = parse_one,
              parse_multi = parse_multi,
              parse_fail = parse_fail)
}
