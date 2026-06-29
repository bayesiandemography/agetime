#' Create New Cohort Labels
#'
#' Create a new set of cohort labels.

#' @param breaks Boundaries between cohorts
#' A numeric vector.
#' @param lower_first Lower limit of
#' first cohort.
#' @param lower_last Lower limit of
#' last cohort.
#' @param open Whether first cohort
#' is "open", i.e. has no lower limit.
#' Default is `FALSE`.
#' @param include_total Whether to include a
#' `"Total"` category.
#' @param include_na Whether to include
#' an `NA` category.
#' @param format_single Rule for one-year labels: `"lower"` or `"upper"`.
#' @param format_range Rule for multi-year labels: `"include"` or `"exclude"`.
#' @return Character vector.
#' Length depends on the function arguments.
#'
#' @seealso
#' - [age_labels()] Age equivalent of `cohort_labels()`
#' - [period_labels()] Period equivalent of `cohort_labels()`
#'
#' @examples
#' ## 5-year cohorts
#' cohort_labels_five(
#'   lower_first = 2000,
#'   lower_last = 2010
#' )
#'
#' ## 5-year cohorts, first cohort is open
#' cohort_labels_five(
#'   lower_first = 1960,
#'   lower_last = 2020,
#'   open = TRUE
#' )
#'
#' ## single-year cohorts
#' cohort_labels_one(
#'   lower_first = 2000,
#'   lower_last = 2010
#' )
#'
#' ## single-year cohorts, 'format_single' is "upper"
#' cohort_labels_one(
#'   lower_first = 2000,
#'   lower_last = 2010,
#'   format_single = "upper"
#' )
#'
#' ## ten-year cohorts
#' cohort_labels_ten(
#'   lower_first = 2000,
#'   lower_last = 2010
#' )
#'
#' ## ten-year cohorts, 'format_range' is "exclude",
#' cohort_labels_ten(
#'   lower_first = 2000,
#'   lower_last = 2010,
#'   format_range = "exclude"
#' )
#'
#' ## include total and NA
#' cohort_labels_ten(
#'   lower_first = 2000,
#'   lower_last = 2010,
#'   include_total = TRUE,
#'   include_na = TRUE
#' )
#' @export
cohort_labels <- function(breaks,
                          open = FALSE,
                          format_single = c("lower", "upper"),
                          format_range = c("include", "exclude"),
                          include_total = FALSE,
                          include_na = FALSE) {
  check_flag(x = open, nm_x = "open")
  format_single <- match.arg(format_single)
  format_range <- match.arg(format_range)
  inner_labels(
    breaks = breaks,
    format_single = format_single,
    format_range = format_range,
    is_open_left = open,
    is_open_right = FALSE,
    include_total = include_total,
    include_na = include_na
  )
}

#' @rdname cohort_labels
#' @export
cohort_labels_one <- function(lower_first,
                              lower_last,
                              open = FALSE,
                              format_single = c("lower", "upper"),
                              format_range = c("include", "exclude"),
                              include_total = FALSE,
                              include_na = FALSE) {
  check_flag(x = open, nm_x = "open")
  format_single <- match.arg(format_single)
  format_range <- match.arg(format_range)
  inner_labels_one(
    lower_first = lower_first,
    lower_last = lower_last,
    format_single = format_single,
    format_range = format_range,
    is_open_left = open,
    is_open_right = FALSE,
    include_total = include_total,
    include_na = include_na
  )
}


#' @rdname cohort_labels
#' @export
cohort_labels_five <- function(lower_first,
                               lower_last,
                               open = FALSE,
                               format_single = c("lower", "upper"),
                               format_range = c("include", "exclude"),
                               include_total = FALSE,
                               include_na = FALSE) {
  check_flag(x = open, nm_x = "open")
  format_single <- match.arg(format_single)
  format_range <- match.arg(format_range)
  inner_labels_five(
    lower_first = lower_first,
    lower_last = lower_last,
    format_single = format_single,
    format_range = format_range,
    is_open_left = open,
    is_open_right = FALSE,
    include_total = include_total,
    include_na = include_na
  )
}

#' @rdname cohort_labels
#' @export
cohort_labels_ten <- function(lower_first,
                              lower_last,
                              open = FALSE,
                              format_single = c("lower", "upper"),
                              format_range = c("include", "exclude"),
                              include_total = FALSE,
                              include_na = FALSE) {
  check_flag(x = open, nm_x = "open")
  format_single <- match.arg(format_single)
  format_range <- match.arg(format_range)
  inner_labels_ten(
    lower_first = lower_first,
    lower_last = lower_last,
    format_single = format_single,
    format_range = format_range,
    is_open_left = open,
    is_open_right = FALSE,
    include_total = include_total,
    include_na = include_na
  )
}
