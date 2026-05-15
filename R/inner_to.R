inner_to <- function(x,
                     breaks,
                     is_open_left,
                     is_open_right,
                     label_type,
                     x_one,
                     x_multi,
                     x_fail = c("error", "warn", "silent")) {
  x <- to_character_or_factor(x = x,
                              nm_x = "x",
                              length_zero_ok = TRUE)
  check_breaks(breaks)
  breaks <- as.integer(breaks)
  if (!is.null(open))
    check_flag(x = open, nm_x = "open")
  intervals <- intervals(labels = x,
                         label_type = label_type,
                         x_one = intepret_one,
                         x_multi = x_multi,
                         x_fail = x_fail)
  include_total <- int_has_total(intervals)
  include_na <- int_has_na(intervals)
  levels_breaks <- make_levels_from_breaks(breaks = breaks,
                                           is_open_left = is_open_left,
                                           is_open_right = is_open_right,
                                           x_one = x_one,
                                           x_multi = x_multi,
                                           include_total = include_total,
                                           include_na = include_na)
  m_contains <- make_m_contains(breaks = breaks,
                                levels_breaks = levels_breaks,
                                is_open_left = is_open_left,
                                is_open_right = is_open_right,
                                include_total = include_total,
                                include_na = include_na,
                                intervals = intervals)
  check_m_contains(m_contains = m_contains,
                   label_type = label_type)
  i_new <- apply(m_contains, 2L, which)
  i_x_to_xu <- get_i_x_to_xu(intervals)
  ans <- levels_breaks[i_new][i_x_to_xu]
  if (is.factor(x))
    ans <- factor(x = ans,
                  levels = levels_breaks,
                  exclude = NULL)
  ans
}
