#' Inner Levels Sort
#'
#' @param labels Vector of labels.
#' @param decreasing Whether to sort in decreasing order.
#' @param label_type Label domain: `"age"`, `"cohort"`, or `"period"`.
#' @param interpret_single Rule for one-year labels: `"lower"` or `"upper"`.
#' @param interpret_multi Rule for multi-year labels: `"include"`
#' or `"exclude"`.
#' @param interpret_fail How to handle unparsable labels.
#' @returns Factor with sorted levels.
#'
#' @noRd

inner_levels_sort <- function(labels,
                              decreasing,
                              label_type,
                              interpret_single,
                              interpret_multi,
                              interpret_fail) {
  prep <- inner_levels_fill_prep(
    labels = labels,
    breaks = NULL,
    nm_labels = "labels"
  )
  empty <- inner_levels_fill_empty(
    levels = prep$levels,
    breaks = NULL,
    is_ordered = prep$is_ordered,
    format_single = interpret_single,
    format_multi = interpret_multi
  )
  if (!is.null(empty)) {
    return(empty)
  }
  labels <- prep$labels
  check_flag(x = decreasing, nm_x = "decreasing")
  intervals <- intervals(
    labels = labels,
    label_type = label_type,
    interpret_single = interpret_single,
    interpret_multi = interpret_multi,
    interpret_fail = interpret_fail
  )
  lower <- get_lower(intervals)
  upper <- get_upper(intervals)
  is_total <- get_is_total(intervals)
  labels_unique <- get_labels_unique(intervals)
  i_xun_to_xunu <- get_i_xun_to_xunu(intervals)
  i_xun <- seq_along(i_xun_to_xunu)
  ord_norm <- order(
    lower,
    upper,
    is_total
  )
  rank_norm <- match(seq_along(ord_norm), ord_norm)
  i_rank <- rank_norm[i_xun_to_xunu]
  ord_unique <- order(i_rank,
    i_xun,
    decreasing = decreasing
  )
  levels_new <- labels_unique[ord_unique]
  inner_levels_fill_factor(
    labels = labels,
    levels = levels_new,
    is_ordered = prep$is_ordered
  )
}
