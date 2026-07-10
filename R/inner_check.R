#' Inner Assert
#'
#' @param labels Vector of labels.
#' @param label_type Label domain: `"age"`, `"cohort"`, or `"period"`.
#' @param interpret_single Rule for one-year labels: `"lower"` or `"upper"`.
#' @param interpret_multi Rule for multi-year labels: `"include"`
#' or `"exclude"`.
#' @param interpret_fail How to handle unparsable labels.
#' @param no_overlap Run the no-overlap check?
#' @param no_gap Run the no-gap check?
#' @param no_total Run the no-total check?
#' @param no_na Run the no-NA check?
#' @param has_zero Run the has-zero check?
#' @param has_open Run the has-open check?
#' @param valid_life Run the valid-life check?
#' @returns `labels`, invisibly, or an error if checks fail.
#'
#' @noRd

inner_assert <- function(labels,
                         label_type,
                         interpret_single,
                         interpret_multi,
                         interpret_fail,
                         no_overlap,
                         no_gap,
                         no_total,
                         no_na,
                         has_zero,
                         has_open,
                         valid_life) {
  val <- inner_check(
    labels = labels,
    label_type = label_type,
    interpret_single = interpret_single,
    interpret_multi = interpret_multi,
    interpret_fail = interpret_fail,
    no_overlap = no_overlap,
    no_gap = no_gap,
    no_total = no_total,
    no_na = no_na,
    has_zero = has_zero,
    has_open = has_open,
    valid_life = valid_life
  )
  throw_assert_error(val)
  invisible(labels)
}
#' Inner Check
#'
#' @param labels Vector of labels.
#' @param label_type Label domain: `"age"`, `"cohort"`, or `"period"`.
#' @param interpret_single Rule for one-year labels: `"lower"` or `"upper"`.
#' @param interpret_multi Rule for multi-year labels: `"include"`
#' or `"exclude"`.
#' @param interpret_fail How to handle unparsable labels.
#' @param no_overlap Run the no-overlap check?
#' @param no_gap Run the no-gap check?
#' @param no_total Run the no-total check?
#' @param no_na Run the no-NA check?
#' @param has_zero Run the has-zero check?
#' @param has_open Run the has-open check?
#' @param valid_life Run the valid-life check?
#' @returns List with `ok` and check `details`.
#'
#' @noRd


inner_check <- function(labels,
                        label_type,
                        interpret_single,
                        interpret_multi,
                        interpret_fail,
                        no_overlap,
                        no_gap,
                        no_total,
                        no_na,
                        has_zero,
                        has_open,
                        valid_life) {
  labels <- to_character_or_factor(
    labels = labels,
    nm_labels = "labels",
    length_zero_ok = TRUE
  )
  intervals <- intervals(
    labels = labels,
    label_type = label_type,
    interpret_single = interpret_single,
    interpret_multi = interpret_multi,
    interpret_fail = interpret_fail
  )
  details_list <- list()
  if (isTRUE(no_overlap)) {
    details_list <- c(
      details_list,
      list(inner_check_no_overlap(intervals = intervals))
    )
  }
  if (isTRUE(no_gap)) {
    details_list <- c(
      details_list,
      list(inner_check_no_gap(intervals = intervals))
    )
  }
  if (isTRUE(no_total)) {
    details_list <- c(
      details_list,
      list(inner_check_no_total(intervals = intervals))
    )
  }
  if (isTRUE(no_na)) {
    details_list <- c(
      details_list,
      list(inner_check_no_na(intervals = intervals))
    )
  }
  if (isTRUE(has_zero)) {
    details_list <- c(
      details_list,
      list(inner_check_has_zero(intervals = intervals))
    )
  }
  if (isTRUE(has_open)) {
    details_list <- c(
      details_list,
      list(inner_check_has_open(intervals = intervals))
    )
  }
  if (isTRUE(valid_life)) {
    details_list <- c(
      details_list,
      list(inner_check_valid_life(intervals = intervals))
    )
  }
  details <- if (length(details_list) == 0L) {
    tibble::tibble(
      check = character(),
      passed = logical(),
      comment = character()
    )
  } else {
    dplyr::bind_rows(details_list)
  }
  ok <- if (nrow(details) == 0L) {
    TRUE
  } else {
    all(details$passed)
  }
  list(
    ok = ok,
    details = details
  )
}
#' Inner Check No Overlap
#'
#' @param intervals An `agetime_intervals` object.
#' @returns One-row tibble with check result details.
#'
#' @noRd


