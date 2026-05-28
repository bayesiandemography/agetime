
make_is_open <- function(intervals) {
  m <- get_m(intervals)
  i <- get_i_x_to_xunu(intervals)
  l <- m[, 1L]
  u <- m[, 2L]
  o <- is.infinite(l) | is.infinite(u)
  o[i]
}



make_labels_intervals <- function(intervals,
                                  x_one,
                                  x_multi) {
  is_one <- get_is_one(intervals)
  is_range <- get_is_range(intervals)
  is_open_left <- get_is_open_left(intervals)
  is_open_right <- get_is_open_right(intervals)
  is_total <- get_is_total(intervals)
  is_na <- get_is_na(intervals)
  m <- get_m(intervals)
  l <- m[, 1L]
  u <- m[, 2L]
  is_unparseable <- is.na(l) & is.na(u) & !is_na & !is_total
  is_valid <- (is_one | is_range
    | is_open_left | is_open_right
    | is_total | is_na | is_unparseable)
  if (any(!is_valid))
    cli::cli_abort("Internal error: Invalid interval.")
  ans <- character(length = length(l))
  if (x_one == "lower")
    ans[is_one] <- as.character(l[is_one])
  else if (x_one == "upper")
    ans[is_one] <- as.character(u[is_one])
  else
    cli::cli_abort("Internal error: 'x_one' invalid.")
  if (x_multi == "include")
    ans[is_range] <- paste(l[is_range], u[is_range], sep = "-")
  else if (x_multi == "exclude")
    ans[is_range] <- paste(l[is_range], u[is_range] - 1, sep = "-")
  else
    cli::cli_abort("Internal error: 'x_multi' invalid.")
  ans[is_open_left] <- paste0("<", u[is_open_left])
  ans[is_open_right] <- paste0(l[is_open_right], "+")
  ans[is_total] <- "Total"
  ans[is_na] <- NA_character_
  ans[is_unparseable] <- NA_character_
  ans
}
                        

make_levels_from_breaks <- function(breaks,
                                    is_open_left,
                                    is_open_right,
                                    x_one,
                                    x_multi,
                                    include_total,
                                    include_na) {
  lower <- breaks[-length(breaks)]
  upper <- breaks[-1L]
  if (is_open_left) {
    lower <- c(-Inf, lower)
    upper <- c(lower[[2L]], upper)
  }
  if (is_open_right) {
    lower <- c(lower, upper[length(upper)])
    upper <- c(upper, Inf)
  }
  width <- upper - lower
  is_open_left <- is.infinite(lower)
  is_open_right <- is.infinite(upper)
  is_one <- width == 1L
  is_multi <- !(is_open_left | is_open_right | is_one)
  ans <- character(length = length(lower))
  ans[is_open_left] <- paste0("<", upper[is_open_left])
  ans[is_open_right] <- paste0(lower[is_open_right], "+")
  if (x_one == "lower")
    ans[is_one] <- lower[is_one]
  else
    ans[is_one] <- upper[is_one]
  if (x_multi == "exclude")
    ans[is_multi] <- paste(lower[is_multi],
                           upper[is_multi] - 1L,
                           sep = "-")
  else
    ans[is_multi] <- paste(lower[is_multi],
                           upper[is_multi],
                           sep = "-")
  if (include_total)
    ans <- c(ans, "Total")
  if (include_na)
    ans <- c(ans, NA)
  ans
}



