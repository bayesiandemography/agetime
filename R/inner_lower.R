#' Inner Low Mid Up Width
#'
#' @param labels Vector of labels.
#' @param label_type Label domain: `"age"`, `"cohort"`, or `"period"`.
#' @param interpret_single Rule for one-year labels: `"lower"` or `"upper"`.
#' @param interpret_multi Rule for multi-year labels: `"include"`
#' or `"exclude"`.
#' @param interpret_fail How to handle unparsable labels.
#' @returns List with interval matrix `m` and index vector `i`.
#'
#' @noRd

inner_low_mid_up_width <- function(labels,
                                   label_type,
                                   interpret_single,
                                   interpret_multi,
                                   interpret_fail) {
  labels <- to_character_or_factor(
    labels = labels,
    nm_labels = "labels",
    length_zero_ok = TRUE
  )
  intervals <- intervals(
    labels = labels,
    label_type = label_type,
    interpret_single = interpret_single,
    interpret_multi = interpret_multi,
    interpret_fail = interpret_fail
  )
  m <- get_m(intervals)
  i <- get_i_x_to_xunu(intervals)
  list(m = m, i = i)
}
#' Inner Lower
#'
#' @param labels Vector of labels.
#' @param label_type Label domain: `"age"`, `"cohort"`, or `"period"`.
#' @param interpret_single Rule for one-year labels: `"lower"` or `"upper"`.
#' @param interpret_multi Rule for multi-year labels: `"include"`
#' or `"exclude"`.
#' @param interpret_fail How to handle unparsable labels.
#' @returns Numeric vector of lower bounds.
#'
#' @noRd

inner_lower <- function(labels,
                        label_type,
                        interpret_single,
                        interpret_multi,
                        interpret_fail) {
  l <- inner_low_mid_up_width(
    labels = labels,
    label_type = label_type,
    interpret_single = interpret_single,
    interpret_multi = interpret_multi,
    interpret_fail = interpret_fail
  )
  m <- l$m
  i <- l$i
  m[i, 1L]
}
#' Inner Mid
#'
#' @param labels Vector of labels.
#' @param label_type Label domain: `"age"`, `"cohort"`, or `"period"`.
#' @param interpret_single Rule for one-year labels: `"lower"` or `"upper"`.
#' @param interpret_multi Rule for multi-year labels: `"include"`
#' or `"exclude"`.
#' @param interpret_fail How to handle unparsable labels.
#' @returns Numeric vector of interval midpoints.
#'
#' @noRd


inner_mid <- function(labels,
                      label_type,
                      interpret_single,
                      interpret_multi,
                      interpret_fail) {
  l <- inner_low_mid_up_width(
    labels = labels,
    label_type = label_type,
    interpret_single = interpret_single,
    interpret_multi = interpret_multi,
    interpret_fail = interpret_fail
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
#' @param labels Vector of labels.
#' @param label_type Label domain: `"age"`, `"cohort"`, or `"period"`.
#' @param interpret_single Rule for one-year labels: `"lower"` or `"upper"`.
#' @param interpret_multi Rule for multi-year labels: `"include"`
#' or `"exclude"`.
#' @param interpret_fail How to handle unparsable labels.
#' @returns Numeric vector of upper bounds.
#'
#' @noRd


inner_upper <- function(labels,
                        label_type,
                        interpret_single,
                        interpret_multi,
                        interpret_fail) {
  l <- inner_low_mid_up_width(
    labels = labels,
    label_type = label_type,
    interpret_single = interpret_single,
    interpret_multi = interpret_multi,
    interpret_fail = interpret_fail
  )
  m <- l$m
  i <- l$i
  m[i, 2L]
}
#' Inner Width
#'
#' @param labels Vector of labels.
#' @param label_type Label domain: `"age"`, `"cohort"`, or `"period"`.
#' @param interpret_single Rule for one-year labels: `"lower"` or `"upper"`.
#' @param interpret_multi Rule for multi-year labels: `"include"`
#' or `"exclude"`.
#' @param interpret_fail How to handle unparsable labels.
#' @returns Numeric vector of interval widths.
#'
#' @noRd


inner_width <- function(labels,
                        label_type,
                        interpret_single,
                        interpret_multi,
                        interpret_fail) {
  l <- inner_low_mid_up_width(
    labels = labels,
    label_type = label_type,
    interpret_single = interpret_single,
    interpret_multi = interpret_multi,
    interpret_fail = interpret_fail
  )
  m <- l$m
  i <- l$i
  l <- m[, 1L]
  u <- m[, 2L]
  w <- u - l
  w[i]
}
