
get_i_x_to_xu <- function(intervals) intervals$i_x_to_xu

get_i_xun_to_xunu <- function(intervals) intervals$i_xun_to_xunu

get_i_x_to_xunu <- function(intervals) {
  i_x_to_xu <- get_i_x_to_xu(intervals)
  i_xun_to_xunu <- get_i_xun_to_xunu(intervals)
  i_xun_to_xunu[i_x_to_xu]
}

get_is_na <- function(intervals) {
  labels <- get_labels_unique_norm_unique(intervals)
  is.na(labels)
}


get_is_one <- function(intervals) {
  tol <- 1e-10
  m <- get_m(intervals)
  l <- m[, 1L]
  u <- m[, 2L]
  is.finite(l) & is.finite(u) & (abs(u - l - 1) < tol)
}


get_is_open <- function(intervals) {
  m <- get_m(intervals)
  l <- m[, 1L]
  u <- m[, 2L]
  is.infinite(l) || is.infinite(u)
}

get_is_open_left <- function(intervals) {
  m <- get_m(intervals)
  l <- m[, 1L]
  u <- m[, 2L]
  is.infinite(l) & is.finite(u)
}

get_is_open_right <- function(intervals) {
  m <- get_m(intervals)
  l <- m[, 1L]
  u <- m[, 2L]
  is.finite(l) & is.infinite(u)
}

get_is_range <- function(intervals) {
  m <- get_m(intervals)
  l <- m[, 1L]
  u <- m[, 2L]
  is.finite(l) & is.finite(u) & (u - l > 1.5)
}


get_is_total <- function(intervals) {
  labels <- get_labels_unique_norm_unique(intervals)
  !is.na(labels) & (labels == "total")
}

get_labels_unique <- function(intervals)
  intervals$labels_unique

get_labels_unique_norm_unique <- function(intervals)
  intervals$labels_unique_norm_unique

get_lower <- function(intervals) {
  m <- get_m(intervals)
  m[, 1L]
}

get_m <- function(intervals)
  intervals$m


get_upper <- function(intervals) {
  m <- get_m(intervals)
  m[, 2L]
}

get_width <- function(intervals) {
  m <- get_m(intervals)
  l <- m[, 1L]
  u <- m[, 2L]
  u - l
}

  
