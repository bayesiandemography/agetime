#' Pool Labels for Subtotal Detection
#'
#' @param intervals An `agetime_intervals` object.
#' @returns Character vector of unique labels eligible for subtotal logic.
#'
#' @noRd
pool_labels_for_subtotal <- function(intervals) {
  labels_unique <- get_labels_unique(intervals)
  i_xun_to_xunu <- get_i_xun_to_xunu(intervals)
  m <- get_m(intervals)
  is_total <- get_is_total(intervals)
  is_na <- get_is_na(intervals)
  is_unparseable <- is.na(m[, 1L]) & is.na(m[, 2L]) & !is_total & !is_na
  eligible_xunu <- !is_total & !is_na & !is_unparseable
  if (!any(eligible_xunu)) {
    return(character(0))
  }
  xunu_idxs <- which(eligible_xunu)
  pool <- vapply(
    xunu_idxs,
    FUN = function(xunu) {
      i_xu <- which(i_xun_to_xunu == xunu)[[1L]]
      labels_unique[[i_xu]]
    },
    FUN.VALUE = character(1)
  )
  pool[nzchar(pool)]
}

#' Interval Bounds Match
#'
#' @param a,b Numeric bounds, possibly infinite.
#' @returns `TRUE` when bounds match for partition coverage.
#'
#' @noRd
interval_bounds_match <- function(a, b) {
  a <- as.numeric(a)
  b <- as.numeric(b)
  if (is.infinite(a) && is.infinite(b)) {
    return(TRUE)
  }
  if (is.infinite(a) || is.infinite(b)) {
    return(FALSE)
  }
  isTRUE(all.equal(a, b))
}

#' Bound In List
#'
#' @param x Numeric bound, possibly infinite.
#' @param bounds List of numeric bounds.
#' @returns `TRUE` when `x` matches an element of `bounds`.
#'
#' @noRd
bound_in_list <- function(x, bounds) {
  for (b in bounds) {
    if (interval_bounds_match(x, b)) {
      return(TRUE)
    }
  }
  FALSE
}

#' Children Can Rebuild Parent
#'
#' @param parent Numeric vector of length 2.
#' @param children Two-column matrix of candidate child intervals.
#' @returns `TRUE` when two or more children tile `parent`
#' without gaps or overlaps.
#'
#' @noRd
children_can_rebuild_parent <- function(parent, children) {
  n <- nrow(children)
  if (n < 2L) {
    return(FALSE)
  }
  l_parent <- parent[[1L]]
  u_parent <- parent[[2L]]
  bounds <- list(l_parent)
  n_used <- 0L
  i <- 1L
  while (i <= length(bounds)) {
    t <- bounds[[i]]
    used <- n_used[[i]]
    if (interval_bounds_match(t, u_parent) && used >= 2L) {
      return(TRUE)
    }
    for (j in seq_len(n)) {
      if (!interval_bounds_match(children[j, 1L], t)) {
        next
      }
      u_child <- children[j, 2L]
      used_new <- used + 1L
      already <- FALSE
      for (k in seq_along(bounds)) {
        if (interval_bounds_match(u_child, bounds[[k]])) {
          already <- TRUE
          if (used_new < n_used[[k]]) {
            n_used[[k]] <- used_new
          }
          if (interval_bounds_match(u_child, u_parent) && used_new >= 2L) {
            return(TRUE)
          }
          break
        }
      }
      if (!already) {
        bounds <- c(bounds, list(u_child))
        n_used <- c(n_used, used_new)
      }
    }
    i <- i + 1L
  }
  FALSE
}

#' Subtotal Labels from Pool Intervals
#'
#' @param intervals An `agetime_intervals` object built from pool labels only.
#' @returns Character vector of labels that are subtotals within the pool.
#'
#' @noRd
subtotal_labels_from_pool <- function(intervals) {
  labels_unique <- get_labels_unique(intervals)
  m <- get_m(intervals)
  n <- nrow(m)
  if (n < 2L) {
    return(character(0))
  }
  contain <- does_m1_contain_m2(m1 = m, m2 = m)
  equal <- does_m1_equal_m2(m1 = m, m2 = m)
  strict_contain <- contain & !equal
  subtotal <- character(0)
  for (i in seq_len(n)) {
    child_idx <- which(strict_contain[i, ])
    if (length(child_idx) < 2L) {
      next
    }
    if (children_can_rebuild_parent(
      parent = m[i, ],
      children = m[child_idx, , drop = FALSE]
    )) {
      subtotal <- c(subtotal, labels_unique[[i]])
    }
  }
  subtotal
}

#' Inner Is Subtotal
#'
#' @param labels Vector of labels.
#' @param label_type Label domain: `"age"`, `"cohort"`, or `"period"`.
#' @param interpret_single Rule for one-year labels: `"lower"` or `"upper"`.
#' @param interpret_multi Rule for multi-year labels: `"include"`
#' or `"exclude"`.
#' @param interpret_fail How to handle unparsable labels.
#' @returns Logical vector the same length as `labels`.
#'
#' @noRd
inner_is_subtotal <- function(labels,
                              label_type,
                              interpret_single,
                              interpret_multi,
                              interpret_fail) {
  labels <- to_character_or_factor(
    labels = labels,
    nm_labels = "labels",
    length_zero_ok = TRUE
  )
  if (length(labels) == 0L) {
    return(logical(0))
  }
  intervals_all <- intervals(
    labels = labels,
    label_type = label_type,
    interpret_single = interpret_single,
    interpret_multi = interpret_multi,
    interpret_fail = interpret_fail
  )
  labels_chr <- as.character(labels)
  pool_labels <- pool_labels_for_subtotal(intervals = intervals_all)
  if (length(pool_labels) < 2L) {
    return(set_labels_names(rep(FALSE, length(labels_chr)), labels))
  }
  intervals_pool <- intervals(
    labels = pool_labels,
    label_type = label_type,
    interpret_single = interpret_single,
    interpret_multi = interpret_multi,
    interpret_fail = interpret_fail
  )
  subtotal_labels <- subtotal_labels_from_pool(intervals = intervals_pool)
  is_subtotal <- labels_chr %in% subtotal_labels
  set_labels_names(is_subtotal, labels)
}
