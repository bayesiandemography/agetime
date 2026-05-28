
inner_standard <- function(x,
                           label_type,
                           x_one,
                           x_multi,
                           x_fail) {
  x <- to_character_or_factor(x = x,
                              nm_x = "x",
                              length_zero_ok = TRUE)
  is_factor <- is.factor(x)
  intervals <- intervals(labels = x,
                         label_type = label_type,
                         x_one = x_one,
                         x_multi = x_multi,
                         x_fail = x_fail)
  labels <- make_labels_intervals(intervals = intervals,
                                  x_one = x_one,
                                  x_multi = x_multi)
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
                    exclude = NULL)
    }
    else {
      ans <- factor(levels = levels_std,
                    ordered = is.ordered(x),
                    exclude = NULL)
    }
    return(ans)
  }
  i <- get_i_x_to_xunu(intervals)
  labels[i]
}


