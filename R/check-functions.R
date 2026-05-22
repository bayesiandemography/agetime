
check_breaks <- function(breaks) {
  check_incr_nonneg_integers(x = breaks,
                             nm_x = "breaks",
                             min_length = 2L)
}
  

check_flag <- function(x, nm_x) {
  if (length(x) != 1L)
    cli::cli_abort(c("{.arg {nm_x}} does not have length 1.",
                     i = "{.arg {nm_x}} has length {.val {length(x)}}."))
  if (is.na(x))
    cli::cli_abort("{.arg {nm_x}} is {.val {NA}}.")
  if (!(x %in% c(TRUE, FALSE, 1L, 0L)))
    cli::cli_abort(c("{.arg {nm_x}} is not {.val {TRUE}} or {.val {FALSE}}.",
                     "{.arg {nm_x}} equals {.val {x}}."))
  invisible(TRUE)
}

check_in_limits_intervals <- function(x, nm_x, intervals, nm_intervals) {
  m <- get_m(intervals)
  labels <- get_labels_unique(intervals)
  lower <- m[, 1L]
  upper <- m[, 2L]
  if (all(is.na(lower)) || all(is.na(upper)))
    return(invisible(TRUE))
  i_lowest <- which.min(lower)
  i_highest <- which.max(upper)
  lowest <- lower[[i_lowest]]
  highest <- upper[[i_highest]]
  is_in <- (lowest <= x) & (x < highest)
  i_not_in <- match(FALSE, is_in, nomatch = 0L)
  if (i_not_in > 0L)
    cli::cli_abort(c(paste("Value in {.arg {nm_x}} outside",
                           "range for {.arg {nm_intervals}}."),
                     i = "Value in {.arg {nm_x}}: {.val {x[[i_not_in]]}}.",
                     i = paste("Lowest interval in {.arg {nm_intervals}}:",
                               "{.val {labels[[i_lowest]]}}."),
                     i = paste("Highest interval in {.arg {nm_intervals}}:",
                               "{.val {labels[[i_highest]]}}.")))
  invisible(TRUE)
}



check_incr_nonneg_integers <- function(x, nm_x, min_length) {
    eps <- 1e-8
    if (length(x) < min_length)
        cli::cli_abort(c("{.arg {nm_x}} has length {.val {length(x)}}.",
                         i = "{.arg {nm_x}} must have length >= {min_length}."))
    if (!is.numeric(x))
        cli::cli_abort(c("{.arg {nm_x}} is non-numeric.",
                         i = "{.arg {nm_x}} has class {.cls {class(x)}}."))
    n_na <- sum(is.na(x))
    if (n_na > 0L)
        cli::cli_abort("{.arg {nm_x}} has {cli::qty(n_na)} NA{?s}.")
    is_integerish <- abs(x - round(x)) < eps
    i_not_integerish <- match(FALSE, is_integerish, nomatch = 0L)
    if (i_not_integerish > 0L)
        cli::cli_abort(c("{.arg {nm_x}} has non-integer value.",
                         "Value: {.val {x[[i_not_integerish]]}}."))
    n_neg <- sum(x < 0L)
    if (n_neg > 0L)
        cli::cli_abort("{.arg {nm_x}} has negative {cli::qty(n_na)} value{?s}.")
    is_non_incr <- diff(x) <= 0L
    i_non_incr <- match(TRUE, is_non_incr, nomatch = 0L)
    if (i_non_incr > 0L) {
        x_non <- x[c(i_non_incr, i_non_incr + 1L)]
        cli::cli_abort(c("{.arg {nm_x}} non-increasing.",
                         i = "Non-increasing values: {.val {x_non}}."))
    }
    invisible(TRUE)
}
    


check_m_contains <- function(m_contains, label_type) {
  int_name <- switch(label_type,
                     age = "age group",
                     cohort = "cohort",
                     period = "period")
  labels_old <- colnames(m_contains)
  colsum <- colSums(m_contains)
  is_not_fit <- colsum != 1L
  if (any(is_not_fit)) {
    labels_not_fit <- labels_old[is_not_fit]
    cli::cli_abort(paste("Old label{?s} {.val {labels_not_fit}}",
                         "does not map on to new label set."))
  }
  invisible(TRUE)
}
  

