#' Inner Is Open
#'
#' @param x Vector of labels.
#' @param label_type Label domain: `"age"`, `"cohort"`, or `"period"`.
#' @param x_one Rule for one-year labels: `"lower"` or `"upper"`.
#' @param x_multi Rule for multi-year labels: `"include"` or `"exclude"`.
#' @param x_fail How to handle unparsable labels.
#' @param check_open_left Whether to check left-open intervals.
#' @param check_open_right Whether to check right-open intervals.
#' @returns Logical vector the same length as `x`.
#'
#' @noRd

inner_is_open <- function(x,
                          label_type,
                          x_one,
                          x_multi,
                          x_fail,
                          check_open_left,
                          check_open_right) {
  x <- to_character_or_factor(x = x,
                              nm_x = "x",
                              length_zero_ok = TRUE)
  intervals <- intervals(labels = x,
                         label_type = label_type,
                         x_one = x_one,
                         x_multi = x_multi,
                         x_fail = x_fail)
  is_open_left <- check_open_left & get_is_open_left(intervals)
  is_open_right <- check_open_right & get_is_open_right(intervals)
  is_open <- is_open_left | is_open_right
  i <- get_i_x_to_xunu(intervals)
  is_open[i]
}
#' Inner Is Total
#'
#' @param x Vector of labels.
#' @param label_type Label domain: `"age"`, `"cohort"`, or `"period"`.
#' @param x_one Rule for one-year labels: `"lower"` or `"upper"`.
#' @param x_multi Rule for multi-year labels: `"include"` or `"exclude"`.
#' @param x_fail How to handle unparsable labels.
#' @returns Logical vector the same length as `x`.
#'
#' @noRd

inner_is_total <- function(x,
                           label_type,
                           x_one,
                           x_multi,
                           x_fail) {
  x <- to_character_or_factor(x = x,
                              nm_x = "x",
                              length_zero_ok = TRUE)
  intervals <- intervals(labels = x,
                         label_type = label_type,
                         x_one = x_one,
                         x_multi = x_multi,
                         x_fail = x_fail)
  is_total <- get_is_total(intervals)
  i <- get_i_x_to_xunu(intervals)
  is_total[i]
}
