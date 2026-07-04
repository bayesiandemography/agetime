#' Check Breaks
#'
#' @param breaks Increasing vector of break points.
#' @returns Return value used internally.
#'
#' @noRd
check_breaks <- function(breaks) {
  if (length(breaks) < 2L) {
    cli::cli_abort(c("{.arg breaks} has length {.val {length(breaks)}}.",
      i = "Use at least two break points?"
    ))
  }
  check_incr_nonneg_integers(
    x = breaks,
    nm_x = "breaks",
    min_length = 2L
  )
}

#' Check Flag
#'
#' @param x Single logical flag (`TRUE`, `FALSE`, `1L`, or `0L`).
#' @param nm_x Argument name used in error messages.
#' @returns Return value used internally.
#'
#' @noRd
check_flag <- function(x, nm_x) {
  if (length(x) != 1L) {
    cli::cli_abort(c("{.arg {nm_x}} has length {.val {length(x)}}.",
      i = "Supply a single value?"
    ))
  }
  if (is.na(x)) {
    cli::cli_abort("{.arg {nm_x}} is {.val {NA}}.")
  }
  if (!(x %in% c(TRUE, FALSE, 1L, 0L))) {
    cli::cli_abort(c("{.arg {nm_x}} is {.val {x}}.",
      i = "Use {.val {TRUE}} or {.val {FALSE}}?"
    ))
  }
  invisible(TRUE)
}

#' Check In Limits Intervals
#'
#' @param x Numeric break points.
#' @param nm_x Argument name used in error messages.
#' @param intervals An `agetime_intervals` object.
#' @param nm_intervals Argument name for the label vector in error messages.
#' @param label_type Label domain: `"age"`, `"cohort"`, or `"period"`.
#' @returns Return value used internally.
#'
#' @noRd
check_in_limits_intervals <- function(x,
                                      nm_x,
                                      intervals,
                                      nm_intervals,
                                      label_type) {
  m <- get_m(intervals)
  labels <- get_labels_unique(intervals)
  lower <- m[, 1L]
  upper <- m[, 2L]
  if (all(is.na(lower)) || all(is.na(upper))) {
    return(invisible(TRUE))
  }
  i_lowest <- which.min(lower)
  i_highest <- which.max(upper)
  lowest <- lower[[i_lowest]]
  highest <- upper[[i_highest]]
  is_in <- (lowest <= x) & (x < highest)
  i_not_in <- match(FALSE, is_in, nomatch = 0L)
  if (i_not_in > 0L) {
    x_not_in <- x[[i_not_in]]
    label_lowest <- labels[[i_lowest]]
    label_highest <- labels[[i_highest]]
    msg_envir <- list2env(
      list(
        nm_x = nm_x,
        x_not_in = x_not_in,
        label_lowest = label_lowest,
        label_highest = label_highest
      ),
      parent = environment()
    )
    x_msg <- cli::format_inline(
      "{.arg {nm_x}} is {.val {x_not_in}}.",
      .envir = msg_envir
    )
    label_lowest_msg <- cli::format_inline(
      "Lowest interval: {.val {label_lowest}}.",
      .envir = msg_envir
    )
    label_highest_msg <- cli::format_inline(
      "Highest interval: {.val {label_highest}}.",
      .envir = msg_envir
    )
    cli::cli_abort(c(
      paste0(
        "{.arg {nm_x}} is outside the range covered by ",
        "{label_name(label_type)}s in {.arg {nm_intervals}}."
      ),
      i = x_msg,
      i = label_lowest_msg,
      i = label_highest_msg,
      i = paste0(
        "Use values within the range covered by ",
        "{label_name(label_type)}s in {.arg {nm_intervals}}?"
      )
    ))
  }
  invisible(TRUE)
}

