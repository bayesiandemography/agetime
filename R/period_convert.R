#' Convert to New Periods
#'
#' Modify the periods used by `x`. The
#' the new periods must
#' contain the old ones.
#'
#' @inheritParams period_lower
#' @param breaks Boundaries between periods.
#' A numeric vector.
#'
#' @returns
#' If `x` is a factor, then the return value is
#' a factor; otherwise it is a character vector.
#'
#' @seealso
#' [period_convert_five()] Convert to 5-year periods
#' [period_convert_ten()] Convert to 10-year periods
#' [age_convert()] Age group equivalent of `period_convert()`
#' [cohort_convert()] Cohort equivalent of `period_convert()`
#' 
#' @examples
#' x <- c("2001-2004", "1987-1989", "2000", "2005-2010")
#' period_convert(breaks = c(1990, 2000, 2005, 2015))
#' @export
period_convert <- function(x,
                           breaks,
                           x_one = c("lower", "upper"),
                           x_multi = c("include", "exclude"),
                           x_fail = c("error", "warn", "silent")) {
  x_one <- match.arg(x_one)
  x_multi <- match.arg(x_multi)
  x_fail <- match.arg(x_fail)
  inner_convert(x = x,
                breaks = breaks,
                is_open_left = FALSE,
                is_open_right = FALSE,
                label_type = "period",
                x_one = x_one,
                x_multi = x_multi,
                x_fail = x_fail)
}


#' Convert to Equal-Length Periods
#'
#' @description
#'
#' Modify the periods used by `x`.
#' The new periods must contain
#' the old periods, and follow a regular
#' pattern:
#' 
#' - `period_convert_five` Five-year periods
#' - `period_convert_ten` Ten-year periods
#'
#' @inheritParams period_lower
#' @param offset Parameter controlling
#' alignment of periods. Defult is `0`.
#'
#' @returns
#' If `x` is a factor, then the return value is
#' a factor; otherwise it is a character vector.
#'
#' @seealso
#' [period_convert()] Convert to general periods
#' [age_convert_five()] Age equivalent of `period_convert_five()`
#' [age_convert_ten()] Age equivalent of `period_convert_ten()`
#' [cohort_convert_five()] Cohort equivalent of `period_convert_five()`
#' [cohort_convert_ten()] Cohort equivalent of `period_convert_ten()`
#' period_complete()] Add levels for intermediate periods
#' 
#' @examples
#' x <- c("2002-2004", "1987-1989", "2000", "Total")
#' period_convert_five(x)
#' period_covert_five(x, offset = 1)
#' period_covert_five(x, offset = 2)
#' period_covert_ten(x)
#' period_covert_ten(x, offset = 1)
#' period_covert_ten(x, offset = 2)
#' @export
period_convert_five <- function(x,
                                offset = 0,
                                x_one = c("lower", "upper"),
                                x_multi = c("include", "exclude"),
                                x_fail = c("error", "warn", "silent")) {
  x_one <- match.arg(x_one)
  x_multi <- match.arg(x_multi)
  x_fail <- match.arg(x_fail)
  inner_convert_width(x = x,
                      width = 5L,
                      offset = offset,
                      label_type = "period",
                      x_one = x_one,
                      x_multi = x_multi,
                      x_fail = x_fail)
}

#' @rdname period_convert_five
#' @export
period_convert_ten <- function(x,
                               offset = 0,
                               x_one = c("lower", "upper"),
                               x_multi = c("include", "exclude"),
                               x_fail = c("error", "warn", "silent")) {
  x_one <- match.arg(x_one)
  x_multi <- match.arg(x_multi)
  x_fail <- match.arg(x_fail)
  inner_convert_width(x = x,
                      width = 10L,
                      offset = offset,
                      label_type = "period",
                      x_one = x_one,
                      x_multi = x_multi,
                      x_fail = x_fail)
}
