#' Inner Levels Set Open
#'
#' @param x Vector of labels.
#' @param open_boundary Boundary used to open intervals.
#' @param nm_open_boundary Argument name used in boundary error messages.
#' @param make_open_left Whether to open intervals below `open_boundary` on
#' the left.
#' @param make_open_right Whether to open intervals at or above `open_boundary`
#' on the right.
#' @param label_type Label domain: `"age"`, `"cohort"`, or `"period"`.
#' @param x_one Rule for one-year labels: `"lower"` or `"upper"`.
#' @param x_multi Rule for multi-year labels: `"include"` or `"exclude"`.
#' @param x_fail How to handle unparsable labels.
#' @returns Factor with selected intervals made open-ended in values and levels.
#'
#' Errors when `open_boundary` would split an existing interval.
#'
#' @noRd
inner_levels_set_open <- function(x,
                                  open_boundary,
                                  nm_open_boundary,
                                  make_open_left,
                                  make_open_right,
                                  label_type,
                                  x_one,
                                  x_multi,
                                  x_fail) {
  is_ordered <- is.factor(x) && is.ordered(x)
  x <- to_character_or_factor(
    x = x,
    nm_x = "x",
    length_zero_ok = TRUE
  )
  vals <- if (is.factor(x)) as.character(x) else x
  if (is.factor(x)) {
    labels <- levels(x)
  } else {
    labels <- unique(x)
  }
  check_n(
    n = open_boundary,
    nm_n = nm_open_boundary,
    min = 0L,
    max = NULL,
    divisible_by = NULL
  )
  intervals <- intervals(
    labels = labels,
    label_type = label_type,
    x_one = x_one,
    x_multi = x_multi,
    x_fail = x_fail
  )
  m <- get_m(intervals)
  i_xun_to_xunu <- get_i_xun_to_xunu(intervals)
  labels_unique <- get_labels_unique(intervals)
  l <- m[, 1L]
  u <- m[, 2L]
  is_splits_interval <- (!is.na(l) & (l < open_boundary)) &
    (!is.na(u) & (open_boundary < u))
  i_splits_interval <- match(TRUE, is_splits_interval, nomatch = 0L)
  if (i_splits_interval > 0L) {
    lab_split <- labels_unique[[i_splits_interval]]
    msg_envir <- list2env(
      list(lab_split = lab_split),
      parent = environment()
    )
    msg <- cli::format_inline(
      "Interval {.val {lab_split}} would be split.",
      .envir = msg_envir
    )
    cli::cli_abort(msg)
  }
  if (make_open_left) {
    is_le_open <- !is.na(u) & (u <= open_boundary)
    i_le_open <- which(is_le_open)
    label_open <- paste0("<", open_boundary)
    i_open <- i_le_open
  } else if (make_open_right) {
    is_ge_open <- !is.na(l) & (open_boundary <= l)
    i_ge_open <- which(is_ge_open)
    label_open <- paste0(open_boundary, "+")
    i_open <- i_ge_open
  } else {
    cli::cli_abort("Internal error: no open direction specified.")
  }
  is_label_now_open <- i_xun_to_xunu %in% i_open
  labels_new <- ifelse(is_label_now_open, label_open, labels_unique)
  i_vals_to_xu <- match(vals, labels_unique)
  i_vals_to_xunu <- i_xun_to_xunu[i_vals_to_xu]
  is_val_now_open <- i_vals_to_xunu %in% i_open
  vals_new <- ifelse(is_val_now_open, label_open, vals)
  levels_new <- unique(c(labels_new, label_open))
  levels_new <- levels(inner_levels_sort(
    x = factor(levels_new, levels = levels_new, exclude = NULL),
    decreasing = FALSE,
    label_type = label_type,
    x_one = x_one,
    x_multi = x_multi,
    x_fail = x_fail
  ))
  factor(
    x = vals_new,
    levels = levels_new,
    ordered = is_ordered,
    exclude = NULL
  )
}
