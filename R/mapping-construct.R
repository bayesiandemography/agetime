# mapping-construct.R
# Build label-to-label mapping matrices and coarsen containment maps.
# Used by inner_mapping.R and inner_coarsen.R.
#' Construct Coarsen Mapping
#'
#' @param breaks Increasing vector of break points.
#' @param levels_breaks Labels constructed from new breaks.
#' @param is_open_left Whether to include an open-left interval.
#' @param is_open_right Whether to include an open-right interval.
#' @param include_total Whether to append `"Total"`.
#' @param include_na Whether to append `NA`.
#' @param intervals An `agetime_intervals` object.
#' @returns Logical matrix mapping new labels to original labels.
#'
#' @noRd

construct_coarsen_mapping <- function(breaks,
                                     levels_breaks,
                                     is_open_left,
                                     is_open_right,
                                     include_total,
                                     include_na,
                                     intervals) {
  m_int <- get_m(intervals)
  labels_unique <- get_labels_unique(intervals)
  i_xun_to_xunu <- get_i_xun_to_xunu(intervals)
  is_total <- get_is_total(intervals)
  is_na <- get_is_na(intervals)
  n <- length(breaks)
  m_br <- cbind(breaks[-n], breaks[-1])
  if (is_open_left) {
    m_br <- rbind(
      c(-Inf, breaks[[1L]]),
      m_br
    )
  }
  if (is_open_right) {
    m_br <- rbind(
      m_br,
      c(breaks[[n]], Inf)
    )
  }
  if (include_total) {
    m_br <- rbind(
      m_br,
      c(NA_real_, NA_real_)
    )
    i_total <- nrow(m_br)
  }
  if (include_na) {
    m_br <- rbind(
      m_br,
      c(NA_real_, NA_real_)
    )
    i_na <- nrow(m_br)
  }
  ans <- does_m1_contain_m2(m1 = m_br, m2 = m_int)
  if (include_total) {
    ans[, is_total] <- FALSE
    ans[i_total, ] <- is_total
  }
  if (include_na) {
    ans[, is_na] <- FALSE
    ans[i_na, ] <- is_na
  }
  rownames(ans) <- levels_breaks
  ans <- ans[, i_xun_to_xunu, drop = FALSE]
  colnames(ans) <- labels_unique
  ans
}

#' Construct Coarsen-To Mapping
#'
#' @param intervals_labels Intervals parsed from `labels`.
#' @param intervals_to Intervals parsed from `to`.
#' @returns Logical matrix mapping unique `to` labels (rows)
#' to unique `labels` (columns).
#'
#' @noRd
construct_coarsen_to_mapping <- function(intervals_labels, intervals_to) {
  m_labels <- get_m(intervals_labels)
  m_to <- get_m(intervals_to)
  is_total_labels <- get_is_total(intervals_labels)
  is_total_to <- get_is_total(intervals_to)
  is_na_labels <- get_is_na(intervals_labels)
  is_na_to <- get_is_na(intervals_to)
  ans <- does_m1_contain_m2(m1 = m_to, m2 = m_labels)
  ans[is_total_to, ] <- FALSE
  ans[, is_total_labels] <- FALSE
  if (any(is_total_to) && any(is_total_labels)) {
    ans[is_total_to, is_total_labels] <- TRUE
  }
  ans[is_na_to, ] <- FALSE
  ans[, is_na_labels] <- FALSE
  if (any(is_na_to) && any(is_na_labels)) {
    ans[is_na_to, is_na_labels] <- TRUE
  }
  ans[is.na(ans)] <- FALSE
  i_xun_to_xunu_labels <- get_i_xun_to_xunu(intervals_labels)
  i_xun_to_xunu_to <- get_i_xun_to_xunu(intervals_to)
  ans <- ans[i_xun_to_xunu_to, i_xun_to_xunu_labels, drop = FALSE]
  rownames(ans) <- get_labels_unique(intervals_to)
  colnames(ans) <- get_labels_unique(intervals_labels)
  ans
}

#' Construct a Mapping Between Two Sets of Labels
#'
#' @param intervals_x,intervals_y Objects of class "agetime_intervals"
#' constructed from two label vectors.
#' @param relation `"equals"`,
#' `"contains"`, `"is-contained-in"`, or `"overlaps-with"`.
#' @param format Type of return value.
#' @param name_x Name for the `labels_x` side of the mapping.
#' @param name_y Name for the `labels_y` side of the mapping.
#' @returns Tibble or matrix
#'
#' @noRd
construct_mapping <- function(intervals_x,
                              intervals_y,
                              relation,
                              format,
                              name_x,
                              name_y) {
  labels_x <- get_labels_unique(intervals_x)
  labels_y <- get_labels_unique(intervals_y)
  is_na_x <- get_is_na(intervals_x)
  is_na_y <- get_is_na(intervals_y)
  is_total_x <- get_is_total(intervals_x)
  is_total_y <- get_is_total(intervals_y)
  i_xun_to_xunu_x <- get_i_xun_to_xunu(intervals_x)
  i_xun_to_xunu_y <- get_i_xun_to_xunu(intervals_y)
  mx <- get_m(intervals_x)
  my <- get_m(intervals_y)
  if (relation == "equals") {
    mxy <- does_m1_equal_m2(m1 = mx, m2 = my)
    mxy[is_total_x, is_total_y] <- TRUE
    mxy[is_total_x, !is_na_y & !is_total_y] <- FALSE
    mxy[!is_na_x & !is_total_x, is_total_y] <- FALSE
  } else if (relation == "contains") {
    mxy <- does_m1_contain_m2(m1 = mx, m2 = my)
    mxy[is_total_x, ] <- TRUE
    mxy[!is_na_x & !is_total_x, is_total_y] <- FALSE
  } else if (relation == "is-contained-in") {
    mxy <- is_m1_inside_m2(m1 = mx, m2 = my)
    mxy[is_total_x, !is_na_y] <- FALSE
    mxy[, is_total_y] <- TRUE
  } else if (relation == "overlaps-with") {
    mxy <- does_m1_overlap_m2(m1 = mx, m2 = my)
    mxy[is_total_x, ] <- TRUE
    mxy[, is_total_y] <- TRUE
  } else {
    cli::cli_abort(paste0(
      "Internal error: {.val {relation}} is not a valid value for ",
      "{.arg relation}."
    ))
  }
  mxy <- mxy[i_xun_to_xunu_x, , drop = FALSE]
  mxy <- mxy[, i_xun_to_xunu_y, drop = FALSE]
  dn <- list(labels_x, labels_y)
  names(dn) <- c(name_x, name_y)
  dimnames(mxy) <- dn
  if (format == "tibble") {
    ans <- as.data.frame.table(mxy, stringsAsFactors = FALSE)
    ans <- ans[ans[[3L]], 1:2]
    names(ans) <- c(name_x, name_y)
    ans <- tibble::tibble(ans)
  } else {
    ans <- 1L * mxy
  }
  ans
}
