#' Convert to New Age Groups
#'
#' Modify the age groups used by `labels`. The
#' the new age groups must
#' contain the old ones.
#'
#' @inheritParams age_lower
#' @param breaks Boundaries between age groups.
#' A numeric vector.
#' @param open_right Whether to include an age group that is
#' open on the right. Optional. See below for details.
#' @return Factor with the same length as `labels`.
#'
#' @section The `open_right` argument:
#'
#' An age group is open on the right if it has no upper limit,
#' e.g. `"100+"`.
#'
#' By default, the return value has an open age group
#' if and only if `labels` does. The full range of options is:
#'
#' | `open_right` | `labels` has open on right | Return value has open on right |
#' |--------------|----------------------------|--------------------------------|
#' | `NULL` (default) | Yes | Yes |
#' | `NULL` (default) | No | No |
#' | `TRUE` | Yes | Yes |
#' | `TRUE` | No | Yes |
#' | `FALSE` | Yes | *Error* |
#' | `FALSE` | No | No |
#'
#' @examples
#' labels <- c("10-14", "16", "22-23")
#' age_modify(labels, breaks = c(10, 15, 25))
#'
#' ## let inclusion of open age group depend on labels
#' labels_no_open <- c("1-4", "87-89", "0", "50-54")
#' age_modify(labels_no_open, breaks = c(0, 10, 40, 90))
#' labels_has_open <- c("1-4", "87+", "0", "50-54")
#' age_modify(labels_has_open, breaks = c(0, 10, 40, 87))
#'
#' ## insist on an open age group
#' age_modify(
#'   labels_no_open,
#'   breaks = c(0, 10, 40, 90),
#'   open_right = TRUE
#' )
#' @seealso
#' - [age_modify_five()] Convert to 5-year age groups
#' - [age_modify_ten()] Convert to 10-year age groups
#' - [age_modify_life()] Convert to life table age groups
#' - [period_modify()] Period equivalent of `age_modify()`
#' - [cohort_modify()] Cohort equivalent of `age_modify()`
#' @export

age_modify <- function(labels,
                       breaks,
                       open_right = NULL,
                       interpret_fail = c("error", "warn", "silent")) {
  check_open_flag(x = open_right, nm_x = "open_right")
  interpret_fail <- match.arg(interpret_fail)
  inner_modify(
    labels = labels,
    breaks = breaks,
    is_open_left = NULL,
    is_open_right = open_right,
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
#' @inheritSection age_check Abridged and complete life tables
#' @inheritParams age_lower
#' @inherit age_modify return
#' @inheritSection age_modify The `open_right` argument
#'
#' @seealso
#' - [age_modify()] Convert to general age groups
#' - [period_modify_five()] Period equivalent of `age_modify_five()`
#' - [period_modify_ten()] Period equivalent of `age_modify_ten()`
#' - [cohort_modify_five()] Cohort equivalent of `age_modify_five()`
#' - [cohort_modify_ten()] Cohort equivalent of `age_modify_ten()`
#' - [age_fill()] Add levels for intermediate age groups
#'
#' @examples
#' labels <- c("1-3", "16-19", "0", "31+", "total", "22")
#' age_modify_five(labels)
#' age_modify_ten(labels)
#' age_modify_life(labels)
#'
#' labels_no_open <- c("1-3", "16-19", "0", "total", "22")
#' age_modify_five(labels_no_open)
#' age_modify_five(labels_no_open, open_right = TRUE)
#' @inheritParams age_modify
#' @export

age_modify_five <- function(labels,
                            open_right = NULL,
                            interpret_fail = c("error", "warn", "silent")) {
  check_open_flag(x = open_right, nm_x = "open_right")
  interpret_fail <- match.arg(interpret_fail)
  inner_modify_width(
    labels = labels,
    width = 5L,
    offset = 0L,
    is_open_left = NULL,
    is_open_right = open_right,
    label_type = "age",
    interpret_single = "lower",
    interpret_multi = "exclude",
    interpret_fail = interpret_fail
  )
}

#' @rdname age_modify_five
#' @inheritParams age_modify
#' @export
age_modify_ten <- function(labels,
                           open_right = NULL,
                           interpret_fail = c("error", "warn", "silent")) {
  check_open_flag(x = open_right, nm_x = "open_right")
  interpret_fail <- match.arg(interpret_fail)
  inner_modify_width(
    labels = labels,
    width = 10L,
    offset = 0L,
    is_open_left = NULL,
    is_open_right = open_right,
    label_type = "age",
    interpret_single = "lower",
    interpret_multi = "exclude",
    interpret_fail = interpret_fail
  )
}

#' @rdname age_modify_five
#' @inheritParams age_modify
#' @export
age_modify_life <- function(labels,
                            open_right = NULL,
                            interpret_fail = c("error", "warn", "silent")) {
  check_open_flag(x = open_right, nm_x = "open_right")
  is_ordered <- is.factor(labels) && is.ordered(labels)
  labels <- to_character_or_factor(
    labels = labels,
    nm_labels = "labels",
    length_zero_ok = TRUE
  )
  interpret_fail <- match.arg(interpret_fail)
  if (identical(length(labels), 0L)) {
    if (is.factor(labels) && nlevels(labels) == 0L) {
      return(factor(levels = character(), ordered = is_ordered))
    }
    if (!is.factor(labels)) {
      return(factor())
    }
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
  if (int_is_open_right(intervals)) {
    top_lower <- min(l[is.infinite(u)], na.rm = TRUE)
  } else {
    u_max <- max(u[is.finite(u)], na.rm = TRUE)
    if (u_max <= 5L) {
      top_lower <- 5L
    } else {
      top_lower <- u_max
      if (top_lower %% 5L != 0L) {
        top_lower <- top_lower + (5L - top_lower %% 5L)
      }
    }
  }
  if (top_lower <= 5L) {
    breaks <- c(0L, 1L, 5L)
  } else {
    breaks <- c(0L, 1L, seq.int(from = 5L, to = top_lower, by = 5L))
  }
  inner_modify(
    labels = labels,
    breaks = breaks,
    is_open_left = NULL,
    is_open_right = open_right,
    label_type = "age",
    interpret_single = "lower",
    interpret_multi = "exclude",
    interpret_fail = interpret_fail
  )
}
