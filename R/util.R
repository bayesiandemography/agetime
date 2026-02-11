#' Does First Interval Contain Second
#'
#' @param int1,int2 Numeric vectors of length 2
#'
#' @returns TRUE, FALSE, or NA
#'
#' @noRd
does_int1_contain_int2 <- function(int1, int2) {
  l1 <- int1[[1L]]
  u1 <- int1[[2L]]
  l2 <- int2[[1L]]
  u2 <- int2[[2L]]
  (l1 <= l2) & (u2 <= u1)
}

#' Does First Interval Equal Second
#'
#' @param int1,int2 Numeric vectors of length 2
#'
#' @returns TRUE or FALSE, or NA
#'
#' @noRd
does_int1_equal_int2 <- function(int1, int2) {
  if (anyNA(c(int1, int2)))
    return(NA)
  l1 <- int1[[1L]]
  u1 <- int1[[2L]]
  l2 <- int2[[1L]]
  u2 <- int2[[2L]]
  isTRUE(all.equal(l1, l2)) && isTRUE(all.equal(u1, u2))
}

## HAS_TESTS
#' Does First Interval Overlap Second
#'
#' @param int1,int2 Numeric vectors of length 2
#'
#' @returns TRUE, FALSE, or NA
#'
#' @noRd
does_int1_overlap_int2 <- function(int1, int2) {
  l1 <- int1[[1L]]
  u1 <- int1[[2L]]
  l2 <- int2[[1L]]
  u2 <- int2[[2L]]
  int1_lower <- u1 <= l2
  int1_higher <- u2 <= l1
  no_overlap <- int1_lower || int1_higher
  !no_overlap
}

#' Do Intervals from One Matrix Contain Intervals from Another Matrix
#'
#' @param m1,m2 Matrices with 2 columns
#'
#' @returns Logical matrix with nrow(m1) rows and nrow(m1) columns
#'
#' @noRd
does_m1_contain_m2 <- function(m1, m2) {
  n1 <- nrow(m1)
  n2 <- nrow(m2)
  ans <- matrix(nrow = n1, ncol = n2)
  for (i1 in seq_len(n1)) {
    for (i2 in seq_len(n2)) {
      int1 <- m1[i1, ]
      int2 <- m2[i2, ]
      ans[i1, i2] <- does_int1_contain_int2(int1 = int1, int2 = int2)
    }
  }
  ans
}

#' Do Intervals from One Matrix Equal Intervals from Another Matrix
#'
#' @param m1,m2 Matrices with 2 columns
#'
#' @returns Logical matrix with nrow(m1) rows and nrow(m1) columns
#'
#' @noRd
does_m1_equal_m2 <- function(m1, m2) {
  n1 <- nrow(m1)
  n2 <- nrow(m2)
  ans <- matrix(nrow = n1, ncol = n2)
  for (i1 in seq_len(n1)) {
    for (i2 in seq_len(n2)) {
      int1 <- m1[i1, ]
      int2 <- m2[i2, ]
      ans[i1, i2] <- does_int1_equal_int2(int1 = int1, int2 = int2)
    }
  }
  ans
}


## HAS_TESTS
#' Do Intervals from One Matrix Overlap Intervals from Another Matrix
#'
#' @param m1,m2 Matrices with 2 columns
#'
#' @returns Logical matrix with nrow(m1) rows and nrow(m1) columns
#'
#' @noRd
does_m1_overlap_m2 <- function(m1, m2) {
  n1 <- nrow(m1)
  n2 <- nrow(m2)
  ans <- matrix(nrow = n1, ncol = n2)
  for (i1 in seq_len(n1)) {
    for (i2 in seq_len(n2)) {
      int1 <- m1[i1, ]
      int2 <- m2[i2, ]
      ans[i1, i2] <- does_int1_overlap_int2(int1 = int1, int2 = int2)
    }
  }
  ans
}

#' Is the First Interval Inside the Second
#'
#' @param int1,int2 Numeric vectors of length 2
#'
#' @returns TRUE, FALSE, or NA
#'
#' @noRd
is_int1_inside_int2 <- function(int1, int2) {
  l1 <- int1[[1L]]
  u1 <- int1[[2L]]
  l2 <- int2[[1L]]
  u2 <- int2[[2L]]
  (l2 <= l1) & (u1 <= u2)
}

