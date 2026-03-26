
inner_is_open <- function(x,
                          label_type,
                          label_one,
                          label_multi,
                          unknown_label,
                          open) {
  x <- to_character_or_factor(x = x,
                              nm_x = "x",
                              length_zero_ok = TRUE)
  intervals <- intervals(labels = x,
                         label_type = label_type,
                         label_one = label_one,
                         label_multi = label_multi,
                         unknown_label = unknown_label)
  if (open == "right")
    is_open <- get_is_open_right(intervals)
  else
    is_open <- get_is_open_left(intervals)
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
