
inner_is_open <- function(x,
                          label_type,
                          label_one,
                          label_multi,
                          unknown_label,
                          check_open_left,
                          check_open_right) {
  x <- to_character_or_factor(x = x,
                              nm_x = "x",
                              length_zero_ok = TRUE)
  intervals <- intervals(labels = x,
                         label_type = label_type,
                         label_one = label_one,
                         label_multi = label_multi,
                         unknown_label = unknown_label)
  is_open_left <- check_open_left & get_is_open_left(intervals)
  is_open_right <- check_open_right & get_is_open_right(intervals)
  is_open <- is_open_left | is_open_right
  i <- get_i_x_to_xunu(intervals)
  is_open[i]
}

inner_is_total <- function(x,
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
  is_total <- get_is_total(intervals)
  i <- get_i_x_to_xunu(intervals)
  is_total[i]
}
