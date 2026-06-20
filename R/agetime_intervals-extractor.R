#' Get I X To Xu
#'
#' @param intervals An `agetime_intervals` object.
#' @returns Integer index vector from input labels to unique original labels.
#'
#' @noRd
get_i_x_to_xu <- function(intervals) intervals$i_x_to_xu

#' Get I Xun To Xunu
#'
#' @param intervals An `agetime_intervals` object.
#' @returns Integer index vector from normalized
#' labels to unique normalized labels.
#'
#' @noRd
get_i_xun_to_xunu <- function(intervals) intervals$i_xun_to_xunu

#' Get I X To Xunu
#'
#' @param intervals An `agetime_intervals` object.
#' @returns Integer index vector from input labels to unique normalized labels.
#'
#' @noRd
get_i_x_to_xunu <- function(intervals) {
  i_x_to_xu <- get_i_x_to_xu(intervals)
  i_xun_to_xunu <- get_i_xun_to_xunu(intervals)
  i_xun_to_xunu[i_x_to_xu]
}

#' Get Is Na
#'
#' @param intervals An `agetime_intervals` object.
#' @returns Logical vector indicating missing labels.
#'
#' @noRd
get_is_na <- function(intervals) {
  labels <- get_labels_unique_norm_unique(intervals)
  is.na(labels)
}

#' Get Is One
#'
#' @param intervals An `agetime_intervals` object.
#' @returns Logical vector indicating width-1 finite intervals.
#'
#' @noRd
get_is_one <- function(intervals) {
  tol <- 1e-10
  m <- get_m(intervals)
  l <- m[, 1L]
  u <- m[, 2L]
  is.finite(l) & is.finite(u) & (abs(u - l - 1) < tol)
}

#' Detect Any Open Interval
#'
#' @param intervals An `agetime_intervals` object.
#' @returns `TRUE` if any interval has an infinite bound, otherwise `FALSE`.
#'
#' Returns `TRUE` when any interval bound is infinite.
#' This is used in extension logic on single-label
#' interval objects.
#'
#' @noRd
get_is_open <- function(intervals) {
  m <- get_m(intervals)
  l <- m[, 1L]
  u <- m[, 2L]
  is.infinite(l) || is.infinite(u)
}

#' Get Is Open Left
#'
#' @param intervals An `agetime_intervals` object.
#' @returns Logical vector indicating open-left intervals.
#'
#' @noRd
get_is_open_left <- function(intervals) {
  m <- get_m(intervals)
  l <- m[, 1L]
  u <- m[, 2L]
  is.infinite(l) & is.finite(u)
}

#' Get Is Open Right
#'
#' @param intervals An `agetime_intervals` object.
#' @returns Logical vector indicating open-right intervals.
#'
#' @noRd
get_is_open_right <- function(intervals) {
  m <- get_m(intervals)
  l <- m[, 1L]
  u <- m[, 2L]
  is.finite(l) & is.infinite(u)
}

#' Get Is Multi
#'
#' @param intervals An `agetime_intervals` object.
#' @returns Logical vector indicating finite multi-year intervals.
#'
#' @noRd
get_is_multi <- function(intervals) {
  m <- get_m(intervals)
  l <- m[, 1L]
  u <- m[, 2L]
  is.finite(l) & is.finite(u) & (u - l > 1.5)
}

#' Get Is Total
#'
#' @param intervals An `agetime_intervals` object.
#' @returns Logical vector indicating total labels.
#'
#' @noRd
get_is_total <- function(intervals) {
  labels <- get_labels_unique_norm_unique(intervals)
  !is.na(labels) & (labels == "total")
}

#' Get Labels Unique
#'
#' @param intervals An `agetime_intervals` object.
#' @returns Unique labels before normalization.
#'
#' @noRd
get_labels_unique <- function(intervals) {
  intervals$labels_unique
}

#' Get Labels Unique Norm Unique
#'
#' @param intervals An `agetime_intervals` object.
#' @returns Unique labels after normalization.
#'
#' @noRd
get_labels_unique_norm_unique <- function(intervals) {
  intervals$labels_unique_norm_unique
}

#' Get Lower
#'
#' @param intervals An `agetime_intervals` object.
#' @returns Numeric lower bounds.
#'
#' @noRd
get_lower <- function(intervals) {
  m <- get_m(intervals)
  m[, 1L]
}

#' Get M
#'
#' @param intervals An `agetime_intervals` object.
#' @returns Two-column interval matrix.
#'
#' @noRd
get_m <- function(intervals) {
  intervals$m
}

#' Get Upper
#'
#' @param intervals An `agetime_intervals` object.
#' @returns Numeric upper bounds.
#'
#' @noRd
get_upper <- function(intervals) {
  m <- get_m(intervals)
  m[, 2L]
}

#' Get Width
#'
#' @param intervals An `agetime_intervals` object.
#' @returns Numeric interval widths.
#'
#' @noRd
get_width <- function(intervals) {
  m <- get_m(intervals)
  l <- m[, 1L]
  u <- m[, 2L]
  u - l
}
