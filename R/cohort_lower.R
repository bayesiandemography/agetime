## HAS_TESTS
#' Limits, Widths, and Midpoints from  Cohort Labels
#'
#' Calculate lower limits, upper limits,
#' widths, and midpoints for cohorts.
#'
#' Lower and upper limits can be used
#' to filter on cohorts.
#' See below for examples.
#'
#' @section Controlling how cohort labels are interpreted:
#'
#' If `interpret_single` is `"lower"` (the default),
#' then labels for single-year cohorts
#' are assumed to refer to lower limits,
#' so that `"2025"` means `[2025,2026)`.
#' This is the convention that data providers
#' typically use for calendar years. 
#'
#' If `interpret_single` is `"upper"`,
#' then labels for single-year cohorts
#' are assumed to refer to upper limits,
#' so that `"2025"` means `[2024,2025)`.
#' This is the convention that data providers
#' typically use for non-calendar years,
#' such as 1 July to 30 June.
#'
#' If `interpret_multi` is `"include"` (the default),
#' then labels for multi-year cohorts
#' are assumed to include upper limits,
#' so that `"2025-2030"` means `[2025,2030)`.
#'
#' If `interpret_multi` is `"exclude"`,
#' then labels for multi-year cohorts
#' are assumed to exclude the upper limits
#' so that `"2025-2030"` means `[2025,2031)`.
#'
#' @param labels Vector of cohort labels.
#' @param interpret_single How to interpret
#' labels for single-year cohorts.
#' Choices are `"lower"` (the default) and `"upper"`.
#' See below for details.
#' @param interpret_multi How to interpret
#' labels for multi-year cohorts.
#' Choices are `"include"` (the default) and
#' `"exclude"`. See below for details.
#' @param interpret_fail Action if element of `labels`
#' cannot be interpreted. Choices are `"error"` (the default),
#' `"warn"`, and `"silent"`.
#' @return Numeric vector with the same length as `labels`.
#' @examples
#' labels <- c("2025-2030", "<2025", "2030-2035")
#' cohort_lower(labels) # [2025, 2030)
#' cohort_upper(labels) # [2024, 2030)
#' cohort_width(labels) # 5
#' cohort_mid(labels) # 2027.5
#' library(dplyr, warn.conflicts = FALSE)
#' df <- tribble(
#'   ~cohort, ~count,
#'   "2025-2030", 20,
#'   "<2025", 5,
#'   "2030-2035", 11
#' )
#' df
#' df |> filter(cohort_lower(cohort) >= 2025)
#'
#' ## 'interpret_single' is "lower" (the default)
#' cohort_lower("2025")
#' cohort_upper("2025")
#' cohort_width("2025")
#'
#' ## 'interpret_single' is "upper"
#' cohort_lower("2025", interpret_single = "upper")
#' cohort_upper("2025", interpret_single = "upper")
#' cohort_width("2025", interpret_single = "upper")
#'
#' ## 'interpret_multi' is "include" (the default)
#' cohort_upper("2025-2030")
#' cohort_width("2025-2030")
#'
#' ## 'interpret_multi' is "exclude"
#' cohort_upper("2025-2030", interpret_multi = "exclude")
#' cohort_width("2025-2030", interpret_multi = "exclude")
#'
#' ## no action when 'interpret_fail' is "silent"
#' cohort_lower(c("2000-2005", "long time ago"),
#'   interpret_fail = "silent"
#' )
#' @export

# When length(labels) == 0, returns numeric(0).
cohort_lower <- function(labels,
                         interpret_single = c("lower", "upper"),
                         interpret_multi = c("include", "exclude"),
                         interpret_fail = c("error", "warn", "silent")) {
  interpret_single <- match.arg(interpret_single)
  interpret_multi <- match.arg(interpret_multi)
  interpret_fail <- match.arg(interpret_fail)
  inner_lower(
    labels = labels,
    label_type = "cohort",
    interpret_single = interpret_single,
    interpret_multi = interpret_multi,
    interpret_fail = interpret_fail
  )
}


#' @export
#' @rdname cohort_lower
cohort_mid <- function(labels,
                       interpret_single = c("lower", "upper"),
                       interpret_multi = c("include", "exclude"),
                       interpret_fail = c("error", "warn", "silent")) {
  interpret_single <- match.arg(interpret_single)
  interpret_multi <- match.arg(interpret_multi)
  interpret_fail <- match.arg(interpret_fail)
  inner_mid(
    labels = labels,
    label_type = "cohort",
    interpret_single = interpret_single,
    interpret_multi = interpret_multi,
    interpret_fail = interpret_fail
  )
}


#' @export
#' @rdname cohort_lower
cohort_upper <- function(labels,
                         interpret_single = c("lower", "upper"),
                         interpret_multi = c("include", "exclude"),
                         interpret_fail = c("error", "warn", "silent")) {
  interpret_single <- match.arg(interpret_single)
  interpret_multi <- match.arg(interpret_multi)
  interpret_fail <- match.arg(interpret_fail)
  inner_upper(
    labels = labels,
    label_type = "cohort",
    interpret_single = interpret_single,
    interpret_multi = interpret_multi,
    interpret_fail = interpret_fail
  )
}


#' @export
#' @rdname cohort_lower
cohort_width <- function(labels,
                         ## redundant, but keep so interface constant
                         interpret_single = c("lower", "upper"),
                         interpret_multi = c("include", "exclude"),
                         interpret_fail = c("error", "warn", "silent")) {
  interpret_single <- match.arg(interpret_single)
  interpret_multi <- match.arg(interpret_multi)
  interpret_fail <- match.arg(interpret_fail)
  inner_width(
    labels = labels,
    label_type = "cohort",
    interpret_single = interpret_single,
    interpret_multi = interpret_multi,
    interpret_fail = interpret_fail
  )
}
