
inner_levels_sort <- function(x,
                              decreasing,
                              label_type,
                              x_one,
                              x_multi,
                              x_fail) {
  x <- to_character_or_factor(x = x,
                              nm_x = "x",
                              length_zero_ok = FALSE)
  check_flag(x = decreasing, nm_x = "decreasing")
  intervals <- intervals(labels = x,
                         label_type = label_type,
                         x_one = x_one,
                         x_multi = x_multi,
                         x_fail = x_fail)
  lower <- get_lower(intervals)
  upper <- get_upper(intervals)
  is_total <- get_is_total(intervals)
  labels_unique <- get_labels_unique(intervals)
  i_xun_to_xunu <- get_i_xun_to_xunu(intervals)
  i_unique <- seq_along(i_xun_to_xunu)
  ord_norm <- order(lower,
                    upper,
                    is_total)
  ord_norm <- ord_norm[i_xun_to_xunu]
  i_ord <- match(i_unique, ord_norm)
  ord_unique <- order(i_ord,
                      i_unique,
                      decreasing = decreasing)
  levels_new <- labels_unique[ord_unique]
  factor(x, levels = levels_new, exclude = NULL)
}    
  
   
