
inner_assert <- function(x,
                         label_type,
                         x_one,
                         x_multi,
                         x_fail,
                         no_overlap,
                         no_gap,
                         no_total,
                         no_na,
                         include_zero,
                         include_open,
                         valid_life) {
  val <- inner_check(x = x,
                     label_type = label_type,
                     x_one = x_one,
                     x_multi = x_multi,
                     x_fail = x_fail,
                     no_overlap = no_overlap,
                     no_gap = no_gap,
                     no_total = no_total,
                     no_na = no_na,
                     include_zero = include_zero,
                     include_open = include_open,
                     valid_life = valid_life)
  throw_assert_error(val)
  invisible(x)
}


inner_check <- function(x,
                        label_type,
                        x_one,
                        x_multi,
                        x_fail,
                        no_overlap,
                        no_gap,
                        no_total,
                        no_na,
                        include_zero,
                        include_open,
                        valid_life) {
  x <- to_character_or_factor(x = x,
                              nm_x = "x",
                              length_zero_ok = TRUE)
  intervals <- intervals(labels = x,
                         label_type = label_type,
                         x_one = x_one,
                         x_multi = x_multi,
                         x_fail = x_fail)
  val_no_overlap <- inner_check_no_overlap(intervals = intervals,
                                           asserted = no_overlap)
  val_no_gap <- inner_check_no_gap(intervals = intervals,
                                   asserted = no_gap)
  val_no_total <- inner_check_no_total(intervals = intervals,
                                       asserted = no_total)
  val_no_na <- inner_check_no_na(intervals = intervals,
                                 asserted = no_na)
  val_include_zero <- inner_check_include_zero(intervals = intervals,
                                               asserted = include_zero)
  val_include_open <- inner_check_include_open(intervals = intervals,
                                               asserted = include_open)
  val_valid_life <- inner_check_valid_life(intervals = intervals,
                                           asserted = valid_life)
  details <- rbind(val_no_overlap,
                   val_no_gap,
                   val_no_total,
                   val_no_na,
                   val_include_zero,
                   val_include_open,
                   val_valid_life)
  details <- details[!is.na(details$asserted), ]
  ok <- all(details$asserted == details$observed)
  list(ok = ok,
       details = details)
}



inner_check_no_overlap <- function(intervals, asserted) {
  int_is_empty <- int_is_empty(intervals)
  if (int_is_empty) {
    observed <- TRUE
  }
  else {
    m <- get_m(intervals)
    is_total <- get_is_total(intervals)
    m_overlap <- does_m1_overlap_m2(m1 = m, m2 = m)
    m_overlap[is_total, ] <- TRUE
    m_overlap[, is_total] <- TRUE
    m_overlap[row(m_overlap) >= col(m_overlap)] <- FALSE
    observed <- !any(m_overlap, na.rm = TRUE)
  }
  if (is.na(asserted))
    comment <- "No test done"
  else if (identical(asserted, observed))
    comment <- "Passed"
  else if (asserted && !observed) {
    labels_unique <- get_labels_unique(intervals)
    i_xun_to_xunu <- get_i_xun_to_xunu(intervals)
    i_overlap <- match(TRUE, m_overlap)
    i1 <- row(m_overlap)[[i_overlap]]
    i2 <- col(m_overlap)[[i_overlap]]
    lab1 <- labels_unique[[match(i1, i_xun_to_xunu)]]
    lab2 <- labels_unique[[match(i2, i_xun_to_xunu)]]
    comment <- sprintf("Example of overlap: '%s' and '%s'",
                       lab1, lab2)
  }
  else ## !asserted && observed
    comment <- "No intervals overlap"
  tibble::tibble_row(check = "no_overlap",
                     asserted = asserted,
                     observed = observed,
                     comment = comment)
}
 
inner_check_no_gap <- function(intervals, asserted) {
  int_is_empty <- int_is_empty(intervals)
  int_has_total <- int_has_total(intervals)
  if (int_is_empty || int_has_total) {
    observed <- TRUE
  }
  else {
    m <- get_m(intervals)
    ord <- order(m[, 1L], m[, 2L])
    m <- m[ord, , drop = FALSE]
    lower <- m[, 1L]
    upper <- m[, 2L]
    uppermax <- cummax(upper)
    n <- length(upper)
    is_gap <- !is.na(lower[-1L]) & (lower[-1L] > uppermax[-n])
    observed <- !any(is_gap)
  }
  if (is.na(asserted))
    comment <- "No test done"
  else if (asserted == observed)
    comment <- "Passed"
  else if (asserted && !observed) {
    i_xun_to_xunu <- get_i_xun_to_xunu(intervals)
    labels_unique <- get_labels_unique(intervals)
    i_gap <- match(TRUE, is_gap)
    i_xunu <- ord[[i_gap + 1L]]
    i_xu <- match(i_xunu, i_xun_to_xunu)
    lab <- labels_unique[[i_xu]]
    comment <- sprintf("Example: gap below '%s'", lab)
  }
  else ## !asserted && observed
    comment <- "No gaps between intervals"
  tibble::tibble_row(check = "no_gap",
                     asserted = asserted,
                     observed = observed,
                     comment = comment)
}


