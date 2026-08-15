## HAS_TESTS
#' Limits, Widths, and Midpoints from Period Labels
#'
#' Calculate lower limits, upper limits,
#' widths, and midpoints from period labels.
#'
#' Lower and upper limits can be used
#' to filter on periods.
#' See below for examples.
#'
#' `period_mid()` assigns open periods (e.g., `"2025+"`)
#' honorary midpoints, which are useful for plotting.
#' These midpoints are based on half the median width of
#' the closed intervals in `labels`.
#'
#' @section Rules for interpreting inputs:
#'
#' Single-year periods:
#'
#' | `interpret_single`| *Rule*       | *Example* |
#' |---------------|-------------|-------------|
#' | `"lower"` | `"a" -> [a,a+1)` | `"2020" -> [2020,2021)` |
#' | `"upper"` | `"a" -> [a-1,a)` | `"2020" -> [2019,2020)` |
#'
#' Data providers typically use the "lower" convention
#' for calendar years (1 January to 31 December),
#' and the "upper" convention for non-calendar years
#' (e.g., 1 July to 30 June).
#'
#' Multi-year periods:
#'
#' | `interpret_multi`| *Rule*       | *Example* |
#' |---------------|-------------|-------------|
#' | `"include"` | `"a-<a+n>" -> [a,a+n)` | `"2020-2025" -> [2020,2025)` |
#' | `"exclude"` | `"a-<a+n-1>" -> [a,a+n)` | `"2020-2024" -> [2020,2025)` |
#'
#' A two-value label cannot describe a one-year period.
#' With `interpret_multi = "include"`, `"2010-2011"` would be
#' `[2010, 2011)` and `"2010-2010"` would be empty; both are
#' rejected. Use `"2010"`, or `"2010-2012"` for two years.
#' With `interpret_multi = "exclude"`,
#' `"2010-2011"` is two years `[2010, 2012)` and is accepted.
#'
#' @param labels Vector of period labels.
#' @param interpret_single How to interpret
#' labels for single-year periods.
#' Choices are `"lower"` (the default) and `"upper"`.
#' See below for details.
#' @param interpret_multi How to interpret
#' labels for multi-year periods.
#' Choices are `"include"` (the default) and
#' `"exclude"`. See below for details.
#' @param interpret_fail Action if element of `labels`
#' cannot be interpreted. Choices are `"error"` (the default),
#' `"warn"`, and `"silent"`.
#' @return Numeric vector with the same length as `labels`.
#'
#' @seealso
#' - [age_lower()] Age equivalent of `period_lower()`
#' - [cohort_lower()] Cohort equivalent of `period_lower()`
#'
#' @examples
#' labels <- c("2025-2030", "2020-2025", "2030-2035")
#' period_lower(labels)
#' period_upper(labels)
#' period_width(labels)
#' period_mid(labels)
#'
#' ## use 'period_lower()' to filter on period
#' library(dplyr, warn.conflicts = FALSE)
#' df <- tribble(
#'   ~period, ~count,
#'   "2020-2025", 20,
#'   "2025-2030", 5,
#'   "2030-2035", 11
#' )
#' df
#' df |> filter(period_lower(period) >= 2025)
#' 
#' ## midpoint of open periods
#' period_mid(c("2020-2030", "2030-2040", "2040+")) # 2045
#' period_mid(c("2020-2025", "2025-2030", "2030+")) # 2032.5
#'
#' ## 'interpret_single' is "lower" (the default)
#' period_lower("2025")
#' period_upper("2025")
#' period_width("2025")
#'
#' ## 'interpret_single' is "upper"
#' period_lower("2025", interpret_single = "upper")
#' period_upper("2025", interpret_single = "upper")
#' period_width("2025", interpret_single = "upper")
#'
#' ## 'interpret_multi' is "include" (the default)
#' period_upper("2025-2030")
#' period_width("2025-2030")
#'
#' ## 'interpret_multi' is "exclude"
#' period_upper("2025-2030", interpret_multi = "exclude")
#' period_width("2025-2030", interpret_multi = "exclude")
#'
#' ## no action when 'interpret_fail' is "silent"
#' period_lower(
#'   labels = c("2000-2005", "long time ago"),
#'   interpret_fail = "silent"
#' )
#' @export

# When length(labels) == 0, returns numeric(0).
period_lower <- function(labels,
                         interpret_single = c("lower", "upper"),
                         interpret_multi = c("include", "exclude"),
                         interpret_fail = c("error", "warn", "silent")) {
  interpret_single <- match.arg(interpret_single)
  interpret_multi <- match.arg(interpret_multi)
  interpret_fail <- match.arg(interpret_fail)
  inner_lower(
    labels = labels,
    label_type = "period",
    interpret_single = interpret_single,
    interpret_multi = interpret_multi,
    interpret_fail = interpret_fail
  )
}


#' @export
#' @rdname period_lower
period_mid <- function(labels,
                       interpret_single = c("lower", "upper"),
                       interpret_multi = c("include", "exclude"),
                       interpret_fail = c("error", "warn", "silent")) {
  interpret_single <- match.arg(interpret_single)
  interpret_multi <- match.arg(interpret_multi)
  interpret_fail <- match.arg(interpret_fail)
  inner_mid(
    labels = labels,
    label_type = "period",
    interpret_single = interpret_single,
    interpret_multi = interpret_multi,
    interpret_fail = interpret_fail
  )
}


#' @export
#' @rdname period_lower
period_upper <- function(labels,
                         interpret_single = c("lower", "upper"),
                         interpret_multi = c("include", "exclude"),
                         interpret_fail = c("error", "warn", "silent")) {
  interpret_single <- match.arg(interpret_single)
  interpret_multi <- match.arg(interpret_multi)
  interpret_fail <- match.arg(interpret_fail)
  inner_upper(
    labels = labels,
    label_type = "period",
    interpret_single = interpret_single,
    interpret_multi = interpret_multi,
    interpret_fail = interpret_fail
  )
}


#' @export
#' @rdname period_lower
period_width <- function(labels,
                         ## redundant, but keep so interface constant
                         interpret_single = c("lower", "upper"),
                         interpret_multi = c("include", "exclude"),
                         interpret_fail = c("error", "warn", "silent")) {
  interpret_single <- match.arg(interpret_single)
  interpret_multi <- match.arg(interpret_multi)
  interpret_fail <- match.arg(interpret_fail)
  inner_width(
    labels = labels,
    label_type = "period",
    interpret_single = interpret_single,
    interpret_multi = interpret_multi,
    interpret_fail = interpret_fail
  )
}
