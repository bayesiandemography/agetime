
## inner_complete <- function(x,
##                            breaks,
##                            label_type,
##                            x_one,
##                            x_multi,
##                            x_fail) {
##   x <- to_character_or_factor(x = x,
##                               nm_x = "x",
##                               length_zero_ok = FALSE)
##   if (is.null(breaks))
##     breaks <- integer()
##   else if (is.numeric(breaks) && (length(breaks) == 0L))
##     breaks <- integer()
##   else
##     breaks <- check_incr_nonneg_integers(x = breaks,
##                                          nm_x = "breaks",
##                                          min_length = 1L)
##   if (is.factor(x))
##     levels <- levels(x)
##   else
##     levels <- unique(x)
##   if (length(levels) >= 2L) {
##     intervals <- intervals(labels = levels,
##                            label_type = label_type,
##                            x_one = x_one,
##                            x_multi = x_multi,
##                            x_fail = x_fail)
##     m <- get_m(intervals)
##     labels <- get_labels_unique(intervals)
##     ord <- order(m[, 1L], m[, 2L])
##     m <- m[ord, , drop = FALSE]
##     labels <- labels[ord]
##     labels_new <- as.list(labels)
##     lower <- m[, 1L]
##     upper <- m[, 2L]
##     n <- nrow(m)
##     for (i in seq.int(from = 2L, to = n)) {
##       gap <- lower[[i]] - upper[[i - 1L]]
##       if (is.finite(gap) && (gap > 0L)) {
##         if (gap %% width != 0L)
##           cli::cli_abort(c(paste("Gap between {.val {labels[[i]]}} and {.val {labels[[i - 1L]]}}",
##                                  "not divisible by {.arg width}."),
##                          i = "Gap: {.val {gap}}.",
##                          i = "{.arg width}: {.val {with}}."))
##       }
##       breaks <- seq(from = upper[[i - 1L]],
##                     to = lower[[i]],
##                     by = width)
##       labels_gap <- inner_labels(breaks = breaks,
##                                  x_one = x_one,
##                                  x_multi = x_multi,
##                                  is_open_left = FALSE,
##                                  is_open_right = FALSE,
##                                  include_total = FALSE,
##                                  include_na = FALSE)
##       labels_new[[i]] <- c(labels_new[[i]], labels_gap)
##     }

## inner_complete <- function(x,
##                            width,
##                            label_type,
##                            x_one,
##                            x_multi,
##                            x_fail) {
##   x <- to_character_or_factor(x = x,
##                               nm_x = "x",
##                               length_zero_ok = FALSE)
##   check_n(n = width,
##           nm_n = "width",
##           min = 1L,
##           max = NULL,
##           divisible_by = 1L)
##   if (is.factor(x))
##     levels <- levels(x)
##   else
##     levels <- unique(x)
##   if (length(levels) >= 2L) {
##     intervals <- intervals(labels = levels,
##                            label_type = label_type,
##                            x_one = x_one,
##                            x_multi = x_multi,
##                            x_fail = x_fail)
##     m <- get_m(intervals)
##     labels <- get_labels_unique(intervals)
##     ord <- order(m[, 1L], m[, 2L])
##     m <- m[ord, , drop = FALSE]
##     labels <- labels[ord]
##     labels_new <- as.list(labels)
##     lower <- m[, 1L]
##     upper <- m[, 2L]
##     n <- nrow(m)
##     for (i in seq.int(from = 2L, to = n)) {
##       gap <- lower[[i]] - upper[[i - 1L]]
##       if (is.finite(gap) && (gap > 0L)) {
##         if (gap %% width != 0L)
##           cli::cli_abort(c(paste("Gap between {.val {labels[[i]]}} and {.val {labels[[i - 1L]]}}",
##                                  "not divisible by {.arg width}."),
##                          i = "Gap: {.val {gap}}.",
##                          i = "{.arg width}: {.val {with}}."))
##       }
##       breaks <- seq(from = upper[[i - 1L]],
##                     to = lower[[i]],
##                     by = width)
##       labels_gap <- inner_labels(breaks = breaks,
##                                  x_one = x_one,
##                                  x_multi = x_multi,
##                                  is_open_left = FALSE,
##                                  is_open_right = FALSE,
##                                  include_total = FALSE,
##                                  include_na = FALSE)
##       labels_new[[i]] <- c(labels_new[[i]], labels_gap)
##     }
    
##   }
##   for (len in length_gap) {
##     if (len > 0L) {
      
## }

## inner_complete(c("0-4", "10-14", "20-24"),
##                width = 5,
##                label_type = "age",
##                x_one = "lower",
##                x_multi = "exclude",
##                x_fail = "error")
