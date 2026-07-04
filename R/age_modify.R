#' Convert to New Age Groups
#'
#' Modify the age groups used by `labels`. The
#' the new age groups must
#' contain the old ones.
#'
#' @inheritParams age_lower
#' @param breaks Boundaries between age groups.
#' A numeric vector.
#' @param open Whether the oldest age group
#' is "open", i.e. has no upper limit.
#' Default is `TRUE`.
#' @return Character vector or factor with the same length as `labels`.
#'
#' @examples
#' labels <- c("1-4", "87-89", "0", "50-54")
#' age_modify(labels, breaks = c(0, 10, 40, 90))
#' age_modify(labels, breaks = c(0, 10, 40, 90), open = FALSE)
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
# length and ordered attribute. When length(labels) == 0, returns
# character(0) or
# still modifies factor levels().
age_modify <- function(labels,
                       breaks,
                       open = TRUE,
                       interpret_fail = c("error", "warn", "silent")) {
  check_flag(x = open, nm_x = "open")
  interpret_fail <- match.arg(interpret_fail)
  inner_modify(
    labels = labels,
    breaks = breaks,
    is_open_left = FALSE,
    is_open_right = open,
    label_type = "age",
    interpret_single = "lower",
    interpret_multi = "exclude",
    interpret_fail = interpret_fail
  )
}


#' Convert to Specialised Age Groups
#'
#' @description
#'
#' Modify the age groups used by `labels`.
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
#' labels <- c("1-3", "87-89", "0", "91+", "total", "52")
#' age_modify_five(labels)
#' age_modify_ten(labels)
#' age_modify_life(labels)
#' @export

# When length(labels) == 0 and labels is a factor with no levels,
# labels is returned unchanged.
age_modify_five <- function(labels,
                            interpret_fail = c("error", "warn", "silent")) {
  interpret_fail <- match.arg(interpret_fail)
  inner_modify_width(
    labels = labels,
    width = 5L,
    offset = 0L,
    label_type = "age",
    interpret_single = "lower",
    interpret_multi = "exclude",
    interpret_fail = interpret_fail
  )
}

#' @rdname age_modify_five
#' @export
age_modify_ten <- function(labels,
                           interpret_fail = c("error", "warn", "silent")) {
  interpret_fail <- match.arg(interpret_fail)
  inner_modify_width(
    labels = labels,
    width = 10L,
    offset = 0L,
    label_type = "age",
    interpret_single = "lower",
    interpret_multi = "exclude",
    interpret_fail = interpret_fail
  )
}

#' @rdname age_modify_five
#' @export
age_modify_life <- function(labels,
                            interpret_fail = c("error", "warn", "silent")) {
  is_factor <- is.factor(labels)
  labels <- to_character_or_factor(
    labels = labels,
    nm_labels = "labels",
    length_zero_ok = TRUE
  )
  interpret_fail <- match.arg(interpret_fail)
  if (identical(length(labels), 0L) && !is_factor) {
    return(character(0))
  }
  if (identical(length(labels), 0L) && is_factor && nlevels(labels) == 0L) {
    return(factor(levels = character(), ordered = is.ordered(labels)))
  }
  intervals <- intervals(
    labels = labels,
    label_type = "age",
    interpret_single = "lower",
    interpret_multi = "exclude",
    interpret_fail = interpret_fail
  )
  l <- get_lower(intervals)
  u <- get_upper(intervals)
  is_open_right <- int_is_open_right(intervals)
  if (is_open_right) {
    is_or <- is.infinite(u)
    top_lower <- min(l[is_or], na.rm = TRUE)
    breaks <- c(0L, 1L, seq.int(from = 5L, to = top_lower, by = 5L))
  } else {
    u_max <- max(u[is.finite(u)], na.rm = TRUE)
    if (u_max <= 5L) {
      breaks <- c(0L, 1L, 5L)
    } else {
      end_break <- u_max
      if (end_break %% 5L != 0L) {
        end_break <- end_break + (5L - end_break %% 5L)
      }
      breaks <- c(0L, 1L, seq.int(from = 5L, to = end_break, by = 5L))
    }
  }
  inner_modify(
    labels = labels,
    breaks = breaks,
    is_open_left = FALSE,
    is_open_right = is_open_right,
    label_type = "age",
    interpret_single = "lower",
    interpret_multi = "exclude",
    interpret_fail = interpret_fail
  )
}
