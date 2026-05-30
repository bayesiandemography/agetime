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
#' @return A vector the same length as `x` with modified labels.
#'
#' @examples
#' x <- c("1-4", "87-89", "0", "50-54")
#' age_modify(x, breaks = c(0, 10, 40, 90))
#' age_modify(x, breaks = c(0, 10, 40, 90), open = FALSE)
#'
#' ## factor input: factor in, factor out
#' age_modify(factor(c("0-4", "5-9")), breaks = c(0, 10, 90))
#'
#' @seealso
#' - [age_modify_five()] Convert to 5-year age groups
#' - [age_modify_ten()] Convert to 10-year age groups
#' - [age_modify_life()] Convert to life table age groups
#' - [period_modify()] Period equivalent of `age_modify()`
#' - [cohort_modify()] Cohort equivalent of `age_modify()`
#' @export

# Character input returns character; factor input returns factor with the same
# length and ordered attribute. When length(x) == 0, returns character(0) or
# still modifies factor levels().
age_modify <- function(x,
                        breaks,
                        open = TRUE, 
                        x_fail = c("error", "warn", "silent")) {
  check_flag(x = open, nm_x = "open")
  x_fail <- match.arg(x_fail)
  inner_modify(x = x,
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
#' - `age_modify_five` Five-year age groups
#' - `age_modify_ten` Ten-year age groups
#' - `age_modify_life` Age groups used in 'abridged' life tables
#'
#' @inheritParams age_lower
#' @inherit age_modify return
#'
#' @seealso
#' - [age_modify()] Convert to general age groups
#' - [period_modify_five()] Period equivalent of `age_modify_five()`
#' - [period_modify_ten()] Period equivalent of `age_modify_ten()`
#' - [cohort_modify_five()] Cohort equivalent of `age_modify_five()`
#' - [cohort_modify_ten()] Cohort equivalent of `age_modify_ten()`
#' - [age_levels_fill()] Add levels for intermediate age groups
#' 
#' @examples
#' x <- c("1-3", "87-89", "0", "91+", "total", "52")
#' age_modify_five(x)
#' age_modify_ten(x)
#' age_modify_life(x)
#' @export

# When length(x) == 0 and x is a factor with no levels, x is returned unchanged.
age_modify_five <- function(x,
                             x_fail = c("error", "warn", "silent")) {
  x_fail <- match.arg(x_fail)
  inner_modify_width(x = x,
                      width = 5L,
                      offset = 0L,
                      label_type = "age",
                      x_one = "lower",
                      x_multi = "exclude",
                      x_fail = x_fail)
}

#' @rdname age_modify_five
#' @export
age_modify_ten <- function(x,
                            x_fail = c("error", "warn", "silent")) {
  x_fail <- match.arg(x_fail)
  inner_modify_width(x = x,
                      width = 10L,
                      offset = 0L,
                      label_type = "age",
                      x_one = "lower",
                      x_multi = "exclude",
                      x_fail = x_fail)
}

#' @rdname age_modify_five
#' @export
age_modify_life <- function(x,
                             x_fail = c("error", "warn", "silent")) {
  is_factor <- is.factor(x)
  x <- to_character_or_factor(x = x,
                              nm_x = "x",
                              length_zero_ok = TRUE)
  x_fail <- match.arg(x_fail)
  if (identical(length(x), 0L) && !is_factor)
    return(character(0))
  if (identical(length(x), 0L) && is_factor && nlevels(x) == 0L)
    return(factor(levels = character(), ordered = is.ordered(x)))
  intervals <- intervals(labels = x,
                         label_type = "age",
                         x_one = "lower",
                         x_multi = "exclude",
                         x_fail = x_fail)
  l <- get_lower(intervals)
  end <- max(l, na.rm = TRUE)
  if (end == 1L)
    breaks <- c(0L, 1L)
  else if (end <= 5L)
    breaks = c(0, 1L, 5L)
  else {
    remainder_end <- end  %% 5L
    if (remainder_end > 0L)
      end <- end - remainder_end
    breaks <- c(0L, 1L, seq.int(from = 5L, to = end, by = 5L))
  }
  inner_modify(x = x,
                breaks = breaks,
                is_open_left = FALSE,
                is_open_right = TRUE,
                label_type = "age",
                x_one = "lower",
                x_multi = "exclude",
                x_fail = x_fail)
}

