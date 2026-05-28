## Can omit 'breaks' and 'width', but cannot give values for both
inner_levels_fill <- function(x,
                              breaks,
                              width,
                              label_type,
                              x_one,
                              x_multi,
                              x_fail) {
  x <- to_character_or_factor(x = x,
                              nm_x = "x",
                              length_zero_ok = FALSE)
  if (is.factor(x))
    levels <- levels(x)
  else
    levels <- unique(x)
  if (identical(length(levels), 0L))
    return(factor())
  intervals <- intervals(labels = levels,
                         label_type = label_type,
                         x_one = x_one,
                         x_multi = x_multi,
                         x_fail = x_fail)
  has_breaks <- length(breaks) > 0L
  has_width <- length(width) > 0L
  if (has_breaks && has_width)
    cli::cli_abort("Internal error: 'breaks' and 'width' both supplied.")
  if (has_breaks) {
    check_incr_nonneg_integers(x = breaks,
                               nm_x = "breaks",
                               min_length = 1L)
    check_not_in_intervals(x = breaks,
                           nm_x = "breaks",
                           intervals = intervals,
                           nm_intervals = "x")
    check_in_limits_intervals(x = breaks,
                              nm_x = "breaks",
                              intervals = intervals,
                              nm_intervals = "x")
  }
  m <- get_m(intervals)
  n <- nrow(m)
  can_have_gaps <- n >= 2L
  if (!can_have_gaps) {
    if (!is.factor(x))
      x <- factor(x)
    return(x)
  }
  labels <- get_labels_unique_norm_unique(intervals)
  ord <- order(m[, 1L], m[, 2L])
  m <- m[ord, , drop = FALSE]
  lower <- m[, 1L]
  uppermax <- cummax(m[, 2L])
  labels <- labels[ord]
  levels_extra <- vector(mode = "list", length = n)
  for (i in seq.int(from = 2L, to = n)) {
    l_curr <- lower[[i]]
    u_prev <- uppermax[[i - 1L]]
    diff <- l_curr - u_prev
    is_gap <- is.finite(diff) && (diff > 0L)
    if (is_gap) {
      if (has_breaks) {
        breaks_internal <- breaks[(u_prev < breaks) & (breaks < l_curr)]
        breaks_gap <- c(u_prev, breaks_internal, l_curr)
      }
      else if (has_width) {
        if (diff %% width != 0L) {
          label_curr <- labels[[i]]
          label_prev <- labels[[i - 1L]]
          cli::cli_abort(c("Gap between {.val {label_prev}} and {.val {label_curr}} is not divisible by {.val {width}}.",
                           i = "Choose a different {.arg width}?"))
        }
        breaks_gap <- seq.int(from = u_prev,
                              to = l_curr,
                              by = width)
      }
      else
        breaks_gap <- c(u_prev, l_curr)
      labels_gap <-  inner_labels(breaks = breaks_gap,
                                  x_one = x_one,
                                  x_multi = x_multi,
                                  is_open_left = FALSE,
                                  is_open_right = FALSE,
                                  include_total = FALSE,
                                  include_na = FALSE)
      levels_extra[[i - 1L]] <- labels_gap
    }
  }
  unord <- match(seq_len(n), ord)
  levels_extra <- levels_extra[unord]
  i_xun_to_xunu <- get_i_xun_to_xunu(intervals)
  levels_extra <- levels_extra[i_xun_to_xunu]
  levels_old <- as.list(levels)
  levels <- rbind(levels_old, levels_extra)
  levels <- unlist(levels)
  levels <- unique(levels)
  if (is.factor(x))
    levels(x) <- levels
  else
    x <- factor(x, levels = levels, exclude = NULL)
  x
}
    
    
  
   
## inner_complete(c("0-4", "10-14", "20-24"),
##                width = 5,
##                label_type = "age",
##                x_one = "lower",
##                x_multi = "exclude",
##                x_fail = "error")