inner_check_no_total <- function(intervals, asserted) {
  int_is_empty <- int_is_empty(intervals)
  if (int_is_empty) {
    observed <- TRUE
  }
  else {
    is_total <- get_is_total(intervals)
    observed <- !any(is_total)
  }  
  if (is.na(asserted))
    comment <- "No test done"
  else if (identical(asserted, observed))
    comment <- "Passed"
  else if (asserted && !observed) {
    labels_unique <- get_labels_unique(intervals)
    i_xun_to_xunu <- get_i_xun_to_xunu(intervals)
    i_total <- match(TRUE, is_total)
    i_xu <- match(i_total, i_xun_to_xunu)
    lab <- labels_unique[[i_xu]]
    comment <- sprintf("Example: '%s'", lab)
  }
  else ## !asserted && observed
    comment <- "No 'Total' age groups"
  tibble::tibble_row(check = "no_total",
                     asserted = asserted,
                     observed = observed,
                     comment = comment)
}


inner_check_no_na <- function(intervals, asserted) {
  int_is_empty <- int_is_empty(intervals)
  if (int_is_empty) {
    observed <- TRUE
  }
  else {
    is_na <- get_is_na(intervals)
    observed <- !any(is_na)
  }
  if (is.na(asserted))
    comment <- "No test done"
  else if (identical(asserted, observed))
    comment <- "Passed"
  else if (asserted && !observed) {
    comment <- "Labels include NA."
  }
  else ## !asserted && observed
    comment <- "No NA labels"
  tibble::tibble_row(check = "no_na",
                     asserted = asserted,
                     observed = observed,
                     comment = comment)
}


inner_check_include_zero <- function(intervals, asserted) {
  int_is_empty <- int_is_empty(intervals)
  m <- get_m(intervals)
  labels_unique <- get_labels_unique(intervals)
  i_xun_to_xunu <- get_i_xun_to_xunu(intervals)
  lower <- m[, 1L]
  if (int_is_empty)
    observed <- FALSE
  else
    observed <- any(lower == 0, na.rm = TRUE)
  if (is.na(asserted))
    comment <- "No test done"
  else if (identical(asserted, observed))
    comment <- "Passed"
  else if (asserted && !observed) {
    if (int_is_empty) {
      comment <- "No intervals."
    }
    else {
      i_min <- which.min(lower)
      i_xu <- match(i_min, i_xun_to_xunu)
      lab <- labels_unique[[i_xu]]
      comment <- sprintf("Lowest interval: '%s'", lab)
    }
  }
  else { ## !asserted && observed
    i_zero <- match(0, lower)
    i_xu <- match(i_zero, i_xun_to_xunu)
    lab <- labels_unique[[i_xu]]
    comment <- sprintf("Example: '%s'", lab)
  }
  tibble::tibble_row(check = "include_zero",
                     asserted = asserted,
                     observed = observed,
                     comment = comment)
}

inner_check_include_open <- function(intervals, asserted) {
  int_is_empty <- int_is_empty(intervals)
  m <- get_m(intervals)
  labels_unique <- get_labels_unique(intervals)
  i_xun_to_xunu <- get_i_xun_to_xunu(intervals)
  upper <- m[, 2L]
  if (int_is_empty)
    observed <- FALSE
  else
    observed <- any(is.infinite(upper))
  if (is.na(asserted))
    comment <- "No test done"
  else if (asserted == observed)
    comment <- "Passed"
  else if (asserted && !observed) {
    if (int_is_empty) {
      comment <- "No intervals."
    }
    else {
      i_max <- which.max(upper)
      i_xu <- match(i_max, i_xun_to_xunu)
      lab <- labels_unique[[i_xu]]
      comment <- sprintf("Highest interval: '%s'", lab)
    }
  }
  else { ## !asserted && observed
    i_open <- match(TRUE, is.infinite(upper))
    i_xu <- match(i_open, i_xun_to_xunu)
    lab <- labels_unique[[i_xu]]
    comment <- sprintf("Example: '%s'", lab)
  }
  tibble::tibble_row(check = "include_open",
                     asserted = asserted,
                     observed = observed,
                     comment = comment)
}



inner_check_valid_life <- function(intervals, asserted) {
  int_is_empty <- int_is_empty(intervals)
  if (int_is_empty)
    observed <- TRUE
  else {
    val <- label_non_life(intervals)
    observed <- is.null(val)
  }
  if (is.na(asserted))
    comment <- "No test done"
  else if (asserted == observed)
    comment <- "Passed"
  else if (asserted && !observed) {
    comment <- sprintf("Not valid for life table: '%s'", val)
  }
  else { ## !asserted && observed
    comment <- "All labels valid for life table."
  }
  tibble::tibble_row(check = "valid_life",
                     asserted = asserted,
                     observed = observed,
                     comment = comment)
}  


throw_assert_error <- function(val) {
  if (!val$ok) {
    details <- val$details
    details <- pillar::pillar(details)
    details <- paste(utils::capture.output(print(details)),
                     collapse = "\n")
    msg <- c("Check failed.", " " = details)
    cli::cli_abort(msg)
  }
  invisible(NULL)
}
