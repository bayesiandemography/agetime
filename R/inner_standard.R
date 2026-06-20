#' Inner Standard
#'
#' Construct standard labels from intervals.
#' Note that arguments 'x_one' and 'x_multi' control
#' the way that `x` is parsed into intervals. They
#' do not control the way that the intervals are rendered.
#'
#' @param x Vector of labels.
#' @param label_type Label domain: `"age"`, `"cohort"`, or `"period"`.
#' @param x_one Rule for one-year labels: `"lower"` or `"upper"`.
#' @param x_multi Rule for multi-year labels: `"include"` or `"exclude"`.
#' @param x_fail How to handle unparsable labels.
#' @returns Standardized labels as character vector or factor.
#'
#' @noRd
inner_standard <- function(x,
                           label_type,
                           x_one,
                           x_multi,
                           x_fail) {
  x <- to_character_or_factor(
    x = x,
    nm_x = "x",
    length_zero_ok = TRUE
  )
  is_factor <- is.factor(x)
  intervals <- intervals(
    labels = x,
    label_type = label_type,
    x_one = x_one,
    x_multi = x_multi,
    x_fail = x_fail
  )
  label_multi <- if (label_type == "age") "exclude" else "include"
  labels <- construct_labels_intervals(
    intervals = intervals,
    "lower",
    label_multi
  )
  if (is_factor) {
    i_xun <- get_i_xun_to_xunu(intervals)
    levels_std <- labels[i_xun]
    levels_std <- levels_std[!duplicated(levels_std)]
    if (length(x) > 0L) {
      i <- get_i_x_to_xunu(intervals)
      values_std <- labels[i]
      ans <- factor(values_std,
        levels = levels_std,
        ordered = is.ordered(x),
        exclude = NULL
      )
    } else {
      ans <- factor(
        levels = levels_std,
        ordered = is.ordered(x),
        exclude = NULL
      )
    }
    return(ans)
  }
  i <- get_i_x_to_xunu(intervals)
  labels[i]
}