#' Are Intervals from One Matrix Inside Intervals from Another Matrix
#'
#' @param m1,m2 Matrices with 2 columns
#'
#' @returns Logical matrix with nrow(m1) rows and nrow(m1) columns
#'
#' @noRd
is_m1_inside_m2 <- function(m1, m2) {
  n1 <- nrow(m1)
  n2 <- nrow(m2)
  ans <- matrix(nrow = n1, ncol = n2)
  for (i1 in seq_len(n1)) {
    for (i2 in seq_len(n2)) {
      int1 <- m1[i1, ]
      int2 <- m2[i2, ]
      ans[i1, i2] <- is_int1_inside_int2(int1 = int1, int2 = int2)
    }
  }
  ans
}


make_levels_from_breaks <- function(breaks,
                                    is_open_left,
                                    is_open_right,
                                    labels_one,
                                    labels_multi,
                                    include_total,
                                    include_na) {
  lower <- breaks[-length(breaks)]
  upper <- breaks[-1L]
  if (is_open_left) {
    lower <- c(-Inf, lower)
    upper <- c(lower[[1L]], upper)
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
  ans[is_open_left] <- paste0("<", lower[is_open_left])
  ans[is_open_right] <- paste0(lower[is_open_right], "+")
  if (labels_one == "lower")
    ans[is_one] <- lower[is_one]
  else
    ans[is_one] <- upper[is_one]
  if (labels_multi == "exclude")
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
                             open,
                             min,
                             divisible_by) {
  user_supplied_value <- !is.null(lower_first)
  if (user_supplied_value) {
    poputils::check_n(n = lower_first,
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
      cli::cli_abort(c(paste("Value supplied for {.arg lower_first} falls within",
                             "existing {cli::qty(n_inside)} interval{?s}",
                             "in {.arg x}."),
                       i = "{.arg lower_first}: {.val {lower_first}}.",
                       i = "Existing interval{?s}: {.val {labels_inside}}."))
    }
    is_high <- !is_na & (lower_first >= u)
    is_excluded <- !open & is_high
    if (any(is_excluded)) {
      labels_excl <- labels_unique[i_xun_to_xunu %in% which(is_excluded)]
      n_excl <- length(labels_excl)
      cli::cli_abort(c(paste("Value supplied for {.arg lower_first} would exclude",
                             "existing {cli::qty(n_excl)} interval{?s} in {.arg x}."),
                       i = "{.arg lower_first}: {.val {lower_first}}.",
                       i = "Would be excluded: {.val {labels_excl}}."))
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
    poputils::check_n(n = lower_last,
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
      cli::cli_abort(c(paste("Value supplied for {.arg lower_last} falls within",
                             "existing {cli::qty(n_inside)} interval{?s}",
                             "in {.arg x}."),
                       i = "{.arg lower_last}: {.val {lower_last}}.",
                       i = "Existing interval{?s}: {.val {labels_inside}}."))
    }
    is_low <- !is_na & ((lower_last + divisible_by) < u)
    is_excluded <- !open & is_low
    if (any(is_excluded)) {
      labels_excl <- labels_unique[i_xun_to_xunu %in% which(is_excluded)]
      n_excl <- length(labels_excl)
      cli::cli_abort(c(paste("Value supplied for {.arg lower_last} would exclude",
                             "existing {cli::qty(n_excl)} interval{?s} in {.arg x}."),
                       i = "{.arg lower_last}: {.val {lower_last}}.",
                       i = "Would be excluded: {.val {labels_excl}}."))
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
#' Include the pair (x_i, y_j) in the mapping
#' if a person or event included in x_i
#' could, in principle, be included in y_j.
#' 
#' If x_i is total or NA,
#' then all pairs involving
#' x_i are included in the mapping.
#'
#' If y_j is total or NA,
#' then all pairs involving
#' y_j are included in the mapping.
#'
#' @param obj1,obj2 Objects of class "agetime_intervals"
#' constructed from two label vectors
#' @param x_complete,y_complete,x_unique,y_unique
#' Constraints on mappings. Logical or NULL
#' @param check Action if constraints violated
#' @param return_val Type of return value
#'
#' @returns Tibble or matrix
#'
#' @noRd
make_mapping <- function(obj1,
                         obj2,
                         x_complete,
                         y_complete,
                         x_unique,
                         y_unique,
                         check,
                         return_val) {
  labels_1 <- get_labels_unique(obj1)
  labels_2 <- get_labels_unique(obj2)
  is_na_1 <- get_is_na(obj1)
  is_na_2 <- get_is_na(obj2)
  is_total_1 <- get_is_total(obj1)
  is_total_2 <- get_is_total(obj2)
  i_xun_to_xunu_1 <- get_i_xun_to_xunu(obj1)
  i_xun_to_xunu_2 <- get_i_xun_to_xunu(obj2)
  m1 <- get_m(obj1)
  m2 <- get_m(obj2)
  m12 <- does_m1_overlap_m2(m1 = m1, m2 = m2)
  set_row_to_true <- is_na_1 | is_total_1
  set_col_to_true <- is_na_2 | is_total_2
  m12[set_row_to_true, ] <- TRUE
  m12[, set_col_to_true] <- TRUE
  m12 <- m12[i_xun_to_xunu_1, ]
  m12 <- m12[, i_xun_to_xunu_2]
  dimnames(m12) <- list(x = labels_1, y = labels_2)
  check_mapping_constraints(m_mapping = m12,
                            x_complete = x_complete,
                            y_complete = y_complete,
                            x_unique = x_unique,
                            y_unique = y_unique,
                            check = check)
  if (return_val == "data.frame") {
    ans <- as.data.frame.table(m12, stringsAsFactors = FALSE)
    ans <- ans[ans[[3L]], 1:2]
    ans <- tibble::tibble(ans)
  }
  else 
    ans <- 1L * m12
  ans
}




## NEEDS CHECKING
make_match <- function(intervals_x,
                       intervals_table,
                       type,
                       nomatch) {
  m_x <- get_m(intervals_x)
  m_table <- get_m(intervals_table)
  i_x_to_xunu_x <- get_i_x_to_xunu(intervals_x)
  i_x_to_xunu_table <- get_i_x_to_xunu(intervals_table)
  is_total_x <- get_is_total(intervals_x)
  is_total_table <- get_is_total(intervals_table)
  is_na_x <- get_is_na(intervals_x)
  is_na_table <- get_is_na(intervals_table)
  if (type == "equal") {
    m_match <- does_m1_equal_m2(m1 = m_x, m2 = m_table)
    m_match[is_total_x, is_total_table] <- TRUE
    m_match[is_na_x, is_na_table] <- TRUE
  }
  else if (type == "inside") {
    m_match <- is_m1_inside_m2(m1 = m_x, m2 = m_table)
    m_match[, is_total_table] <- TRUE
    m_match[is_na_x, is_na_table] <- TRUE
  }
  else
    cli::cli_abort("Internal error: Invalid value for 'type'.")
  s_table <- seq_len(ncol(m_match))
  i_first_table <- match(s_table, i_x_to_xunu_table)
  ans <- rep(nomatch, times = nrow(m_match))
  has_match <- rowSums(m_match, na.rm = TRUE) > 0L
  if (any(has_match)) {
    ans[has_match] <- apply(m_match[has_match, , drop = FALSE],
                            MARGIN = 1L,
                            function(idx) min(i_first_table[idx], na.rm = TRUE))
  }
  ans[i_x_to_xunu_x]
}
  
  

## make_levels_from_lower_upper <- function(lower,
##                                          upper,
##                                          labels_one,
##                                          labels_multi,
##                                          include_na,
##                                          include_total) {
##   width <- upper - lower
##   is_open_left <- is.infinite(lower)
##   is_open_right <- is.infinite(upper)
##   is_closed <- !is_open_left & !is_open_right
##   is_one <- is_closed & (width == 1L)
##   is_multi <- is_closed & (width > 1L)
##   n <- length(lower)
##   ans <- character(length = n)
##   ans[is_open_left] <- paste0("<", lower[is_open_left])
##   ans[is_open_right] <- paste0(lower[is_open_right], "+")
##   if (labels_one == "lower")
##     ans[is_one] <- lower[is_one]
##   else
##     ans[is_one] <- upper[is_one]
##   if (labels_multi == "exclude")
##     ans[is_multi] <- paste(lower[is_multi],
##                            upper[is_multi] - 1L,
##                            sep = "-")
##   else
##     ans[is_multi] <- paste(lower[is_multi],
##                            upper[is_multi] - 1L,
##                            sep = "-")
##   if (include_total)
##     ans <- c(ans, "Total")
##   if (include_na)
##     ans <- c(ans, NA)
##   ans
## }



to_character_or_factor <- function(x, nm_x) {
  msg <- c("{.arg {nm_x}} must be a vector of labels.",
           i = "{.arg {nm_x}} has class {.cls {class(x)}}.")
  if (is.data.frame(x)) {
    msg[["i"]] <- "{.arg {nm_x}} is a data frame."
    cli::cli_abort(msg)
  }
  if (is.list(x)) {
    msg[["i"]] <- "{.arg {nm_x}} is a list."
    cli::cli_abort(msg)
  }
  if (!is.null(dim(x))) {
    msg[["i"]] <- "{.arg {nm_x}} is not a vector (it has dimensions)."
    cli::cli_abort(msg)
  }
  if (is.factor(x))
    return(x)
  x_char <- tryCatch(as.character(x), error = function(e) NULL)
  if (is.null(x_char)) {
    cli::cli_abort(msg)
  }
  x_char
}

