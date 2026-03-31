
inner_standard <- function(x,
                           label_type,
                           parse_one,
                           parse_multi,
                           parse_fail) {
  x <- to_character_or_factor(x = x,
                              nm_x = "x",
                              length_zero_ok = TRUE)
  intervals <- intervals(labels = x,
                         label_type = label_type,
                         parse_one = parse_one,
                         parse_multi = parse_multi,
                         parse_fail = parse_fail)
  labels <- make_labels_intervals(intervals = intervals,
                                  parse_one = parse_one,
                                  parse_multi = parse_multi)
  i <- get_i_x_to_xunu(intervals)
  labels[i]
}


