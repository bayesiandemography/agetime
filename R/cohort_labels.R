#' Create New Cohort Labels
#'
#' Create a new set of cohort labels.

#' @inheritParams cohort_lower
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
#' @returns A character vector.
#'
#' @seealso
#' - [age_labels()] Age equivalent of `cohort_labels()`
#' - [period_labels()] Period equivalent of `cohort_labels()`
#'
#' @examples
#' ## 5-year cohorts
#' cohort_labels_five(lower_first = 2000,
#'                    lower_last = 2010)
#'
#' ## 5-year cohorts, first cohort is open
#' cohort_labels_five(lower_first = 1960,
#'                    lower_last = 2020,
#'                    open = TRUE)
#'
#' ## single-year cohorts
#' cohort_labels_one(lower_first = 2000,
#'                   lower_last = 2010)
#'
#' ## single-year cohorts, 'x_one' is "upper"
#' cohort_labels_one(lower_first = 2000,
#'                   lower_last = 2010,
#'                   x_one = "upper")
#' 
#' ## ten-year cohorts
#' cohort_labels_ten(lower_first = 2000,
#'                   lower_last = 2010)
#'
#' ## ten-year cohorts, 'x_multi' is "exclude",
#' cohort_labels_ten(lower_first = 2000,
#'                   lower_last = 2010,
#'                   x_multi = "exclude")
#'
#' ## include total and NA
#' cohort_labels_ten(lower_first = 2000,
#'                   lower_last = 2010,
#'                   include_total = TRUE,
#'                   include_na = TRUE)
#' @export
cohort_labels <- function(breaks,
                          open = FALSE,
                          x_one = c("lower", "upper"),
                          x_multi = c("include", "exclude"),
                          include_total = FALSE,
                          include_na = FALSE) {
  check_flag(x = open, nm_x = "open")
  x_one <- match.arg(x_one)
  x_multi <- match.arg(x_multi)
  inner_labels(breaks = breaks,
               x_one = x_one,
               x_multi = x_multi,
               is_open_left = open,
               is_open_right = FALSE,
               include_total = include_total,
               include_na = include_na)
}

#' @rdname cohort_labels
#' @export
cohort_labels_one <- function(lower_first,
                              lower_last,
                              open = FALSE,
                              x_one = c("lower", "upper"),
                              x_multi = c("include", "exclude"),
                              include_total = FALSE,
                              include_na = FALSE) {
  check_flag(x = open, nm_x = "open")
  x_one <- match.arg(x_one)
  x_multi <- match.arg(x_multi)
  inner_labels_one(lower_first = lower_first,
                   lower_last = lower_last,
                   x_one = x_one,
                   x_multi = x_multi,
                   is_open_left = open,
                   is_open_right = FALSE,
                   include_total = include_total,
                   include_na = include_na)
}


#' @rdname cohort_labels
#' @export
cohort_labels_five <- function(lower_first,
                               lower_last,
                               open = FALSE,
                               x_one = c("lower", "upper"),
                               x_multi = c("include", "exclude"),
                               include_total = FALSE,
                               include_na = FALSE) {
  check_flag(x = open, nm_x = "open")
  x_one <- match.arg(x_one)
  x_multi <- match.arg(x_multi)
  inner_labels_five(lower_first = lower_first,
                    lower_last = lower_last,
                    x_one = x_one,
                    x_multi = x_multi,
                    is_open_left = open,
                    is_open_right = FALSE,
                    include_total = include_total,
                    include_na = include_na)
}

#' @rdname cohort_labels
#' @export
cohort_labels_ten <- function(lower_first,
                              lower_last,
                              open = FALSE,
                              x_one = c("lower", "upper"),
                              x_multi = c("include", "exclude"),
                              include_total = FALSE,
                              include_na = FALSE) {
  check_flag(x = open, nm_x = "open")
  x_one <- match.arg(x_one)
  x_multi <- match.arg(x_multi)
  inner_labels_ten(lower_first = lower_first,
                   lower_last = lower_last,
                   x_one = x_one,
                   x_multi = x_multi,
                   is_open_left = open,
                   is_open_right = FALSE,
                   include_total = include_total,
                   include_na = include_na)
}


