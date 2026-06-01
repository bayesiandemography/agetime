# mapping-construct.R
# Build label-to-label mapping matrices and modify containment maps.
# Used by inner_mapping.R and inner_modify.R.

make_m_contains <- function(breaks,
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
  if (is_open_left)
    m_br <- rbind(c(-Inf, breaks[[1L]]),
                  m_br)
  if (is_open_right)
    m_br <- rbind(m_br,
                  c(breaks[[n]], Inf))
  if (include_total) {
    m_br <- rbind(m_br,
                  c(NA_real_, NA_real_))
    i_total <- nrow(m_br)
  }
  if (include_na) {
    m_br <- rbind(m_br,
                  c(NA_real_, NA_real_))
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

#' Make a Mapping Between Two Sets of Labels
#'
#' @param intervals_x,intervals_y Objects of class "agetime_intervals"
#' constructed from two label vectors.
#' @param relation `"equals"`,
#' `"contains"`, `"is-contained-in"`, or `"overlaps-with"`.
#' @param format Type of return value.
#' @returns Tibble or matrix
#'
#' @noRd
make_mapping <- function(intervals_x,
                         intervals_y,
                         relation,
                         format) {
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
  }
  else if (relation == "contains") {
    mxy <- does_m1_contain_m2(m1 = mx, m2 = my)
    mxy[is_total_x, ] <- TRUE
    mxy[!is_na_x & !is_total_x, is_total_y] <- FALSE
  }
  else if (relation == "is-contained-in") {
    mxy <- is_m1_inside_m2(m1 = mx, m2 = my)
    mxy[is_total_x, !is_na_y] <- FALSE
    mxy[, is_total_y] <- TRUE
  }
  else if (relation == "overlaps-with") {
    mxy <- does_m1_overlap_m2(m1 = mx, m2 = my)
    mxy[is_total_x, ] <- TRUE
    mxy[, is_total_y] <- TRUE
  }
  else
    cli::cli_abort("Internal error: {.val {relation}} is not a valid value for {.arg relation}.")
  mxy <- mxy[i_xun_to_xunu_x, ]
  mxy <- mxy[, i_xun_to_xunu_y]
  dimnames(mxy) <- list(x = labels_x, y = labels_y)
  if (format == "tibble") {
    ans <- as.data.frame.table(mxy, stringsAsFactors = FALSE)
    ans <- ans[ans[[3L]], 1:2]
    ans <- tibble::tibble(ans)
  }
  else
    ans <- 1L * mxy
  ans
}
