#' Inner Assert
#'
#' @param labels Vector of labels.
#' @param label_type Label domain: `"age"`, `"cohort"`, or `"period"`.
#' @param interpret_single Rule for one-year labels: `"lower"` or `"upper"`.
#' @param interpret_multi Rule for multi-year labels: `"at_upper"`
#' or `"below_upper"`.
#' @param interpret_fail How to handle unparsable labels.
#' @param on Universe to check: `"levels"` or `"values"`.
#' @param no_overlap Run the no-overlap check?
#' @param no_gap Run the no-gap check?
#' @param no_total Run the no-total check?
#' @param no_na Run the no-NA check?
#' @param no_open_left Run the no-open-left check?
#' @param no_open_right Run the no-open-right check?
#' @param has_zero Run the has-zero check?
#' @param has_open_left Run the has-open-left check?
#' @param has_open_right Run the has-open-right check?
#' @param valid_life Run the valid-life check?
#' @param call Environment of the user-facing function,
#' used to report where an error occurred.
#' @returns `labels`, invisibly, or an error if checks fail.
#'
#' @noRd

inner_assert <- function(labels,
                         label_type,
                         interpret_single,
                         interpret_multi,
                         interpret_fail,
                         on,
                         no_overlap,
                         no_gap,
                         no_total,
                         no_na,
                         no_open_left,
                         no_open_right,
                         has_zero,
                         has_open_left,
                         has_open_right,
                         valid_life,
                         call = parent.frame()) {
  val <- inner_diagnose(
    labels = labels,
    label_type = label_type,
    interpret_single = interpret_single,
    interpret_multi = interpret_multi,
    interpret_fail = interpret_fail,
    on = on,
    no_overlap = no_overlap,
    no_gap = no_gap,
    no_total = no_total,
    no_na = no_na,
    no_open_left = no_open_left,
    no_open_right = no_open_right,
    has_zero = has_zero,
    has_open_left = has_open_left,
    has_open_right = has_open_right,
    valid_life = valid_life
  )
  throw_assert_error(val = val, label_type = label_type, call = call)
  invisible(labels)
}
#' Inner Diagnose
#'
#' @param labels Vector of labels.
#' @param label_type Label domain: `"age"`, `"cohort"`, or `"period"`.
#' @param interpret_single Rule for one-year labels: `"lower"` or `"upper"`.
#' @param interpret_multi Rule for multi-year labels: `"at_upper"`
#' or `"below_upper"`.
#' @param interpret_fail How to handle unparsable labels.
#' @param on Universe to check: `"levels"` or `"values"`.
#' @param no_overlap Run the no-overlap check?
#' @param no_gap Run the no-gap check?
#' @param no_total Run the no-total check?
#' @param no_na Run the no-NA check?
#' @param no_open_left Run the no-open-left check?
#' @param no_open_right Run the no-open-right check?
#' @param has_zero Run the has-zero check?
#' @param has_open_left Run the has-open-left check?
#' @param has_open_right Run the has-open-right check?
#' @param valid_life Run the valid-life check?
#' @returns List with `ok` and condition `details`.
#'
#' @noRd


