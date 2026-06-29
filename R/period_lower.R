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
#' @param labels Vector of period labels.
#' @param interpret_single How to interpret
#' labels in `labels` that describe one-year periods.
#' Choices are `"lower"` (the default) and `"upper"`.
#' @param interpret_range How to interpret
#' labels in `labels` that describe multi-year periods.
#' Choices are `"include"` (the default) and
#' `"exclude"`.
#' @param interpret_fail Action if element of `labels`
#' cannot be parsed: `"error"` (the default),
#' `"warn"`, or `"silent"`.
#' @return Numeric vector with the same length as `labels`.
#'
#' @seealso
#' - [parsing_period_labels()] Interpretation details for period labels
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
#' ## 'interpret_range' is "include" (the default)
#' period_upper("2025-2030")
#' period_width("2025-2030")
#'
#' ## 'interpret_range' is "exclude"
#' period_upper("2025-2030", interpret_range = "exclude")
#' period_width("2025-2030", interpret_range = "exclude")
#'
#' ## no action when 'interpret_fail' is "silent"
#' period_lower(c("2000-2005", "long time ago"),
#'   interpret_fail = "silent"
#' )
#' @export

# When length(labels) == 0, returns numeric(0).
period_lower <- function(labels,
                         interpret_single = c("lower", "upper"),
                         interpret_range = c("include", "exclude"),
                         interpret_fail = c("error", "warn", "silent")) {
  interpret_single <- match.arg(interpret_single)
  interpret_range <- match.arg(interpret_range)
  interpret_fail <- match.arg(interpret_fail)
  inner_lower(
    labels = labels,
    label_type = "period",
    interpret_single = interpret_single,
    interpret_range = interpret_range,
    interpret_fail = interpret_fail
  )
}


#' @export
#' @rdname period_lower
period_mid <- function(labels,
                       interpret_single = c("lower", "upper"),
                       interpret_range = c("include", "exclude"),
                       interpret_fail = c("error", "warn", "silent")) {
  interpret_single <- match.arg(interpret_single)
  interpret_range <- match.arg(interpret_range)
  interpret_fail <- match.arg(interpret_fail)
  inner_mid(
    labels = labels,
    label_type = "period",
    interpret_single = interpret_single,
    interpret_range = interpret_range,
    interpret_fail = interpret_fail
  )
}


#' @export
#' @rdname period_lower
period_upper <- function(labels,
                         interpret_single = c("lower", "upper"),
                         interpret_range = c("include", "exclude"),
                         interpret_fail = c("error", "warn", "silent")) {
  interpret_single <- match.arg(interpret_single)
  interpret_range <- match.arg(interpret_range)
  interpret_fail <- match.arg(interpret_fail)
  inner_upper(
    labels = labels,
    label_type = "period",
    interpret_single = interpret_single,
    interpret_range = interpret_range,
    interpret_fail = interpret_fail
  )
}


#' @export
#' @rdname period_lower
period_width <- function(labels,
                         ## redundant, but keep so interface constant
                         interpret_single = c("lower", "upper"),
                         interpret_range = c("include", "exclude"),
                         interpret_fail = c("error", "warn", "silent")) {
  interpret_single <- match.arg(interpret_single)
  interpret_range <- match.arg(interpret_range)
  interpret_fail <- match.arg(interpret_fail)
  inner_width(
    labels = labels,
    label_type = "period",
    interpret_single = interpret_single,
    interpret_range = interpret_range,
    interpret_fail = interpret_fail
  )
}
