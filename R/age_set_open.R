
#' Define the Oldest Age Group
#'
#' ## TODO - WEAKEN REQUIREMENT THAT
#' ## lower_last IS AN EXISTING
#' ## 'lower'.
#'
#' If the oldest age group in `x` was not previously
#' open, then calling `age_set_open()` on `x` makes
#' it open.
#'
#' @inheritParams age_lower
#' @param lower_last Lower limit of
#' an existing age group in `x`.
#'
#' @returns Modified version of `x`.
#'
#' @examples
#' x <- c("20-24", "80-84", "100+")
#' age_set_open(x, lower_last = 80)
#' age_set_open(x, lower_last = 20)
#'
#' ## 'x' does not have open age group
#' x <- c("20-24", "80-84", "100")
#' age_set_open(x, 100)
#' age_set_open(x, 80)
#' @export
age_set_open <- function(x,
                         lower_last,
                         unknown_label = c("error", "warn", "silent")) {
  x <- to_character_or_factor(x = x,
                              nm_x = "x",
                              length_zero_ok = FALSE)
  poputils::check_n(n = lower_last,
                    nm_n = "lower_last",
                    min = 0L,
                    max = NULL,
                    divisible_by = NULL)
  unknown_label <- match.arg(unknown_label)
  intervals <- intervals(labels = x,
                      label_type = "age",
                      unknown_label = unknown_label)
  m <- get_m(intervals)
  i_xun_to_xunu <- get_i_xun_to_xunu(intervals)
  i_x_to_x_xunu <- get_i_x_to_xunu(intervals)
  labels_unique <- get_labels_unique(intervals)
  l <- m[, 1L]
  u <- m[, 2L]
  is_open <- is.infinite(u)
  is_open_lt <- is_open & (l < lower_last)
  n_open_lt <- sum(i_xun_to_xunu %in% which(is_open_lt))
  if (n_open_lt > 0L) {
    cli::cli_abort(c(paste("{.arg x} has open {cli::qty(n_open_lt)} age group{?s}",
                           "with lower limit{?s} less than {.arg lower_last}."),
                     i = "Open age group{?s}: {.val {labels_unique[is_open_lt]}}.",
                     i = "{.arg lower_last}: {.val {lower_last}}."))
  }
  i_last <- match(lower_last, l, nomatch = 0L)
  if (i_last == 0L) {
    is_obs <- !is.na(l)
    l_obs <- l[is_obs]
    n_obs <- length(l_obs)
    i_interval <- findInterval(lower_last, l_obs)
    if (i_interval < n_obs)
      alt_val <- l[is_obs][c(i_interval, i_interval + 1L)]
    else
      alt_val <- l[is_obs][[i_interval]]
    n_alt_val <- length(alt_val)
    cli::cli_abort(c("{.arg lower_last} not the lower limit of an existing age group.",
                     i = "{.arg lower_last}: {.val {lower_last}}.",
                     i = "Closest lower {cli::qty(n_alt_val)} limit{?s}: {.val {alt_val}}."))
  }
  l_max <- max(l, na.rm = TRUE)
  if ((lower_last == l_max) && is_open[[i_last]])
    return(x)
  i_now_open <- which(l >= lower_last)
  is_x_now_open <- i_x_to_x_xunu %in% i_now_open
  label_open <- paste0(lower_last, "+")
  if (is.factor(x)) {
    is_label_now_open <- i_xun_to_xunu %in% i_now_open
    levels <- ifelse(is_label_now_open, label_open, labels_unique)
    levels <- unique(levels)
    x <- as.character(x)
    x[is_x_now_open] <- label_open
    ans <- factor(x = x,
                  levels = levels,
                  exclude = NULL)
  }
  else {
    ans <- x
    ans[is_x_now_open] <- label_open
  }
  ans
}
