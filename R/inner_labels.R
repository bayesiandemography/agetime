#' Inner Labels
#'
#' @param breaks Increasing vector of break points.
#' @param format_single Rule for one-year labels: `"lower"` or `"upper"`.
#' @param format_multi Rule for multi-year labels: `"at_upper"` or `"below_upper"`.
#' @param is_open_left Whether to include an open-left interval.
#' @param is_open_right Whether to include an open-right interval.
#' @param include_total Whether to append `"Total"`.
#' @param include_missing Whether to append `"Missing"`.
#' @param require_divisible_bounds Whether `lower_first` and `lower_last`
#' must themselves be divisible by 5.
#' @returns Character vector of labels.
#'
#' @noRd

inner_labels <- function(breaks,
                         format_single,
                         format_multi,
                         is_open_left,
                         is_open_right,
                         include_total,
                         include_missing) {
  check_breaks(breaks)
  check_flag(x = include_total, nm_x = "include_total")
  check_flag(x = include_missing, nm_x = "include_missing")
  construct_labels_breaks(
    breaks = breaks,
    format_single = format_single,
    format_multi = format_multi,
    is_open_left = is_open_left,
    is_open_right = is_open_right,
    include_total = include_total,
    include_missing = include_missing
  )
}
#' Inner Labels One
#'
#' @param lower_first First lower bound for generated labels.
#' @param lower_last Last lower bound for generated labels.
#' @param format_single Rule for one-year labels: `"lower"` or `"upper"`.
#' @param format_multi Rule for multi-year labels: `"at_upper"` or `"below_upper"`.
#' @param is_open_left Whether to include an open-left interval.
#' @param is_open_right Whether to include an open-right interval.
#' @param include_total Whether to append `"Total"`.
#' @param include_missing Whether to append `"Missing"`.
#' @param require_divisible_bounds Whether `lower_first` and `lower_last`
#' must themselves be divisible by 5.
#' @returns Character vector of labels.
#'
#' @noRd

inner_labels_one <- function(lower_first,
                             lower_last,
                             format_single,
                             format_multi,
                             is_open_left,
                             is_open_right,
                             include_total,
                             include_missing) {
  check_n(
    n = lower_first,
    nm_n = "lower_first",
    min = 0L,
    max = NULL,
    divisible_by = 1L
  )
  check_n(
    n = lower_last,
    nm_n = "lower_last",
    min = 1L,
    max = NULL,
    divisible_by = 1L
  )
  check_x_lt_y(
    x = lower_first,
    y = lower_last,
    nm_x = "lower_first",
    nm_y = "lower_last"
  )
  check_flag(x = include_total, nm_x = "include_total")
  check_flag(x = include_missing, nm_x = "include_missing")
  to <- lower_last + if (is_open_right) 0L else 1L
  breaks <- seq.int(
    from = lower_first,
    to = to,
    by = 1L
  )
  construct_labels_breaks(
    breaks = breaks,
    format_single = format_single,
    format_multi = format_multi,
    is_open_left = is_open_left,
    is_open_right = is_open_right,
    include_total = include_total,
    include_missing = include_missing
  )
}
#' Inner Labels Five
#'
#' @param lower_first First lower bound for generated labels.
#' @param lower_last Last lower bound for generated labels.
#' @param format_single Rule for one-year labels: `"lower"` or `"upper"`.
#' @param format_multi Rule for multi-year labels: `"at_upper"` or `"below_upper"`.
#' @param is_open_left Whether to include an open-left interval.
#' @param is_open_right Whether to include an open-right interval.
#' @param include_total Whether to append `"Total"`.
#' @param include_missing Whether to append `"Missing"`.
#' @returns Character vector of labels.
#'
#' @noRd


inner_labels_five <- function(lower_first,
                              lower_last,
                              format_single,
                              format_multi,
                              is_open_left,
                              is_open_right,
                              include_total,
                              include_missing,
                              require_divisible_bounds) {
  check_n(
    n = lower_first,
    nm_n = "lower_first",
    min = 0L,
    max = NULL,
    divisible_by = if (require_divisible_bounds) 5L else NULL
  )
  check_n(
    n = lower_last,
    nm_n = "lower_last",
    min = 5L,
    max = NULL,
    divisible_by = if (require_divisible_bounds) 5L else NULL
  )
  check_x_lt_y(
    x = lower_first,
    y = lower_last,
    nm_x = "lower_first",
    nm_y = "lower_last"
  )
  check_diff_divisible(
    x = lower_first,
    y = lower_last,
    nm_x = "lower_first",
    nm_y = "lower_last",
    divisible_by = 5L
  )
  check_flag(x = include_total, nm_x = "include_total")
  check_flag(x = include_missing, nm_x = "include_missing")
  to <- lower_last + if (is_open_right) 0L else 5L
  breaks <- seq.int(
    from = lower_first,
    to = to,
    by = 5L
  )
  construct_labels_breaks(
    breaks = breaks,
    format_single = format_single,
    format_multi = format_multi,
    is_open_left = is_open_left,
    is_open_right = is_open_right,
    include_total = include_total,
    include_missing = include_missing
  )
}
#' Inner Labels Ten
#'
#' @param lower_first First lower bound for generated labels.
#' @param lower_last Last lower bound for generated labels.
#' @param format_single Rule for one-year labels: `"lower"` or `"upper"`.
#' @param format_multi Rule for multi-year labels: `"at_upper"` or `"below_upper"`.
#' @param is_open_left Whether to include an open-left interval.
#' @param is_open_right Whether to include an open-right interval.
#' @param include_total Whether to append `"Total"`.
#' @param include_missing Whether to append `"Missing"`.
#' @param require_divisible_bounds Whether `lower_first` and `lower_last`
#' must themselves be divisible by 10.
#' @returns Character vector of labels.
#'
#' @noRd

inner_labels_ten <- function(lower_first,
                             lower_last,
                             format_single,
                             format_multi,
                             is_open_left,
                             is_open_right,
                             include_total,
                             include_missing,
                             require_divisible_bounds) {
  check_n(
    n = lower_first,
    nm_n = "lower_first",
    min = 0L,
    max = NULL,
    divisible_by = if (require_divisible_bounds) 10L else NULL
  )
  check_n(
    n = lower_last,
    nm_n = "lower_last",
    min = 10L,
    max = NULL,
    divisible_by = if (require_divisible_bounds) 10L else NULL
  )
  check_x_lt_y(
    x = lower_first,
    y = lower_last,
    nm_x = "lower_first",
    nm_y = "lower_last"
  )
  check_diff_divisible(
    x = lower_first,
    y = lower_last,
    nm_x = "lower_first",
    nm_y = "lower_last",
    divisible_by = 10L
  )
  check_flag(x = include_total, nm_x = "include_total")
  check_flag(x = include_missing, nm_x = "include_missing")
  to <- lower_last + if (is_open_right) 0L else 10L
  breaks <- seq.int(
    from = lower_first,
    to = to,
    by = 10L
  )
  construct_labels_breaks(
    breaks = breaks,
    format_single = format_single,
    format_multi = format_multi,
    is_open_left = is_open_left,
    is_open_right = is_open_right,
    include_total = include_total,
    include_missing = include_missing
  )
}
