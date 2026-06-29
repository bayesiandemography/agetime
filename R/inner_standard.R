#' Inner Standard
#'
#' Construct standard labels from intervals.
#' Note that arguments 'interpret_single' and 'interpret_range' control
#' the way that `labels` is parsed into intervals. They
#' do not control the way that the intervals are rendered.
#'
#' @param labels Vector of labels.
#' @param label_type Label domain: `"age"`, `"cohort"`, or `"period"`.
#' @param interpret_single Rule for one-year labels: `"lower"` or `"upper"`.
#' @param interpret_range Rule for multi-year labels: `"include"`
#' or `"exclude"`.
#' @param interpret_fail How to handle unparsable labels.
#' @returns Standardized labels as character vector or factor.
#'
#' @noRd
inner_standard <- function(labels,
                           label_type,
                           interpret_single,
                           interpret_range,
                           interpret_fail) {
  labels <- to_character_or_factor(
    labels = labels,
    nm_labels = "labels",
    length_zero_ok = TRUE
  )
  is_factor <- is.factor(labels)
  is_ordered <- is_factor && is.ordered(labels)
  intervals <- intervals(
    labels = labels,
    label_type = label_type,
    interpret_single = interpret_single,
    interpret_range = interpret_range,
    interpret_fail = interpret_fail
  )
  format_range <- if (label_type == "age") "exclude" else "include"
  labels_std <- construct_labels_intervals(
    intervals = intervals,
    "lower",
    format_range
  )
  if (is_factor) {
    i_xun <- get_i_xun_to_xunu(intervals)
    levels_std <- labels_std[i_xun]
    levels_std <- levels_std[!duplicated(levels_std)]
    if (length(labels) > 0L) {
      i <- get_i_x_to_xunu(intervals)
      values_std <- labels_std[i]
      ans <- factor(values_std,
        levels = levels_std,
        ordered = is_ordered,
        exclude = NULL
      )
    } else {
      ans <- factor(
        levels = levels_std,
        ordered = is_ordered,
        exclude = NULL
      )
    }
    return(ans)
  }
  i <- get_i_x_to_xunu(intervals)
  labels_std[i]
}
