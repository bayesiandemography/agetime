#' Create New Period Labels
#'
#' Create a new set of period labels.
#'
#' @section Controlling the formatting of period labels:
#'
#'  `format_single` controls whether the label
#' for a single-year periods is based on the
#' lower or upper limit.
#' For instance, the period `[2025,2026)`
#' has label `"2025"` if `format_single`
#' is `"lower"` and `"2026"` if
#' `format_single` is `"upper"`.
#'
#' `format_multi` controls whether the label
#' for a multi-year period includes the upper limit.
#' For instance, the period `[2025,2030)`
#' has label `"2025-2035"` if
#' `format_multi` is `"include"` and
#' `"2025-2029"` if `format_multi` is
#' `"exclude"`.
#'
#' @param breaks Boundaries between periods.
#' A numeric vector.
#' @param lower_first Lower limit of first period.
#' Non-negative number.
#' @param lower_last Lower limit of last period.
#' Non-negative number.
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
                          format_single = c("lower", "upper"),
                          format_multi = c("include", "exclude"),
                          include_total = FALSE,
                          include_na = FALSE) {
  format_single <- match.arg(format_single)
  format_multi <- match.arg(format_multi)
  inner_labels(
    breaks = breaks,
    format_single = format_single,
    format_multi = format_multi,
    is_open_left = FALSE,
    is_open_right = FALSE,
    include_total = include_total,
    include_na = include_na
  )
}

#' @rdname period_labels
#' @export
period_labels_one <- function(lower_first,
                              lower_last,
                              format_single = c("lower", "upper"),
                              format_multi = c("include", "exclude"),
                              include_total = FALSE,
                              include_na = FALSE) {
  format_single <- match.arg(format_single)
  format_multi <- match.arg(format_multi)
  inner_labels_one(
    lower_first = lower_first,
    lower_last = lower_last,
    format_single = format_single,
    format_multi = format_multi,
    is_open_left = FALSE,
    is_open_right = FALSE,
    include_total = include_total,
    include_na = include_na
  )
}


#' @rdname period_labels
#' @export
period_labels_five <- function(lower_first,
                               lower_last,
                               format_single = c("lower", "upper"),
                               format_multi = c("include", "exclude"),
                               include_total = FALSE,
                               include_na = FALSE) {
  format_single <- match.arg(format_single)
  format_multi <- match.arg(format_multi)
  inner_labels_five(
    lower_first = lower_first,
    lower_last = lower_last,
    format_single = format_single,
    format_multi = format_multi,
    is_open_left = FALSE,
    is_open_right = FALSE,
    include_total = include_total,
    include_na = include_na,
    require_divisible_bounds = FALSE
  )
}

#' @rdname period_labels
#' @export
period_labels_ten <- function(lower_first,
                              lower_last,
                              format_single = c("lower", "upper"),
                              format_multi = c("include", "exclude"),
                              include_total = FALSE,
                              include_na = FALSE) {
  format_single <- match.arg(format_single)
  format_multi <- match.arg(format_multi)
  inner_labels_ten(
    lower_first = lower_first,
    lower_last = lower_last,
    format_single = format_single,
    format_multi = format_multi,
    is_open_left = FALSE,
    is_open_right = FALSE,
    include_total = include_total,
    include_na = include_na,
    require_divisible_bounds = FALSE
  )
}
