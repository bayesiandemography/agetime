#' Convert to New Periods
#'
#' Modify the periods used by `labels`. The
#' the new periods must
#' contain the old ones.
#'
#' @inheritSection period_lower Controlling how period labels are interpreted
#'
#' @inheritParams period_lower
#' @param breaks Boundaries between periods.
#' A numeric vector.
#' @param open_left Whether to include a period that is open on the left.
#' Optional. See below for details.
#' @param open_right Whether to include a period that is open on the right.
#' Optional. See below for details.
#' @return Factor with the same length as `labels`.
#'
#' @section The `open_left` argument:
#'
#' A period is open on the left if it has no lower limit,
#' e.g. `"<2000"`.
#'
#' By default, the return value has a period
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
#' A period is open on the right if it has no upper limit,
#' e.g. `"2000+"`.
#'
#' By default, the return value has a period
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
#' period_modify(labels, breaks = c(1970, 2000, 2005, 2015))
#'
#' ## open ends inferred from labels
#' labels_closed <- c("2001-2004", "2005-2010")
#' period_modify(labels_closed, breaks = c(2000, 2010, 2020))
#' labels_open <- c("<1970", "2001-2004", "2020+")
#' period_modify(labels_open, breaks = c(1970, 2000, 2010, 2020))
#'
#' ## structural open right
#' period_modify(labels_closed, breaks = c(2000, 2010, 2020), open_right = TRUE)
#'
#' @seealso
#' - [period_modify_five()] Convert to 5-year periods
#' - [period_modify_ten()] Convert to 10-year periods
#' - [age_modify()] Age group equivalent of `period_modify()`
#' - [cohort_modify()] Cohort equivalent of `period_modify()`
#' @export

period_modify <- function(labels,
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
    label_type = "period",
    interpret_single = interpret_single,
    interpret_multi = interpret_multi,
    interpret_fail = interpret_fail
  )
}


#' Convert to Periods with Equal Widths
#'
#' @description
#'
#' Modify the periods defined by `labels`.
#' The new periods must contain
#' the old periods, and (except for open periods)
#' all have the same width.
#'
#' - `period_modify_five` Five-year periods
#' - `period_modify_ten` Ten-year periods
#' 
#' @inheritSection period_lower Controlling how period labels are interpreted
#'
#' @inheritParams period_lower
#' @param offset Parameter controlling
#' alignment of periods. Default is `0`.
#' @inherit period_modify return
#'
#' @seealso
#' - [period_modify()] Convert to general periods
#' - [age_modify_five()] Age equivalent of `period_modify_five()`
#' - [age_modify_ten()] Age equivalent of `period_modify_ten()`
#' - [cohort_modify_five()] Cohort equivalent of `period_modify_five()`
#' - [cohort_modify_ten()] Cohort equivalent of `period_modify_ten()`
#' - [period_fill()] Add levels for intermediate periods
#'
#' @examples
#' labels <- c("2002-2004", "1987-1989", "2000", "Total")
#' period_modify_five(labels)
#' period_modify_ten(labels)
#'
#' ## align to different boundaries
#' period_modify_five(labels, offset = 2)
#'
#' ## open ends inferred from labels
#' period_modify_five(c("<2020", "2020-2024"))
#' @inheritParams period_modify
#' @inheritSection period_modify The `open_left` argument
#' @inheritSection period_modify The `open_right` argument
#' @export

period_modify_five <- function(labels,
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
    label_type = "period",
    interpret_single = interpret_single,
    interpret_multi = interpret_multi,
    interpret_fail = interpret_fail
  )
}

#' @rdname period_modify_five
#' @inheritParams period_modify
#' @export
period_modify_ten <- function(labels,
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
    label_type = "period",
    interpret_single = interpret_single,
    interpret_multi = interpret_multi,
    interpret_fail = interpret_fail
  )
}
