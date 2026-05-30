
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
#' @param x Vector of cohort labels.
#' @param x_one Whether labels
#' for one-year cohorts are based on
#' lower or upper limit of period.
#' Default is `"lower"`.
#' @param x_multi Whether
#' labels for multi-year periods
#' include or exclude final
#' year of period.
#' Default is `"include"`.
#' @param x_fail Action if element of `x`
#' cannot be parsed: `"error"` (the default),
#' `"warn"`, or `"silent"`.
#' @return Numeric vector with the same length as `x`.
#'
#' @seealso
#' - [parsing_cohort_labels()] Details for `x_one`, `x_multi`, and `x_fail`
#' - [age_lower()] Age equivalent of `cohort_lower()`
#' - [period_lower()] Period equivalent of `cohort_lower()`
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
#' ## 'x_one' is "lower" (the default)
#' cohort_lower("2025")
#' cohort_upper("2025")
#' cohort_width("2025")
#'
#' ## 'x_one' is "upper"
#' cohort_lower("2025", x_one = "upper")
#' cohort_upper("2025", x_one = "upper")
#' cohort_width("2025", x_one = "upper")
#' 
#' ## 'x_multi' is "include" (the default)
#' cohort_upper("2025-2030")
#' cohort_width("2025-2030")
#'
#' ## 'x_multi' is "exclude"
#' cohort_upper("2025-2030", x_multi = "exclude")
#' cohort_width("2025-2030", x_multi = "exclude")
#'
#' ## no action when 'x_fail' is "silent"
#' cohort_lower(c("2000-2005", "long time ago"),
#'              x_fail = "silent")
#' @export

# When length(x) == 0, returns numeric(0).
cohort_lower <- function(x,
                         x_one = c("lower", "upper"),
                         x_multi = c("include", "exclude"),
                         x_fail = c("error", "warn", "silent")) {
  x_one <- match.arg(x_one)
  x_multi <- match.arg(x_multi)
  x_fail <- match.arg(x_fail)
  inner_lower(x = x,
              label_type = "cohort",
              x_one = x_one,
              x_multi = x_multi,
              x_fail = x_fail)
}


#' @export
#' @rdname cohort_lower
cohort_mid <- function(x,
                       x_one = c("lower", "upper"),
                       x_multi = c("include", "exclude"),
                       x_fail = c("error", "warn", "silent")) {
  x_one <- match.arg(x_one)
  x_multi <- match.arg(x_multi)
  x_fail <- match.arg(x_fail)
  inner_mid(x = x,
            label_type = "cohort",
            x_one = x_one,
            x_multi = x_multi,
            x_fail = x_fail)
}


#' @export
#' @rdname cohort_lower
cohort_upper <- function(x,
                         x_one = c("lower", "upper"),
                         x_multi = c("include", "exclude"),
                         x_fail = c("error", "warn", "silent")) {
  x_one <- match.arg(x_one)
  x_multi <- match.arg(x_multi)
  x_fail <- match.arg(x_fail)
  inner_upper(x = x,
              label_type = "cohort",
              x_one = x_one,
              x_multi = x_multi,
              x_fail = x_fail)
}


#' @export
#' @rdname cohort_lower
cohort_width <- function(x,
                         x_one = c("lower", "upper"), ## redundant, but keep so interface constant
                         x_multi = c("include", "exclude"),
                         x_fail = c("error", "warn", "silent")) {
  x_one <- match.arg(x_one)
  x_multi <- match.arg(x_multi)
  x_fail <- match.arg(x_fail)
  inner_width(x = x,
              label_type = "cohort",
              x_one = x_one,
              x_multi = x_multi,
              x_fail = x_fail)
}
