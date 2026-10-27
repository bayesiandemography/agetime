## HAS_TESTS
#' Limits, Widths, Midpoints, and Intervals from Cohort Labels
#'
#' Calculate lower limits, upper limits,
#' widths, midpoints, and intervals from cohort labels.
#'
#' Lower and upper limits can be used
#' to filter on cohorts.
#' See below for examples.
#'
#' `cohort_mid()` assigns open cohorts (e.g., `"<2000"`)
#' honorary midpoints, which are useful for plotting.
#' An interval that is open on the right gets a midpoint
#' half the width of the closed cohort with the highest lower limit,
#' and an interval that is open on the left gets a midpoint
#' half the width of the closed cohort with the lowest upper limit.
#' If `labels` has no closed cohorts, `cohort_mid()`
#' throws an error.
#'
#' `cohort_interval()` describes each cohort using
#' interval notation. For instance, `"[2020, 2025)"`
#' includes 2020 but not 2025, and `"(-Inf, 2000)"` has
#' no lower limit. `cohort_interval()` is useful for checking
#' how labels are being interpreted.
#'
#' @section Rules for interpreting inputs:
#'
#' "Lower" and "upper" refer to the lower and upper limits of
#' a cohort, as returned by `cohort_lower()` and `cohort_upper()`.
#'
#' Single-year cohorts:
#'
#' A single-year label consists of a year and nothing else,
#' such as `"2020"`.
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
#' Multi-year cohorts:
#'
#' | `interpret_multi`| *Rule*       | *Example* |
#' |---------------|-------------|-------------|
#' | `"at_upper"` | `"a-b" -> [a,b)` | `"2020-2025" -> [2020,2025)` |
#' | `"below_upper"` | `"a-b" -> [a,b+1)` | `"2020-2024" -> [2020,2025)` |
#'
#' In a multi-year label, the first number is always the lower
#' limit, whatever the value of `interpret_single`.
#'
#' If `interpret_multi` is `NULL` (the default), multi-year
#' labels are interpreted using `"at_upper"`. However, if a label
#' has a width of 4, 9, 14, ... years under `"at_upper"`, such as
#' `"2020-2024"`, the label was probably written using
#' `"below_upper"`, and `agetime` gives a message. Supplying a value
#' for `interpret_multi` silences the message.
#'
#' A two-value label cannot describe a one-year cohort.
#' With `interpret_multi = "at_upper"`, `"2010-2011"` would be
#' `[2010, 2011)` and `"2010-2010"` would be empty; both are
#' rejected. Use `"2010"`, or `"2010-2012"` for two years.
#' With `interpret_multi = "below_upper"`,
#' `"2010-2011"` is two years `[2010, 2012)` and is accepted.
#'
#' Open cohorts:
#'
#' | *Label* | *Interval* |
#' |---------------|-------------|
#' | `"<2000"`, `"before 2000"`, `"under 2000"` | `(-Inf,2000)` |
#' | `"2000 or earlier"`, `"up to 2000"` | `(-Inf,2001)` |
#' | `"2000+"`, `"2000 or more"`, `"2000 or later"` | `[2000,Inf)` |
#'
#' Labels starting with `"-"`, such as `"-2000"`, are not accepted.
#'
#' @param labels Vector of cohort labels.
#' @param interpret_single How to interpret a single-year
#' label, that is, a label consisting of a year and nothing
#' else, such as `"2020"`. With `"lower"` (the default),
#' 2020 is the lower limit of the cohort. With `"upper"`,
#' 2020 is the upper limit. See below for details.
#' @param interpret_multi How to interpret the second number
#' in a multi-year label, such as `"2020-2025"`. With
#' `"at_upper"`, the second number is the upper
#' limit of the cohort. With `"below_upper"`, the second
#' number is one year below the upper limit.
#' The default, `NULL`, behaves like `"at_upper"`, but gives
#' a message if labels look like they use `"below_upper"`.
#' See below for details.
#' @param interpret_fail Action if element of `labels`
#' cannot be interpreted. Choices are `"error"` (the default),
#' `"warn"`, and `"silent"`.
#' @return `cohort_interval()` returns a character vector,
#' and the other functions return a numeric vector.
#' The result has the same length as `labels`.
#' If `labels` has names, the result has the same names.
#' @examples
#' labels <- c("2025-2030", "<2025", "2030-2035")
#' cohort_lower(labels) # [2025, 2030)
#' cohort_upper(labels) # [2024, 2030)
#' cohort_width(labels) # 5
#' cohort_mid(labels) # 2027.5
#' cohort_interval(labels)
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
#' ## midpoint of open cohorts
#' cohort_mid(c("<2000", "2000-2010", "2010-2020")) # 1995
#' cohort_mid(c("<2000", "2000-2005", "2005-2010")) # 1997.5
#'
#' ## 'interpret_single' is "lower" (the default)
#' cohort_lower("2025")
#' cohort_upper("2025")
#' cohort_width("2025")
#' cohort_interval("2025")
#'
#' ## 'interpret_single' is "upper"
#' cohort_lower("2025", interpret_single = "upper")
#' cohort_upper("2025", interpret_single = "upper")
#' cohort_width("2025", interpret_single = "upper")
#' cohort_interval("2025", interpret_single = "upper")
#'
#' ## 'interpret_multi' is "at_upper"
#' ## (the default, NULL, behaves like "at_upper")
#' cohort_upper("2025-2030")
#' cohort_width("2025-2030")
#' cohort_interval("2025-2030")
#'
#' ## 'interpret_multi' is "below_upper"
#' cohort_upper("2025-2030", interpret_multi = "below_upper")
#' cohort_width("2025-2030", interpret_multi = "below_upper")
#' cohort_interval("2025-2030", interpret_multi = "below_upper")
#'
#' ## no action when 'interpret_fail' is "silent"
#' cohort_lower(
#'   labels = c("2000-2005", "long time ago"),
#'   interpret_fail = "silent"
#' )
#' @export

