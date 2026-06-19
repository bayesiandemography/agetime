#' Inner Low Mid Up Width
#'
#' @param x Vector of labels.
#' @param label_type Label domain: `"age"`, `"cohort"`, or `"period"`.
#' @param x_one Rule for one-year labels: `"lower"` or `"upper"`.
#' @param x_multi Rule for multi-year labels: `"include"` or `"exclude"`.
#' @param x_fail How to handle unparsable labels.
#' @returns List with interval matrix `m` and index vector `i`.
#'
#' @noRd

inner_low_mid_up_width <- function(x,
                                   label_type,
                                   x_one,
                                   x_multi,
                                   x_fail) {
  x <- to_character_or_factor(
    x = x,
    nm_x = "x",
    length_zero_ok = TRUE
  )
  intervals <- intervals(
    labels = x,
    label_type = label_type,
    x_one = x_one,
    x_multi = x_multi,
    x_fail = x_fail
  )
  m <- get_m(intervals)
  i <- get_i_x_to_xunu(intervals)
  list(m = m, i = i)
}
#' Inner Lower
#'
#' @param x Vector of labels.
#' @param label_type Label domain: `"age"`, `"cohort"`, or `"period"`.
#' @param x_one Rule for one-year labels: `"lower"` or `"upper"`.
#' @param x_multi Rule for multi-year labels: `"include"` or `"exclude"`.
#' @param x_fail How to handle unparsable labels.
#' @returns Numeric vector of lower bounds.
#'
#' @noRd

inner_lower <- function(x,
                        label_type,
                        x_one,
                        x_multi,
                        x_fail) {
  l <- inner_low_mid_up_width(
    x = x,
    label_type = label_type,
    x_one = x_one,
    x_multi = x_multi,
    x_fail = x_fail
  )
  m <- l$m
  i <- l$i
  m[i, 1L]
}
#' Inner Mid
#'
#' @param x Vector of labels.
#' @param label_type Label domain: `"age"`, `"cohort"`, or `"period"`.
#' @param x_one Rule for one-year labels: `"lower"` or `"upper"`.
#' @param x_multi Rule for multi-year labels: `"include"` or `"exclude"`.
#' @param x_fail How to handle unparsable labels.
#' @returns Numeric vector of interval midpoints.
#'
#' @noRd


inner_mid <- function(x,
                      label_type,
                      x_one,
                      x_multi,
                      x_fail) {
  l <- inner_low_mid_up_width(
    x = x,
    label_type = label_type,
    x_one = x_one,
    x_multi = x_multi,
    x_fail = x_fail
  )
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
#' Inner Upper
#'
#' @param x Vector of labels.
#' @param label_type Label domain: `"age"`, `"cohort"`, or `"period"`.
#' @param x_one Rule for one-year labels: `"lower"` or `"upper"`.
#' @param x_multi Rule for multi-year labels: `"include"` or `"exclude"`.
#' @param x_fail How to handle unparsable labels.
#' @returns Numeric vector of upper bounds.
#'
#' @noRd


inner_upper <- function(x,
                        label_type,
                        x_one,
                        x_multi,
                        x_fail) {
  l <- inner_low_mid_up_width(
    x = x,
    label_type = label_type,
    x_one = x_one,
    x_multi = x_multi,
    x_fail = x_fail
  )
  m <- l$m
  i <- l$i
  m[i, 2L]
}
#' Inner Width
#'
#' @param x Vector of labels.
#' @param label_type Label domain: `"age"`, `"cohort"`, or `"period"`.
#' @param x_one Rule for one-year labels: `"lower"` or `"upper"`.
#' @param x_multi Rule for multi-year labels: `"include"` or `"exclude"`.
#' @param x_fail How to handle unparsable labels.
#' @returns Numeric vector of interval widths.
#'
#' @noRd


inner_width <- function(x,
                        label_type,
                        x_one,
                        x_multi,
                        x_fail) {
  l <- inner_low_mid_up_width(
    x = x,
    label_type = label_type,
    x_one = x_one,
    x_multi = x_multi,
    x_fail = x_fail
  )
  m <- l$m
  i <- l$i
  l <- m[, 1L]
  u <- m[, 2L]
  w <- u - l
  w[i]
}
