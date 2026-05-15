
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
