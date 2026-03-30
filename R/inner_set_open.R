
inner_set_open <- function(x,
                           open,
                           make_open_left,
                           make_open_right,
                           label_type,
                           label_one,
                           label_multi,
                           unknown_label) {
  x <- to_character_or_factor(x = x,
                              nm_x = "x",
                              length_zero_ok = FALSE)
  poputils::check_n(n = open,
                    nm_n = "open",
                    min = 0L,
                    max = NULL,
                    divisible_by = NULL)
  intervals <- intervals(labels = x,
                         label_type = label_type,
                         label_one = label_one,
                         label_multi = label_multi,
                         unknown_label = unknown_label)
  m <- get_m(intervals)
  i_xun_to_xunu <- get_i_xun_to_xunu(intervals)
  i_x_to_xunu <- get_i_x_to_xunu(intervals)
  labels_unique <- get_labels_unique(intervals)
  l <- m[, 1L]
  u <- m[, 2L]
  is_splits_interval <- (!is.na(l) & (l < open)) & (!is.na(u) & (open < u))
  i_splits_interval <- match(TRUE, is_splits_interval, nomatch = 0L)
  if (i_splits_interval > 0L) {
    lab_split <- labels_unique[[i_splits_interval]]
    cli::cli_abort(paste("Setting {.arg open} to {.val {open}} splits",
                         "existing interval {.val {lab_split}}."))
  }
  if (make_open_left) {
    is_le_open <- !is.na(u) & (u <= open)
    i_le_open <- which(is_le_open)
    label_open <- paste0("<", open)
    if (is.factor(x)) {
      is_label_now_open <- i_xun_to_xunu %in% i_le_open
      levels_old <- levels(x)
      levels_new <- ifelse(is_label_now_open, label_open, levels_old)
      x <- factor(x = x,
                  levels = levels_old,
                  labels = labels_new)
    }
    else
      x[i_x_to_xunu %in% i_le_open] <- label_open
  }
  if (make_open_right) {
    is_ge_open <- !is.na(l) & (open <= l)
    i_ge_open <- which(is_ge_open)
    label_open <- paste0(open, "+")
    if (is.factor(x)) {
      is_label_now_open <- i_xun_to_xunu %in% i_ge_open
      levels_old <- levels(x)
      levels_new <- ifelse(is_label_now_open, label_open, levels_old)
      x <- factor(x = x,
                  levels = levels_old,
                  labels = labels_new)
    }
    else
      x[i_x_to_xunu %in% i_ge_open] <- label_open
  }
  x
}

