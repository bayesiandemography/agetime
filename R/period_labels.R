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
#' @param label_one Rule for one-year labels: `"lower"` or `"upper"`.
#' @param label_multi Rule for multi-year labels: `"include"` or `"exclude"`.
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
#' ## single-year periods, 'label_one' is "upper"
#' period_labels_one(
#'   lower_first = 2000,
#'   lower_last = 2010,
#'   label_one = "upper"
#' )
#'
#' ## ten-year periods
#' period_labels_ten(
#'   lower_first = 2000,
#'   lower_last = 2010
#' )
#'
#' ## ten-year periods, 'label_multi' is "exclude",
#' period_labels_ten(
#'   lower_first = 2000,
#'   lower_last = 2010,
#'   label_multi = "exclude"
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
                          label_one = c("lower", "upper"),
                          label_multi = c("include", "exclude"),
                          include_total = FALSE,
                          include_na = FALSE) {
  label_one <- match.arg(label_one)
  label_multi <- match.arg(label_multi)
  inner_labels(
    breaks = breaks,
    label_one = label_one,
    label_multi = label_multi,
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
                              label_one = c("lower", "upper"),
                              label_multi = c("include", "exclude"),
                              include_total = FALSE,
                              include_na = FALSE) {
  label_one <- match.arg(label_one)
  label_multi <- match.arg(label_multi)
  inner_labels_one(
    lower_first = lower_first,
    lower_last = lower_last,
    label_one = label_one,
    label_multi = label_multi,
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
                               label_one = c("lower", "upper"),
                               label_multi = c("include", "exclude"),
                               include_total = FALSE,
                               include_na = FALSE) {
  label_one <- match.arg(label_one)
  label_multi <- match.arg(label_multi)
  inner_labels_five(
    lower_first = lower_first,
    lower_last = lower_last,
    label_one = label_one,
    label_multi = label_multi,
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
                              label_one = c("lower", "upper"),
                              label_multi = c("include", "exclude"),
                              include_total = FALSE,
                              include_na = FALSE) {
  label_one <- match.arg(label_one)
  label_multi <- match.arg(label_multi)
  inner_labels_ten(
    lower_first = lower_first,
    lower_last = lower_last,
    label_one = label_one,
    label_multi = label_multi,
    is_open_left = FALSE,
    is_open_right = FALSE,
    include_total = include_total,
    include_na = include_na
  )
}
