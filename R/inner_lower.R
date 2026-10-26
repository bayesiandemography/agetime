#' Inner Low Mid Up Width
#'
#' @param labels Vector of labels.
#' @param label_type Label domain: `"age"`, `"cohort"`, or `"period"`.
#' @param interpret_single Rule for one-year labels: `"lower"` or `"upper"`.
#' @param interpret_multi Rule for multi-year labels: `"at_upper"`
#' or `"below_upper"`.
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
#' @param interpret_multi Rule for multi-year labels: `"at_upper"`
#' or `"below_upper"`.
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
  copy_labels_names(m[i, 1L], labels)
}
#' Inner Mid
#'
#' @param labels Vector of labels.
#' @param label_type Label domain: `"age"`, `"cohort"`, or `"period"`.
#' @param interpret_single Rule for one-year labels: `"lower"` or `"upper"`.
#' @param interpret_multi Rule for multi-year labels: `"at_upper"`
#' or `"below_upper"`.
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
  mid <- mid_intervals(m = m, label_type = label_type, call = parent.frame())
  copy_labels_names(mid[i], labels)
}


#' Midpoints of Intervals, Including Open Intervals
#'
#' Closed intervals get their ordinary midpoints. An open
#' interval gets a midpoint half the width of the nearest
#' closed interval away from its finite limit: for an interval
#' that is open on the right, such as `"80+"`, the closed
#' interval with the highest lower limit, and for an interval
#' that is open on the left, such as `"<2000"`, the closed
#' interval with the lowest upper limit.
#'
#' @param m Matrix of intervals, with lower limits in column 1,
#' upper limits in column 2, and labels as row names.
#' @param label_type Label domain: `"age"`, `"cohort"`, or `"period"`.
#' @param call Environment used to report errors.
#' @returns Numeric vector with one midpoint per row of `m`.
#'
#' @noRd
mid_intervals <- function(m, label_type, call) {
  l <- m[, 1L]
  u <- m[, 2L]
  ans <- l + 0.5 * (u - l)
  is_open_left <- is.infinite(l) & is.finite(u)
  is_open_right <- is.finite(l) & is.infinite(u)
  if (!any(is_open_left) && !any(is_open_right)) {
    return(ans)
  }
  is_closed <- is.finite(l) & is.finite(u)
  if (!any(is_closed)) {
    i_open <- match(TRUE, is_open_left | is_open_right)
    label <- rownames(m)[[i_open]]
    nm <- label_name(label_type)
    cli::cli_abort(
      c(
        "Can't calculate midpoint of open {nm} {.val {label}}.",
        i = "No closed {nm}s to take a width from."
      ),
      call = call
    )
  }
  l_closed <- l[is_closed]
  u_closed <- u[is_closed]
  if (any(is_open_right)) {
    i_top <- which(l_closed == max(l_closed))
    w_top <- max(u_closed[i_top] - l_closed[i_top])
    ans[is_open_right] <- l[is_open_right] + 0.5 * w_top
  }
  if (any(is_open_left)) {
    i_bottom <- which(u_closed == min(u_closed))
    w_bottom <- max(u_closed[i_bottom] - l_closed[i_bottom])
    ans[is_open_left] <- u[is_open_left] - 0.5 * w_bottom
  }
  ans
}
#' Inner Upper
#'
#' @param labels Vector of labels.
#' @param label_type Label domain: `"age"`, `"cohort"`, or `"period"`.
#' @param interpret_single Rule for one-year labels: `"lower"` or `"upper"`.
#' @param interpret_multi Rule for multi-year labels: `"at_upper"`
#' or `"below_upper"`.
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
  copy_labels_names(m[i, 2L], labels)
}
#' Inner Width
#'
#' @param labels Vector of labels.
#' @param label_type Label domain: `"age"`, `"cohort"`, or `"period"`.
#' @param interpret_single Rule for one-year labels: `"lower"` or `"upper"`.
#' @param interpret_multi Rule for multi-year labels: `"at_upper"`
#' or `"below_upper"`.
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
  copy_labels_names(w[i], labels)
}


#' Inner Interval
#'
#' @param labels Vector of labels.
#' @param label_type Label domain: `"age"`, `"cohort"`, or `"period"`.
#' @param interpret_single Rule for one-year labels: `"lower"` or `"upper"`.
#' @param interpret_multi Rule for multi-year labels: `"at_upper"`
#' or `"below_upper"`.
#' @param interpret_fail How to handle unparsable labels.
#' @returns Character vector of intervals, such as `"[2020, 2025)"`.
#'
#' @noRd
inner_interval <- function(labels,
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
  interval <- format_interval(lower = m[, 1L], upper = m[, 2L])
  copy_labels_names(interval[i], labels)
}


#' Format Intervals Using Interval Notation
#'
#' Write intervals as, for instance, `"[2020, 2025)"`. An
#' infinite limit is written `-Inf` or `Inf`, with a round
#' bracket, as in `"(-Inf, 2000)"`. Numbers are never written
#' in scientific notation.
#'
#' @param lower Numeric vector of lower limits.
#' @param upper Numeric vector of upper limits.
#' @returns Character vector, with `NA` wherever
#' `lower` or `upper` is `NA`.
#'
#' @noRd
format_interval <- function(lower, upper) {
  open <- ifelse(is.infinite(lower), "(", "[")
  lower <- format_limit(lower)
  upper <- format_limit(upper)
  ans <- paste0(open, lower, ", ", upper, ")", recycle0 = TRUE)
  ans[is.na(lower) | is.na(upper)] <- NA_character_
  ans
}


#' Format Limits of Intervals
#'
#' @param x Numeric vector.
#' @returns Character vector, with `NA` wherever `x` is `NA`.
#'
#' @noRd
format_limit <- function(x) {
  ans <- vapply(x, format, "", scientific = FALSE, trim = TRUE)
  ans[is.na(x)] <- NA_character_
  ans
}