#' Check 'x' Consists of Increasing Non-Negative Integers
#'
#' @param x Numeric vector of non-negative whole numbers.
#' @param nm_x Argument name used in error messages.
#' @param min_length Minimum required length.
#' @returns Return value used internally.
#'
#' @noRd
check_incr_nonneg_integers <- function(x, nm_x, min_length) {
  eps <- 1e-8
  if (length(x) < min_length) {
    cli::cli_abort(c("{.arg {nm_x}} has length {.val {length(x)}}.",
      i = "Use at least {min_length} value{?s}?"
    ))
  }
  if (!is.numeric(x)) {
    cli::cli_abort(c("{.arg {nm_x}} is non-numeric.",
      i = "{.arg {nm_x}} has class {.cls {class(x)}}."
    ))
  }
  n_na <- sum(is.na(x))
  if (n_na > 0L) {
    cli::cli_abort("{.arg {nm_x}} has {cli::qty(n_na)} NA{?s}.")
  }
  is_integerish <- abs(x - round(x)) < eps
  i_not_integerish <- match(FALSE, is_integerish, nomatch = 0L)
  if (i_not_integerish > 0L) {
    cli::cli_abort(paste0(
      "{.arg {nm_x}} has value {.val {x[[i_not_integerish]]}} ",
      "that is not a whole number."
    ))
  }
  n_neg <- sum(x < 0L)
  if (n_neg > 0L) {
    cli::cli_abort("{.arg {nm_x}} has {cli::qty(n_neg)} negative value{?s}.")
  }
  is_non_incr <- diff(x) <= 0L
  i_non_incr <- match(TRUE, is_non_incr, nomatch = 0L)
  if (i_non_incr > 0L) {
    x_non <- x[c(i_non_incr, i_non_incr + 1L)]
    msg_envir <- list2env(
      list(nm_x = nm_x, x_non = x_non),
      parent = environment()
    )
    msg <- cli::format_inline(
      "{.arg {nm_x}} has non-increasing values: {.val {x_non}}.",
      .envir = msg_envir
    )
    cli::cli_abort(msg)
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
    n <- length(labels_not_fit)
    msg_envir <- list2env(
      list(
        n = n,
        labels_not_fit = labels_not_fit,
        label_type = label_type
      ),
      parent = environment()
    )
    msg <- cli::format_inline(
      paste0(
        "{cli::qty(n)} label{?s} {.val {labels_not_fit}} ",
        "cannot each lie in exactly one new {label_name(label_type)}."
      ),
      .envir = msg_envir
    )
    cli::cli_abort(c(
      msg,
      i = paste0(
        "Make sure that every old {label_name(label_type)} ",
        "lies in exactly one new {label_name(label_type)}?"
      )
    ))
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
#' @param n Single numeric value (whole number).
#' @param nm_n Argument name used in error messages.
#' @param min Minimum allowed value, or `NULL`.
#' @param max Maximum allowed value, or `NULL`.
#' @param divisible_by Required divisor, or `NULL`.
#' @returns
#' If all tests pass, `check_n()` returns `TRUE` invisibly.
#' Otherwise it throws an error.
#'
#' @noRd
check_n <- function(n, nm_n, min, max, divisible_by) {
  if (!is.numeric(n)) {
    cli::cli_abort(c("{.arg {nm_n}} is non-numeric.",
      i = "{.arg {nm_n}} has class {.cls {class(n)}}."
    ))
  }
  if (length(n) != 1L) {
    cli::cli_abort(c("{.arg {nm_n}} has length {.val {length(n)}}.",
      i = "Supply a single value?"
    ))
  }
  if (is.na(n)) {
    cli::cli_abort("{.arg {nm_n}} is {.val {NA}}.")
  }
  if (is.infinite(n)) {
    cli::cli_abort("{.arg {nm_n}} is {.val {n}}.")
  }
  if (!isTRUE(all.equal(round(n), n))) {
    cli::cli_abort(c("{.arg {nm_n}} is {.val {n}}.",
      i = "Use a whole number?"
    ))
  }
  if (!is.null(min) && (n < min)) {
    cli::cli_abort(c("{.arg {nm_n}} is {.val {n}}.",
      i = "Use a value of at least {.val {min}}?"
    ))
  }
  if (!is.null(max) && (n > max)) {
    cli::cli_abort(c("{.arg {nm_n}} is {.val {n}}.",
      i = "Use a value of at most {.val {max}}?"
    ))
  }
  if (!is.null(divisible_by) && (n %% divisible_by != 0L)) {
    cli::cli_abort(c("{.arg {nm_n}} is {.val {n}}.",
      i = "Use a value divisible by {.val {divisible_by}}?"
    ))
  }
  invisible(TRUE)
}


#' Check Difference Is Divisible
#'
#' @param x First numeric value.
#' @param y Second numeric value.
#' @param nm_x Argument name used in error messages.
#' @param nm_y Argument name used in error messages.
#' @param divisible_by Required divisor.
#' @returns Return value used internally.
#'
#' @noRd
check_diff_divisible <- function(x, y, nm_x, nm_y, divisible_by) {
  diff <- y - x
  if (diff %% divisible_by != 0L) {
    cli::cli_abort(c(
      "Difference between {.arg {nm_x}} and {.arg {nm_y}} is {.val {diff}}.",
      i = paste0(
        "Use values whose difference is divisible by ",
        "{.val {divisible_by}}?"
      )
    ))
  }
  invisible(TRUE)
}


#' Check Not In Intervals
#'
#' @param x Numeric break points.
#' @param nm_x Argument name used in error messages.
#' @param intervals An `agetime_intervals` object.
#' @param nm_intervals Argument name for the label vector in error messages.
#' @param label_type Label domain: `"age"`, `"cohort"`, or `"period"`.
#' @returns Return value used internally.
#'
#' @noRd
check_not_in_intervals <- function(x,
                                   nm_x,
                                   intervals,
                                   nm_intervals,
                                   label_type) {
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
      if (i_in > 0L) {
        x_in <- x[[i_in]]
        label <- labels[[i]]
        msg_envir <- list2env(
          list(nm_x = nm_x, x_in = x_in, label = label),
          parent = environment()
        )
        value_msg <- cli::format_inline(
          "Value in {.arg {nm_x}}: {.val {x_in}}.",
          .envir = msg_envir
        )
        interval_msg <- cli::format_inline(
          "Interval: {.val {label}}.",
          .envir = msg_envir
        )
        cli::cli_abort(c(
          paste0(
            "{.arg {nm_x}} lies inside an existing ",
            "{label_name(label_type)}."
          ),
          i = value_msg,
          i = interval_msg
        ))
      }
    }
  }
  invisible(TRUE)
}

#' Check X Lt Y
#'
#' @param x Numeric scalar; must be less than `y`.
#' @param y Numeric scalar.
#' @param nm_x Argument name used in error messages.
#' @param nm_y Argument name used in error messages.
#' @returns Return value used internally.
#'
#' @noRd
check_x_lt_y <- function(x, y, nm_x, nm_y) {
  if (x >= y) {
    if (x == y) {
      cli::cli_abort("{.arg {nm_x}} equals {.arg {nm_y}} ({.val {x}}).")
    } else {
      cli::cli_abort(paste0(
        "{.arg {nm_x}} ({.val {x}}) is greater than ",
        "{.arg {nm_y}} ({.val {y}})."
      ))
    }
  }
  invisible(TRUE)
}
