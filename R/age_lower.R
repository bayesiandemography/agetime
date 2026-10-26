## HAS_TESTS
#' Limits, Widths, Midpoints, and Intervals from Age Group Labels
#'
#' Calculate lower limits, upper limits,
#' widths, midpoints, and intervals from age group labels.
#'
#' Lower and upper limits can be used
#' to filter on age. See below for examples.
#'
#' `age_mid()` assigns open age groups (e.g., `"100+"`)
#' honorary midpoints, which are useful for plotting.
#' An open age group gets a midpoint half the width of the
#' closed age group with the highest lower limit, so that,
#' for instance, the midpoint of `"100+"` is `102.5` when
#' the other age groups are five-year groups.
#' If `labels` has no closed age groups, `age_mid()`
#' throws an error.
#'
#' `age_interval()` describes each age group using
#' interval notation. For instance, `"[5, 10)"`
#' includes age 5 but not age 10, and `"[100, Inf)"` has
#' no upper limit. `age_interval()` is useful for checking
#' how labels are being interpreted.
#'
#' @param labels Vector of age group labels.
#' @param interpret_fail Action if element of `labels`
#' cannot be interpreted. Choices are `"error"` (the default),
#' `"warn"`, and `"silent"`.
#' @return `age_interval()` returns a character vector,
#' and the other functions return a numeric vector.
#' The result has the same length as `labels`.
#' If `labels` has names, the result has the same names.
#'
#' @seealso
#' - [period_lower()] Period equivalent of `age_lower()`
#' - [cohort_lower()] Cohort equivalent of `age_lower()`
#'
#' @examples
#' labels <- c("5-9", "10-14", "100+")
#' age_lower(labels)
#' age_upper(labels)
#' age_width(labels)
#' age_mid(labels)
#' age_interval(labels)
#'
#' ## use 'age_lower()' to filter on age
#' library(dplyr, warn.conflicts = FALSE)
#' df <- tribble(
#'   ~age, ~count,
#'   "5-9", 11,
#'   "10-14", 20,
#'   "100+", 7
#' )
#' df
#' df |> filter(age_lower(age) >= 10)
#'
#' ## midpoint of open intervals
#' age_mid(c("80-89", "90-99", "100+")) # 105
#' age_mid(c("90-94", "95-99", "100+")) # 102.5
#'
#' ## no action when 'interpret_fail' is "silent"
#' age_lower(
#'   labels = c("0-4", "young people", "50plus"),
#'   interpret_fail = "silent"
#' )
#' @export

# When length(labels) == 0, returns numeric(0).
age_lower <- function(labels,
                      interpret_fail = c("error", "warn", "silent")) {
  interpret_fail <- match.arg(interpret_fail)
  inner_lower(
    labels = labels,
    label_type = "age",
    interpret_single = "lower",
    interpret_multi = "below_upper",
    interpret_fail = interpret_fail
  )
}

#' @export
#' @rdname age_lower
age_mid <- function(labels,
                    interpret_fail = c("error", "warn", "silent")) {
  interpret_fail <- match.arg(interpret_fail)
  inner_mid(
    labels = labels,
    label_type = "age",
    interpret_single = "lower",
    interpret_multi = "below_upper",
    interpret_fail = interpret_fail
  )
}

#' @export
#' @rdname age_lower
age_upper <- function(labels,
                      interpret_fail = c("error", "warn", "silent")) {
  interpret_fail <- match.arg(interpret_fail)
  inner_upper(
    labels = labels,
    label_type = "age",
    interpret_single = "lower",
    interpret_multi = "below_upper",
    interpret_fail = interpret_fail
  )
}

#' @export
#' @rdname age_lower
age_width <- function(labels,
                      interpret_fail = c("error", "warn", "silent")) {
  interpret_fail <- match.arg(interpret_fail)
  inner_width(
    labels = labels,
    label_type = "age",
    interpret_single = "lower",
    interpret_multi = "below_upper",
    interpret_fail = interpret_fail
  )
}

#' @export
#' @rdname age_lower
age_interval <- function(labels,
                         interpret_fail = c("error", "warn", "silent")) {
  interpret_fail <- match.arg(interpret_fail)
  inner_interval(
    labels = labels,
    label_type = "age",
    interpret_single = "lower",
    interpret_multi = "below_upper",
    interpret_fail = interpret_fail
  )
}
