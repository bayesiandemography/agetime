# label-construct.R
# Build character labels from breaks or parsed intervals.
# Used by inner_labels.R and inner_standard.R.
#' Construct Labels From Intervals
#'
#' @param intervals An `agetime_intervals` object.
#' @param format_single Rule for one-year labels: `"lower"` or `"upper"`.
#' @param format_multi Rule for multi-year labels: `"include"` or `"exclude"`.
#' @returns Character vector of labels for parsed intervals.
#'
#' When `format_multi = "exclude"`, range labels are rendered with the displayed
#' upper bound reduced by 1 from the internal interval upper bound.
#'
#' @noRd
construct_labels_intervals <- function(intervals,
                                       format_single,
                                       format_multi) {
  is_one <- get_is_one(intervals)
  is_multi <- get_is_multi(intervals)
  is_open_left <- get_is_open_left(intervals)
  is_open_right <- get_is_open_right(intervals)
  is_total <- get_is_total(intervals)
  is_na <- get_is_na(intervals)
  m <- get_m(intervals)
  l <- m[, 1L]
  u <- m[, 2L]
  is_unparseable <- is.na(l) & is.na(u) & !is_na & !is_total
  is_valid <- (
    is_one | is_multi |
      is_open_left | is_open_right |
      is_total | is_na | is_unparseable
  )
  if (any(!is_valid)) {
    cli::cli_abort("Internal error: Invalid interval.")
  }
  ans <- character(length = length(l))
  if (format_single == "lower") {
    ans[is_one] <- as.character(l[is_one])
  } else if (format_single == "upper") {
    ans[is_one] <- as.character(u[is_one])
  } else {
    cli::cli_abort("Internal error: 'format_single' invalid.")
  }
  if (format_multi == "include") {
    ans[is_multi] <- paste(l[is_multi], u[is_multi], sep = "-")
  } else if (format_multi == "exclude") {
    ans[is_multi] <- paste(l[is_multi], u[is_multi] - 1, sep = "-")
  } else {
    cli::cli_abort("Internal error: 'format_multi' invalid.")
  }
  ans[is_open_left] <- paste0("<", u[is_open_left])
  ans[is_open_right] <- paste0(l[is_open_right], "+")
  ans[is_total] <- "Total"
  ans[is_na] <- NA_character_
  ans[is_unparseable] <- NA_character_
  ans
}
#' Construct Labels From Breaks
#'
#' @param breaks Increasing vector of break points.
#' @param is_open_left Whether to include an open-left interval.
#' @param is_open_right Whether to include an open-right interval.
#' @param format_single Rule for one-year labels: `"lower"` or `"upper"`.
#' @param format_multi Rule for multi-year labels: `"include"` or `"exclude"`.
#' @param include_total Whether to append `"Total"`.
#' @param include_na Whether to append `NA`.
#' @returns Character vector of labels for breaks.
#'
#' When `format_multi = "exclude"`, range labels are rendered with the displayed
#' upper bound reduced by 1 from the interval break upper bound.
#'
#' @noRd
construct_labels_breaks <- function(breaks,
                                    is_open_left,
                                    is_open_right,
                                    format_single,
                                    format_multi,
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
  if (format_single == "lower") {
    ans[is_one] <- lower[is_one]
  } else {
    ans[is_one] <- upper[is_one]
  }
  if (format_multi == "exclude") {
    ans[is_multi] <- paste(lower[is_multi],
      upper[is_multi] - 1L,
      sep = "-"
    )
  } else {
    ans[is_multi] <- paste(lower[is_multi],
      upper[is_multi],
      sep = "-"
    )
  }
  if (include_total) {
    ans <- c(ans, "Total")
  }
  if (include_na) {
    ans <- c(ans, NA)
  }
  ans
}
