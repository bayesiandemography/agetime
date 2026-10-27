#' Inner Extend
#'
#' @param labels Vector of labels.
#' @param n Number of intervals to extend by.
#' @param width Interval width.
#' @param include_labels Whether to include original `labels` in output.
#' @param label_type Label domain: `"age"`, `"cohort"`, or `"period"`.
#' @param interpret_single Rule for one-year labels: `"lower"` or `"upper"`.
#' @param interpret_multi Rule for multi-year labels: `"at_upper"`
#' or `"below_upper"`.
#' @param interpret_fail How to handle unparsable labels.
#' @returns Extended label vector (or factor).
#'
#' New intervals start at the highest upper limit among the
#' intervals in `labels` (the levels, if `labels` is a factor).
#' If `width` is `NULL`, width is inferred from the interval
#' with the highest upper limit, using the narrowest interval
#' if there is a tie. `labels` cannot include totals, `NA`s,
#' or intervals that are open on the right.
#'
#' @noRd

inner_extend <- function(labels,
                         n,
                         width,
                         include_labels,
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
    ), call = user_frame())
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
    x = include_labels,
    nm_x = "include_labels"
  )
  intervals <- intervals(
    labels = labels,
    label_type = label_type,
    interpret_single = interpret_single,
    interpret_multi = interpret_multi,
    interpret_fail = interpret_fail
  )
  nm <- label_name(label_type)
  i_orig <- match(seq_along(get_labels_unique_norm_unique(intervals)),
                  get_i_xun_to_xunu(intervals))
  labels_orig <- get_labels_unique(intervals)[i_orig]
  is_total <- get_is_total(intervals)
  if (any(is_total)) {
    label <- labels_orig[is_total][[1L]]
    fix <- paste0("labels[!", label_type, "_is_total(labels)]")
    cli::cli_abort(c(
      "Can't extend {nm}s: {.arg labels} includes a total ({.val {label}}).",
      i = "Remove totals first with {.code {fix}}?"
    ), call = user_frame())
  }
  is_na <- get_is_na(intervals)
  if (any(is_na) || anyNA(labels)) {
    label <- if (any(is_na)) labels_orig[is_na][[1L]] else NA
    fix <- paste0("labels[!", label_type, "_is_missing(labels)]")
    cli::cli_abort(c(
      "Can't extend {nm}s: {.arg labels} includes a missing value ({.val {label}}).",
      i = "Remove missing values first with {.code {fix}}?"
    ), call = user_frame())
  }
  is_open_right <- get_is_open_right(intervals)
  if (any(is_open_right)) {
    label <- labels_orig[is_open_right][[1L]]
    cli::cli_abort(
      "Can't extend {nm}s: {.val {label}} is open on the right.",
      call = user_frame()
    )
  }
  lower <- get_lower(intervals)
  upper <- get_upper(intervals)
  is_valid <- !is.na(upper)
  if (!any(is_valid)) {
    cli::cli_abort("Can't extend {nm}s: no valid {nm}s to extend from.",
                   call = user_frame())
  }
  ## extend from the interval with the highest upper limit,
  ## breaking ties in favour of the narrowest interval
  upper_max <- max(upper[is_valid])
  is_top <- is_valid & (upper == upper_max)
  i_top <- which(is_top)[which.max(lower[is_top])]
  if (!has_width) {
    if (is.infinite(lower[[i_top]])) {
      label <- labels_orig[[i_top]]
      cli::cli_abort(c(
        "Can't infer width of new {nm}s from {.val {label}}, which is open on the left.",
        i = "Supply a value for {.arg width}?"
      ), call = user_frame())
    }
    width <- upper_max - lower[[i_top]]
  }
  breaks <- seq.int(
    from = upper_max,
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
    is_ordered <- is.ordered(labels)
    if (include_labels) {
      levels <- unique(c(levels(labels), ans))
      ans <- c(as.character(labels), ans)
    } else {
      levels <- ans
    }
    ans <- factor(ans, levels = levels, ordered = is_ordered)
  } else {
    if (include_labels) {
      ans <- c(labels, ans)
    }
  }
  ans
}
