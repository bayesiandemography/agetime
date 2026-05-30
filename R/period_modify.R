#' Convert to New Periods
#'
#' Modify the periods used by `x`. The
#' the new periods must
#' contain the old ones.
#'
#' @inheritParams period_lower
#' @param breaks Boundaries between periods.
#' A numeric vector.
#' @return A vector the same length as `x` with modified labels.
#'
#' @examples
#' x <- c("2001-2004", "1987-1989", "2000", "2005-2010")
#' period_modify(x, breaks = c(1970, 2000, 2005, 2015))
#'
#' @seealso
#' - [period_modify_five()] Convert to 5-year periods
#' - [period_modify_ten()] Convert to 10-year periods
#' - [age_modify()] Age group equivalent of `period_modify()`
#' - [cohort_modify()] Cohort equivalent of `period_modify()`
#' @export

# Character input returns character; factor input returns factor with the same
# length and ordered attribute. When length(x) == 0, returns character(0) or
# still modifies factor levels().
period_modify <- function(x,
                           breaks,
                           x_one = c("lower", "upper"),
                           x_multi = c("include", "exclude"),
                           x_fail = c("error", "warn", "silent")) {
  x_one <- match.arg(x_one)
  x_multi <- match.arg(x_multi)
  x_fail <- match.arg(x_fail)
  inner_modify(x = x,
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
#' - `period_modify_five` Five-year periods
#' - `period_modify_ten` Ten-year periods
#'
#' @inheritParams period_lower
#' @param offset Parameter controlling
#' alignment of periods. Default is `0`.
#' @inherit period_modify return
#'
#' @seealso
#' - [period_modify()] Convert to general periods
#' - [age_modify_five()] Age equivalent of `period_modify_five()`
#' - [age_modify_ten()] Age equivalent of `period_modify_ten()`
#' - [cohort_modify_five()] Cohort equivalent of `period_modify_five()`
#' - [cohort_modify_ten()] Cohort equivalent of `period_modify_ten()`
#' - [period_levels_fill()] Add levels for intermediate periods
#' 
#' @examples
#' x <- c("2002-2004", "1987-1989", "2000", "Total")
#' period_modify_five(x)
#' period_modify_five(x, offset = 1)
#' period_modify_five(x, offset = 2)
#' period_modify_ten(x)
#' period_modify_ten(x, offset = 1)
#' period_modify_ten(x, offset = 2)
#' @export

# When length(x) == 0 and x is a factor with no levels, x is returned unchanged.
period_modify_five <- function(x,
                                offset = 0,
                                x_one = c("lower", "upper"),
                                x_multi = c("include", "exclude"),
                                x_fail = c("error", "warn", "silent")) {
  x_one <- match.arg(x_one)
  x_multi <- match.arg(x_multi)
  x_fail <- match.arg(x_fail)
  inner_modify_width(x = x,
                      width = 5L,
                      offset = offset,
                      label_type = "period",
                      x_one = x_one,
                      x_multi = x_multi,
                      x_fail = x_fail)
}

#' @rdname period_modify_five
#' @export
period_modify_ten <- function(x,
                               offset = 0,
                               x_one = c("lower", "upper"),
                               x_multi = c("include", "exclude"),
                               x_fail = c("error", "warn", "silent")) {
  x_one <- match.arg(x_one)
  x_multi <- match.arg(x_multi)
  x_fail <- match.arg(x_fail)
  inner_modify_width(x = x,
                      width = 10L,
                      offset = offset,
                      label_type = "period",
                      x_one = x_one,
                      x_multi = x_multi,
                      x_fail = x_fail)
}
