#' Create New Period Labels
#'
#' Create a new set of period labels.

#'
#' @param breaks Boundaries between periods
#' A numeric vector.
#' @param lower_first Lower limit of first period.
#' @param lower_last Lower limit of last period.
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
#' - [age_labels()] Age equivalent of `period_labels()`
#' - [cohort_labels()] Cohort equivalent of `period_labels()`
#'
#' @examples
#' ## 5-year periods
#' period_labels_five(
#'   lower_first = 2000,
#'   lower_last = 2010
#' )
#'
#' ## single-year periods
#' period_labels_one(
#'   lower_first = 2000,
#'   lower_last = 2010
#' )
#'
#' ## single-year periods, 'format_single' is "upper"
#' period_labels_one(
#'   lower_first = 2000,
#'   lower_last = 2010,
#'   format_single = "upper"
#' )
#'
#' ## ten-year periods
#' period_labels_ten(
#'   lower_first = 2000,
#'   lower_last = 2010
#' )
#'
#' ## ten-year periods, 'format_range' is "exclude",
#' period_labels_ten(
#'   lower_first = 2000,
#'   lower_last = 2010,
#'   format_range = "exclude"
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
                          format_range = c("include", "exclude"),
                          include_total = FALSE,
                          include_na = FALSE) {
  format_single <- match.arg(format_single)
  format_range <- match.arg(format_range)
  inner_labels(
    breaks = breaks,
    format_single = format_single,
    format_range = format_range,
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
                              format_range = c("include", "exclude"),
                              include_total = FALSE,
                              include_na = FALSE) {
  format_single <- match.arg(format_single)
  format_range <- match.arg(format_range)
  inner_labels_one(
    lower_first = lower_first,
    lower_last = lower_last,
    format_single = format_single,
    format_range = format_range,
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
                               format_range = c("include", "exclude"),
                               include_total = FALSE,
                               include_na = FALSE) {
  format_single <- match.arg(format_single)
  format_range <- match.arg(format_range)
  inner_labels_five(
    lower_first = lower_first,
    lower_last = lower_last,
    format_single = format_single,
    format_range = format_range,
    is_open_left = FALSE,
    is_open_right = FALSE,
    include_total = include_total,
    include_na = include_na
  )
}

#' @rdname period_labels
#' @export
period_labels_ten <- function(lower_first,
                              lower_last,
                              format_single = c("lower", "upper"),
                              format_range = c("include", "exclude"),
                              include_total = FALSE,
                              include_na = FALSE) {
  format_single <- match.arg(format_single)
  format_range <- match.arg(format_range)
  inner_labels_ten(
    lower_first = lower_first,
    lower_last = lower_last,
    format_single = format_single,
    format_range = format_range,
    is_open_left = FALSE,
    is_open_right = FALSE,
    include_total = include_total,
    include_na = include_na
  )
}
