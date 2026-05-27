#' Convert to New Cohorts
#'
#' Modify the cohorts used by `x`. The
#' the new cohorts must
#' contain the old ones.
#'
#' @inheritParams cohort_lower
#' @param breaks Boundaries between cohorts.
#' A numeric vector.
#' @param open Whether the first cohort
#' is "open", i.e. has no lower limit.
#' Default is `FALSE`.
#'
#' @returns
#' If `x` is a factor, then the return value is
#' a factor; otherwise it is a character vector.
#'
#' @seealso
#' - [cohort_modify_five()] Convert to 5-year cohorts
#' - [cohort_modify_ten()] Convert to 10-year cohorts
#' - [age_modify()] Age group equivalent of `cohort_modify()`
#' - [period_modify()] Period equivalent of `cohort_modify()`
#' 
#' @examples
#' x <- c("2001-2004", "1987-1989", "2000", "2005-2010")
#' cohort_modify(x, breaks = c(1970, 2000, 2005, 2015))
#' cohort_modify(x, breaks = c(1970, 2000, 2005, 2015), open = TRUE)
#' @export
cohort_modify <- function(x,
                           breaks,
                           open = FALSE,
                           x_one = c("lower", "upper"),
                           x_multi = c("include", "exclude"),
                           x_fail = c("error", "warn", "silent")) {
  check_flag(x = open, nm_x = "open")
  x_one <- match.arg(x_one)
  x_multi <- match.arg(x_multi)
  x_fail <- match.arg(x_fail)
  inner_modify(x = x,
                breaks = breaks,
                is_open_left = open,
                is_open_right = FALSE,
                label_type = "cohort",
                x_one = x_one,
                x_multi = x_multi,
                x_fail = x_fail)
}


#' Convert to Equal-Length Cohorts
#'
#' @description
#'
#' Modify the cohorts used by `x`.
#' The new cohorts must contain
#' the old cohorts, and follow a regular
#' pattern:
#' 
#' - `cohort_modify_five` Five-year cohorts
#' - `cohort_modify_ten` Ten-year cohorts
#'
#' @inheritParams cohort_lower
#' @param offset Parameter controlling
#' alignment of cohorts. Default is `0`.
#'
#' @returns
#' A factor if `x` is a factor; otherwise a character vector.
#'
#' @seealso
#' [cohort_modify()] Convert to general cohorts
#' [age_modify_five()] Age equivalent of `cohort_modify_five()`
#' [age_modify_ten()] Age equivalent of `cohort_modify_ten()`
#' [period_modify_five()] Period equivalent of `cohort_modify_five()`
#' [period_modify_ten()] Period equivalent of `cohort_modify_ten()`
#' [cohort_levels_fill()] Add levels for intermediate cohorts
#' 
#' @examples
#' x <- c("2002-2004", "1987-1989", "2000", "Total")
#' cohort_modify_five(x)
#' cohort_modify_five(x, offset = 1)
#' cohort_modify_five(x, offset = 2)
#' cohort_modify_ten(x)
#' cohort_modify_ten(x, offset = 1)
#' cohort_modify_ten(x, offset = 2)
#' @export
cohort_modify_five <- function(x,
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
                      label_type = "cohort",
                      x_one = x_one,
                      x_multi = x_multi,
                      x_fail = x_fail)
}

#' @rdname cohort_modify_five
#' @export
cohort_modify_ten <- function(x,
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
                      label_type = "cohort",
                      x_one = x_one,
                      x_multi = x_multi,
                      x_fail = x_fail)
}
