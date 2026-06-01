#' Inner Levels Sort
#'
#' @param x Vector of labels.
#' @param decreasing Whether to sort in decreasing order.
#' @param label_type Label domain: `"age"`, `"cohort"`, or `"period"`.
#' @param x_one Rule for one-year labels: `"lower"` or `"upper"`.
#' @param x_multi Rule for multi-year labels: `"include"` or `"exclude"`.
#' @param x_fail How to handle unparsable labels.
#' @returns Factor with sorted levels.
#'
#' @noRd

inner_levels_sort <- function(x,
                              decreasing,
                              label_type,
                              x_one,
                              x_multi,
                              x_fail) {
  prep <- inner_levels_fill_prep(x = x,
                                 breaks = NULL,
                                 nm_x = "x")
  empty <- inner_levels_fill_empty(levels = prep$levels,
                                   breaks = NULL,
                                   is_ordered = prep$is_ordered,
                                   x_one = x_one,
                                   x_multi = x_multi)
  if (!is.null(empty))
    return(empty)
  x <- prep$x
  check_flag(x = decreasing, nm_x = "decreasing")
  intervals <- intervals(labels = x,
                         label_type = label_type,
                         x_one = x_one,
                         x_multi = x_multi,
                         x_fail = x_fail)
  lower <- get_lower(intervals)
  upper <- get_upper(intervals)
  is_total <- get_is_total(intervals)
  labels_unique <- get_labels_unique(intervals)
  i_xun_to_xunu <- get_i_xun_to_xunu(intervals)
  i_xun <- seq_along(i_xun_to_xunu)
  ord_norm <- order(lower,
                    upper,
                    is_total)
  ord_norm <- ord_norm[i_xun_to_xunu]
  i_rank <- match(i_xun, ord_norm)
  ord_unique <- order(i_rank,
                      i_xun,
                      decreasing = decreasing)
  levels_new <- labels_unique[ord_unique]
  inner_levels_fill_factor(x = x,
                           levels = levels_new,
                           is_ordered = prep$is_ordered)
}
