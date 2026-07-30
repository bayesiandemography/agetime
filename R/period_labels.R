#' Create New Period Labels
#'
#' Create a new set of period labels.
#'
#' @inheritSection period_standard Rules for formatting output
#' 
#' @param breaks Boundaries between periods.
#' A numeric vector.
#' @param lower_first Lower limit of first period.
#' Non-negative number.
#' @param lower_last Lower limit of last period.
#' Non-negative number.
#' @param open_left Whether first period
#' is open on the left, i.e. has no lower limit.
#' Default is `FALSE`.
#' @param open_right Whether last period
#' is open on the right, i.e. has no upper limit.
#' Default is `FALSE`.
#' @param include_total Whether to include a
#' `"Total"` category. Default is `FALSE`.
#' @param include_na Whether to include
#' an `NA` category. Default is `FALSE`.
#' @param format_single How to format label for
#' single-year period. Choices are `"lower"`
#' (the default) and `"upper"`. See below for
#' details.
#' @param format_multi How to format label for
#' multi-year period. Choices are `"include"`
#' (the default) and `"exclude"`. See below for details.
#'
#' @return Character vector.
#'
#' @seealso
#' - [age_labels()] Age equivalent of `period_labels()`
#' - [cohort_labels()] Cohort equivalent of `period_labels()`
#'
#' @examples
#' ## 5-year periods
#' period_labels_five(
#'   lower_first = 2000,
#'   lower_last = 2015
#' )
#'
#' ## single-year periods
#' period_labels_one(
#'   lower_first = 2000,
#'   lower_last = 2004
#' )
#'
#' ## single-year periods, 'format_single' is "upper"
#' period_labels_one(
#'   lower_first = 2000,
#'   lower_last = 2004,
#'   format_single = "upper"
#' )
#'
#' ## ten-year periods
#' period_labels_ten(
#'   lower_first = 2001,
#'   lower_last = 2021
#' )
#'
#' ## ten-year periods, 'format_multi' is "exclude",
#' period_labels_ten(
#'   lower_first = 2000,
#'   lower_last = 2010,
#'   format_multi = "exclude"
#' )
#'
#' ## include total and NA
#' period_labels_ten(
#'   lower_first = 2000,
#'   lower_last = 2010,
#'   include_total = TRUE,
#'   include_na = TRUE
#' )
#' @export
period_labels <- function(breaks,
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

#' @rdname period_labels
#' @export
period_labels_one <- function(lower_first,
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


#' @rdname period_labels
#' @export
period_labels_five <- function(lower_first,
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

#' @rdname period_labels
#' @export
period_labels_ten <- function(lower_first,
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
