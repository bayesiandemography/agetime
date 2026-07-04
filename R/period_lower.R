## HAS_TESTS
#' Limits, Widths, and Midpoints from Period Labels
#'
#' Calculate lower limits, upper limits,
#' widths, and midpoints for periods.
#'
#' Lower and upper limits can be used
#' to filter on periods.
#' See below for examples.
#'
#' @section Controlling how period labels are interpreted:
#'
#' If `interpret_single` is `"lower"` (the default),
#' then labels for single-year periods
#' are assumed to refer to lower limits,
#' so that `"2025"` means `[2025,2026)`.
#' This is the convention that data
#' providers typically use
#' for calendar years.
#'
#' If `interpret_single` is `"upper"`,
#' then labels for single-year periods
#' are assumed to refer to upper limits,
#' so that `"2025"` means `[2024,2025)`.
#' This is the convention that data providers
#' typically use for non-calendar years,
#' such as 1 July to 30 June.
#'
#' If `interpret_multi` is `"include"` (the default),
#' then labels for multi-year periods
#' are assumed to include upper limits,
#' so that `"2025-2030"` means `[2025,2030)`.
#'
#' If `interpret_multi` is `"exclude"`,
#' then labels for multi-year periods
#' are assumed to exclude the upper limits,
#' so that `"2025-2030"` means `[2025,2031)`.
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
#' period_lower(c("2000-2005", "long time ago"),
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
