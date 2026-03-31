
inner_standard <- function(x,
                           label_type,
                           label_one,
                           label_multi,
                           unknown_label) {
  x <- to_character_or_factor(x = x,
                              nm_x = "x",
                              length_zero_ok = TRUE)
  intervals <- intervals(labels = x,
                         label_type = label_type,
                         label_one = label_one,
                         label_multi = label_multi,
                         unknown_label = unknown_label)
  labels <- make_labels_intervals(intervals = intervals,
                                  label_one = label_one,
                                  label_multi = label_multi)
  i <- get_i_x_to_xunu(intervals)
  labels[i]
}


