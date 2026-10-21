#' Resolve the Value of 'interpret_multi'
#'
#' If `interpret_multi` is supplied, check it and return it.
#' If `interpret_multi` is `NULL`, return `"at_upper"`, and
#' give a message if any multi-year label has a width,
#' under `"at_upper"`, that is one less than a multiple
#' of 5 (eg `"1990-1994"`), since such labels were probably
#' written using the `"below_upper"` convention.
#'
#' @param interpret_multi `NULL`, `"at_upper"`, or `"below_upper"`.
#' @param labels Vector of labels.
#' @param labels_other A second vector of labels read by the
#' same call, such as `to` in `period_coarsen_to()`, or `NULL`.
#' @param label_type Label domain: `"cohort"` or `"period"`.
#' @param interpret_single Rule for one-year labels: `"lower"` or `"upper"`.
#' @returns `"at_upper"` or `"below_upper"`.
#'
#' @noRd
resolve_interpret_multi <- function(interpret_multi,
                                    labels,
                                    labels_other,
                                    label_type,
                                    interpret_single) {
  if (!is.null(interpret_multi)) {
    return(match.arg(interpret_multi, choices = c("at_upper", "below_upper")))
  }
  ans <- "at_upper"
  candidates <- c(labels_to_check(labels), labels_to_check(labels_other))
  if (length(candidates) == 0L) {
    return(ans)
  }
  intervals <- intervals(
    labels = candidates,
    label_type = label_type,
    interpret_single = interpret_single,
    interpret_multi = ans,
    interpret_fail = "silent"
  )
  m <- get_m(intervals)
  width <- m[, 2L] - m[, 1L]
  is_suspect <- is.finite(width) & (width > 1) & ((width + 1) %% 5 == 0)
  i_xun_to_xunu <- get_i_xun_to_xunu(intervals)
  i_suspect <- match(TRUE, is_suspect[i_xun_to_xunu])
  if (!is.na(i_suspect)) {
    label <- get_labels_unique(intervals)[[i_suspect]]
    row <- i_xun_to_xunu[[i_suspect]]
    l <- m[row, 1L]
    u <- m[row, 2L]
    w <- width[[row]]
    cli::cli_inform(c(
      "Interpreting {.val {label}} as [{l}, {u}), which has width {w}.",
      i = paste0(
        "If {.val {label}} should instead be interpreted as [{l}, {u + 1}), ",
        "set {.arg interpret_multi} to {.val {\"below_upper\"}}."
      ),
      i = "Supplying a value for {.arg interpret_multi} silences this message."
    ))
  }
  ans
}

#' Labels to Check When Resolving 'interpret_multi'
#'
#' @param labels Vector of labels, or `NULL`.
#' @returns Character vector of distinct labels (levels, for a
#' factor), or `NULL` if `labels` cannot hold labels.
#'
#' @noRd
labels_to_check <- function(labels) {
  if (is.factor(labels)) {
    levels(labels)
  } else if (is.atomic(labels) && !is.null(labels)) {
    unique(as.character(labels))
  } else {
    NULL
  }
}
