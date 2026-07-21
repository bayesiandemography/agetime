#' Coarsen Cohorts
#'
#' Define new cohorts that contain existing cohorts.
#'
#' The new cohorts cannot split existing cohorts,
#' and are typically wider than the existing cohorts.
#' 
#' If `labels` is a factor, its levels are modified
#' along with its elements.
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
#' labels <- c("2001-2004", "1987-1989", "2000", "2005-2010")
#' cohort_coarsen(labels, breaks = c(1970, 2000, 2005, 2015))
#'
#' ## let inclusion of open cohort depend on labels
#' labels_closed <- c("2001-2004", "2005-2010")
#' cohort_coarsen(labels_closed, breaks = c(2000, 2010, 2020))
#' labels_open <- c("<1970", "2001-2004", "2020+")
#' cohort_coarsen(labels_open, breaks = c(1970, 2000, 2010, 2020))
#'
#' ## insist on an open cohort
#' cohort_coarsen(
#'   labels_closed,
#'   breaks = c(2000, 2010, 2020),
#'   open_right = TRUE
#' )
#'
#' @seealso
#' - [cohort_coarsen_five()] Coarsen to 5-year cohorts
#' - [cohort_coarsen_ten()] Coarsen to 10-year cohorts
#' - [age_coarsen()] Age group equivalent of `cohort_coarsen()`
#' - [period_coarsen()] Period equivalent of `cohort_coarsen()`
#' @export

cohort_coarsen <- function(labels,
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
    label_type = "cohort",
    interpret_single = interpret_single,
    interpret_multi = interpret_multi,
    interpret_fail = interpret_fail,
    minimal_levels = FALSE,
    preserve_input_type = FALSE
  )
}


#' Coarsen to Cohorts with Equal Widths
#'
#' @description
#'
#' Coarsen the cohorts defined by `labels`.
#' The new cohorts must contain
#' the old cohorts, and (except for open cohorts)
#' all have the same width.
#'
#' - `cohort_coarsen_five` Five-year cohorts
#' - `cohort_coarsen_ten` Ten-year cohorts
#'
#' @details
#'
#' The new cohorts cannot split existing
#' cohorts, and are typically wider than the existing cohorts.
#' 
#' If `labels` is a factor, its levels are modified
#' along with its elements.
#'
#' @inheritSection cohort_lower Controlling how cohort labels are interpreted
#'
#' @inheritParams cohort_lower
#' @param offset Parameter controlling
#' alignment of cohorts. Default is `0`.
#' @inherit age_standard return
#'
#' @seealso
#' - [cohort_coarsen()] Coarsen to general cohorts
#' - [age_coarsen_five()] Age equivalent of `cohort_coarsen_five()`
#' - [age_coarsen_ten()] Age equivalent of `cohort_coarsen_ten()`
#' - [period_coarsen_five()] Period equivalent of `cohort_coarsen_five()`
#' - [period_coarsen_ten()] Period equivalent of `cohort_coarsen_ten()`
#' - [cohort_fill()] Add levels for intermediate cohorts
#'
#' @examples
#' labels <- c("2002-2004", "1987-1989", "2000", "Total")
#' cohort_coarsen_five(labels)
#' cohort_coarsen_ten(labels)
#'
#' ## align to different boundaries
#' cohort_coarsen_five(labels, offset = 2)
#'
#' ## let inclusion of open cohort depend on labels
#' cohort_coarsen_five(c("2010", "2020-2025"))
#'
#' ## insist on an open cohort
#' cohort_coarsen_five(c("2010", "2020-2025"), open_left = TRUE)
#' @inheritParams cohort_coarsen
#' @inheritSection cohort_coarsen The `open_left` argument
#' @inheritSection cohort_coarsen The `open_right` argument
#' @export

cohort_coarsen_five <- function(labels,
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
    label_type = "cohort",
    interpret_single = interpret_single,
    interpret_multi = interpret_multi,
    interpret_fail = interpret_fail
  )
}

#' @rdname cohort_coarsen_five
#' @export
cohort_coarsen_ten <- function(labels,
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
    label_type = "cohort",
    interpret_single = interpret_single,
    interpret_multi = interpret_multi,
    interpret_fail = interpret_fail
  )
}
