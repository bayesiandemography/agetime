#' Check Breaks
#'
#' @param breaks Increasing vector of break points.
#' @returns Return value used internally.
#'
#' @noRd
check_breaks <- function(breaks) {
  check_incr_nonneg_integers(x = breaks,
                             nm_x = "breaks",
                             min_length = 2L)
}

#' Check Flag
#'
#' @param x Vector of labels.
#' @param nm_x Argument name used in error messages.
#' @returns Return value used internally.
#'
#' @noRd
check_flag <- function(x, nm_x) {
  if (length(x) != 1L)
    cli::cli_abort(c("{.arg {nm_x}} has length {.val {length(x)}}.",
                     i = "Supply a single value?"))
  if (is.na(x))
    cli::cli_abort("{.arg {nm_x}} is {.val {NA}}.")
  if (!(x %in% c(TRUE, FALSE, 1L, 0L)))
    cli::cli_abort(c("{.arg {nm_x}} is {.val {x}}.",
                     i = "Use {.val {TRUE}} or {.val {FALSE}}?"))
  invisible(TRUE)
}

#' Check In Limits Intervals
#'
#' @param x Vector of labels.
#' @param nm_x Argument name used in error messages.
#' @param intervals An `agetime_intervals` object.
#' @param nm_intervals Argument name for interval labels in error messages.
#' @returns Return value used internally.
#'
#' @noRd
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
    cli::cli_abort(c("Value in {.arg {nm_x}} outside range of {.arg {nm_intervals}}.",
                     i = "Value in {.arg {nm_x}}: {.val {x[[i_not_in]]}}.",
                     i = paste("Lowest interval in {.arg {nm_intervals}}:",
                               "{.val {labels[[i_lowest]]}}."),
                     i = paste("Highest interval in {.arg {nm_intervals}}:",
                               "{.val {labels[[i_highest]]}}.")))
  invisible(TRUE)
}

#' Check 'x' Consists of Increasing Non-Negative Integers
#'
#' @param x Vector of labels.
#' @param nm_x Argument name used in error messages.
#' @param min_length Minimum required length.
#' @returns Return value used internally.
#'
#' @noRd
check_incr_nonneg_integers <- function(x, nm_x, min_length) {
  eps <- 1e-8
  if (length(x) < min_length)
    cli::cli_abort(c("{.arg {nm_x}} has length {.val {length(x)}}.",
                     i = "Use at least {min_length} value{?s}?"))
  if (!is.numeric(x))
    cli::cli_abort(c("{.arg {nm_x}} is non-numeric.",
                     i = "{.arg {nm_x}} has class {.cls {class(x)}}."))
  n_na <- sum(is.na(x))
  if (n_na > 0L)
    cli::cli_abort("{.arg {nm_x}} has {cli::qty(n_na)} NA{?s}.")
  is_integerish <- abs(x - round(x)) < eps
  i_not_integerish <- match(FALSE, is_integerish, nomatch = 0L)
  if (i_not_integerish > 0L)
    cli::cli_abort(c("{.arg {nm_x}} has a non-integer value.",
                     i = "Value: {.val {x[[i_not_integerish]]}}."))
  n_neg <- sum(x < 0L)
  if (n_neg > 0L)
    cli::cli_abort("{.arg {nm_x}} has {cli::qty(n_neg)} negative value{?s}.")
  is_non_incr <- diff(x) <= 0L
  i_non_incr <- match(TRUE, is_non_incr, nomatch = 0L)
  if (i_non_incr > 0L) {
    x_non <- x[c(i_non_incr, i_non_incr + 1L)]
    cli::cli_abort(c("{.arg {nm_x}} is not increasing.",
                     i = "Non-increasing values: {.val {x_non}}."))
  }
  invisible(TRUE)
}

#' Check if Any Labels Do Not Fit into New Set
#'
#' @param m_contains Containment matrix from modified breaks to original labels.
#' @param label_type Label domain: `"age"`, `"cohort"`, or `"period"`.
#' @returns Return value used internally.
#'
#' @noRd
check_m_contains <- function(m_contains, label_type) {
  labels_old <- colnames(m_contains)
  colsum <- colSums(m_contains)
  is_not_fit <- colsum != 1L
  if (any(is_not_fit)) {
    labels_not_fit <- labels_old[is_not_fit]
    cli::cli_abort(c("Label{?s} {.val {labels_not_fit}} do not map to the new label set.",
                     i = "Check the mapping between old and new labels?"))
  }
  invisible(TRUE)
}
  

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
#' @param n A whole number.
#' @param nm_n Name for 'n' to be used in error messages.
#' @param min Minimum value 'n' can take. Can be NULL.
#' @param max Maximum values 'n' can take. Can be NULL.
#' @param divisible_by 'n' must be divisible by this. Can be NULL.
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
    cli::cli_abort(c("{.arg {nm_n}} has length {.val {length(n)}}.",
                     i = "Supply a single value?"))
  if (is.na(n))
    cli::cli_abort("{.arg {nm_n}} is {.val {NA}}.")
  if (is.infinite(n))
    cli::cli_abort("{.arg {nm_n}} is {.val {Inf}}.")
  if (!isTRUE(all.equal(round(n), n)))
    cli::cli_abort(c("{.arg {nm_n}} is not a whole number.",
                     i = "{.arg {nm_n}} is {.val {n}}."))
  if (!is.null(min) && (n < min))
    cli::cli_abort(c("{.arg {nm_n}} is {.val {n}}.",
                     i = "Use a value of at least {min}?"))
  if (!is.null(max) && (n > max))
    cli::cli_abort(c("{.arg {nm_n}} is {.val {n}}.",
                     i = "Use a value of at most {max}?"))
  if (!is.null(divisible_by) && (n %% divisible_by != 0L))
    cli::cli_abort(c("{.arg {nm_n}} is not divisible by {divisible_by}.",
                     i = "{.arg {nm_n}} is {.val {n}}.",
                     i = "Use a value divisible by {divisible_by}?"))
  invisible(TRUE)
}


#' Check Not In Intervals
#'
#' @param x Vector of labels.
#' @param nm_x Argument name used in error messages.
#' @param intervals An `agetime_intervals` object.
#' @param nm_intervals Argument name for interval labels in error messages.
#' @returns Return value used internally.
#'
#' @noRd
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
        cli::cli_abort(c("Value in {.arg {nm_x}} falls inside an interval from {.arg {nm_intervals}}.",
                         i = "Value in {.arg {nm_x}}: {.val {x[[i_in]]}}.",
                         i = "Interval: {.val {labels[[i]]}}."))
    }
  }
  invisible(TRUE)
}

#' Check X Lt Y
#'
#' @param x Vector of labels.
#' @param y Vector of labels to compare against `x`.
#' @param nm_x Argument name used in error messages.
#' @param nm_y Argument name used in error messages.
#' @returns Return value used internally.
#'
#' @noRd
check_x_lt_y <- function(x, y, nm_x, nm_y) {
  if (x >= y)
    cli::cli_abort(c("{.arg {nm_x}} is not less than {.arg {nm_y}}.",
                     i = "{.arg {nm_x}}: {.val {x}}.",
                     i = "{.arg {nm_y}}: {.val {y}}."))
  invisible(TRUE)
}
