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
    cli::cli_abort(paste0(
      "Internal error: {.val {label_type}} is not a valid value for ",
      "{.arg label_type}."
    ))
  }
  ans
}
#' To Character Or Factor
#'
#' @param labels Vector of labels.
#' @param nm_labels Argument name used in error messages.
#' @param length_zero_ok Argument `length_zero_ok`.
#' @returns Character vector or factor.
#'
#' @noRd

to_character_or_factor <- function(labels, nm_labels, length_zero_ok) {
  if (is.data.frame(labels)) {
    cli::cli_abort("{.arg {nm_labels}} is a data frame.", call = user_frame())
  }
  if (is.list(labels)) {
    cli::cli_abort("{.arg {nm_labels}} is a list.", call = user_frame())
  }
  if (!is.null(dim(labels))) {
    cli::cli_abort("{.arg {nm_labels}} is not a vector.", call = user_frame())
  }
  if (identical(length(labels), 0L) && !length_zero_ok) {
    cli::cli_abort("{.arg {nm_labels}} has length 0.", call = user_frame())
  }
  if (is.factor(labels)) {
    return(labels)
  }
  labels_char <- tryCatch(as.character(labels), error = function(e) NULL)
  if (is.null(labels_char)) {
    cli::cli_abort(c("{.arg {nm_labels}} is not a vector of labels.",
      i = "{.arg {nm_labels}} has class {.cls {class(labels)}}."
    ), call = user_frame())
  }
  labels_char
}

#' Copy Names of Input Labels to Result
#'
#' Results of element-wise functions, such as `age_lower()`,
#' keep the names of `labels`, if any, following the
#' convention of base R functions such as `nchar()`.
#' Unnamed labels give unnamed results.
#'
#' @param x Vector with one value per element of `labels`.
#' @param labels Vector of labels, as supplied by the user.
#' @returns `x` with the names of `labels`.
#'
#' @noRd
copy_labels_names <- function(x, labels) {
  names(x) <- names(labels)
  x
}


#' Find the Frame of the User-Facing Function
#'
#' Return the frame of the outermost \pkg{agetime} function on the
#' call stack, which is the function the user called. Used so that
#' error messages report, for instance, `age_coarsen()` rather than
#' an internal helper.
#'
#' @returns An environment.
#'
#' @noRd
user_frame <- function() {
  ns <- topenv(environment(user_frame))
  n <- sys.nframe()
  for (i in seq_len(n - 1L)) {
    env_fun <- environment(sys.function(i))
    if (is.environment(env_fun) && identical(topenv(env_fun), ns)) {
      return(sys.frame(i))
    }
  }
  parent.frame()
}