inner_diagnose <- function(labels,
                        label_type,
                        interpret_single,
                        interpret_multi,
                        interpret_fail,
                        on,
                        no_overlap,
                        no_gap,
                        no_total,
                        no_na,
                        no_open_left,
                        no_open_right,
                        has_zero,
                        has_open_left,
                        has_open_right,
                        valid_life) {
  labels <- to_character_or_factor(
    labels = labels,
    nm_labels = "labels",
    length_zero_ok = TRUE
  )
  on <- match.arg(on, choices = c("levels", "values"))
  labels_for_intervals <- labels
  if (identical(on, "values") && is.factor(labels)) {
    labels_for_intervals <- droplevels(labels)
  }
  intervals <- intervals(
    labels = labels_for_intervals,
    label_type = label_type,
    interpret_single = interpret_single,
    interpret_multi = interpret_multi,
    interpret_fail = interpret_fail
  )
  details_list <- list()
  if (isTRUE(no_overlap)) {
    details_list <- c(
      details_list,
      list(inner_diagnose_no_overlap(intervals = intervals, on = on))
    )
  }
  if (isTRUE(no_gap)) {
    details_list <- c(
      details_list,
      list(inner_diagnose_no_gap(intervals = intervals, on = on))
    )
  }
  if (isTRUE(no_total)) {
    details_list <- c(
      details_list,
      list(inner_diagnose_no_total(intervals = intervals, on = on))
    )
  }
  if (isTRUE(no_na)) {
    details_list <- c(
      details_list,
      list(inner_diagnose_no_na(intervals = intervals, on = on))
    )
  }
  if (isTRUE(no_open_left)) {
    details_list <- c(
      details_list,
      list(inner_diagnose_no_open_left(intervals = intervals, on = on))
    )
  }
  if (isTRUE(no_open_right)) {
    details_list <- c(
      details_list,
      list(inner_diagnose_no_open_right(intervals = intervals, on = on))
    )
  }
  if (isTRUE(has_zero)) {
    details_list <- c(
      details_list,
      list(inner_diagnose_has_zero(intervals = intervals, on = on))
    )
  }
  if (isTRUE(has_open_left)) {
    details_list <- c(
      details_list,
      list(inner_diagnose_has_open_left(intervals = intervals, on = on))
    )
  }
  if (isTRUE(has_open_right)) {
    details_list <- c(
      details_list,
      list(inner_diagnose_has_open_right(intervals = intervals, on = on))
    )
  }
  if (isTRUE(valid_life)) {
    details_list <- c(
      details_list,
      list(inner_diagnose_valid_life(intervals = intervals, on = on))
    )
  }
  details <- if (length(details_list) == 0L) {
    tibble::tibble(
      condition = character(),
      passed = logical(),
      comment = character()
    )
  } else {
    vctrs::vec_rbind(!!!details_list)
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
#' Inner Diagnose No Overlap
#'
#' @param intervals An `agetime_intervals` object.
#' @param on Universe checked: `"levels"` or `"values"`.
#' @returns One-row tibble with condition result details.
#'
#' @noRd


inner_diagnose_no_overlap <- function(intervals, on) {
  int_is_empty <- int_is_empty(intervals)
  synonyms <- NULL
  if (int_is_empty) {
    passed <- TRUE
  } else {
    m <- get_m(intervals)
    is_total <- get_is_total(intervals)
    m_overlap <- does_m1_overlap_m2(m1 = m, m2 = m)
    m_overlap[is_total, ] <- TRUE
    m_overlap[, is_total] <- TRUE
    m_overlap[row(m_overlap) >= col(m_overlap)] <- FALSE
    synonyms <- find_synonyms(intervals)
    passed <- !any(m_overlap, na.rm = TRUE) && is.null(synonyms)
  }
  if (identical(passed, TRUE)) {
    comment <- NA_character_
  } else if (!is.null(synonyms)) {
    comment <- sprintf(
      "Example of overlap among %s: '%s' and '%s' describe the same interval",
      on, synonyms[[1L]], synonyms[[2L]]
    )
  } else {
    labels_unique <- get_labels_unique(intervals)
    i_xun_to_xunu <- get_i_xun_to_xunu(intervals)
    i_overlap <- match(TRUE, m_overlap)
    i1 <- row(m_overlap)[[i_overlap]]
    i2 <- col(m_overlap)[[i_overlap]]
    lab1 <- labels_unique[[match(i1, i_xun_to_xunu)]]
    lab2 <- labels_unique[[match(i2, i_xun_to_xunu)]]
    comment <- sprintf(
      "Example of overlap among %s: '%s' and '%s'",
      on, lab1, lab2
    )
  }
  tibble::tibble_row(
    condition = "no_overlap",
    passed = passed,
    comment = comment
  )
}
#' Find Labels That Describe the Same Interval
#'
#' Two different labels, such as `"0"` and `"infant"`, are
#' synonyms if they describe the same interval. Repeated copies
#' of the same label are not synonyms. Labels for totals and
#' missing values are ignored, since these are handled by other
#' conditions.
#'
#' @param intervals An `agetime_intervals` object.
#' @returns `NULL` if there are no synonyms, or a length-2
#' character vector with an example pair of synonyms.
#'
#' @noRd
find_synonyms <- function(intervals) {
  labels_unique <- get_labels_unique(intervals)
  i_xun_to_xunu <- get_i_xun_to_xunu(intervals)
  m <- get_m(intervals)
  is_na <- get_is_na(intervals)
  is_total <- get_is_total(intervals)
  is_unparsed <- is.na(m[, 1L]) & is.na(m[, 2L])
  is_ignore <- (is_na | is_total | is_unparsed)[i_xun_to_xunu]
  ## different labels with the same normalized label, or
  ## different normalized labels with the same interval
  key <- vctrs::vec_group_id(vctrs::data_frame(lower = m[, 1L], upper = m[, 2L]))
  key_xu <- key[i_xun_to_xunu]
  key_xu[is_ignore] <- NA
  is_dup <- !is.na(key_xu) & duplicated(key_xu)
  if (!any(is_dup)) {
    return(NULL)
  }
  i_second <- match(TRUE, is_dup)
  i_first <- match(key_xu[[i_second]], key_xu)
  c(labels_unique[[i_first]], labels_unique[[i_second]])
}


#' Inner Diagnose No Gap
#'
#' @param intervals An `agetime_intervals` object.
#' @param on Universe checked: `"levels"` or `"values"`.
#' @returns One-row tibble with condition result details.
#'
#' @noRd

inner_diagnose_no_gap <- function(intervals, on) {
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
    comment <- sprintf("Example: gap among %s below '%s'", on, lab)
  }
  tibble::tibble_row(
    condition = "no_gap",
    passed = passed,
    comment = comment
  )
}
#' Inner Diagnose No Total
#'
#' @param intervals An `agetime_intervals` object.
#' @param on Universe checked: `"levels"` or `"values"`.
#' @returns One-row tibble with condition result details.
#'
#' @noRd


inner_diagnose_no_total <- function(intervals, on) {
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
    comment <- sprintf("Example among %s: '%s'", on, lab)
  }
  tibble::tibble_row(
    condition = "no_total",
    passed = passed,
    comment = comment
  )
}
#' Inner Diagnose No Na
#'
#' @param intervals An `agetime_intervals` object.
#' @param on Universe checked: `"levels"` or `"values"`.
#' @returns One-row tibble with condition result details.
#'
#' @noRd


