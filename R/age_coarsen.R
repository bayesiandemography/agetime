#' Coarsen Age Groups
#'
#' Define new age groups that contain existing age groups.
#'
#' The new age groups cannot split existing
#' age groups, and are typically wider than them.
#' 
#' If `labels` is a factor, its levels are modified
#' along with its elements.
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
#' age_coarsen(labels, breaks = c(10, 15, 25))
#'
#' ## let inclusion of open age group depend on labels
#' labels_no_open <- c("1-4", "87-89", "0", "50-54")
#' age_coarsen(labels_no_open, breaks = c(0, 10, 40, 90))
#' labels_has_open <- c("1-4", "87+", "0", "50-54")
#' age_coarsen(labels_has_open, breaks = c(0, 10, 40, 87))
#'
#' ## insist on an open age group
#' age_coarsen(
#'   labels_no_open,
#'   breaks = c(0, 10, 40, 90),
#'   open_right = TRUE
#' )
#' @seealso
#' - [age_coarsen_five()] Coarsen to 5-year age groups
#' - [age_coarsen_ten()] Coarsen to 10-year age groups
#' - [age_coarsen_life()] Coarsen to life table age groups
#' - [period_coarsen()] Period equivalent of `age_coarsen()`
#' - [cohort_coarsen()] Cohort equivalent of `age_coarsen()`
#' @export

age_coarsen <- function(labels,
                       breaks,
                       open_right = NULL,
                       interpret_fail = c("error", "warn", "silent")) {
  check_open_flag(x = open_right, nm_x = "open_right")
  interpret_fail <- match.arg(interpret_fail)
  inner_coarsen(
    labels = labels,
    breaks = breaks,
    is_open_left = NULL,
    is_open_right = open_right,
    label_type = "age",
    interpret_single = "lower",
    interpret_multi = "exclude",
    interpret_fail = interpret_fail,
    minimal_levels = FALSE,
    preserve_input_type = FALSE
  )
}


#' Coarsen to Specialised Age Groups
#'
#' @description
#'
#' Define new age groups that contain existing
#' age groups and that follow a regular
#' pattern:
#'
#' - `age_coarsen_five` Five-year age groups
#' - `age_coarsen_ten` Ten-year age groups
#' - `age_coarsen_life` Age groups used in 'abridged' life tables
#'
#' @details
#'
#' The new age groups cannot split existing
#' age groups.
#' 
#' If `labels` is a factor, its levels are modified
#' along with its elements.
#'
#' @inheritSection age_check Abridged and complete life tables
#' @inheritParams age_lower
#' @inheritParams age_coarsen
#' @inherit age_standard return
#'
#' @inheritSection age_coarsen The `open_right` argument
#'
#' @seealso
#' - [age_coarsen()] Coarsen to general age groups
#' - [period_coarsen_five()] Period equivalent of `age_coarsen_five()`
#' - [period_coarsen_ten()] Period equivalent of `age_coarsen_ten()`
#' - [cohort_coarsen_five()] Cohort equivalent of `age_coarsen_five()`
#' - [cohort_coarsen_ten()] Cohort equivalent of `age_coarsen_ten()`
#' - [age_fill()] Add levels for intermediate age groups
#'
#' @examples
#' labels <- c("1-3", "16-19", "0", "31+", "total", "22")
#' age_coarsen_five(labels)
#' age_coarsen_ten(labels)
#' age_coarsen_life(labels)
#'
#' labels_no_open <- c("1-3", "16-19", "0", "total", "22")
#' age_coarsen_five(labels_no_open)
#' age_coarsen_five(labels_no_open, open_right = TRUE)
#' @export

age_coarsen_five <- function(labels,
                            open_right = NULL,
                            interpret_fail = c("error", "warn", "silent")) {
  check_open_flag(x = open_right, nm_x = "open_right")
  interpret_fail <- match.arg(interpret_fail)
  inner_coarsen_width(
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

#' @rdname age_coarsen_five
#' @export
age_coarsen_ten <- function(labels,
                           open_right = NULL,
                           interpret_fail = c("error", "warn", "silent")) {
  check_open_flag(x = open_right, nm_x = "open_right")
  interpret_fail <- match.arg(interpret_fail)
  inner_coarsen_width(
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

#' @rdname age_coarsen_five
#' @export
age_coarsen_life <- function(labels,
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
      return(character(0))
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
  inner_coarsen(
    labels = labels,
    breaks = breaks,
    is_open_left = NULL,
    is_open_right = open_right,
    label_type = "age",
    interpret_single = "lower",
    interpret_multi = "exclude",
    interpret_fail = interpret_fail,
    minimal_levels = TRUE,
    preserve_input_type = TRUE
  )
}
