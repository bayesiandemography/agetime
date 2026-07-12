#' Convert to New Cohorts
#'
#' Modify the cohorts used by `labels`. The
#' the new cohorts must
#' contain the old ones.
#'
#' @inheritSection cohort_lower Controlling how cohort labels are interpreted
#'
#' @inheritParams cohort_lower
#' @param breaks Boundaries between cohorts.
#' A numeric vector.
#' @param open_left Whether to include a cohort that is open on the left.
#' Optional. See below for details.
#' @param open_right Whether to include a cohort that is open on the right.
#' Optional. See below for details.
#' @return Factor with the same length as `labels`.
#'
#' @section The `open_left` argument:
#'
#' A cohort is open on the left if it has no lower limit,
#' e.g. `"<2000"`.
#'
#' By default, the return value has a cohort
#' that is open on the left if and only if `labels` does.
#' The full range of options is:
#'
#' | `open_left` | `labels` has open on left | Return value has open on left |
#' |-------------|---------------------------|-------------------------------|
#' | `NULL` (default) | Yes | Yes |
#' | `NULL` (default) | No | No |
#' | `TRUE` | Yes | Yes |
#' | `TRUE` | No | Yes |
#' | `FALSE` | Yes | *Error* |
#' | `FALSE` | No | No |
#'
#' @section The `open_right` argument:
#'
#' A cohort is open on the right if it has no upper limit,
#' e.g. `"2000+"`.
#'
#' By default, the return value has a cohort
#' that is open on the right if and only if `labels` does.
#' The full range of options is:
#'
#' | `open_right` | `labels` has open on right | Return value has open on right |
#' |--------------|----------------------------|--------------------------------|
#' | `NULL` (default) | Yes | Yes |
#' | `NULL` (default) | No | No |
#' | `TRUE` | Yes | Yes |
#' | `TRUE` | No | Yes |
#' | `FALSE` | Yes | *Error* |
#' | `FALSE` | No | No |
#'
#' @examples
#' ## basic recoding
#' labels <- c("2001-2004", "1987-1989", "2000", "2005-2010")
#' cohort_modify(labels, breaks = c(1970, 2000, 2005, 2015))
#'
#' ## open ends inferred from labels
#' labels_closed <- c("2001-2004", "2005-2010")
#' cohort_modify(labels_closed, breaks = c(2000, 2010, 2020))
#' labels_open <- c("<1970", "2001-2004", "2020+")
#' cohort_modify(labels_open, breaks = c(1970, 2000, 2010, 2020))
#'
#' ## structural open right
#' cohort_modify(labels_closed, breaks = c(2000, 2010, 2020), open_right = TRUE)
#'
#' @seealso
#' - [cohort_modify_five()] Convert to 5-year cohorts
#' - [cohort_modify_ten()] Convert to 10-year cohorts
#' - [age_modify()] Age group equivalent of `cohort_modify()`
#' - [period_modify()] Period equivalent of `cohort_modify()`
#' @export

cohort_modify <- function(labels,
                          breaks,
                          open_left = NULL,
                          open_right = NULL,
                          interpret_single = c("lower", "upper"),
                          interpret_multi = c("include", "exclude"),
                          interpret_fail = c("error", "warn", "silent")) {
  check_open_flag(x = open_left, nm_x = "open_left")
  check_open_flag(x = open_right, nm_x = "open_right")
  interpret_single <- match.arg(interpret_single)
  interpret_multi <- match.arg(interpret_multi)
  interpret_fail <- match.arg(interpret_fail)
  inner_modify(
    labels = labels,
    breaks = breaks,
    is_open_left = open_left,
    is_open_right = open_right,
    label_type = "cohort",
    interpret_single = interpret_single,
    interpret_multi = interpret_multi,
    interpret_fail = interpret_fail
  )
}


#' Convert to Cohorts with Equal Widths
#'
#' @description
#'
#' Modify the cohorts defined by `labels`.
#' The new cohorts must contain
#' the old cohorts, and (except for open cohorts)
#' all have the same width.
#'
#' - `cohort_modify_five` Five-year cohorts
#' - `cohort_modify_ten` Ten-year cohorts
#'
#' @inheritSection cohort_lower Controlling how cohort labels are interpreted
#'
#' @inheritParams cohort_lower
#' @param offset Parameter controlling
#' alignment of cohorts. Default is `0`.
#' @inherit cohort_modify return
#'
#' @seealso
#' - [cohort_modify()] Convert to general cohorts
#' - [age_modify_five()] Age equivalent of `cohort_modify_five()`
#' - [age_modify_ten()] Age equivalent of `cohort_modify_ten()`
#' - [period_modify_five()] Period equivalent of `cohort_modify_five()`
#' - [period_modify_ten()] Period equivalent of `cohort_modify_ten()`
#' - [cohort_fill()] Add levels for intermediate cohorts
#'
#' @examples
#' labels <- c("2002-2004", "1987-1989", "2000", "Total")
#' cohort_modify_five(labels)
#' cohort_modify_ten(labels)
#'
#' ## align to different boundaries
#' cohort_modify_five(labels, offset = 2)
#'
#' ## open ends inferred from labels
#' cohort_modify_five(c("<2020", "2020-2024"))
#' @inheritParams cohort_modify
#' @inheritSection cohort_modify The `open_left` argument
#' @inheritSection cohort_modify The `open_right` argument
#' @export

cohort_modify_five <- function(labels,
                               offset = 0,
                               open_left = NULL,
                               open_right = NULL,
                               interpret_single = c("lower", "upper"),
                               interpret_multi = c("include", "exclude"),
                               interpret_fail = c("error", "warn", "silent")) {
  check_open_flag(x = open_left, nm_x = "open_left")
  check_open_flag(x = open_right, nm_x = "open_right")
  interpret_single <- match.arg(interpret_single)
  interpret_multi <- match.arg(interpret_multi)
  interpret_fail <- match.arg(interpret_fail)
  inner_modify_width(
    labels = labels,
    width = 5L,
    offset = offset,
    is_open_left = open_left,
    is_open_right = open_right,
    label_type = "cohort",
    interpret_single = interpret_single,
    interpret_multi = interpret_multi,
    interpret_fail = interpret_fail
  )
}

#' @rdname cohort_modify_five
#' @inheritParams cohort_modify
#' @export
cohort_modify_ten <- function(labels,
                              offset = 0,
                              open_left = NULL,
                              open_right = NULL,
                              interpret_single = c("lower", "upper"),
                              interpret_multi = c("include", "exclude"),
                              interpret_fail = c("error", "warn", "silent")) {
  check_open_flag(x = open_left, nm_x = "open_left")
  check_open_flag(x = open_right, nm_x = "open_right")
  interpret_single <- match.arg(interpret_single)
  interpret_multi <- match.arg(interpret_multi)
  interpret_fail <- match.arg(interpret_fail)
  inner_modify_width(
    labels = labels,
    width = 10L,
    offset = offset,
    is_open_left = open_left,
    is_open_right = open_right,
    label_type = "cohort",
    interpret_single = interpret_single,
    interpret_multi = interpret_multi,
    interpret_fail = interpret_fail
  )
}
