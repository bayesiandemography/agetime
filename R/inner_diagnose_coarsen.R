#' Inner Diagnose Coarsen
#'
#' @param labels,to Source and target labels.
#' @param include_equals Whether identical classifications are allowed.
#' @param interpret_fail How to handle uninterpretable labels.
#' @param label_type Label domain: `"age"`, `"period"`, or `"cohort"`.
#' @param interpret_single Rule for one-year labels.
#' @param interpret_multi Rule for multi-year labels, or `NULL`.
#' @returns List with `ok` and condition `details`.
#' @noRd
inner_diagnose_coarsen <- function(labels, to, include_equals, interpret_fail,
                                    label_type, interpret_single, interpret_multi) {
  check_flag(include_equals, nm_x = "include_equals")
  labels <- as.character(to_character_or_factor(labels, "labels", TRUE))
  to <- as.character(to_character_or_factor(to, "to", TRUE))
  if (label_type != "age") {
    interpret_multi <- resolve_interpret_multi(
      interpret_multi = interpret_multi,
      labels = labels,
      labels_other = to,
      label_type = label_type,
      interpret_single = interpret_single
    )
  }
  source <- intervals(labels, label_type, interpret_single, interpret_multi, interpret_fail,
                      nm_labels = "labels")
  target <- intervals(to, label_type, interpret_single, interpret_multi, interpret_fail,
                      nm_labels = "to")
  m_source <- get_m(source)[get_i_x_to_xunu(source), , drop = FALSE]
  m_target <- get_m(target)[get_i_x_to_xunu(target), , drop = FALSE]
  details <- list(
    coarsen_diagnose_intervals(m_source, labels, "labels", label_type),
    coarsen_diagnose_intervals(m_target, to, "to", label_type)
  )
  if (details[[1L]]$passed) {
    details <- c(details, list(coarsen_diagnose_overlap(m_source, labels, "labels")))
  }
  if (details[[2L]]$passed) {
    details <- c(details, list(coarsen_diagnose_overlap(m_target, to, "to")))
  }
  passed <- all(vapply(details, function(x) x$passed, logical(1)))
  if (passed) {
    contained <- outer(m_source[, 1L], m_target[, 1L], `>=`) &
      outer(m_source[, 2L], m_target[, 2L], `<=`)
    bad <- which(rowSums(contained) != 1L)
    details <- c(details, list(tibble::tibble_row(
      condition = "contained",
      passed = length(bad) == 0L,
      comment = if (length(bad)) {
        sprintf("Source '%s' in '%s' does not fit wholly inside a single target interval in '%s'.",
                labels[[bad[[1L]]]], arg_nm("labels"), arg_nm("to"))
      } else NA_character_
    )))
    passed <- length(bad) == 0L
  }
  if (passed) {
    assignment <- if (nrow(m_source)) max.col(contained, ties.method = "first") else integer(0)
    comment <- coarsen_coverage_comment(m_source, m_target, assignment, to,
                                       label_type, interpret_single, interpret_multi)
    details <- c(details, list(tibble::tibble_row(
      condition = "complete",
      passed = is.na(comment),
      comment = comment
    )))
    passed <- is.na(comment)
  }
  if (passed && !as.logical(include_equals)) {
    details <- c(details, list(tibble::tibble_row(
      condition = "not_equal",
      passed = nrow(m_source) > nrow(m_target),
      comment = if (nrow(m_source) == nrow(m_target)) {
        sprintf("Source and target describe the same classification; no %ss would be merged.",
                label_name(label_type))
      } else NA_character_
    )))
  }
  details <- vctrs::vec_rbind(!!!details)
  list(ok = all(details$passed), details = details)
}

#' Check for Non-Interval Labels Before Coarsening
#'
#' @param m Matrix of intervals for all input values.
#' @param labels Original labels.
#' @param arg Argument name, `"labels"` or `"to"`.
#' @param label_type Label domain: `"age"`, `"period"`, or `"cohort"`.
#' @returns One-row diagnostic tibble.
#' @noRd
coarsen_diagnose_intervals <- function(m, labels, arg, label_type) {
  bad <- which(is.na(m[, 1L]) | is.na(m[, 2L]))
  tibble::tibble_row(
    condition = paste0(arg, "_intervals"),
    passed = length(bad) == 0L,
    comment = if (length(bad)) {
      sprintf("Label '%s' in '%s' is not %s %s interval; totals and missing categories cannot be aggregated by %s.",
              labels[[bad[[1L]]]], arg_nm(arg),
              if (label_type == "age") "an" else "a", label_type, label_type)
    } else NA_character_
  )
}

