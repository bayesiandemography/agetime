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
#' @param open_left Whether the first period
#' is open on the left, i.e. has no lower limit.
#' Default is `NULL`, which infers from `labels`:
#' `TRUE` when any label is open on the left, otherwise `FALSE`.
#' Use `TRUE` or `FALSE` to add or suppress an open left level
#' regardless of `labels`.
#' @param open_right Whether the last period
#' is open on the right, i.e. has no upper limit.
#' Default is `NULL`, which infers from `labels`:
#' `TRUE` when any label is open on the right, otherwise `FALSE`.
#' Use `TRUE` or `FALSE` to add or suppress an open right level
#' regardless of `labels`.
#' @return Factor with the same length as `labels`.
#'
#' @examples
#' labels <- c("2001-2004", "1987-1989", "2000", "2005-2010")
#' period_modify(labels, breaks = c(1970, 2000, 2005, 2015))
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


#' Convert to Equal-Length Periods
#'
#' @description
#'
#' Modify the periods used by `labels`.
#' The new periods must contain
#' the old periods, and follow a regular
#' pattern:
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
#' period_modify_five(labels, offset = 1)
#' period_modify_five(labels, offset = 2)
#' period_modify_ten(labels)
#' period_modify_ten(labels, offset = 1)
#' period_modify_ten(labels, offset = 2)
#' @inheritParams period_modify
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
