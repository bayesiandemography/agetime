
inner_standard <- function(x,
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
  labels <- make_labels_intervals(intervals = intervals,
                                  x_one = x_one,
                                  x_multi = x_multi)
  i <- get_i_x_to_xunu(intervals)
  labels[i]
}


