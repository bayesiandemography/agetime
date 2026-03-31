#' Create a New Set of Period Labels
#'
#' @inheritParams period_lower
#' @param breaks Boundaries between periods
#' A numeric vector.
#' @param lower_first The lower limit of the
#' first period.
#' @param lower_last The lower limit of the
#' last period.
#' @param include_total Whether to include a
#' `"Total"` category.
#' @param include_na Whether to include
#' an `NA` category.
#'
#' @returns A character vector
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
#' ## single-year periods, 'parse_one' is "upper"
#' period_labels_one(lower_first = 2000,
#'                   lower_last = 2010,
#'                   parse_one = "upper")
#' 
#' ## ten-year periods
#' period_labels_ten(lower_first = 2000,
#'                   lower_last = 2010)
#'
#' ## ten-year periods, 'parse_multi' is "exclude",
#' period_labels_ten(lower_first = 2000,
#'                   lower_last = 2010,
#'                   parse_multi = "exclude")
#'
#' ## include total and NA
#' period_labels_ten(lower_first = 2000,
#'                   lower_last = 2010,
#'                   include_total = TRUE,
#'                   include_na = TRUE)
#' @export
period_labels <- function(breaks,
                          parse_one = c("lower", "upper"),
                          parse_multi = c("include", "exclude"),
                          include_total = FALSE,
                          include_na = FALSE) {
  parse_one <- match.arg(parse_one)
  parse_multi <- match.arg(parse_multi)
  inner_labels(breaks = breaks,
               parse_one = parse_one,
               parse_multi = parse_multi,
               is_open_left = FALSE,
               is_open_right = FALSE,
               include_total = include_total,
               include_na = include_na)
}

#' @rdname period_labels
#' @export
period_labels_one <- function(lower_first,
                              lower_last,
                              parse_one = c("lower", "upper"),
                              parse_multi = c("include", "exclude"),
                              include_total = FALSE,
                              include_na = FALSE) {
  parse_one <- match.arg(parse_one)
  parse_multi <- match.arg(parse_multi)
  inner_labels_one(lower_first = lower_first,
                   lower_last = lower_last,
                   parse_one = parse_one,
                   parse_multi = parse_multi,
                   is_open_left = FALSE,
                   is_open_right = FALSE,
                   include_total = include_total,
                   include_na = include_na)
}


#' @rdname period_labels
#' @export
period_labels_five <- function(lower_first,
                               lower_last,
                               parse_one = c("lower", "upper"),
                               parse_multi = c("include", "exclude"),
                               include_total = FALSE,
                               include_na = FALSE) {
  parse_one <- match.arg(parse_one)
  parse_multi <- match.arg(parse_multi)
  inner_labels_five(lower_first = lower_first,
                    lower_last = lower_last,
                    parse_one = parse_one,
                    parse_multi = parse_multi,
                    is_open_left = FALSE,
                    is_open_right = FALSE,
                    include_total = include_total,
                    include_na = include_na)
}

#' @rdname period_labels
#' @export
period_labels_ten <- function(lower_first,
                              lower_last,
                              parse_one = c("lower", "upper"),
                              parse_multi = c("include", "exclude"),
                              include_total = FALSE,
                              include_na = FALSE) {
  parse_one <- match.arg(parse_one)
  parse_multi <- match.arg(parse_multi)
  inner_labels_ten(lower_first = lower_first,
                   lower_last = lower_last,
                   parse_one = parse_one,
                   parse_multi = parse_multi,
                   is_open_left = FALSE,
                   is_open_right = FALSE,
                   include_total = include_total,
                   include_na = include_na)
}


