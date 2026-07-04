#' Inner Extend
#'
#' @param labels Vector of labels.
#' @param n Number of intervals to extend by.
#' @param width Interval width.
#' @param include_x Whether to include original `labels` in output.
#' @param label_type Label domain: `"age"`, `"cohort"`, or `"period"`.
#' @param interpret_single Rule for one-year labels: `"lower"` or `"upper"`.
#' @param interpret_multi Rule for multi-year labels: `"include"`
#' or `"exclude"`.
#' @param interpret_fail How to handle unparsable labels.
#' @returns Extended label vector (or factor).
#'
#' If `width` is `NULL`, width is inferred from the final label.
#' The final interval cannot be open, total, or `NA`.
#'
#' @noRd

inner_extend <- function(labels,
                         n,
                         width,
                         include_x,
                         label_type,
                         interpret_single,
                         interpret_multi,
                         interpret_fail) {
  is_factor <- is.factor(labels)
  labels <- to_character_or_factor(
    labels = labels,
    nm_labels = "labels",
    length_zero_ok = TRUE
  )
  if (identical(length(labels), 0L)) {
    cli::cli_abort(c("{.arg labels} has length 0.",
      i = "Supply at least one label to extend from?"
    ))
  }
  check_n(
    n = n,
    nm_n = "n",
    min = 1L,
    max = NULL,
    divisible_by = NULL
  )
  has_width <- !is.null(width)
  if (has_width) {
    check_n(
      n = width,
      nm_n = "width",
      min = 1L,
      max = NULL,
      divisible_by = 1L
    )
  }
  check_flag(
    x = include_x,
    nm_x = "include_x"
  )
  tail <- as.character(labels[[length(labels)]])
  intervals_tail <- intervals(
    labels = tail,
    label_type = label_type,
    interpret_single = interpret_single,
    interpret_multi = interpret_multi,
    interpret_fail = interpret_fail
  )
  is_open <- get_is_open(intervals_tail)
  if (is_open) {
    cli::cli_abort("Final interval {.val {tail}} is open.")
  }
  is_na <- get_is_na(intervals_tail)
  if (is_na) {
    cli::cli_abort("Final interval is {.val {NA}}.")
  }
  is_total <- get_is_total(intervals_tail)
  if (is_total) {
    cli::cli_abort(c("Final interval {.val {tail}} is total.",
      i = paste0(
        "Extend ordinary {label_name(label_type)}s ",
        "and then add total if needed?"
      )
    ))
  }
  if (!has_width) {
    width <- get_width(intervals_tail)
  }
  upper <- get_upper(intervals_tail)
  breaks <- seq.int(
    from = upper,
    by = width,
    length.out = n + 1L
  )
  ans <- inner_labels(
    breaks = breaks,
    format_single = interpret_single,
    format_multi = interpret_multi,
    is_open_left = FALSE,
    is_open_right = FALSE,
    include_total = FALSE,
    include_na = FALSE
  )
  if (is_factor) {
    if (include_x) {
      ans <- c(as.character(labels), ans)
      levels <- unique(c(levels(labels), ans))
      ans <- factor(ans, levels = levels)
    } else {
      ans <- factor(ans)
    }
  } else {
    if (include_x) {
      ans <- c(labels, ans)
    }
  }
  ans
}
