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
#'
#' `cohort_interval()` describes each cohort using
#' interval notation. For instance, `"[2020, 2025)"`
#' includes 2020 but not 2025, and `"(-Inf, 2000)"` has
#' no lower limit. `cohort_interval()` is useful for checking
#' how labels are being interpreted.
#'
#' @section Rules for interpreting inputs:
#'
#' **Single-year**
#'
#' Labels for single-year cohorts sometimes refer to
#' the lower limits of cohorts, and sometimes
#' refer to upper limits. For instance, the label `"2020"`
#' is sometimes used to refer to the cohort that
#' starts at midnight on 1 January 2020
#' and ends at midnight on 1 January 2021,
#' and is sometimes used to refer to the
#' cohort that starts at midnight on 1 July 2019
#' and ends at midnight on 1 July 2020.
#'
#' The `interpret_single` argument can be used to distinguish
#' between the two conventions:
#'
#' | `interpret_single`| *Rule*       | *Example* |
#' |---------------|-------------|-------------|
#' | `"lower"` | `"a" -> [a,a+1)` | `"2020" -> [2020,2021)` |
#' | `"upper"` | `"a" -> [a-1,a)` | `"2020" -> [2019,2020)` |
#'
#' **Multi-year**
#'
#' In labels for multi-year cohorts, the second number is
#' sometimes the upper limit of the cohort, and sometimes
#' the upper limit minus 1. For instance, the cohort
#' that starts at midnight on 1 January 2020 and ends
#' at midnight on 1 January 2025 is sometimes labelled
#' `"2020-2025"` and is sometimes labelled `"2020-2024"`.
#'
#' The `interpret_multi` argument can be used to distinguish
#' between the two conventions:
#'
#' | `interpret_multi`| *Rule*       | *Example* |
#' |---------------|-------------|-------------|
#' | `"at_upper"` | `"a-b" -> [a,b)` | `"2020-2025" -> [2020,2025)` |
#' | `"below_upper"` | `"a-b" -> [a,b+1)` | `"2020-2024" -> [2020,2025)` |
#'
#' If `interpret_multi` is `NULL` (the default), then multi-year
#' labels are interpreted using the `"at_upper"` convention.
#' If, however, the `"at_upper"` convention
#' leads to intervals with
#' widths 4, 9, 14, \dots, then \pkg{agetime} emits a message.
#' Supplying an explicit value for `interpret_multi`
#' silences this message.
#'
#' **Open**
#'
#' A cohort that is open on the left has no lower limit,
#' and a cohort that is open on the right has no upper limit.
#' Labels for open cohorts are not affected by `interpret_single`
#' or `interpret_multi`.
#'
#' Some examples of open cohorts:
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
#' @param interpret_single How to interpret a label for a single year,
#' such as `"2020"`. Choices are `"lower"` (the default) and `"upper"`.
#' See below for details.
#' @param interpret_multi How to interpret a label
#' that refers to multiple years, such as `"2020-2025"`.
#' Choices are `NULL` (the default), `"at_upper"`,
#' and `"below_upper"`. See below for details.
#' @param interpret_fail Action if element of `labels`
#' cannot be interpreted. Choices are `"error"` (the default),
#' `"warn"`, and `"silent"`.
#' @return `cohort_interval()` returns a character vector,
#' and the other functions return a numeric vector.
#' The result has the same length as `labels`.
#' If `labels` has names, the result has the same names.
#'
#' @seealso
#' - [age_lower()] Age equivalent of `cohort_lower()`
#' - [age_upper()] Age equivalent of `cohort_upper()`
#' - [age_mid()] Age equivalent of `cohort_mid()`
#' - [age_width()] Age equivalent of `cohort_width()`
#' - [age_interval()] Age equivalent of `cohort_interval()`
#' - [period_lower()] Period equivalent of `cohort_lower()`
#' - [period_upper()] Period equivalent of `cohort_upper()`
#' - [period_mid()] Period equivalent of `cohort_mid()`
#' - [period_width()] Period equivalent of `cohort_width()`
#' - [period_interval()] Period equivalent of `cohort_interval()`
#'
#' @examples
#' labels <- c("2025-2030", "<2025", "2030-2035")
#' cohort_lower(labels)
#' cohort_upper(labels)
#' cohort_width(labels)
#' cohort_mid(labels)
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
#'
#' ## names of 'labels' are kept
#' cohorts <- c(parents = "1960-1970", children = "1990-2000")
#' cohort_lower(cohorts)
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
