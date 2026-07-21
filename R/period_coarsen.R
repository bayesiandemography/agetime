#' Coarsen Periods
#'
#' Define new periods that contain existing periods.
#'
#' The new periods cannot split existing periods,
#' and are typically wider than the existing periods.
#' 
#' If `labels` is a factor, its levels are modified
#' along with its elements.
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
#' labels <- c("2001-2004", "1987-1989", "2000", "2005-2010")
#' period_coarsen(labels, breaks = c(1970, 2000, 2005, 2015))
#'
#' ## let inclusion of open period depend on labels
#' labels_closed <- c("2001-2004", "2005-2010")
#' period_coarsen(labels_closed, breaks = c(2000, 2010, 2020))
#' labels_open <- c("<1970", "2001-2004", "2020+")
#' period_coarsen(labels_open, breaks = c(1970, 2000, 2010, 2020))
#'
#' ## insist on an open period
#' period_coarsen(
#'   labels_closed,
#'   breaks = c(2000, 2010, 2020),
#'   open_right = TRUE
#' )
#'
#' @seealso
#' - [period_coarsen_five()] Coarsen to 5-year periods
#' - [period_coarsen_ten()] Coarsen to 10-year periods
#' - [age_coarsen()] Age group equivalent of `period_coarsen()`
#' - [cohort_coarsen()] Cohort equivalent of `period_coarsen()`
#' @export

period_coarsen <- function(labels,
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
  inner_coarsen(
    labels = labels,
    breaks = breaks,
    is_open_left = open_left,
    is_open_right = open_right,
    label_type = "period",
    interpret_single = interpret_single,
    interpret_multi = interpret_multi,
    interpret_fail = interpret_fail,
    minimal_levels = FALSE,
    preserve_input_type = FALSE
  )
}


#' Coarsen to Periods with Equal Widths
#'
#' @description
#'
#' Coarsen the periods defined by `labels`.
#' The new periods must contain
#' the old periods, and (except for open periods)
#' all have the same width.
#'
#' - `period_coarsen_five` Five-year periods
#' - `period_coarsen_ten` Ten-year periods
#'
#' @details
#'
#' The new periods cannot split existing
#' periods, and are typically wider than the existing periods.
#' 
#' If `labels` is a factor, its levels are modified
#' along with its elements.
#'
#' @inheritSection period_lower Controlling how period labels are interpreted
#'
#' @inheritParams period_lower
#' @param offset Parameter controlling
#' alignment of periods. Default is `0`.
#' @inherit age_standard return
#' @inheritParams period_coarsen
#'
#' @seealso
#' - [period_coarsen()] Coarsen to general periods
#' - [age_coarsen_five()] Age equivalent of `period_coarsen_five()`
#' - [age_coarsen_ten()] Age equivalent of `period_coarsen_ten()`
#' - [cohort_coarsen_five()] Cohort equivalent of `period_coarsen_five()`
#' - [cohort_coarsen_ten()] Cohort equivalent of `period_coarsen_ten()`
#' - [period_fill()] Add levels for intermediate periods
#'
#' @examples
#' labels <- c("2002-2004", "1987-1989", "2000", "Total")
#' period_coarsen_five(labels)
#' period_coarsen_ten(labels)
#'
#' ## align to different boundaries
#' period_coarsen_five(labels, offset = 2)
#'
#' ## let inclusion of open period depend on labels
#' period_coarsen_five(c("<2020", "2020-2024"))
#'
#' ## insist on an open period
#' period_coarsen_five(c("2010", "2020-2025"), open_right = TRUE)
#' @inheritSection period_coarsen The `open_left` argument
#' @inheritSection period_coarsen The `open_right` argument
#' @export

period_coarsen_five <- function(labels,
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
  inner_coarsen_width(
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

#' @rdname period_coarsen_five
#' @inheritParams period_coarsen
#' @export
period_coarsen_ten <- function(labels,
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
  inner_coarsen_width(
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
