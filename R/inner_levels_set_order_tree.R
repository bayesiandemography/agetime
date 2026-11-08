#' Inner Levels Set Order Tree
#'
#' Order levels of labels that form a reporting tree: leaves,
#' then internal nodes (children before parents), then
#' unparsed labels, then missing labels.
#'
#' @param labels Vector of labels.
#' @param label_type Label domain: `"age"`, `"cohort"`, or `"period"`.
#' @param interpret_single Rule for one-year labels: `"lower"` or `"upper"`.
#' @param interpret_multi Rule for multi-year labels: `"at_upper"`
#' or `"below_upper"`.
#' @param interpret_fail How to handle unparsable labels.
#' @returns Factor with levels in tree order.
#'
#' @noRd
inner_levels_set_order_tree <- function(labels,
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
  intervals <- intervals(
    labels = labels,
    label_type = label_type,
    interpret_single = interpret_single,
    interpret_multi = interpret_multi,
    interpret_fail = interpret_fail
  )
  m <- get_m(intervals)
  is_missing <- get_is_missing(intervals)
  is_total <- get_is_total(intervals)
  labels_unique <- get_labels_unique(intervals)
  i_xun_to_xunu <- get_i_xun_to_xunu(intervals)
  label_for_row <- function(i) labels_unique[match(i, i_xun_to_xunu)]
  noun <- tree_noun(label_type)
  if (any(is_total)) {
    labels_total <- labels_unique[is_total[i_xun_to_xunu]]
    hint_recode <- sprintf("%s[%s_is_total(%s)] <- \"Missing\"",
                           label_type, label_type, label_type)
    cli::cli_abort(c(
      "{noun} include a total, so do not form a reporting tree.",
      i = "Total{?s}: {.val {labels_total}}.",
      i = paste("If a total means {label_type} not stated,",
                "recode it to {.val Missing} first,",
                "e.g. {.code {hint_recode}}."),
      i = "If a total is a sum over other {tolower(noun)}, remove it."
    ), call = user_frame())
  }
  is_failed <- !is_missing & (is.na(m[, 1L]) | is.na(m[, 2L]))
  is_valid <- !is_missing & !is_failed
  i_valid <- which(is_valid)
  m_valid <- m[is_valid, , drop = FALSE]
  pairs <- tree_find_partial_overlaps(m_valid)
  n_pairs <- nrow(pairs)
  if (n_pairs > 0L) {
    n_show <- min(n_pairs, 3L)
    msg_pairs <- vapply(seq_len(n_show), function(k) {
      lab1 <- label_for_row(i_valid[[pairs[k, 1L]]])
      lab2 <- label_for_row(i_valid[[pairs[k, 2L]]])
      sprintf("'%s' and '%s' overlap, but neither contains the other.",
              lab1, lab2)
    }, "")
    names(msg_pairs) <- rep("i", n_show)
    msg <- c("{noun} do not form a tree.", msg_pairs)
    n_more <- n_pairs - n_show
    if (n_more > 0L) {
      msg <- c(msg, i = "...and {n_more} more pair{?s}.")
    }
    cli::cli_abort(msg, call = user_frame())
  }
  ord_valid <- i_valid[tree_order(m_valid)]
  ord_norm <- c(ord_valid, which(is_failed), which(is_missing))
  rank_norm <- match(seq_along(is_missing), ord_norm)
  i_rank <- rank_norm[i_xun_to_xunu]
  i_xun <- seq_along(i_xun_to_xunu)
  ord_unique <- order(i_rank, i_xun)
  levels_new <- labels_unique[ord_unique]
  inner_levels_fill_factor(
    labels = labels,
    levels = levels_new,
    is_ordered = prep$is_ordered
  )
}


#' Noun Describing Labels, for Messages About Trees
#'
#' @param label_type `"age"`, `"cohort"`, or `"period"`.
#' @returns A string.
#'
#' @noRd
tree_noun <- function(label_type) {
  switch(label_type,
    age = "Age groups",
    period = "Periods",
    cohort = "Cohorts"
  )
}
