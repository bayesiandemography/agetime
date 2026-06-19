# label-input.R
# Coerce user label vectors and supply domain-specific label helpers.
# Used at the start of inner_* functions and in life-table checks.
#' Find First Non-Life Label
#'
#' @param intervals An `agetime_intervals` object.
#' @returns First non-life-table label, or `NULL` if all are valid.
#'
#' @noRd


label_non_life <- function(intervals) {
  m <- get_m(intervals)
  labels <- get_labels_unique(intervals)
  n <- nrow(m)
  is_equal <- function(x, y) {
    isTRUE(all.equal(x, y, check.attributes = FALSE))
  }
  for (i in seq_len(n)) {
    l <- m[i, 1L]
    u <- m[i, 2L]
    label <- labels[[i]]
    if (is.na(l)) {
      NULL
    } else if (is.infinite(l)) {
      return(label)
    } else if (is_equal(l, 0L)) {
      if (!is_equal(u, 1L)) {
        return(label)
      }
    } else if (is_equal(l, 1L)) {
      if (!is_equal(u, 5L)) {
        return(label)
      }
    } else {
      if (l %% 5L != 0L) {
        return(label)
      }
      if (is.finite(u) && (((u - l) %% 5L) != 0L)) {
        return(label)
      }
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
    NULL
  )
  if (is.null(ans)) {
    cli::cli_abort("Internal error: {.val {label_type}} is not a valid value for {.arg label_type}.")
  }
  ans
}
#' To Character Or Factor
#'
#' @param x Vector of labels.
#' @param nm_x Argument name used in error messages.
#' @param length_zero_ok Argument `length_zero_ok`.
#' @returns Character vector or factor.
#'
#' @noRd

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
  if (identical(length(x), 0L) && !length_zero_ok) {
    cli::cli_abort("{.arg {nm_x}} has length 0.")
  }
  if (is.factor(x)) {
    return(x)
  }
  x_char <- tryCatch(as.character(x), error = function(e) NULL)
  if (is.null(x_char)) {
    cli::cli_abort(c("{.arg {nm_x}} is not a vector of labels.",
      i = "{.arg {nm_x}} has class {.cls {class(x)}}."
    ))
  }
  x_char
}