inner_check_no_overlap <- function(intervals) {
  int_is_empty <- int_is_empty(intervals)
  if (int_is_empty) {
    passed <- TRUE
  } else {
    m <- get_m(intervals)
    is_total <- get_is_total(intervals)
    m_overlap <- does_m1_overlap_m2(m1 = m, m2 = m)
    m_overlap[is_total, ] <- TRUE
    m_overlap[, is_total] <- TRUE
    m_overlap[row(m_overlap) >= col(m_overlap)] <- FALSE
    passed <- !any(m_overlap, na.rm = TRUE)
  }
  if (identical(passed, TRUE)) {
    comment <- NA_character_
  } else {
    labels_unique <- get_labels_unique(intervals)
    i_xun_to_xunu <- get_i_xun_to_xunu(intervals)
    i_overlap <- match(TRUE, m_overlap)
    i1 <- row(m_overlap)[[i_overlap]]
    i2 <- col(m_overlap)[[i_overlap]]
    lab1 <- labels_unique[[match(i1, i_xun_to_xunu)]]
    lab2 <- labels_unique[[match(i2, i_xun_to_xunu)]]
    comment <- sprintf(
      "Example of overlap: '%s' and '%s'",
      lab1, lab2
    )
  }
  tibble::tibble_row(
    check = "no_overlap",
    passed = passed,
    comment = comment
  )
}
#' Inner Check No Gap
#'
#' @param intervals An `agetime_intervals` object.
#' @returns One-row tibble with check result details.
#'
#' @noRd

inner_check_no_gap <- function(intervals) {
  int_is_empty <- int_is_empty(intervals)
  int_has_total <- int_has_total(intervals)
  if (int_is_empty || int_has_total) {
    passed <- TRUE
  } else {
    m <- get_m(intervals)
    ord <- order(m[, 1L], m[, 2L])
    m <- m[ord, , drop = FALSE]
    lower <- m[, 1L]
    upper <- m[, 2L]
    uppermax <- cummax(upper)
    n <- length(upper)
    is_gap <- !is.na(lower[-1L]) & (lower[-1L] > uppermax[-n])
    passed <- !any(is_gap)
  }
  if (identical(passed, TRUE)) {
    comment <- NA_character_
  } else {
    i_xun_to_xunu <- get_i_xun_to_xunu(intervals)
    labels_unique <- get_labels_unique(intervals)
    i_gap <- match(TRUE, is_gap)
    i_xunu <- ord[[i_gap + 1L]]
    i_xu <- match(i_xunu, i_xun_to_xunu)
    lab <- labels_unique[[i_xu]]
    comment <- sprintf("Example: gap below '%s'", lab)
  }
  tibble::tibble_row(
    check = "no_gap",
    passed = passed,
    comment = comment
  )
}
#' Inner Check No Total
#'
#' @param intervals An `agetime_intervals` object.
#' @returns One-row tibble with check result details.
#'
#' @noRd


inner_check_no_total <- function(intervals) {
  int_is_empty <- int_is_empty(intervals)
  if (int_is_empty) {
    passed <- TRUE
  } else {
    is_total <- get_is_total(intervals)
    passed <- !any(is_total)
  }
  if (identical(passed, TRUE)) {
    comment <- NA_character_
  } else {
    labels_unique <- get_labels_unique(intervals)
    i_xun_to_xunu <- get_i_xun_to_xunu(intervals)
    i_total <- match(TRUE, is_total)
    i_xu <- match(i_total, i_xun_to_xunu)
    lab <- labels_unique[[i_xu]]
    comment <- sprintf("Example: '%s'", lab)
  }
  tibble::tibble_row(
    check = "no_total",
    passed = passed,
    comment = comment
  )
}
#' Inner Check No Na
#'
#' @param intervals An `agetime_intervals` object.
#' @returns One-row tibble with check result details.
#'
#' @noRd


