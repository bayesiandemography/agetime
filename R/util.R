#' Does First Interval Contain Second
#'
#' @param int1,int2 Numeric vectors of length 2.
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
#' @param int1,int2 Numeric vectors of length 2.
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
#' @param int1,int2 Numeric vectors of length 2.
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
#' @param m1,m2 Matrices with 2 columns.
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
#' @param m1,m2 Matrices with 2 columns.
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
#' @param m1,m2 Matrices with 2 columns.
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
#' @param int1,int2 Numeric vectors of length 2.
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
#' @param m1,m2 Matrices with 2 columns.
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

## return label of first interval that is
## not found in an abridged life table
label_non_life <- function(intervals) {
  m <- get_m(intervals)
  labels <- get_labels_unique(intervals)
  n <- nrow(m)
  is_equal <- function(x, y)
    isTRUE(all.equal(x, y, check.attributes = FALSE))
  for (i in seq_len(n)) {
    l <- m[i, 1L]
    u <- m[i, 2L]
    label <- labels[[i]]
    if (is.na(l)) {
      NULL
    }
    else if (is.infinite(l)) {
      return(label)
    }
    else if (is_equal(l, 0L)) {
      if (!is_equal(u, 1L))
        return(label)
    }
    else if (is_equal(l, 1L)) {
      if (!is_equal(u, 5L))
        return(label)
    }
    else {
      if (l %% 5L != 0L)
        return(label)
      if (is.finite(u) && (((u - l) %% 5L) != 0L))
        return(label)
    }
  }
  NULL
}

#' Name for a Label Type
#'
#' @param label_type `"age"`, `"period"`, or `"cohort"`.
#' @returns Character scalar.
#'
#' @noRd
label_name <- function(label_type) {
  ans <- switch(label_type,
                age = "age group",
                period = "period",
                cohort = "cohort",
                NULL)
  if (is.null(ans))
    cli::cli_abort("Internal error: {.val {label_type}} is not a valid value for {.arg label_type}.")
  ans
}

to_character_or_factor <- function(x, nm_x, length_zero_ok) {
  if (is.data.frame(x)) {
    cli::cli_abort("{.arg {nm_x}} is a data frame.")
  }
  if (is.list(x)) {
    cli::cli_abort("{.arg {nm_x}} is a list.")
  }
  if (!is.null(dim(x))) {
    cli::cli_abort("{.arg {nm_x}} is not a vector.")
  }
  if (identical(length(x), 0L) && !length_zero_ok)
    cli::cli_abort("{.arg {nm_x}} has length 0.")
  if (is.factor(x))
    return(x)
  x_char <- tryCatch(as.character(x), error = function(e) NULL)
  if (is.null(x_char)) {
    cli::cli_abort(c("{.arg {nm_x}} is not a vector of labels.",
                     i = "{.arg {nm_x}} has class {.cls {class(x)}}."))
  }
  x_char
}


val_length_zero <- function(x) {
  if (is.factor(x))
    return(x)
  else
    character()
}
