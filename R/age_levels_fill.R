#' Fill in Gaps in Age Group Levels
#'
#' Fill in gaps in the levels of `x`.
#'
#' If `x` is not a factor, and so does
#' not have levels, convert it to
#' a factor before filling in the levels.
#' 
#' - `age_levels_fill` adds the age groups
#'   specified by `breaks`.
#' - `age_levels_fill_one` adds age groups with
#'   width 1.
#' - `age_levels_fill_five` adds age groups with
#'   width 5.
#' - `age_levels_fill_ten` adds age groups with
#'   width 10.
#' - `age_levels_fill_life` adds age groups
#'   used by a life table.
#'
#' @inheritParams age_lower
#' @param breaks Boundaries of the
#' the newly-created age groups.
#' (Boundaries supplied by existing
#' age groups can be omitted.)
#'
#' @returns
#' A factor, the same length as `x`.
#' 
#' @examples
#' x <- factor(c("0-4", "20-24"))
#' x
#' age_levels_fill(x) ## uses existing boundaries
#' age_levels_fill(x, breaks = c(8, 12))
#' age_levels_fill_one(x)
#' age_levels_fill_five(x)
#'
#' x <- c("25-29", "0-4")
#' age_levels_fill_ten(x)
#'
#' x <- c("60+", "0")
#' age_levels_fill_life(x)
#'
#' ## levels are used by functions
#' ## such as 'table()'
#' x <- c("30-39", "0-9")
#' x |> table()
#' x |>
#'   age_levels_fill() |>
#'   table()
#'
#' ## sort after filling
#' x |>
#'   age_levels_fill() |>
#'   age_levels_sort() |>
#'   table()
#' @export
age_levels_fill <- function(x,
                            breaks = NULL,
                            x_fail = c("error", "warn", "silent")) {
  x_fail <- match.arg(x_fail)
  inner_levels_fill(x = x,
                    breaks = breaks,
                    width = NULL,
                    label_type = "age",
                    x_one = "lower",
                    x_multi = "exclude",
                    x_fail = x_fail)
}

#' @rdname age_levels_fill
#' @export
age_levels_fill_one <- function(x,
                                x_fail = c("error", "warn", "silent")) {
  x_fail <- match.arg(x_fail)
  inner_levels_fill(x = x,
                    breaks = NULL,
                    width = 1L,
                    label_type = "age",
                    x_one = "lower",
                    x_multi = "exclude",
                    x_fail = x_fail)
}

#' @rdname age_levels_fill
#' @export
age_levels_fill_five <- function(x,
                                 x_fail = c("error", "warn", "silent")) {
  x_fail <- match.arg(x_fail)
  inner_levels_fill(x = x,
                    breaks = NULL,
                    width = 5L,
                    label_type = "age",
                    x_one = "lower",
                    x_multi = "exclude",
                    x_fail = x_fail)
}

#' @rdname age_levels_fill
#' @export
age_levels_fill_ten <- function(x,
                                x_fail = c("error", "warn", "silent")) {
  x_fail <- match.arg(x_fail)
  inner_levels_fill(x = x,
                    breaks = NULL,
                    width = 10L,
                    label_type = "age",
                    x_one = "lower",
                    x_multi = "exclude",
                    x_fail = x_fail)
}


#' @rdname age_levels_fill
#' @export
age_levels_fill_life <- function(x,
                                 x_fail = c("error", "warn", "silent")) {
  x <- to_character_or_factor(x = x,
                              nm_x = "x",
                              length_zero_ok = FALSE)
  x_fail <- match.arg(x_fail)
  if (is.factor(x))
    levels <- levels(x)
  else
    levels <- unique(x)
  if (identical(length(levels), 0L))
    return(factor())
  intervals <- intervals(labels = levels,
                         label_type = "age",
                         x_one = "lower",
                         x_multi = "exclude",
                         x_fail = x_fail)
  val <- label_non_life(intervals)
  if (!is.null(val))
    cli::cli_abort("Label {.val {val}} is not valid for a life table.")
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
      if ((u_prev == 1L) && (l_curr == 5L))
        breaks_gap <- c(u_prev, l_curr)
      else
        breaks_gap <- c(u_prev, seq(from = 5L, to = l_curr, by = 5L))
      labels_gap <-  inner_labels(breaks = breaks_gap,
                                  x_one = "lower",
                                  x_multi = "exclude",
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
  
   
