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

#' Finest Child Indices
#'
#' @param child_idx Integer indices into interval rows.
#' @param strict_contain Strict containment matrix (parents contain children).
#' @returns Subset of `child_idx` that are not strict parents of another child.
#'
#' @noRd
finest_child_indices <- function(child_idx, strict_contain) {
  if (length(child_idx) == 0L) {
    return(integer(0))
  }
  is_finest <- rep(TRUE, length(child_idx))
  for (ic in seq_along(child_idx)) {
    c_idx <- child_idx[[ic]]
    for (id in seq_along(child_idx)) {
      d_idx <- child_idx[[id]]
      if (d_idx != c_idx && isTRUE(strict_contain[d_idx, c_idx])) {
        is_finest[[ic]] <- FALSE
        break
      }
    }
  }
  child_idx[is_finest]
}

#' Interval Bounds Match
#'
#' @param a,b Numeric bounds, possibly infinite.
#' @returns `TRUE` when bounds match for partition coverage.
#'
#' @noRd
interval_bounds_match <- function(a, b) {
  if (is.infinite(a) && is.infinite(b)) {
    return(TRUE)
  }
  if (is.infinite(a) || is.infinite(b)) {
    return(FALSE)
  }
  isTRUE(all.equal(a, b))
}

#' Intervals Partition Cover Parent
#'
#' @param parent Numeric vector of length 2.
#' @param children Two-column matrix of child intervals.
#' @returns `TRUE` when children partition `parent` without gaps or overlaps.
#'
#' @noRd
intervals_partition_covers <- function(parent, children) {
  if (nrow(children) == 0L) {
    return(FALSE)
  }
  m_overlap <- does_m1_overlap_m2(m1 = children, m2 = children)
  diag(m_overlap) <- FALSE
  if (any(m_overlap, na.rm = TRUE)) {
    return(FALSE)
  }
  ord <- order(children[, 1L], children[, 2L])
  m <- children[ord, , drop = FALSE]
  lower <- m[, 1L]
  upper <- m[, 2L]
  l_parent <- parent[[1L]]
  u_parent <- parent[[2L]]
  if (!interval_bounds_match(lower[[1L]], l_parent)) {
    return(FALSE)
  }
  if (!interval_bounds_match(upper[[length(upper)]], u_parent)) {
    return(FALSE)
  }
  n <- length(upper)
  if (n > 1L) {
    uppermax <- cummax(upper)
    is_gap <- !is.na(lower[-1L]) & (lower[-1L] > uppermax[-n])
    if (any(is_gap)) {
      return(FALSE)
    }
  }
  TRUE
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
    if (length(child_idx) == 0L) {
      next
    }
    finest_idx <- finest_child_indices(
      child_idx = child_idx,
      strict_contain = strict_contain
    )
    if (length(finest_idx) == 0L) {
      next
    }
    if (intervals_partition_covers(
      parent = m[i, ],
      children = m[finest_idx, , drop = FALSE]
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
