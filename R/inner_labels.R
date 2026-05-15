
inner_labels <- function(breaks,
                         x_one,
                         x_multi,
                         is_open_left,
                         is_open_right,
                         include_total,
                         include_na) {
  check_breaks(breaks)
  check_flag(x = include_total, nm_x = "include_total")
  check_flag(x = include_na, nm_x = "include_na")
  make_levels_from_breaks(breaks = breaks,
                          x_one = x_one,
                          x_multi = x_multi,
                          is_open_left = is_open_left,
                          is_open_right = is_open_right,
                          include_total = include_total,
                          include_na = include_na)
}

inner_labels_one <- function(lower_first,
                             lower_last,
                             x_one,
                             x_multi,
                             is_open_left,
                             is_open_right,
                             include_total,
                             include_na) {
  check_n(n = lower_first,
                    nm_n = "lower_first",
                    min = 0L,
                    max = NULL,
                    divisible_by = 1L)
  check_n(n = lower_last,
                    nm_n = "lower_last",
                    min = 1L,
                    max = NULL,
                    divisible_by = 1L)
  check_x_lt_y(x = lower_first,
               y = lower_last,
               nm_x = "lower_first",
               nm_y = "lower_last")
  check_flag(x = include_total, nm_x = "include_total")
  check_flag(x = include_na, nm_x = "include_na")
  to <- lower_last + if (is_open_right) 0L else 1L
  breaks <- seq.int(from = lower_first,
                    to = to,
                    by = 1L)
  make_levels_from_breaks(breaks = breaks,
                          x_one = x_one,
                          x_multi = x_multi,
                          is_open_left = is_open_left,
                          is_open_right = is_open_right,
                          include_total = include_total,
                          include_na = include_na)
}


inner_labels_five <- function(lower_first,
                              lower_last,
                              x_one,
                              x_multi,
                              is_open_left,
                              is_open_right,
                              include_total,
                              include_na) {
  check_n(n = lower_first,
                    nm_n = "lower_first",
                    min = 0L,
                    max = NULL,
                    divisible_by = 5L)
  check_n(n = lower_last,
                    nm_n = "lower_last",
                    min = 5L,
                    max = NULL,
                    divisible_by = 5L)
  check_x_lt_y(x = lower_first,
               y = lower_last,
               nm_x = "lower_first",
               nm_y = "lower_last")
  check_flag(x = include_total, nm_x = "include_total")
  check_flag(x = include_na, nm_x = "include_na")
  to <- lower_last + if (is_open_right) 0L else 5L
  breaks <- seq.int(from = lower_first,
                    to = to,
                    by = 5L)
  make_levels_from_breaks(breaks = breaks,
                          x_one = x_one,
                          x_multi = x_multi,
                          is_open_left = is_open_left,
                          is_open_right = is_open_right,
                          include_total = include_total,
                          include_na = include_na)
}

inner_labels_ten <- function(lower_first,
                             lower_last,
                             x_one,
                             x_multi,
                             is_open_left,
                             is_open_right,
                             include_total,
                             include_na) {
  check_n(n = lower_first,
                    nm_n = "lower_first",
                    min = 0L,
                    max = NULL,
                    divisible_by = 10L)
  check_n(n = lower_last,
                    nm_n = "lower_last",
                    min = 10L,
                    max = NULL,
                    divisible_by = 10L)
  check_x_lt_y(x = lower_first,
               y = lower_last,
               nm_x = "lower_first",
               nm_y = "lower_last")
  check_flag(x = include_total, nm_x = "include_total")
  check_flag(x = include_na, nm_x = "include_na")
  to <- lower_last + if (is_open_right) 0L else 10L
  breaks <- seq.int(from = lower_first,
                    to = to,
                    by = 10L)
  make_levels_from_breaks(breaks = breaks,
                          x_one = x_one,
                          x_multi = x_multi,
                          is_open_left = is_open_left,
                          is_open_right = is_open_right,
                          include_total = include_total,
                          include_na = include_na)
}


