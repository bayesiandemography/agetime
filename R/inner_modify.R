#' Resolve Open Left
#'
#' @param is_open_left Whether to include an open-left interval, or `NULL`
#' to infer from `intervals`.
#' @param intervals An `agetime_intervals` object.
#' @returns Single logical flag.
#'
#' @noRd
resolve_open_left <- function(is_open_left, intervals) {
  if (is.null(is_open_left)) {
    return(int_is_open_left(intervals))
  }
  isTRUE(is_open_left)
}

#' Resolve Open Right
#'
#' @param is_open_right Whether to include an open-right interval, or `NULL`
#' to infer from `intervals`.
#' @param intervals An `agetime_intervals` object.
#' @returns Single logical flag.
#'
#' @noRd
resolve_open_right <- function(is_open_right, intervals) {
  if (is.null(is_open_right)) {
    return(int_is_open_right(intervals))
  }
  isTRUE(is_open_right)
}

#' Inner Modify
#'
#' @param labels Vector of labels.
#' @param breaks Increasing vector of break points.
#' @param is_open_left Whether to include an open-left interval, or `NULL`
#' to infer from `labels`.
#' @param is_open_right Whether to include an open-right interval, or `NULL`
#' to infer from `labels`.
#' @param label_type Label domain: `"age"`, `"cohort"`, or `"period"`.
#' @param interpret_single Rule for one-year labels: `"lower"` or `"upper"`.
#' @param interpret_multi Rule for multi-year labels: `"include"`
#' or `"exclude"`.
#' @param interpret_fail How to handle unparsable labels.
#' @returns Modified labels as a factor.
#'
#' @noRd
inner_modify <- function(labels,
                         breaks,
                         is_open_left,
                         is_open_right,
                         label_type,
                         interpret_single,
                         interpret_multi,
                         interpret_fail) {
  is_ordered <- is.factor(labels) && is.ordered(labels)
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
  check_modify_open_flags(
    is_open_left = is_open_left,
    is_open_right = is_open_right,
    intervals = intervals,
    label_type = label_type
  )
  is_open_left <- resolve_open_left(
    is_open_left = is_open_left,
    intervals = intervals
  )
  is_open_right <- resolve_open_right(
    is_open_right = is_open_right,
    intervals = intervals
  )
  int_has_total <- int_has_total(intervals)
  int_has_na <- int_has_na(intervals)
  levels_breaks <- construct_labels_breaks(
    breaks = breaks,
    is_open_left = is_open_left,
    is_open_right = is_open_right,
    format_single = interpret_single,
    format_multi = interpret_multi,
    include_total = int_has_total,
    include_na = int_has_na
  )
  if (length(labels) > 0L) {
    m_contains <- construct_modify_mapping(
      breaks = breaks,
      levels_breaks = levels_breaks,
      is_open_left = is_open_left,
      is_open_right = is_open_right,
      include_total = int_has_total,
      include_na = int_has_na,
      intervals = intervals
    )
    check_m_contains(
      m_contains = m_contains,
      label_type = label_type
    )
    i_new <- apply(m_contains, 2L, which)
    i_x_to_xu <- get_i_x_to_xu(intervals)
    ans <- levels_breaks[i_new][i_x_to_xu]
  } else {
    ans <- character(0)
  }
  factor(
    x = ans,
    levels = levels_breaks,
    ordered = is_ordered,
    exclude = NULL
  )
}

#' Inner Modify Width
#'
#' @param labels Vector of labels.
#' @param width Interval width.
#' @param offset Alignment offset for width-based breaks.
#' @param is_open_left Whether to include an open-left interval, or `NULL`
#' to infer from `labels`.
#' @param is_open_right Whether to include an open-right interval, or `NULL`
#' to infer from `labels`.
#' @param label_type Label domain: `"age"`, `"cohort"`, or `"period"`.
#' @param interpret_single Rule for one-year labels: `"lower"` or `"upper"`.
#' @param interpret_multi Rule for multi-year labels: `"include"`
#' or `"exclude"`.
#' @param interpret_fail How to handle unparsable labels.
#' @returns Modified labels as a factor.
#'
#' Computes aligned breaks from `width` and `offset` using existing interval
#' bounds before calling `inner_modify()`.
#'
#' @noRd
inner_modify_width <- function(labels,
                               width,
                               offset,
                               is_open_left,
                               is_open_right,
                               label_type,
                               interpret_single,
                               interpret_multi,
                               interpret_fail) {
  is_ordered <- is.factor(labels) && is.ordered(labels)
  labels <- to_character_or_factor(
    labels = labels,
    nm_labels = "labels",
    length_zero_ok = TRUE
  )
  if (identical(length(labels), 0L)) {
    if (is.factor(labels) && nlevels(labels) == 0L) {
      return(factor(levels = character(), ordered = is_ordered))
    }
    if (!is.factor(labels)) {
      return(factor())
    }
  }
  check_n(
    n = offset,
    nm_n = "offset",
    min = 0L,
    max = width - 1L,
    divisible_by = 1L
  )
  intervals <- intervals(
    labels = labels,
    label_type = label_type,
    interpret_single = interpret_single,
    interpret_multi = interpret_multi,
    interpret_fail = interpret_fail
  )
  is_open_left_resolved <- resolve_open_left(
    is_open_left = is_open_left,
    intervals = intervals
  )
  is_open_right_resolved <- resolve_open_right(
    is_open_right = is_open_right,
    intervals = intervals
  )
  if (is_open_left_resolved) {
    u <- get_upper(intervals)
    start <- min(u, na.rm = TRUE)
  } else {
    l <- get_lower(intervals)
    start <- min(l[is.finite(l)], na.rm = TRUE)
  }
  remainder_start <- (start - offset) %% width
  if (remainder_start > 0L) {
    if (is_open_left_resolved) {
      start <- start + width - remainder_start
    } else {
      start <- start - remainder_start
    }
  }
  if (is_open_right_resolved) {
    l <- get_lower(intervals)
    end <- max(l[is.finite(l)], na.rm = TRUE)
  } else {
    u <- get_upper(intervals)
    end <- max(u[is.finite(u)], na.rm = TRUE)
  }
  remainder_end <- (end - offset) %% width
  if (remainder_end > 0L) {
    if (is_open_right_resolved) {
      end <- end - remainder_end
    } else {
      end <- end + width - remainder_end
    }
  }
  breaks <- seq.int(from = start, to = end, by = width)
  inner_modify(
    labels = labels,
    breaks = breaks,
    is_open_left = is_open_left,
    is_open_right = is_open_right,
    label_type = label_type,
    interpret_single = interpret_single,
    interpret_multi = interpret_multi,
    interpret_fail = interpret_fail
  )
}