## HAS_TESTS
#' Check Whole Number
#'
#' Copied from 'poputils' with 'rvec' test dropped,
#' to avoid depending on 'poputils' or 'rvec'.
#'
#' Check that `n` is  finite, non-NA scalar that
#' is an integer or integerish (ie is equal to `round(n)`),
#' and optionally within a specified range
#' and divisible by a specified number.
#'
#' @param n A whole number
#' @param nm_n Name for 'n' to be used in error messages
#' @param min Minimum value 'n' can take. Can be NULL.
#' @param max Maximum values 'n' can take. Can be NULL.
#' @param divisible_by 'n' must be divisible by this. Can be NULL.
#'
#' @returns
#' If all tests pass, `check_n()` returns `TRUE` invisibly.
#' Otherwise it throws an error.
#'
#' @noRd
check_n <- function(n, nm_n, min, max, divisible_by) {
  if (!is.numeric(n))
    cli::cli_abort(c("{.arg {nm_n}} is non-numeric.",
                     i = "{.arg {nm_n}} has class {.cls {class(n)}}."))
  if (length(n) != 1L)
    cli::cli_abort(c("{.arg {nm_n}} does not have length 1.",
                     i = "{.arg {nm_n}} has length {length(n)}."))
  if (is.na(n))
    cli::cli_abort("{.arg {nm_n}} is {.val {NA}}.")
  if (is.infinite(n))
    cli::cli_abort("{.arg {nm_n}} is {.val {Inf}}.")
  if (!isTRUE(all.equal(round(n), n)))
    cli::cli_abort(c("{.arg {nm_n}} is not an integer.",
                     i = "{.arg {nm_n}} is {.val {n}}."))
  if (!is.null(min) && (n < min))
    cli::cli_abort(c("{.arg {nm_n}} is less than {min}.",
                     i = "{.arg {nm_n}} is {.val {n}}."))
  if (!is.null(max) && (n > max))
    cli::cli_abort(c("{.arg {nm_n}} is greater than {max}.",
                     i = "{.arg {nm_n}} is {.val {n}}."))
  if (!is.null(divisible_by) && (n %% divisible_by != 0L))
    cli::cli_abort(c("{.arg {nm_n}} is not divisible by {divisible_by}.",
                     i = "{.arg nm_n}: {.val {n}}."))
  invisible(TRUE)
}

    
    
check_is_integerish <- function(x) {
  tol <- 1e-8
  x <- as.double(x)
  is_ok <- is.na(x) | is.infinite(x) | (abs(x - round(x)) <= tol)
  i_not_ok <- match(FALSE, is_ok, nomatch = 0L)
  if (i_not_ok > 0L) {
    x_not_ok <- x[[i_not_ok]]
    cli::cli_abort("Internal error: value {.val {x_not_ok}} is not integerish.")
  }
  invisible(TRUE)
}



check_mapping_constraints <- function(m_mapping,
                                      x_complete,
                                      y_complete,
                                      x_unique,
                                      y_unique,
                                      check) {
  rowsum <- rowSums(m_mapping, na.rm = TRUE)
  colsum <- colSums(m_mapping, na.rm = TRUE)
  is_x_complete <- all(rowsum > 0L)
  is_y_complete <- all(colsum > 0L)
  is_x_unique <- all(rowsum %in% c(0L, 1L))
  is_y_unique <- all(colsum %in% c(0L, 1L))
  for (nm in c("x_complete", "y_complete", "x_unique", "y_unique")) {
    val_constr <- get(nm)
    if (!is.null(val_constr)) {
      if (!(val_constr %in% c(TRUE, FALSE)))
        cli::cli_abort(c("{.arg {nm}} is {.val {val_constr}}.",
                         i = paste("{.arg {nm}} must be {.val {NULL}},",
                                   "{.val {TRUE}}, or {.val {FALSE}}.")))
      val_check <- get(paste0("is_", nm))
      if (!identical(val_constr, val_check)) {
        msg <- "Constraint {.code {nm} = {val_constr}} not satisfied."
        if (check == "error")
          cli::cli_abort(msg)
        else
          cli::cli_warn(msg)
      }
    }
  }
  invisible(TRUE)
}

check_not_in_intervals <- function(x, nm_x, intervals, nm_intervals) {
  m <- get_m(intervals)
  labels <- get_labels_unique(intervals)
  lower <- m[, 1L]
  upper <- m[, 2L]
  for (i in seq_along(lower)) {
    l <- lower[[i]]
    u <- upper[[i]]
    is_finite <- is.finite(l) && is.finite(u)
    if (is_finite) {
      is_in <- (l < x) & (x < u)
      i_in <- match(TRUE, is_in, nomatch = 0L)
      if (i_in > 0L)
        cli::cli_abort(c(paste("Value in {.arg {nm_x}} inside",
                               "interval from {.arg {nm_intervals}}."),
                         i = "Value in {.arg {nm_x}}: {.val {x[[i_in]]}}.",
                         i = "Interval: {.val {labels[[i]]}}."))
    }
  }
  invisible(TRUE)
}



check_x_lt_y <- function(x, y, nm_x, nm_y) {
  if (x >= y)
    cli::cli_abort(c("{.arg {nm_x}} must be less than {.arg {nm_y}}.",
                     i = "{.arg {nm_x}}: {.val {x}}.",
                     i = "{.arg {nm_y}}: {.val {y}}."))
  invisible(TRUE)
}
