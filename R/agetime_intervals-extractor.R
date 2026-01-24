
get_i <- function(object) object$i

get_i_x_to_xu <- function(object) object$i_x_to_xu

get_i_xun_to_xunu <- function(object) object$i_xun_to_xunu

get_is_na <- function(object) {
  labels <- get_labels_unique_norm_unique(object)
  is.na(labels)
}

get_is_open <- function(object) {
  m <- get_m(object)
  i <- get_i(object)
  l <- m[, 1L]
  u <- m[, 2L]
  o <- is.infinite(l) | is.infinite(u)
  o[i]
}

get_is_total <- function(object) {
  labels <- get_labels_unique_norm_unique(object)
  labels == "total"
}

get_labels_unique <- function(object) object$labels_unique

get_labels_unique_norm_unique <- function(object) object$labels_unique_norm_unique

get_lower <- function(object) {
  i <- get_i(object)
  m <- get_m(object)
  m[i, 1L]
}

get_m <- function(object) object$m

get_mid <- function(object) {
  m <- get_m(object)
  i <- get_i(object)
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

get_upper <- function(object) {
  i <- get_i(object)
  m <- get_m(object)
  m[i, 2L]
}

get_width <- function(object) {
  m <- get_m(object)
  i <- get_i(object)
  l <- m[, 1L]
  u <- m[, 2L]
  w <- u - l
  w[i]
}


  