inner_diagnose_no_na <- function(intervals, on) {
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
    comment <- sprintf("%s include NA.", on_sentence_start(on))
  }
  tibble::tibble_row(
    condition = "no_na",
    passed = passed,
    comment = comment
  )
}
#' Inner Diagnose No Open Left
#'
#' @param intervals An `agetime_intervals` object.
#' @param on Universe checked: `"levels"` or `"values"`.
#' @returns One-row tibble with condition result details.
#'
#' @noRd

inner_diagnose_no_open_left <- function(intervals, on) {
  int_is_empty <- int_is_empty(intervals)
  if (int_is_empty) {
    passed <- TRUE
  } else {
    m <- get_m(intervals)
    is_open_left <- is.infinite(m[, 1L]) & is.finite(m[, 2L])
    passed <- !any(is_open_left)
  }
  if (identical(passed, TRUE)) {
    comment <- NA_character_
  } else {
    labels_unique <- get_labels_unique(intervals)
    i_xun_to_xunu <- get_i_xun_to_xunu(intervals)
    i_open <- match(TRUE, is_open_left)
    i_xu <- match(i_open, i_xun_to_xunu)
    lab <- labels_unique[[i_xu]]
    comment <- sprintf("Example among %s: '%s'", on, lab)
  }
  tibble::tibble_row(
    condition = "no_open_left",
    passed = passed,
    comment = comment
  )
}
#' Inner Diagnose No Open Right
#'
#' @param intervals An `agetime_intervals` object.
#' @param on Universe checked: `"levels"` or `"values"`.
#' @returns One-row tibble with condition result details.
#'
#' @noRd

inner_diagnose_no_open_right <- function(intervals, on) {
  int_is_empty <- int_is_empty(intervals)
  if (int_is_empty) {
    passed <- TRUE
  } else {
    m <- get_m(intervals)
    is_open_right <- is.finite(m[, 1L]) & is.infinite(m[, 2L])
    passed <- !any(is_open_right)
  }
  if (identical(passed, TRUE)) {
    comment <- NA_character_
  } else {
    labels_unique <- get_labels_unique(intervals)
    i_xun_to_xunu <- get_i_xun_to_xunu(intervals)
    i_open <- match(TRUE, is_open_right)
    i_xu <- match(i_open, i_xun_to_xunu)
    lab <- labels_unique[[i_xu]]
    comment <- sprintf("Example among %s: '%s'", on, lab)
  }
  tibble::tibble_row(
    condition = "no_open_right",
    passed = passed,
    comment = comment
  )
}
#' Inner Diagnose Has Zero
#'
#' @param intervals An `agetime_intervals` object.
#' @param on Universe checked: `"levels"` or `"values"`.
#' @returns One-row tibble with condition result details.
#'
#' @noRd


inner_diagnose_has_zero <- function(intervals, on) {
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
    comment <- sprintf("No %s.", on)
  } else {
    i_min <- which.min(lower)
    i_xu <- match(i_min, i_xun_to_xunu)
    lab <- labels_unique[[i_xu]]
    comment <- sprintf("Lowest interval among %s: '%s'", on, lab)
  }
  tibble::tibble_row(
    condition = "has_zero",
    passed = passed,
    comment = comment
  )
}
#' Inner Diagnose Has Open Left
#'
#' @param intervals An `agetime_intervals` object.
#' @param on Universe checked: `"levels"` or `"values"`.
#' @returns One-row tibble with condition result details.
#'
#' @noRd

