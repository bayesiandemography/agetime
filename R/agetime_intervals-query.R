#' Int Is Empty
#'
#' @param intervals An `agetime_intervals` object.
#' @returns Return value used internally.
#'
#' @noRd

int_is_empty <- function(intervals) {
  m <- get_m(intervals)
  identical(nrow(m), 0L)
}
#' Int Is Open Left
#'
#' @param intervals An `agetime_intervals` object.
#' @returns Return value used internally.
#'
#' @noRd

int_is_open_left <- function(intervals) {
  is_open_left <- get_is_open_left(intervals)
  any(is_open_left)
}
#' Int Is Open Right
#'
#' @param intervals An `agetime_intervals` object.
#' @returns Return value used internally.
#'
#' @noRd

int_is_open_right <- function(intervals) {
  is_open_right <- get_is_open_right(intervals)
  any(is_open_right)
}
#' Int Has Na
#'
#' @param intervals An `agetime_intervals` object.
#' @returns Return value used internally.
#'
#' @noRd

int_has_na <- function(intervals) {
  is_na <- get_is_na(intervals)
  any(is_na)
}
#' Int Has Total
#'
#' @param intervals An `agetime_intervals` object.
#' @returns Return value used internally.
#'
#' @noRd

int_has_total <- function(intervals) {
  is_total <- get_is_total(intervals)
  any(is_total)
}
