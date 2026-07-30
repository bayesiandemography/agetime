#' Create New Cohort Labels
#'
#' Create a new set of cohort labels.
#' 
#' @inheritSection cohort_standard Rules for formatting output
#'
#' @param breaks Boundaries between cohorts
#' A numeric vector.
#' @param lower_first Lower limit of
#' first cohort. Non-negative number.
#' @param lower_last Lower limit of
#' last cohort. Non-negative number.
#' @param open_left Whether first cohort
#' is open on the left, i.e. has no lower limit.
#' Default is `FALSE`.
#' @param open_right Whether last cohort
#' is open on the right, i.e. has no upper limit.
#' Default is `FALSE`.
#' @param include_total Whether to include a
#' `"Total"` category. Default is `FALSE`.
#' @param include_na Whether to include
#' an `NA` category. Default is `FALSE`.
#' @param format_single How to format label for
#' single-year cohort. Choices are `"lower"`
#' (the default) and `"upper"`. See below for
#' details.
#' @param format_multi How to format label for
#' multi-year cohort. Choices are `"include"`
#' (the default) and `"exclude"`. See below for details.
#'
#' @return Character vector.
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
#'   open_left = TRUE
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
#' ## ten-year cohorts, 'format_multi' is "exclude",
#' cohort_labels_ten(
#'   lower_first = 2000,
#'   lower_last = 2010,
#'   format_multi = "exclude"
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
                          open_left = FALSE,
                          open_right = FALSE,
                          format_single = c("lower", "upper"),
                          format_multi = c("include", "exclude"),
                          include_total = FALSE,
                          include_na = FALSE) {
  check_flag(x = open_left, nm_x = "open_left")
  check_flag(x = open_right, nm_x = "open_right")
  format_single <- match.arg(format_single)
  format_multi <- match.arg(format_multi)
  inner_labels(
    breaks = breaks,
    format_single = format_single,
    format_multi = format_multi,
    is_open_left = open_left,
    is_open_right = open_right,
    include_total = include_total,
    include_na = include_na
  )
}

#' @rdname cohort_labels
#' @export
cohort_labels_one <- function(lower_first,
                              lower_last,
                              open_left = FALSE,
                              open_right = FALSE,
                              format_single = c("lower", "upper"),
                              format_multi = c("include", "exclude"),
                              include_total = FALSE,
                              include_na = FALSE) {
  check_flag(x = open_left, nm_x = "open_left")
  check_flag(x = open_right, nm_x = "open_right")
  format_single <- match.arg(format_single)
  format_multi <- match.arg(format_multi)
  inner_labels_one(
    lower_first = lower_first,
    lower_last = lower_last,
    format_single = format_single,
    format_multi = format_multi,
    is_open_left = open_left,
    is_open_right = open_right,
    include_total = include_total,
    include_na = include_na
  )
}


#' @rdname cohort_labels
#' @export
cohort_labels_five <- function(lower_first,
                               lower_last,
                               open_left = FALSE,
                               open_right = FALSE,
                               format_single = c("lower", "upper"),
                               format_multi = c("include", "exclude"),
                               include_total = FALSE,
                               include_na = FALSE) {
  check_flag(x = open_left, nm_x = "open_left")
  check_flag(x = open_right, nm_x = "open_right")
  format_single <- match.arg(format_single)
  format_multi <- match.arg(format_multi)
  inner_labels_five(
    lower_first = lower_first,
    lower_last = lower_last,
    format_single = format_single,
    format_multi = format_multi,
    is_open_left = open_left,
    is_open_right = open_right,
    include_total = include_total,
    include_na = include_na,
    require_divisible_bounds = FALSE
  )
}

#' @rdname cohort_labels
#' @export
cohort_labels_ten <- function(lower_first,
                              lower_last,
                              open_left = FALSE,
                              open_right = FALSE,
                              format_single = c("lower", "upper"),
                              format_multi = c("include", "exclude"),
                              include_total = FALSE,
                              include_na = FALSE) {
  check_flag(x = open_left, nm_x = "open_left")
  check_flag(x = open_right, nm_x = "open_right")
  format_single <- match.arg(format_single)
  format_multi <- match.arg(format_multi)
  inner_labels_ten(
    lower_first = lower_first,
    lower_last = lower_last,
    format_single = format_single,
    format_multi = format_multi,
    is_open_left = open_left,
    is_open_right = open_right,
    include_total = include_total,
    include_na = include_na,
    require_divisible_bounds = FALSE
  )
}
