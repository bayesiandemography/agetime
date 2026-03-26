
inner_extend <- function(x,
                         n,
                         width,
                         include_x,
                         label_type,
                         label_one,
                         label_multi,
                         unknown_label) {
  is_factor <- is.factor(x)
  x <- to_character_or_factor(x = x,
                              nm_x = "x",
                              length_zero_ok = FALSE)
  check_number(x = n,
               nm_x = "n",
               min = 1L)
  has_width <- !is.null(width)
  if (has_width)
    check_number(x = width,
                 nm_x = "width",
                 min = 1L)
  check_flag(x = include_x,
             nm_x = "include_x")
  tail <- as.character(x[[length(x)]])
  intervals_tail <- intervals(labels = tail,
                              label_type = label_type,
                              label_one = label_one,
                              label_multi = label_multi,
                              unknown_label = unknown_label)
  is_open <- get_is_open(intervals_tail)
  if (is_open)
    cli::cli_abort(c("Final interval is open.",
                     i = "Final interval: {.val {tail}}."))
  is_na <- get_is_na(intervals_tail)
  if (is_na)
    cli::cli_abort("Final interval is NA.")
  is_total <- get_is_total(intervals_tail)
  if (is_total)
    cli::cli_abort(c("Final interval is total.",
                     i = "Final interval: {.val {tail}}."))
  if (!has_width)
    width <- get_width(intervals_tail)
  upper <- get_upper(intervals_tail)
  breaks <- seq.int(from = upper,
                    by = width,
                    length.out = n + 1L)
  ans <- inner_labels(breaks = breaks,
                      label_one = label_one,
                      label_multi = label_multi,
                      is_open_left = FALSE,
                      is_open_right = FALSE,
                      include_total = FALSE,
                      include_na = FALSE)
  if (is_factor) {
    if (include_x) {
      ans <- c(as.character(x), ans)
      levels <- unique(c(levels(x), ans))
      ans <- factor(ans, levels = levels)
    }
    else
      ans <- factor(ans)
  }
  else {
    if (include_x)
      ans <- c(x, ans)
  }
  ans
}
