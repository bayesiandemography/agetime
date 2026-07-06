#' Inner Is Open
#'
#' @param labels Vector of labels.
#' @param label_type Label domain: `"age"`, `"cohort"`, or `"period"`.
#' @param interpret_single Rule for one-year labels: `"lower"` or `"upper"`.
#' @param interpret_multi Rule for multi-year labels: `"include"`
#' or `"exclude"`.
#' @param interpret_fail How to handle unparsable labels.
#' @param check_open_left Whether to check left-open intervals.
#' @param check_open_right Whether to check right-open intervals.
#' @returns Logical vector the same length as `labels`.
#'
#' @noRd

inner_is_open <- function(labels,
                          label_type,
                          interpret_single,
                          interpret_multi,
                          interpret_fail,
                          check_open_left,
                          check_open_right) {
  labels <- to_character_or_factor(
    labels = labels,
    nm_labels = "labels",
    length_zero_ok = TRUE
  )
  intervals <- intervals(
    labels = labels,
    label_type = label_type,
    interpret_single = interpret_single,
    interpret_multi = interpret_multi,
    interpret_fail = interpret_fail
  )
  is_open_left <- check_open_left & get_is_open_left(intervals)
  is_open_right <- check_open_right & get_is_open_right(intervals)
  is_open <- is_open_left | is_open_right
  i <- get_i_x_to_xunu(intervals)
  set_labels_names(is_open[i], labels)
}
#' Inner Is Total
#'
#' @param labels Vector of labels.
#' @param label_type Label domain: `"age"`, `"cohort"`, or `"period"`.
#' @param interpret_single Rule for one-year labels: `"lower"` or `"upper"`.
#' @param interpret_multi Rule for multi-year labels: `"include"`
#' or `"exclude"`.
#' @param interpret_fail How to handle unparsable labels.
#' @returns Logical vector the same length as `labels`.
#'
#' @noRd

inner_is_total <- function(labels,
                           label_type,
                           interpret_single,
                           interpret_multi,
                           interpret_fail) {
  labels <- to_character_or_factor(
    labels = labels,
    nm_labels = "labels",
    length_zero_ok = TRUE
  )
  intervals <- intervals(
    labels = labels,
    label_type = label_type,
    interpret_single = interpret_single,
    interpret_multi = interpret_multi,
    interpret_fail = interpret_fail
  )
  is_total <- get_is_total(intervals)
  i <- get_i_x_to_xunu(intervals)
  set_labels_names(is_total[i], labels)
}
