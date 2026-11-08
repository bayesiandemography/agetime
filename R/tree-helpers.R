# tree-helpers.R
# Helpers for reporting trees: sets of labels that nest, so that any
# two intervals either do not overlap or one contains the other.
# All helpers take a two-column matrix 'm' of [lower, upper) bounds
# with no NA rows (missing, total, and unparsed labels removed).
# Used by inner_levels_set_order_tree(), and later by the 'valid_tree'
# diagnostic, *_labels_tree(), and the tree constructor.


## HAS_TESTS
#' Find Pairs of Intervals that Overlap Without Nesting
#'
#' A pair overlaps without nesting if the two intervals share
#' some values, but neither interval contains the other.
#' Intervals that are equal (synonyms) nest.
#'
#' @param m Matrix with 2 columns, giving lower and upper limits.
#' @returns Integer matrix with 2 columns, one row per pair,
#' with the smaller row index first, ordered by
#' first and then second index.
#'
#' @noRd
tree_find_partial_overlaps <- function(m) {
  n <- nrow(m)
  if (n < 2L) {
    return(matrix(integer(), nrow = 0L, ncol = 2L))
  }
  overlap <- does_m1_overlap_m2(m1 = m, m2 = m)
  inside <- is_m1_inside_m2(m1 = m, m2 = m)
  partial <- overlap & !inside & !t(inside)
  partial[lower.tri(partial, diag = TRUE)] <- FALSE
  ans <- which(partial, arr.ind = TRUE)
  ans <- ans[order(ans[, 1L], ans[, 2L]), , drop = FALSE]
  dimnames(ans) <- NULL
  ans
}


## HAS_TESTS
#' Identify Leaves of a Tree
#'
#' An interval is a leaf if no other interval lies strictly
#' inside it. Intervals equal to it (synonyms) do not count.
#' Assumes that the intervals nest.
#'
#' @param m Matrix with 2 columns, giving lower and upper limits.
#' @returns Logical vector with length `nrow(m)`.
#'
#' @noRd
tree_is_leaf <- function(m) {
  n <- nrow(m)
  if (identical(n, 0L)) {
    return(logical())
  }
  inside <- is_m1_inside_m2(m1 = m, m2 = m)
  strictly_inside <- inside & !t(inside)
  !apply(strictly_inside, 2L, any)
}


## HAS_TESTS
#' Order Intervals in Tree Order
#'
#' Leaves come first, ordered by lower limit (then upper limit).
#' Internal nodes come next, ordered depth-first, with children
#' before parents: by upper limit ascending, then lower limit
#' descending. For intervals that nest, this puts every node
#' after all nodes inside it, and puts a node before any
#' node entirely above it. Ties (synonyms) keep their original
#' order. Assumes that the intervals nest.
#'
#' @param m Matrix with 2 columns, giving lower and upper limits.
#' @returns Integer vector, a permutation of `seq_len(nrow(m))`.
#'
#' @noRd
tree_order <- function(m) {
  n <- nrow(m)
  if (identical(n, 0L)) {
    return(integer())
  }
  lower <- m[, 1L]
  upper <- m[, 2L]
  is_leaf <- tree_is_leaf(m)
  i <- seq_len(n)
  i_leaf <- i[is_leaf]
  i_internal <- i[!is_leaf]
  ord_leaf <- i_leaf[order(lower[i_leaf], upper[i_leaf], i_leaf)]
  ord_internal <- i_internal[order(upper[i_internal], -lower[i_internal], i_internal)]
  c(ord_leaf, ord_internal)
}


## HAS_TESTS
#' Describe the First Way in Which Intervals Fail to Form a Tree
#'
#' Checks, in order: (1) intervals nest, (2) leaves reach the
#' lowest lower limit, (3) there are no gaps between leaves,
#' (4) leaves reach the highest upper limit.
#'
#' @param m Matrix with 2 columns, giving lower and upper limits,
#' with no NA rows.
#' @param label_keep Function returning the label for row `k` of `m`.
#' @param noun Plural noun for messages, eg "age groups".
#'
#' @returns `NA_character_` if the intervals form a tree,
#' otherwise a string starting "Example: ".
#'
#' @noRd
tree_diagnose_comment <- function(m, label_keep, noun) {
  if (identical(nrow(m), 0L)) {
    return(NA_character_)
  }
  pairs <- tree_find_partial_overlaps(m)
  if (nrow(pairs) > 0L) {
    return(sprintf(
      "Example: '%s' and '%s' overlap, but neither contains the other",
      label_keep(pairs[1L, 1L]), label_keep(pairs[1L, 2L])
    ))
  }
  lower <- m[, 1L]
  upper <- m[, 2L]
  i_leaf <- which(tree_is_leaf(m))
  i_leaf <- i_leaf[!duplicated(m[i_leaf, , drop = FALSE])]
  i_leaf <- i_leaf[order(lower[i_leaf])]
  n_leaf <- length(i_leaf)
  span_lower <- min(lower)
  span_upper <- max(upper)
  ## narrowest interval containing [a, b)
  find_container <- function(a, b) {
    is_cont <- lower <= a & upper >= b
    i <- which(is_cont)
    i[order(upper[i] - lower[i], -lower[i])][[1L]]
  }
  if (lower[[i_leaf[[1L]]]] > span_lower) {
    i_node <- find_container(span_lower, lower[[i_leaf[[1L]]]])
    return(sprintf(
      "Example: most detailed %s do not reach lower limit of '%s'",
      noun, label_keep(i_node)
    ))
  }
  if (n_leaf > 1L) {
    upper_leaf <- upper[i_leaf[-n_leaf]]
    lower_next <- lower[i_leaf[-1L]]
    is_gap <- upper_leaf < lower_next
    if (any(is_gap)) {
      k <- match(TRUE, is_gap)
      return(sprintf(
        "Example: gap among most detailed %s between '%s' and '%s'",
        noun, label_keep(i_leaf[[k]]), label_keep(i_leaf[[k + 1L]])
      ))
    }
  }
  if (upper[[i_leaf[[n_leaf]]]] < span_upper) {
    i_node <- find_container(upper[[i_leaf[[n_leaf]]]], span_upper)
    return(sprintf(
      "Example: most detailed %s do not reach upper limit of '%s'",
      noun, label_keep(i_node)
    ))
  }
  NA_character_
}