# When length(labels) == 0, returns numeric(0).
cohort_lower <- function(labels,
                         interpret_single = c("lower", "upper"),
                         interpret_multi = NULL,
                         interpret_fail = c("error", "warn", "silent")) {
  interpret_single <- match.arg(interpret_single)
  interpret_multi <- resolve_interpret_multi(
    interpret_multi = interpret_multi,
    labels = labels,
    labels_other = NULL,
    label_type = "cohort",
    interpret_single = interpret_single
  )
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
                       interpret_multi = NULL,
                       interpret_fail = c("error", "warn", "silent")) {
  interpret_single <- match.arg(interpret_single)
  interpret_multi <- resolve_interpret_multi(
    interpret_multi = interpret_multi,
    labels = labels,
    labels_other = NULL,
    label_type = "cohort",
    interpret_single = interpret_single
  )
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
                         interpret_multi = NULL,
                         interpret_fail = c("error", "warn", "silent")) {
  interpret_single <- match.arg(interpret_single)
  interpret_multi <- resolve_interpret_multi(
    interpret_multi = interpret_multi,
    labels = labels,
    labels_other = NULL,
    label_type = "cohort",
    interpret_single = interpret_single
  )
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
                         interpret_multi = NULL,
                         interpret_fail = c("error", "warn", "silent")) {
  interpret_single <- match.arg(interpret_single)
  interpret_multi <- resolve_interpret_multi(
    interpret_multi = interpret_multi,
    labels = labels,
    labels_other = NULL,
    label_type = "cohort",
    interpret_single = interpret_single
  )
  interpret_fail <- match.arg(interpret_fail)
  inner_width(
    labels = labels,
    label_type = "cohort",
    interpret_single = interpret_single,
    interpret_multi = interpret_multi,
    interpret_fail = interpret_fail
  )
}


#' @export
#' @rdname cohort_lower
cohort_interval <- function(labels,
                            interpret_single = c("lower", "upper"),
                            interpret_multi = NULL,
                            interpret_fail = c("error", "warn", "silent")) {
  interpret_single <- match.arg(interpret_single)
  interpret_multi <- resolve_interpret_multi(
    interpret_multi = interpret_multi,
    labels = labels,
    labels_other = NULL,
    label_type = "cohort",
    interpret_single = interpret_single
  )
  interpret_fail <- match.arg(interpret_fail)
  inner_interval(
    labels = labels,
    label_type = "cohort",
    interpret_single = interpret_single,
    interpret_multi = interpret_multi,
    interpret_fail = interpret_fail
  )
}
