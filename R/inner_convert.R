inner_convert <- function(x,
                          breaks,
                          is_open_left,
                          is_open_right,
                          label_type,
                          x_one,
                          x_multi,
                          x_fail) {
  x <- to_character_or_factor(x = x,
                              nm_x = "x",
                              length_zero_ok = TRUE)
  if (identical(length(x), 0L))
    return(val_length_zero(x))
  intervals <- intervals(labels = x,
                         label_type = label_type,
                         x_one = x_one,
                         x_multi = x_multi,
                         x_fail = x_fail)
  int_has_total <- int_has_total(intervals)
  int_has_na <- int_has_na(intervals)
  levels_breaks <- make_levels_from_breaks(breaks = breaks,
                                           is_open_left = is_open_left,
                                           is_open_right = is_open_right,
                                           x_one = x_one,
                                           x_multi = x_multi,
                                           include_total = int_has_total,
                                           include_na = int_has_na)
  m_contains <- make_m_contains(breaks = breaks,
                                levels_breaks = levels_breaks,
                                is_open_left = is_open_left,
                                is_open_right = is_open_right,
                                include_total = int_has_total,
                                include_na = int_has_na,
                                intervals = intervals)
  check_m_contains(m_contains = m_contains,
                   label_type = "age")
  i_new <- apply(m_contains, 2L, which)
  i_x_to_xu <- get_i_x_to_xu(intervals)
  ans <- levels_breaks[i_new][i_x_to_xu]
  if (is.factor(x))
    ans <- factor(x = ans,
                  levels = levels_breaks,
                  exclude = NULL)
  ans
}


inner_convert_width <- function(x,
                                width,
                                offset,
                                label_type,
                                x_one,
                                x_multi,
                                x_fail) {
  x <- to_character_or_factor(x = x,
                              nm_x = "x",
                              length_zero_ok = TRUE)
  if (identical(length(x), 0L))
    return(val_length_zero(x))
  check_n(n = offset,
          nm_n = "offset",
          min = 0L,
          max = width - 1L,
          divisible_by = 1L)
  intervals <- intervals(labels = x,
                         label_type = label_type,
                         x_one = x_one,
                         x_multi = x_multi,
                         x_fail = x_fail)
  is_open_left <- int_is_open_left(intervals)
  is_open_right <- int_is_open_right(intervals)
  if (is_open_left) {
    u <- get_upper(intervals)
    start <- min(u, na.rm = TRUE)
  }
  else {
    l <- get_lower(intervals)
    start <- min(l, na.rm = TRUE)
  }
  remainder_start <- (start - offset) %% width
  if (remainder_start > 0L) {
    if (is_open_left)
      start <- start + width - remainder_start
    else
      start <- start - remainder_start
  }
  if (is_open_right) {
    l <- get_lower(intervals)
    end <- max(l, na.rm = TRUE)
  }
  else {
    u <- get_upper(intervals)
    end <- max(u, na.rm = TRUE)
  }
  remainder_end <- (end - offset) %% width
  if (remainder_end > 0L) {
    if (is_open_right)
      end <- end - remainder_end
    else
      end <- end + width - remainder_end
  }
  breaks <- seq.int(from = start, to = end, by = width)
  inner_convert(x = x,
                breaks = breaks,
                is_open_left = is_open_left,
                is_open_right = is_open_right,
                label_type = label_type,
                x_one = x_one,
                x_multi = x_multi,
                x_fail = x_fail)
}
