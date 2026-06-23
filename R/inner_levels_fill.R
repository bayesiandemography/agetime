#' Inner Levels Fill Prep
#'
#' @param x Vector of labels.
#' @param breaks Increasing vector of break points.
#' @param nm_x Argument name used in error messages.
#' @returns List with prepared labels and factor metadata.
#'
#' @noRd
inner_levels_fill_prep <- function(x,
                                   breaks,
                                   nm_x) {
  is_factor <- is.factor(x)
  is_ordered <- is_factor && is.ordered(x)
  x <- to_character_or_factor(
    x = x,
    nm_x = nm_x,
    length_zero_ok = TRUE
  )
  if (is.factor(x)) {
    levels <- levels(x)
  } else {
    levels <- unique(x)
  }
  list(
    x = x,
    is_factor = is_factor,
    is_ordered = is_ordered,
    levels = levels
  )
}
#' Inner Levels Fill Empty
#'
#' @param levels Existing label levels.
#' @param breaks Increasing vector of break points.
#' @param is_ordered Whether output factor should be ordered.
#' @param label_one Rule for one-year labels: `"lower"` or `"upper"`.
#' @param label_multi Rule for multi-year labels: `"include"` or `"exclude"`.
#' @returns Empty factor when `levels` is empty, else `NULL`.
#'
#' @noRd
inner_levels_fill_empty <- function(levels,
                                    breaks,
                                    is_ordered,
                                    label_one,
                                    label_multi) {
  if (length(levels) > 0L) {
    return(NULL)
  }
  if (length(breaks) > 0L) {
    check_incr_nonneg_integers(
      x = breaks,
      nm_x = "breaks",
      min_length = 1L
    )
    labels_new <- inner_labels(
      breaks = breaks,
      label_one = label_one,
      label_multi = label_multi,
      is_open_left = FALSE,
      is_open_right = FALSE,
      include_total = FALSE,
      include_na = FALSE
    )
    return(factor(
      x = character(0),
      levels = labels_new,
      ordered = is_ordered,
      exclude = NULL
    ))
  }
  if (is_ordered) {
    return(factor(levels = character(), ordered = TRUE))
  }
  factor()
}
#' Inner Levels Fill Factor
#'
#' @param x Vector of labels.
#' @param levels Existing label levels.
#' @param is_ordered Whether output factor should be ordered.
#' @returns Factor with updated levels.
#'
#' @noRd

inner_levels_fill_factor <- function(x,
                                     levels,
                                     is_ordered) {
  vals <- if (is.factor(x)) as.character(x) else x
  factor(
    x = vals,
    levels = levels,
    ordered = is_ordered,
    exclude = NULL
  )
}
#' Inner Levels Fill
#'
#' @param x Vector of labels.
#' @param breaks Increasing vector of break points.
#' @param width Interval width.
#' @param label_type Label domain: `"age"`, `"cohort"`, or `"period"`.
#' @param x_one Rule for one-year labels: `"lower"` or `"upper"`.
#' @param x_multi Rule for multi-year labels: `"include"` or `"exclude"`.
#' @param x_fail How to handle unparsable labels.
#' @returns Factor with gap levels filled.
#'
#' Cannot supply both `breaks` and `width`; provide at most one.
#'
#' @noRd