make_lower_first <- function(lower_first,
                             intervals,
                             is_open_left,
                             min,
                             divisible_by) {
  user_supplied_value <- !is.null(lower_first)
  if (user_supplied_value) {
    check_n(n = lower_first,
                      nm_n = "lower_first",
                      min = min,
                      max = NULL,
                      divisible_by = divisible_by)
    lower_first <- as.integer(lower_first)
  }
  m <- get_m(intervals)
  labels_unique <- get_labels_unique(intervals)
  i_xun_to_xunu <- get_i_xun_to_xunu(intervals)
  l <- m[, 1L]
  u <- m[, 2L]
  is_na <- is.na(l)
  if (user_supplied_value) {
    is_lf_inside_int <- !is_na & (l < lower_first) & (lower_first < u)
    if (any(is_lf_inside_int)) {
      labels_inside <- labels_unique[i_xun_to_xunu %in% which(is_lf_inside_int)]
      n_inside <- length(labels_inside)
      cli::cli_abort(c("{.arg lower_first} falls inside an existing interval.",
                       i = "{.arg lower_first}: {.val {lower_first}}.",
                       i = "Existing interval{?s}: {.val {labels_inside}}."))
    }
    is_high <- !is_na & (lower_first >= u)
    is_excluded <- !open & is_high
    if (any(is_excluded)) {
      labels_excl <- labels_unique[i_xun_to_xunu %in% which(is_excluded)]
      n_excl <- length(labels_excl)
      cli::cli_abort(c("{.arg lower_first} would exclude existing interval{?s}.",
                       i = "{.arg lower_first}: {.val {lower_first}}.",
                       i = "Excluded interval{?s}: {.val {labels_excl}}."))
    }
    return(lower_first)
  }
  l_min <- min(l[is.finite(l)])
  l_min - (l_min %% divisible_by)
}


make_lower_last <- function(lower_last,
                            intervals,
                            open,
                            min,
                            divisible_by) {
  user_supplied_value <- !is.null(lower_last)
  if (user_supplied_value) {
    check_n(n = lower_last,
                      nm_n = "lower_last",
                      min = min,
                      max = NULL,
                      divisible_by = divisible_by)
    lower_last <- as.integer(lower_last)
  }
  m <- get_m(intervals)
  labels_unique <- get_labels_unique(intervals)
  i_xun_to_xunu <- get_i_xun_to_xunu(intervals)
  l <- m[, 1L]
  u <- m[, 2L]
  is_na <- is.na(l)
  if (user_supplied_value) {
    is_lf_inside_int <- !is_na & (l < lower_last) & (lower_last < u)
    if (any(is_lf_inside_int)) {
      labels_inside <- labels_unique[i_xun_to_xunu %in% which(is_lf_inside_int)]
      n_inside <- length(labels_inside)
      cli::cli_abort(c("{.arg lower_last} falls inside an existing interval.",
                       i = "{.arg lower_last}: {.val {lower_last}}.",
                       i = "Existing interval{?s}: {.val {labels_inside}}."))
    }
    is_low <- !is_na & ((lower_last + divisible_by) < u)
    is_excluded <- !open & is_low
    if (any(is_excluded)) {
      labels_excl <- labels_unique[i_xun_to_xunu %in% which(is_excluded)]
      n_excl <- length(labels_excl)
      cli::cli_abort(c("{.arg lower_last} would exclude existing interval{?s}.",
                       i = "{.arg lower_last}: {.val {lower_last}}.",
                       i = "Excluded interval{?s}: {.val {labels_excl}}."))
    }
    return(lower_last)
  }
  l_max <- max(l[is.finite(u)])
  if (l_max %% divisible_by == 0L)
    l_max
  else
    ((l_max %/% divisible_by) + 1L) * divisible_by
}



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
#' constructed from two label vectors
#' @param relation `"equals"`,
#' `"contains"`, `"contained"` or `"overlaps"`
#' @param return_val Type of return value
#'
#' @returns Tibble or matrix
#'
#' @noRd
make_mapping <- function(intervals_x,
                         intervals_y,
                         relation,
                         return_val) {
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
  else if (relation == "contained") {
    mxy <- is_m1_inside_m2(m1 = mx, m2 = my)
    mxy[is_total_x, !is_na_y] <- FALSE
    mxy[, is_total_y] <- TRUE
  }
  else if (relation == "overlaps") {
    mxy <- does_m1_overlap_m2(m1 = mx, m2 = my)
    mxy[is_total_x, ] <- TRUE
    mxy[, is_total_y] <- TRUE
  }
  else
    cli::cli_abort("Internal error: {.val {relation}} is not a valid value for {.arg relation}.")
  mxy <- mxy[i_xun_to_xunu_x, ]
  mxy <- mxy[, i_xun_to_xunu_y]
  dimnames(mxy) <- list(x = labels_x, y = labels_y)
  if (return_val == "data.frame") {
    ans <- as.data.frame.table(mxy, stringsAsFactors = FALSE)
    ans <- ans[ans[[3L]], 1:2]
    ans <- tibble::tibble(ans)
  }
  else 
    ans <- 1L * mxy
  ans
}

