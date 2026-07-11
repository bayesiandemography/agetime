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
#' @param open_left Whether the first cohort
#' is "open", i.e. has no lower limit.
#' Default is `FALSE`.
#' @param open_right Whether the last cohort
#' is "open", i.e. has no upper limit.
#' Default is `FALSE`.
#' @return Character vector or factor with the same length as `labels`.
#'
#' @examples
#' labels <- c("2001-2004", "1987-1989", "2000", "2005-2010")
#' cohort_modify(labels, breaks = c(1970, 2000, 2005, 2015))
#' cohort_modify(labels, breaks = c(1970, 2000, 2005, 2015), open_left = TRUE)
#'
#' @seealso
#' - [cohort_modify_five()] Convert to 5-year cohorts
#' - [cohort_modify_ten()] Convert to 10-year cohorts
#' - [age_modify()] Age group equivalent of `cohort_modify()`
#' - [period_modify()] Period equivalent of `cohort_modify()`
#' @export

# Character input returns character; factor input returns factor with the same
# length and ordered attribute. When length(labels) == 0, returns
# character(0) or
# still modifies factor levels().
cohort_modify <- function(labels,
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
    label_type = "cohort",
    interpret_single = interpret_single,
    interpret_multi = interpret_multi,
    interpret_fail = interpret_fail
  )
}


#' Convert to Equal-Length Cohorts
#'
#' @description
#'
#' Modify the cohorts used by `labels`.
#' The new cohorts must contain
#' the old cohorts, and follow a regular
#' pattern:
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
#' cohort_modify_five(labels, offset = 1)
#' cohort_modify_five(labels, offset = 2)
#' cohort_modify_ten(labels)
#' cohort_modify_ten(labels, offset = 1)
#' cohort_modify_ten(labels, offset = 2)
#' @export

# When length(labels) == 0 and labels is a factor with no levels,
# labels is returned unchanged.
cohort_modify_five <- function(labels,
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
    label_type = "cohort",
    interpret_single = interpret_single,
    interpret_multi = interpret_multi,
    interpret_fail = interpret_fail
  )
}

#' @rdname cohort_modify_five
#' @export
cohort_modify_ten <- function(labels,
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
    label_type = "cohort",
    interpret_single = interpret_single,
    interpret_multi = interpret_multi,
    interpret_fail = interpret_fail
  )
}
