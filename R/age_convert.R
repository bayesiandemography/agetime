#' Convert to New Age Groups
#'
#' Modify the age groups used by `x`. The
#' the new age groups must
#' contain the old ones.
#'
#' @inheritParams age_lower
#' @param breaks Boundaries between age groups.
#' A numeric vector.
#' @param open Whether the oldest age group
#' is "open", i.e. has no upper limit.
#' Default is `TRUE`.
#'
#' @returns
#' If `x` is a factor, then the return value is
#' a factor; otherwise it is a character vector.
#'
#' @seealso
#' [age_convert_five()] Convert to 5-year age groups
#' [age_convert_ten()] Convert to 10-year age groups
#' [age_convert_life()] Convert to life table age groups
#' [period_convert()] Period equivalent of `age_convert()`
#' [cohort_convert()] Cohort equivalent of `age_convert()`
#' 
#' @examples
#' x <- c("1-4", "87-89", "0", "50-54")
#' age_convert(breaks = c(0, 10, 40, 90))
#' age_convert(breaks = c(0, 10, 40, 90), open = FALSE)
#' @export
age_convert <- function(x,
                        breaks,
                        open = TRUE, 
                        x_fail = c("error", "warn", "silent")) {
  check_flag(x = open, nm_x = "open")
  x_fail <- match.arg(x_fail)
  inner_convert(x = x,
                breaks = breaks,
                is_open_left = FALSE,
                is_open_right = open,
                label_type = "age",
                x_one = "lower",
                x_multi = "exclude",
                x_fail = x_fail)
}


#' Convert to Specialised Age Groups
#'
#' @description
#'
#' Modify the age groups used by `x`.
#' The new age groups must contain
#' the old age groups, and follow a regular
#' pattern:
#' 
#' - `age_convert_five` Five-year age groups
#' - `age_convert_ten` Ten-year age groups
#' - `age_convert_life` Age groups used in 'abridged' life tables
#'
#' @inheritParams age_lower
#'
#' @returns
#' If `x` is a factor, then the return value is
#' a factor; otherwise it is a character vector.
#'
#' @seealso
#' [age_convert()] Convert to general age groups
#' [age_life()] Convert to life table age groups
#' [period_convert_five()] Period equivalent of `age_convert_five()`
#' [period_convert_ten()] Period equivalent of `age_convert_ten()`
#' [cohort_convert_five()] Cohort equivalent of `age_convert_five()`
#' [cohort_convert_ten()] Cohort equivalent of `age_convert_ten()`
#' age_complete()] Add levels for intermediate age groups
#' 
#' @examples
#' x <- c("1-4", "87-89", "0", "90+", "total", "50-54")
#' age_convert_five(x)
#' age_convert_ten(x)
#' age_convert_life(x)
#' @export
age_convert_five <- function(x,
                             x_fail = c("error", "warn", "silent")) {
  x_fail <- match.arg(x_fail)
  inner_convert_width(x = x,
                      width = 5L,
                      offset = 0L,
                      label_type = "age",
                      x_one = "lower",
                      x_multi = "exclude",
                      x_fail = x_fail)
}

#' @rdname age_convert_five
#' @export
age_convert_ten <- function(x,
                            x_fail = c("error", "warn", "silent")) {
  x_fail <- match.arg(x_fail)
  inner_convert_width(x = x,
                      width = 10L,
                      offset = 0L,
                      label_type = "age",
                      x_one = "lower",
                      x_multi = "exclude",
                      x_fail = x_fail)
}


#' @rdname age_convert_five
#' @export
age_convert_life <- function(x,
                        lower_last = NULL,
                        x_fail = c("error", "warn", "silent")) {
  x <- to_character_or_factor(x = x,
                              nm_x = "x",
                              length_zero_ok = TRUE)
  x_fail <- match.arg(x_fail)
  intervals <- intervals(labels = x,
                         label_type = "age",
                         x_fail = x_fail)
  lower_last <- make_lower_last(lower_last = lower_last,
                                intervals = intervals,
                                open = TRUE,
                                min = 5L,
                                divisible_by = 5L)
  s <- seq.int(from = 5L,
               to = lower_last,
               by = 5L)
  breaks <- c(0L, 1L, s)
  age_convert_inner(x = x,
               breaks = breaks,
               open = TRUE,
               include_total = include_total,
               include_na = include_na,
               intervals = intervals)
}


