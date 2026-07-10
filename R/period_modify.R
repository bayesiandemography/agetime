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
#' is "open", i.e. has no lower limit.
#' Default is `FALSE`.
#' @param open_right Whether the last period
#' is "open", i.e. has no upper limit.
#' Default is `FALSE`.
#' @return Character vector or factor with the same length as `labels`.
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

# Character input returns character; factor input returns factor with the same
# length and ordered attribute. When length(labels) == 0, returns
# character(0) or
# still modifies factor levels().
period_modify <- function(labels,
                          breaks,
                          open_left = FALSE,
                          open_right = FALSE,
                          interpret_single = c("lower", "upper"),
                          interpret_multi = c("include", "exclude"),
                          interpret_fail = c("error", "warn", "silent")) {
  check_flag(x = open_left, nm_x = "open_left")
  check_flag(x = open_right, nm_x = "open_right")
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
#' - [period_levels_fill()] Add levels for intermediate periods
#'
#' @examples
#' labels <- c("2002-2004", "1987-1989", "2000", "Total")
#' period_modify_five(labels)
#' period_modify_five(labels, offset = 1)
#' period_modify_five(labels, offset = 2)
#' period_modify_ten(labels)
#' period_modify_ten(labels, offset = 1)
#' period_modify_ten(labels, offset = 2)
#' @export

# When length(labels) == 0 and labels is a factor with no levels,
# labels is returned unchanged.
period_modify_five <- function(labels,
                               offset = 0,
                               interpret_single = c("lower", "upper"),
                               interpret_multi = c("include", "exclude"),
                               interpret_fail = c("error", "warn", "silent")) {
  interpret_single <- match.arg(interpret_single)
  interpret_multi <- match.arg(interpret_multi)
  interpret_fail <- match.arg(interpret_fail)
  inner_modify_width(
    labels = labels,
    width = 5L,
    offset = offset,
    label_type = "period",
    interpret_single = interpret_single,
    interpret_multi = interpret_multi,
    interpret_fail = interpret_fail
  )
}

#' @rdname period_modify_five
#' @export
period_modify_ten <- function(labels,
                              offset = 0,
                              interpret_single = c("lower", "upper"),
                              interpret_multi = c("include", "exclude"),
                              interpret_fail = c("error", "warn", "silent")) {
  interpret_single <- match.arg(interpret_single)
  interpret_multi <- match.arg(interpret_multi)
  interpret_fail <- match.arg(interpret_fail)
  inner_modify_width(
    labels = labels,
    width = 10L,
    offset = offset,
    label_type = "period",
    interpret_single = interpret_single,
    interpret_multi = interpret_multi,
    interpret_fail = interpret_fail
  )
}
