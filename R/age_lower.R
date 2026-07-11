## HAS_TESTS
#' Limits, Widths, and Midpoints from Age Group Labels
#'
#' Calculate lower limits, upper limits,
#' widths, and midpoints from age group labels
#'
#' Lower and upper limits can be used
#' to filter on age. See below for examples.
#'
#' `age_mid()` assigns open age groups (e.g., `"100+"`)
#' pseudo-midpoints. These pseudo-midpoints are
#' based on half the median width of the closed intervals in `labels`.
#' See below for examples. Pseudo-midpoints are useful for plotting.
#'
#' @param labels Vector of age group labels.
#' @param interpret_fail Action if element of `labels`
#' cannot be interpreted. Choices are `"error"` (the default),
#' `"warn"`, and `"silent"`.
#' @return Numeric vector with the same length as `labels`.
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
#' ## 'midpoint' of open intervals
#' age_mid(c("80-89", "90-99", "100+"))
#' age_mid(c("90-94", "95-99", "100+"))
#' 
#' ## no action when 'interpret_fail' is "silent"
#' age_lower(c("0-4", "young people", "50plus"),
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
    interpret_multi = "exclude",
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
    interpret_multi = "exclude",
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
    interpret_multi = "exclude",
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
    interpret_multi = "exclude",
    interpret_fail = interpret_fail
  )
}