#' Check for Overlaps Before Coarsening
#'
#' @param m Matrix of valid intervals for all input values.
#' @param labels Original labels.
#' @param arg Argument name, `"labels"` or `"to"`.
#' @returns One-row diagnostic tibble.
#' @noRd
coarsen_diagnose_overlap <- function(m, labels, arg) {
  ord <- order(m[, 1L], m[, 2L])
  n <- length(ord)
  bad <- if (n < 2L) integer(0) else which(
    m[ord[-1L], 1L] < cummax(m[ord, 2L])[-n]
  )
  tibble::tibble_row(
    condition = paste0(arg, "_no_overlap"),
    passed = length(bad) == 0L,
    comment = if (length(bad)) {
      i <- bad[[1L]]
      sprintf("Intervals '%s' and '%s' in '%s' overlap or repeat.",
              labels[[ord[[i]]]], labels[[ord[[i + 1L]]]], arg_nm(arg))
    } else NA_character_
  )
}

#' Describe the First Gap Within a Coarsening Target
#'
#' @param m_source,m_target Matrices of source and target intervals.
#' @param assignment Target index for each source interval.
#' @param to Original target labels.
#' @param label_type Label domain: `"age"`, `"period"`, or `"cohort"`.
#' @param interpret_single Rule for one-year labels.
#' @param interpret_multi Rule for multi-year labels.
#' @returns A failure comment, or `NA_character_` if coverage is complete.
#' @noRd
coarsen_coverage_comment <- function(m_source, m_target, assignment, to,
                                      label_type, interpret_single, interpret_multi) {
  for (j in seq_len(nrow(m_target))) {
    children <- m_source[assignment == j, , drop = FALSE]
    children <- children[order(children[, 1L]), , drop = FALSE]
    lower <- c(m_target[j, 1L], children[, 2L])
    upper <- c(children[, 1L], m_target[j, 2L])
    bad <- which(lower < upper)
    if (!length(bad)) {
      next
    }
    i <- bad[[1L]]
    gap <- if (is.infinite(lower[[i]])) {
      paste0("<", upper[[i]])
    } else if (is.infinite(upper[[i]])) {
      paste0(lower[[i]], "+")
    } else if (upper[[i]] - lower[[i]] == 1) {
      as.character(if (interpret_single == "lower") lower[[i]] else upper[[i]])
    } else {
      end <- if (interpret_multi == "below_upper") upper[[i]] - 1 else upper[[i]]
      paste0(lower[[i]], "-", end)
    }
    return(sprintf("Target '%s' in '%s' is not fully covered; source %ss '%s' are missing from '%s'.",
                   to[[j]], arg_nm("to"), label_type, gap, arg_nm("labels")))
  }
  NA_character_
}

#' Throw Coarsening Assertion Error
#'
#' @param val Result of `inner_diagnose_coarsen()`.
#' @param label_type Label domain: `"age"`, `"period"`, or `"cohort"`.
#' @param x_arg,to_arg Argument names used in messages.
#' @param call Execution environment of the function to name in errors.
#' @returns `NULL`, invisibly, or aborts when checks fail.
#' @noRd
throw_coarsen_assert_error <- function(val, label_type, x_arg, to_arg, call) {
  if (!val$ok) {
    comments <- val$details$comment[!val$details$passed]
    bullets <- paste0("{comments[[", seq_along(comments), "]]}")
    names(bullets) <- rep("x", length(bullets))
    label <- label_name(label_type)
    label <- paste0(toupper(substr(label, 1L, 1L)), substring(label, 2L))
    cli::cli_abort(c(
      "{label} labels in {.arg {x_arg}} cannot be coarsened to {.arg {to_arg}}.",
      bullets
    ), call = call)
  }
  invisible(NULL)
}
