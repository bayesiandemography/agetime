
get_lower <- function(x) x$m[x$i, 1L]

get_mid <- function(x) {
  m <- x$m
  i <- x$i
  lower <- m[, 1L]
  upper <- m[, 2L]
  width <- upper - lower
  ans <- lower + 0.5 * width
  is_width_defined <- !is.na(width) & is.finite(width)
  if (any(is_width_defined)) {
    median_width <- stats::median(width[is_width_defined])
    is_open_left <- is.infinite(lower)
    is_open_right <- is.infinite(upper)
    ans[is_open_left] <- upper[is_open_left] - 0.5 * median_width
    ans[is_open_right] <- lower[is_open_right] + 0.5 * median_width
  }
  ans
}

get_upper <- function(x) x$m[x$i, 2L]

get_width <- function(x) {
  m <- x$m
  i <- x$i
  lower <- m[, 1L]
  upper <- m[, 2L]
  upper - lower
}


  
