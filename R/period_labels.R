#' Create New Period Labels
#'
#' Create a new set of period labels.

#'
#' @inheritParams period_lower
#' @param breaks Boundaries between periods
#' A numeric vector.
#' @param lower_first Lower limit of first period.
#' @param lower_last Lower limit of last period.
#' @param include_total Whether to include a
#' `"Total"` category.
#' @param include_na Whether to include
#' an `NA` category.
#' @returns A character vector.
#'
#' @seealso
#' - [age_labels()] Age equivalent of `period_labels()`
#' - [cohort_labels()] Cohort equivalent of `period_labels()`
#'
#' @examples
#' ## 5-year periods
#' period_labels_five(lower_first = 2000,
#'                    lower_last = 2010)
#'
#' ## single-year periods
#' period_labels_one(lower_first = 2000,
#'                   lower_last = 2010)
#'
#' ## single-year periods, 'x_one' is "upper"
#' period_labels_one(lower_first = 2000,
#'                   lower_last = 2010,
#'                   x_one = "upper")
#' 
#' ## ten-year periods
#' period_labels_ten(lower_first = 2000,
#'                   lower_last = 2010)
#'
#' ## ten-year periods, 'x_multi' is "exclude",
#' period_labels_ten(lower_first = 2000,
#'                   lower_last = 2010,
#'                   x_multi = "exclude")
#'
#' ## include total and NA
#' period_labels_ten(lower_first = 2000,
#'                   lower_last = 2010,
#'                   include_total = TRUE,
#'                   include_na = TRUE)
#' @export
period_labels <- function(breaks,
                          x_one = c("lower", "upper"),
                          x_multi = c("include", "exclude"),
                          include_total = FALSE,
                          include_na = FALSE) {
  x_one <- match.arg(x_one)
  x_multi <- match.arg(x_multi)
  inner_labels(breaks = breaks,
               x_one = x_one,
               x_multi = x_multi,
               is_open_left = FALSE,
               is_open_right = FALSE,
               include_total = include_total,
               include_na = include_na)
}

#' @rdname period_labels
#' @export
period_labels_one <- function(lower_first,
                              lower_last,
                              x_one = c("lower", "upper"),
                              x_multi = c("include", "exclude"),
                              include_total = FALSE,
                              include_na = FALSE) {
  x_one <- match.arg(x_one)
  x_multi <- match.arg(x_multi)
  inner_labels_one(lower_first = lower_first,
                   lower_last = lower_last,
                   x_one = x_one,
                   x_multi = x_multi,
                   is_open_left = FALSE,
                   is_open_right = FALSE,
                   include_total = include_total,
                   include_na = include_na)
}


#' @rdname period_labels
#' @export
period_labels_five <- function(lower_first,
                               lower_last,
                               x_one = c("lower", "upper"),
                               x_multi = c("include", "exclude"),
                               include_total = FALSE,
                               include_na = FALSE) {
  x_one <- match.arg(x_one)
  x_multi <- match.arg(x_multi)
  inner_labels_five(lower_first = lower_first,
                    lower_last = lower_last,
                    x_one = x_one,
                    x_multi = x_multi,
                    is_open_left = FALSE,
                    is_open_right = FALSE,
                    include_total = include_total,
                    include_na = include_na)
}

#' @rdname period_labels
#' @export
period_labels_ten <- function(lower_first,
                              lower_last,
                              x_one = c("lower", "upper"),
                              x_multi = c("include", "exclude"),
                              include_total = FALSE,
                              include_na = FALSE) {
  x_one <- match.arg(x_one)
  x_multi <- match.arg(x_multi)
  inner_labels_ten(lower_first = lower_first,
                   lower_last = lower_last,
                   x_one = x_one,
                   x_multi = x_multi,
                   is_open_left = FALSE,
                   is_open_right = FALSE,
                   include_total = include_total,
                   include_na = include_na)
}