inner_check_no_na <- function(intervals) {
  int_is_empty <- int_is_empty(intervals)
  if (int_is_empty) {
    passed <- TRUE
  } else {
    is_na <- get_is_na(intervals)
    passed <- !any(is_na)
  }
  if (identical(passed, TRUE)) {
    comment <- NA_character_
  } else {
    comment <- "Labels include NA."
  }
  tibble::tibble_row(
    check = "no_na",
    passed = passed,
    comment = comment
  )
}
#' Inner Check Has Zero
#'
#' @param intervals An `agetime_intervals` object.
#' @returns One-row tibble with check result details.
#'
#' @noRd


inner_check_has_zero <- function(intervals) {
  int_is_empty <- int_is_empty(intervals)
  m <- get_m(intervals)
  labels_unique <- get_labels_unique(intervals)
  i_xun_to_xunu <- get_i_xun_to_xunu(intervals)
  lower <- m[, 1L]
  if (int_is_empty) {
    passed <- FALSE
  } else {
    passed <- any(lower == 0, na.rm = TRUE)
  }
  if (identical(passed, TRUE)) {
    comment <- NA_character_
  } else if (int_is_empty) {
    comment <- "No intervals."
  } else {
    i_min <- which.min(lower)
    i_xu <- match(i_min, i_xun_to_xunu)
    lab <- labels_unique[[i_xu]]
    comment <- sprintf("Lowest interval: '%s'", lab)
  }
  tibble::tibble_row(
    check = "has_zero",
    passed = passed,
    comment = comment
  )
}
#' Inner Check Has Open
#'
#' @param intervals An `agetime_intervals` object.
#' @returns One-row tibble with check result details.
#'
#' @noRd

inner_check_has_open <- function(intervals) {
  int_is_empty <- int_is_empty(intervals)
  m <- get_m(intervals)
  labels_unique <- get_labels_unique(intervals)
  i_xun_to_xunu <- get_i_xun_to_xunu(intervals)
  lower <- m[, 1L]
  upper <- m[, 2L]
  is_open_left <- is.infinite(lower) & is.finite(upper)
  is_open_right <- is.finite(lower) & is.infinite(upper)
  is_open <- is_open_left | is_open_right
  if (int_is_empty) {
    passed <- FALSE
  } else {
    passed <- any(is_open)
  }
  if (identical(passed, TRUE)) {
    comment <- NA_character_
  } else if (int_is_empty) {
    comment <- "No intervals."
  } else {
    i_max <- which.max(upper)
    i_xu <- match(i_max, i_xun_to_xunu)
    lab <- labels_unique[[i_xu]]
    comment <- sprintf("Highest interval: '%s'", lab)
  }
  tibble::tibble_row(
    check = "has_open",
    passed = passed,
    comment = comment
  )
}
#' Inner Check Valid Life
#'
#' @param intervals An `agetime_intervals` object.
#' @returns One-row tibble with check result details.
#'
#' @noRd


inner_check_valid_life <- function(intervals) {
  int_is_empty <- int_is_empty(intervals)
  if (int_is_empty) {
    passed <- TRUE
  } else {
    val <- label_non_life(intervals)
    passed <- is.null(val)
  }
  if (identical(passed, TRUE)) {
    comment <- NA_character_
  } else {
    comment <- sprintf("Not valid for life table: '%s'", val)
  }
  tibble::tibble_row(
    check = "valid_life",
    passed = passed,
    comment = comment
  )
}
#' Throw Assert Error
#'
#' @param val Result object from `inner_check()`.
#' @returns `NULL`, invisibly, or aborts when checks fail.
#'
#' @noRd


throw_assert_error <- function(val) {
  if (!val$ok) {
    details <- val$details[!val$details$passed, , drop = FALSE]
    details <- pillar::pillar(details)
    details <- paste(utils::capture.output(print(details)),
      collapse = "\n"
    )
    msg <- c("Check failed.", " " = details)
    cli::cli_abort(msg)
  }
  invisible(NULL)
}
