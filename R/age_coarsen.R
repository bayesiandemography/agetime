
## What if intervals are overlapping, or have gaps??

## #' Combine Age Groups
## #'
## #' @inheritParams age_lower
## #' @param lower_new Lower limits of
## #' new, less-detailed age groups.
## #'
## #' @returns Modified version of `x`.
## #'
## #' @examples
## #' x <- c("20-24", "10", "0", "2")
## #' age_coarsen(x, lower = c(0, 20, 40))
## #' age_coarsen_five(x)
## #' age_coarsen_life(x)
## #' @export
## age_coarsen <- function(x,
##                         lower_new,
##                         invalid = c("error", "warn", "silent")) {
##   x <- to_character_or_factor(x = x, nm_x = "x")
##   check_lower_new(lower_new)
##   invalid <- match.arg(invalid)
##   object <- intervals(labels = x,
##                       type = "age",
##                       invalid = invalid)
##   m <- get_m(object)
  
##   i_xun_to_xunu <- get_i_xun_to_xunu(object)
##   i_x_to_x_xunu <- get_i_x_to_xunu(object)
##   labels_unique <- get_labels_unique(object)
##   l <- m[, 1L]
##   u <- m[, 2L]
##   is_lower_new_in_l <- lower_new %in% l
##   i_not_in <- match(FALSE, is_lower_new_in_l, nomatch = 0L)
##   if (i_not_in > 0L) {
##     is_obs <- !is.na(l)
##     l_obs <- l[is_obs]
##     n_obs <- length(l_obs)
##     val_not_in <- lower_new[[i_not_in]]
##     i_interval <- findInterval(lower_not_in, l_obs)
##     if (i_interval < n_obs)
##       alt_val <- l[is_obs][c(i_interval, i_interval + 1L)]
##     else
##       alt_val <- l[is_obs][[i_interval]]
##     n_alt_val <- length(alt_val)
##     cli::cli_abort(c("{.arg lower_last} has a value that is not the lower limit of an existing age group.",
##                      i = "Value that is not a lower limit: {.val {val_not_in}}.",
##                      i = "Closest lower {cli::qty(n_alt_val)} limit{?s}: {.val {alt_val}}."))
##   }
  
##   l_max <- max(l, na.rm = TRUE)
##   if ((lower_last == l_max) && is_open[[i_last]])
##     return(x)
##   i_now_open <- which(l >= lower_last)
##   is_x_now_open <- i_x_to_x_xunu %in% i_now_open
##   label_open <- paste0(lower_last, "+")
##   if (is.factor(x)) {
##     is_label_now_open <- i_xun_to_xunu %in% i_now_open
##     levels <- ifelse(is_label_now_open, label_open, labels_unique)
##     levels <- unique(levels)
##     x <- as.character(x)
##     x[is_x_now_open] <- label_open
##     ans <- factor(x = x,
##                   levels = levels,
##                   exclude = NULL)
##   }
##   else {
##     ans <- x
##     ans[is_x_now_open] <- label_open
##   }
##   ans
## }
