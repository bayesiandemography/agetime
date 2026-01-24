
## Functions used by 'age_mapping()', 'period_mapping()', 'cohort_mapping()'

## HAS_TESTS
#' Does One Interval Lie Inside Another
#'
#' @param int1,int2 Numeric vectors of length 1
#'
#' @returns TRUE, FALSE, or NA
#'
#' @noRd
is_int1_in_int2 <- function(int1, int2) {
  (int2[[1L]] <= int1[[1L]]) && (int1[[2L]] <= int2[[2L]])
}


## HAS_TESTS
#' Do Intervals from One Matrix Lie Inside Intervals from Another Matrix
#'
#' @param m1,m2 Matrices with 2 columns.
#'
#' @returns logical matrix with nrow(m1) rows and nrow(m1) columns
#'
#' @noRd
is_m1_in_m2 <- function(m1, m2) {
  n1 <- nrow(m1)
  n2 <- nrow(m2)
  ans <- matrix(nrow = n1, ncol = n2)
  for (i1 in seq_len(n1)) {
    for (i2 in seq_len(n2)) {
      int1 = m1[i1, ]
      int2 <- m2[i2, ]
      ans[i1, i2] <- is_int1_in_int2(int1 = int1, int2 = int2)
    }
  }
  ans
}


#' Make a Mapping Between Two Sets of Labels
#'
#' Include the pair (x_i, y_j) in the mapping
#' if a person or event included in x_i
#' could, in principle, be included in y_j.
#' 
#' If x_i is total or na,
#' then all pairs involving
#' x_i are included in the mapping.
#'
#' If y_j is total or na,
#' then all pairs involving
#' y_j are included in the mapping.
#'
#' @param obj1,obj2 Objects of class "agetime_intervals"
#' constructed from two label vectors
#' @param relationship Type of relationship expected,
#' or NULL
#' @param return_val "data.frame" or "
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
  m12 <- is_m1_in_m2(m1 = m1, m2 = m2)
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