inner_levels_fill <- function(x,
                              breaks,
                              width,
                              label_type,
                              x_one,
                              x_multi,
                              x_fail) {
  prep <- inner_levels_fill_prep(
    x = x,
    breaks = breaks,
    nm_x = "x"
  )
  empty <- inner_levels_fill_empty(
    levels = prep$levels,
    breaks = breaks,
    is_ordered = prep$is_ordered,
    label_one = x_one,
    label_multi = x_multi
  )
  if (!is.null(empty)) {
    return(empty)
  }
  x <- prep$x
  levels <- prep$levels
  intervals <- intervals(
    labels = levels,
    label_type = label_type,
    x_one = x_one,
    x_multi = x_multi,
    x_fail = x_fail
  )
  has_breaks <- length(breaks) > 0L
  has_width <- length(width) > 0L
  if (has_breaks && has_width) {
    cli::cli_abort("Internal error: 'breaks' and 'width' both supplied.")
  }
  if (has_breaks) {
    check_incr_nonneg_integers(
      x = breaks,
      nm_x = "breaks",
      min_length = 1L
    )
    check_not_in_intervals(
      x = breaks,
      nm_x = "breaks",
      intervals = intervals,
      nm_intervals = "x",
      label_type = label_type
    )
    check_in_limits_intervals(
      x = breaks,
      nm_x = "breaks",
      intervals = intervals,
      nm_intervals = "x",
      label_type = label_type
    )
  }
  m <- get_m(intervals)
  n <- nrow(m)
  can_have_gaps <- n >= 2L
  if (!can_have_gaps) {
    if (!is.factor(x)) {
      x <- factor(x)
    }
    return(x)
  }
  labels <- get_labels_unique_norm_unique(intervals)
  labels_unique <- get_labels_unique(intervals)
  i_xun_to_xunu <- get_i_xun_to_xunu(intervals)
  labels_display <- labels_unique[match(seq_along(labels), i_xun_to_xunu)]
  ord <- order(m[, 1L], m[, 2L])
  m <- m[ord, , drop = FALSE]
  lower <- m[, 1L]
  uppermax <- cummax(m[, 2L])
  labels <- labels[ord]
  labels_display <- labels_display[ord]
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
      } else if (has_width) {
        if (diff %% width != 0L) {
          label_curr <- labels[[i]]
          label_prev <- labels[[i - 1L]]
          msg_envir <- list2env(
            list(
              label_prev = label_prev,
              label_curr = label_curr,
              width = width
            ),
            parent = environment()
          )
          msg <- cli::format_inline(
            paste0(
              "Gap between {.val {label_prev}} and {.val {label_curr}} ",
              "is not divisible by {.val {width}}."
            ),
            .envir = msg_envir
          )
          cli::cli_abort(c(
            msg,
            i = "Choose a different {.arg width}?"
          ))
        }
        breaks_gap <- seq.int(
          from = u_prev,
          to = l_curr,
          by = width
        )
      } else {
        breaks_gap <- c(u_prev, l_curr)
      }
      labels_gap <- inner_labels(
        breaks = breaks_gap,
        label_one = x_one,
        label_multi = x_multi,
        is_open_left = FALSE,
        is_open_right = FALSE,
        include_total = FALSE,
        include_na = FALSE
      )
      levels_extra[[i - 1L]] <- labels_gap
    }
  }
  levels_old <- as.list(labels_display)
  levels <- rbind(levels_old, levels_extra)
  levels <- unlist(levels)
  levels <- unique(levels)
  inner_levels_fill_factor(
    x = x,
    levels = levels,
    is_ordered = prep$is_ordered
  )
}
#' Inner Levels Fill Life
#'
#' @param x Vector of labels.
#' @param x_fail How to handle unparsable labels.
#' @returns Factor with life-table gap levels filled.
#'
#' @noRd

inner_levels_fill_life <- function(x,
                                   x_fail) {
  prep <- inner_levels_fill_prep(
    x = x,
    breaks = NULL,
    nm_x = "x"
  )
  empty <- inner_levels_fill_empty(
    levels = prep$levels,
    breaks = NULL,
    is_ordered = prep$is_ordered,
    label_one = "lower",
    label_multi = "exclude"
  )
  if (!is.null(empty)) {
    return(empty)
  }
  x <- prep$x
  levels <- prep$levels
  intervals <- intervals(
    labels = levels,
    label_type = "age",
    x_one = "lower",
    x_multi = "exclude",
    x_fail = x_fail
  )
  val <- label_non_life(intervals)
  if (!is.null(val)) {
    cli::cli_abort("Label {.val {val}} is not valid for a life table.")
  }
  m <- get_m(intervals)
  n <- nrow(m)
  can_have_gaps <- n >= 2L
  if (!can_have_gaps) {
    if (!is.factor(x)) {
      x <- factor(x)
    }
    return(x)
  }
  labels <- get_labels_unique_norm_unique(intervals)
  labels_unique <- get_labels_unique(intervals)
  i_xun_to_xunu <- get_i_xun_to_xunu(intervals)
  labels_display <- labels_unique[match(seq_along(labels), i_xun_to_xunu)]
  ord <- order(m[, 1L], m[, 2L])
  m <- m[ord, , drop = FALSE]
  lower <- m[, 1L]
  uppermax <- cummax(m[, 2L])
  labels <- labels[ord]
  labels_display <- labels_display[ord]
  levels_extra <- vector(mode = "list", length = n)
  for (i in seq.int(from = 2L, to = n)) {
    l_curr <- lower[[i]]
    u_prev <- uppermax[[i - 1L]]
    diff <- l_curr - u_prev
    is_gap <- is.finite(diff) && (diff > 0L)
    if (is_gap) {
      if ((u_prev == 1L) && (l_curr == 5L)) {
        breaks_gap <- c(u_prev, l_curr)
      } else if ((u_prev == 1L) && (l_curr > 5L)) {
        breaks_gap <- c(1L, seq.int(from = 5L, to = l_curr, by = 5L))
      } else {
        breaks_gap <- seq.int(from = u_prev, to = l_curr, by = 5L)
      }
      labels_gap <- inner_labels(
        breaks = breaks_gap,
        label_one = "lower",
        label_multi = "exclude",
        is_open_left = FALSE,
        is_open_right = FALSE,
        include_total = FALSE,
        include_na = FALSE
      )
      levels_extra[[i - 1L]] <- labels_gap
    }
  }
  levels_old <- as.list(labels_display)
  levels <- rbind(levels_old, levels_extra)
  levels <- unlist(levels)
  levels <- unique(levels)
  inner_levels_fill_factor(
    x = x,
    levels = levels,
    is_ordered = prep$is_ordered
  )
}
