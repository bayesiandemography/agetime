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
#' @param labels Vector of cohort labels.
#' @param interpret_single How to interpret a single-year label.
#' If `"lower"` (the default), the label is assumed to
#' give the lower bound, so that `"2025"` means`[2025,2026)`.
#' If `"upper"`, the label is assumed to give the upper bound,
#' so that `"2025"` means `[2024,2025)`.
#' @param interpret_range How to interpret a label describing a range.
#' If `"include"` (the default), the label is assumed to give
#' the lower and upper bounds, so that `"2025-2030"`
#' means `[2025, 2030)`.
#' If `"exclude"`, the label is assumed to give the lower
#' bound and the upper bound minus 1, so that `"2025-2030"`
#'  means `[2025, 2031)`.
#' @param interpret_fail What to do if an attempt to interpret a
#' label fails: `"error"` (the default), `"warn"`, or `"silent"`.
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
#' ## 'interpret_range' is "include" (the default)
#' cohort_upper("2025-2030")
#' cohort_width("2025-2030")
#'
#' ## 'interpret_range' is "exclude"
#' cohort_upper("2025-2030", interpret_range = "exclude")
#' cohort_width("2025-2030", interpret_range = "exclude")
#'
#' ## no action when 'interpret_fail' is "silent"
#' cohort_lower(c("2000-2005", "long time ago"),
#'   interpret_fail = "silent"
#' )
#' @export

# When length(labels) == 0, returns numeric(0).
cohort_lower <- function(labels,
                         interpret_single = c("lower", "upper"),
                         interpret_range = c("include", "exclude"),
                         interpret_fail = c("error", "warn", "silent")) {
  interpret_single <- match.arg(interpret_single)
  interpret_range <- match.arg(interpret_range)
  interpret_fail <- match.arg(interpret_fail)
  inner_lower(
    labels = labels,
    label_type = "cohort",
    interpret_single = interpret_single,
    interpret_range = interpret_range,
    interpret_fail = interpret_fail
  )
}


#' @export
#' @rdname cohort_lower
cohort_mid <- function(labels,
                       interpret_single = c("lower", "upper"),
                       interpret_range = c("include", "exclude"),
                       interpret_fail = c("error", "warn", "silent")) {
  interpret_single <- match.arg(interpret_single)
  interpret_range <- match.arg(interpret_range)
  interpret_fail <- match.arg(interpret_fail)
  inner_mid(
    labels = labels,
    label_type = "cohort",
    interpret_single = interpret_single,
    interpret_range = interpret_range,
    interpret_fail = interpret_fail
  )
}


#' @export
#' @rdname cohort_lower
cohort_upper <- function(labels,
                         interpret_single = c("lower", "upper"),
                         interpret_range = c("include", "exclude"),
                         interpret_fail = c("error", "warn", "silent")) {
  interpret_single <- match.arg(interpret_single)
  interpret_range <- match.arg(interpret_range)
  interpret_fail <- match.arg(interpret_fail)
  inner_upper(
    labels = labels,
    label_type = "cohort",
    interpret_single = interpret_single,
    interpret_range = interpret_range,
    interpret_fail = interpret_fail
  )
}


#' @export
#' @rdname cohort_lower
cohort_width <- function(labels,
                         ## redundant, but keep so interface constant
                         interpret_single = c("lower", "upper"),
                         interpret_range = c("include", "exclude"),
                         interpret_fail = c("error", "warn", "silent")) {
  interpret_single <- match.arg(interpret_single)
  interpret_range <- match.arg(interpret_range)
  interpret_fail <- match.arg(interpret_fail)
  inner_width(
    labels = labels,
    label_type = "cohort",
    interpret_single = interpret_single,
    interpret_range = interpret_range,
    interpret_fail = interpret_fail
  )
}
