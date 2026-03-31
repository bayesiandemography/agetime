
inner_low_mid_up_width <- function(x,
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
  m <- get_m(intervals)
  i <- get_i_x_to_xunu(intervals)
  list(m = m, i = i)
}

inner_lower <- function(x,
                        label_type,
                        parse_one,
                        parse_multi,
                        parse_fail) {
  l <- inner_low_mid_up_width(x = x,
                              label_type = label_type,
                              parse_one = parse_one,
                              parse_multi = parse_multi,
                              parse_fail = parse_fail)
  m <- l$m
  i <- l$i
  m[i, 1L]
}



inner_mid <- function(x,
                      label_type,
                      parse_one,
                      parse_multi,
                      parse_fail) {
  l <- inner_low_mid_up_width(x = x,
                              label_type = label_type,
                              parse_one = parse_one,
                              parse_multi = parse_multi,
                              parse_fail = parse_fail)
  m <- l$m
  i <- l$i
  l <- m[, 1L]
  u <- m[, 2L]
  w <- u - l
  m <- l + 0.5 * w
  is_open_left <- is.infinite(l)
  is_open_right <- is.infinite(u)
  if (any(is_open_left) || any(is_open_right)) {
    is_w_defined <- !is.na(w) & is.finite(w)
    if (any(is_w_defined)) {
      median_w <- stats::median(w[is_w_defined])
      m[is_open_left] <- u[is_open_left] - 0.5 * median_w
      m[is_open_right] <- l[is_open_right] + 0.5 * median_w
    }
  }
  m[i]
}


inner_upper <- function(x,
                        label_type,
                        parse_one,
                        parse_multi,
                        parse_fail) {
  l <- inner_low_mid_up_width(x = x,
                              label_type = label_type,
                              parse_one = parse_one,
                              parse_multi = parse_multi,
                              parse_fail = parse_fail)
  m <- l$m
  i <- l$i
  m[i, 2L]
}


inner_width <- function(x,
                        label_type,
                        parse_one,
                        parse_multi,
                        parse_fail) {
  l <- inner_low_mid_up_width(x = x,
                              label_type = label_type,
                              parse_one = parse_one,
                              parse_multi = parse_multi,
                              parse_fail = parse_fail)
  m <- l$m
  i <- l$i
  l <- m[, 1L]
  u <- m[, 2L]
  w <- u - l
  w[i]
}









  
