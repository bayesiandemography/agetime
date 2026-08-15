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

#' Coarsen Minimal Levels
#'
#' @param levels_breaks Labels constructed from new breaks.
#' @param breaks Increasing vector of break points.
#' @param i_new Index of new label for each unique input label.
#' @param is_open_left Whether to include an open-left interval.
#' @param is_open_right Whether to include an open-right interval.
#' @param is_ordered Whether output factor should be ordered.
#' @returns Character vector of output factor levels.
#'
#' @noRd
coarsen_minimal_levels <- function(levels_breaks,
                                  breaks,
                                  i_new,
                                  is_open_left,
                                  is_open_right,
                                  is_ordered) {
  levels_recoded <- levels_breaks[i_new]
  n_core <- length(breaks) - 1L +
    as.integer(is_open_left) +
    as.integer(is_open_right)
  core_labels <- levels_breaks[seq_len(n_core)]
  extra <- character(0)
  if (is_open_left) {
    extra <- c(extra, core_labels[[1L]])
  }
  if (is_open_right) {
    extra <- c(extra, core_labels[[length(core_labels)]])
  }
  levels_all <- unique(c(levels_recoded, extra))
  if (is_ordered) {
    levels_output <- levels_recoded[!duplicated(levels_recoded)]
    for (label in extra) {
      if (!label %in% levels_output) {
        levels_output <- c(levels_output, label)
      }
    }
    return(levels_output)
  }
  levels_breaks[levels_breaks %in% levels_all]
}

#' Inner Coarsen
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
#' @param minimal_levels Whether to omit break levels with no mapped input.
#' @param preserve_input_type Whether to return character for non-factor input.
#' @returns Coarsened labels as a factor or character vector.
#'
#' @noRd
inner_coarsen <- function(labels,
                         breaks,
                         is_open_left,
                         is_open_right,
                         label_type,
                         interpret_single,
                         interpret_multi,
                         interpret_fail,
                         minimal_levels,
                         preserve_input_type) {
  is_factor <- is.factor(labels)
  is_ordered <- is_factor && is.ordered(labels)
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
  check_coarsen_open_flags(
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
  i_new <- integer(0)
  if (length(get_labels_unique(intervals)) > 0L) {
    m_contains <- construct_coarsen_mapping(
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
  }
  if (length(labels) > 0L) {
    i_x_to_xu <- get_i_x_to_xu(intervals)
    ans <- levels_breaks[i_new][i_x_to_xu]
  } else {
    ans <- character(0)
  }
  if (minimal_levels) {
    levels_output <- coarsen_minimal_levels(
      levels_breaks = levels_breaks,
      breaks = breaks,
      i_new = i_new,
      is_open_left = is_open_left,
      is_open_right = is_open_right,
      is_ordered = is_ordered
    )
  } else {
    levels_output <- levels_breaks
  }
  if (preserve_input_type && !is_factor) {
    return(ans)
  }
  factor(
    x = ans,
    levels = levels_output,
    ordered = is_ordered,
    exclude = NULL
  )
}

#' Inner Coarsen Width
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
#' @returns Coarsened labels as a factor or character vector.
#'
#' Computes aligned breaks from `width` and `offset` using existing interval
#' bounds before calling `inner_coarsen()`.
#'
#' @noRd
inner_coarsen_width <- function(labels,
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
      return(character(0))
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
  inner_coarsen(
    labels = labels,
    breaks = breaks,
    is_open_left = is_open_left,
    is_open_right = is_open_right,
    label_type = label_type,
    interpret_single = interpret_single,
    interpret_multi = interpret_multi,
    interpret_fail = interpret_fail,
    minimal_levels = TRUE,
    preserve_input_type = TRUE
  )
}

#' Inner Coarsen To
#'
#' @param labels Vector of labels to recode.
#' @param to Vector of labels giving the target classification.
#' @param label_type Label domain: `"age"`, `"cohort"`, or `"period"`.
#' @param interpret_single Rule for one-year labels: `"lower"` or `"upper"`.
#' @param interpret_multi Rule for multi-year labels: `"include"`
#' or `"exclude"`.
#' @param interpret_fail How to handle unparsable labels.
#' @returns Recoded labels as a factor.
#'
#' @noRd
inner_coarsen_to <- function(labels,
                             to,
                             label_type,
                             interpret_single,
                             interpret_multi,
                             interpret_fail) {
  is_factor <- is.factor(labels)
  is_ordered <- is_factor && is.ordered(labels)
  labels <- to_character_or_factor(
    labels = labels,
    nm_labels = "labels",
    length_zero_ok = TRUE
  )
  to <- to_character_or_factor(
    labels = to,
    nm_labels = "to",
    length_zero_ok = TRUE
  )
  if (mapping_has_no_labels(to)) {
    if (mapping_has_no_labels(labels)) {
      return(factor(levels = character(), ordered = is_ordered))
    }
    cli::cli_abort(c(
      "{.arg to} has no labels.",
      i = "Supply at least one label to coarsen to?"
    ))
  }
  intervals_to <- intervals(
    labels = to,
    label_type = label_type,
    interpret_single = interpret_single,
    interpret_multi = interpret_multi,
    interpret_fail = interpret_fail
  )
  check_coarsen_to_no_overlap(
    intervals_to = intervals_to,
    label_type = label_type
  )
  levels_output <- get_labels_unique(intervals_to)
  if (mapping_has_no_labels(labels)) {
    return(factor(
      character(0),
      levels = levels_output,
      ordered = is_ordered,
      exclude = NULL
    ))
  }
  intervals_labels <- intervals(
    labels = labels,
    label_type = label_type,
    interpret_single = interpret_single,
    interpret_multi = interpret_multi,
    interpret_fail = interpret_fail
  )
  m_contains <- construct_coarsen_to_mapping(
    intervals_labels = intervals_labels,
    intervals_to = intervals_to
  )
  check_m_contains(
    m_contains = m_contains,
    label_type = label_type
  )
  i_new <- apply(m_contains, 2L, which)
  if (length(labels) > 0L) {
    ans <- levels_output[i_new][get_i_x_to_xu(intervals_labels)]
  } else {
    ans <- character(0)
  }
  factor(
    x = ans,
    levels = levels_output,
    ordered = is_ordered,
    exclude = NULL
  )
}