inner_diagnose_has_open_left <- function(intervals, on) {
  int_is_empty <- int_is_empty(intervals)
  m <- get_m(intervals)
  labels_unique <- get_labels_unique(intervals)
  i_xun_to_xunu <- get_i_xun_to_xunu(intervals)
  lower <- m[, 1L]
  is_open_left <- is.infinite(lower) & is.finite(m[, 2L])
  if (int_is_empty) {
    passed <- FALSE
  } else {
    passed <- any(is_open_left)
  }
  if (identical(passed, TRUE)) {
    comment <- NA_character_
  } else if (int_is_empty) {
    comment <- sprintf("No %s.", on)
  } else {
    i_min <- which.min(ifelse(is.finite(lower), lower, Inf))
    i_xu <- match(i_min, i_xun_to_xunu)
    lab <- labels_unique[[i_xu]]
    comment <- sprintf("Lowest interval among %s: '%s'", on, lab)
  }
  tibble::tibble_row(
    condition = "has_open_left",
    passed = passed,
    comment = comment
  )
}
#' Inner Diagnose Has Open Right
#'
#' @param intervals An `agetime_intervals` object.
#' @param on Universe checked: `"levels"` or `"values"`.
#' @returns One-row tibble with condition result details.
#'
#' @noRd

inner_diagnose_has_open_right <- function(intervals, on) {
  int_is_empty <- int_is_empty(intervals)
  m <- get_m(intervals)
  labels_unique <- get_labels_unique(intervals)
  i_xun_to_xunu <- get_i_xun_to_xunu(intervals)
  lower <- m[, 1L]
  upper <- m[, 2L]
  is_open_right <- is.finite(lower) & is.infinite(upper)
  if (int_is_empty) {
    passed <- FALSE
  } else {
    passed <- any(is_open_right)
  }
  if (identical(passed, TRUE)) {
    comment <- NA_character_
  } else if (int_is_empty) {
    comment <- sprintf("No %s.", on)
  } else {
    i_max <- which.max(upper)
    i_xu <- match(i_max, i_xun_to_xunu)
    lab <- labels_unique[[i_xu]]
    comment <- sprintf("Highest interval among %s: '%s'", on, lab)
  }
  tibble::tibble_row(
    condition = "has_open_right",
    passed = passed,
    comment = comment
  )
}
#' Inner Diagnose Valid Life
#'
#' @param intervals An `agetime_intervals` object.
#' @param on Universe checked: `"levels"` or `"values"`.
#' @returns One-row tibble with condition result details.
#'
#' @noRd


inner_diagnose_valid_life <- function(intervals, on) {
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
    comment <- sprintf(
      "Not valid for life table among %s: '%s'",
      on, val
    )
  }
  tibble::tibble_row(
    condition = "valid_life",
    passed = passed,
    comment = comment
  )
}
#' Sentence-Start Form of `on`
#'
#' @param on `"levels"` or `"values"`.
#' @returns Capitalized noun for the start of a sentence.
#'
#' @noRd
on_sentence_start <- function(on) {
  if (identical(on, "levels")) {
    "Levels"
  } else {
    "Values"
  }
}
#' Throw Assert Error
#'
#' The message names each failed condition, followed by
#' the comment from `inner_diagnose()`.
#'
#' @param val Result object from `inner_diagnose()`.
#' @param label_type Label domain: `"age"`, `"cohort"`, or `"period"`.
#' @param call Environment of the user-facing function,
#' used to report where the error occurred.
#' @returns `NULL`, invisibly, or aborts when checks fail.
#'
#' @noRd
throw_assert_error <- function(val, label_type, call) {
  if (!val$ok) {
    details <- val$details[!val$details$passed, , drop = FALSE]
    conditions <- details$condition
    comments <- details$comment
    is_no_stop <- !is.na(comments) & !grepl("\\.$", comments)
    comments[is_no_stop] <- paste0(comments[is_no_stop], ".")
    label <- label_name(label_type)
    label <- paste0(toupper(substr(label, 1L, 1L)), substring(label, 2L))
    n <- length(conditions)
    msg <- paste0(label, " labels fail {cli::qty(n)}check{?s} {.arg {conditions}}.")
    bullets <- paste0("{.arg {conditions[[", seq_len(n), "]]}}: {comments[[", seq_len(n), "]]}")
    names(bullets) <- rep("x", times = n)
    cli::cli_abort(c(msg, bullets), call = call)
  }
  invisible(NULL)
}
