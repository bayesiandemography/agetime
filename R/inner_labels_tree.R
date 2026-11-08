#' Inner Labels Tree
#'
#' Create labels for a reporting tree: leaves built from `breaks`,
#' plus internal nodes given as labels, plus (optionally) the root,
#' `"Missing"`. Returned in tree order.
#'
#' @param breaks Boundaries between leaves.
#' @param nodes Labels for internal nodes other than the root,
#' or `NULL`.
#' @param label_type Label domain: `"age"`, `"cohort"`, or `"period"`.
#' @param format_single Rule for one-year labels: `"lower"` or `"upper"`.
#' Also used to interpret `nodes`.
#' @param format_multi Rule for multi-year labels: `"at_upper"` or
#' `"below_upper"`. Also used to interpret `nodes`.
#' @param is_open_left Whether the first leaf is open on the left.
#' @param is_open_right Whether the last leaf is open on the right.
#' @param include_missing Whether to append `"Missing"`.
#' @returns Character vector of labels.
#'
#' @noRd
inner_labels_tree <- function(breaks,
                              nodes,
                              label_type,
                              format_single,
                              format_multi,
                              is_open_left,
                              is_open_right,
                              include_missing) {
  check_flag(x = include_missing, nm_x = "include_missing")
  leaves <- inner_labels(
    breaks = breaks,
    format_single = format_single,
    format_multi = format_multi,
    is_open_left = is_open_left,
    is_open_right = is_open_right,
    include_total = FALSE,
    include_missing = FALSE
  )
  nodes <- tree_check_nodes(
    nodes = nodes,
    leaves = leaves,
    breaks = breaks,
    label_type = label_type,
    format_single = format_single,
    format_multi = format_multi,
    is_open_left = is_open_left,
    is_open_right = is_open_right
  )
  labels <- c(leaves, nodes)
  intervals <- intervals(
    labels = labels,
    label_type = label_type,
    interpret_single = format_single,
    interpret_multi = format_multi,
    interpret_fail = "error"
  )
  m <- get_m(intervals)
  labels_unique <- get_labels_unique(intervals)
  i_xun_to_xunu <- get_i_xun_to_xunu(intervals)
  label_row <- function(k) labels_unique[[match(k, i_xun_to_xunu)]]
  comment <- tree_diagnose_comment(
    m = m,
    label_keep = label_row,
    noun = paste0(label_name(label_type), "s")
  )
  if (!is.na(comment)) {
    cli::cli_abort("Internal error: labels do not form a tree. {comment}") # nocov
  }
  ord <- tree_order(m)
  ans <- vapply(ord, label_row, "")
  if (include_missing) {
    ans <- c(ans, "Missing")
  }
  ans
}


#' Check and Standardise Labels for Internal Nodes
#'
#' @param nodes Labels for internal nodes, or `NULL`.
#' @param leaves Labels for leaves.
#' @param breaks Boundaries between leaves.
#' @param label_type,format_single,format_multi,is_open_left,is_open_right
#' As for `inner_labels_tree()`.
#' @returns Character vector of standardised node labels.
#'
#' @noRd
tree_check_nodes <- function(nodes,
                             leaves,
                             breaks,
                             label_type,
                             format_single,
                             format_multi,
                             is_open_left,
                             is_open_right) {
  if (is.null(nodes)) {
    return(character())
  }
  if (!is.character(nodes)) {
    cli::cli_abort(c(
      "{.arg nodes} is not a character vector.",
      i = "{.arg nodes} has class {.cls {class(nodes)}}."
    ), call = user_frame())
  }
  if (length(nodes) == 0L) {
    return(character())
  }
  if (anyNA(nodes)) {
    cli::cli_abort(c(
      "{.arg nodes} has {.val {NA}}.",
      i = "To include a category for missing values, use {.arg include_missing}."
    ), call = user_frame())
  }
  noun <- label_name(label_type)
  noun_broad <- paste("Broad", noun)
  intervals <- intervals(
    labels = nodes,
    label_type = label_type,
    interpret_single = format_single,
    interpret_multi = format_multi,
    interpret_fail = "error"
  )
  i_row <- get_i_x_to_xunu(intervals)
  is_missing <- get_is_missing(intervals)[i_row]
  is_total <- get_is_total(intervals)[i_row]
  if (any(is_missing)) {
    lab <- nodes[[match(TRUE, is_missing)]]
    cli::cli_abort(c(
      "{.arg nodes} includes {.val {lab}}, which is a label for missing values.",
      i = "To include a category for missing values, use {.arg include_missing}."
    ), call = user_frame())
  }
  if (any(is_total)) {
    lab <- nodes[[match(TRUE, is_total)]]
    cli::cli_abort(c(
      "{.arg nodes} includes {.val {lab}}, which is a label for a total.",
      i = "A total is not part of a reporting tree.",
      i = paste("To include a category for {label_type} not stated,",
                "use {.arg include_missing}.")
    ), call = user_frame())
  }
  m <- get_m(intervals)[i_row, , drop = FALSE]
  lower <- m[, 1L]
  upper <- m[, 2L]
  limits_ok <- breaks
  if (is_open_left) {
    limits_ok <- c(-Inf, limits_ok)
  }
  if (is_open_right) {
    limits_ok <- c(limits_ok, Inf)
  }
  is_lower_ok <- lower %in% limits_ok
  is_upper_ok <- upper %in% limits_ok
  if (!all(is_lower_ok & is_upper_ok)) {
    i <- match(FALSE, is_lower_ok & is_upper_ok)
    limit <- if (is_lower_ok[[i]]) upper[[i]] else lower[[i]]
    side <- if (is_lower_ok[[i]]) "upper" else "lower"
    hint <- if (is.infinite(limit)) {
      paste("{.val {nodes[[i]]}} is open, but the most detailed",
            "{noun}s are not open on the {if (side == 'upper') 'right' else 'left'}.")
    } else {
      interval <- sprintf("[%s, %s)", lower[[i]], upper[[i]])
      paste("{.val {nodes[[i]]}} is interpreted as {interval},",
            "and {limit} is not one of the {.arg breaks}: {.val {breaks}}.")
    }
    cli::cli_abort(c(
      "{noun_broad} {.val {nodes[[i]]}} does not line up with {.arg breaks}.",
      i = hint
    ), call = user_frame())
  }
  m_leaf <- get_m(intervals(
    labels = leaves,
    label_type = label_type,
    interpret_single = format_single,
    interpret_multi = format_multi,
    interpret_fail = "error"
  ))
  n_spanned <- vapply(seq_along(nodes), function(i) {
    sum(m_leaf[, 1L] >= lower[[i]] & m_leaf[, 2L] <= upper[[i]])
  }, 1L)
  if (any(n_spanned < 2L)) {
    i <- match(TRUE, n_spanned < 2L)
    cli::cli_abort(c(
      "{noun_broad} {.val {nodes[[i]]}} is the same as a most detailed {noun}.",
      i = "A broad {noun} must contain two or more of the most detailed {noun}s."
    ), call = user_frame())
  }
  n_leaf <- nrow(m_leaf)
  if (any(n_spanned == n_leaf)) {
    i <- match(TRUE, n_spanned == n_leaf)
    cli::cli_abort(c(
      "{noun_broad} {.val {nodes[[i]]}} contains all the most detailed {noun}s.",
      i = "Records with no information on {label_type} are represented by {.val Missing}.",
      i = "To include {.val Missing}, use {.arg include_missing}."
    ), call = user_frame())
  }
  nodes_std <- construct_labels_intervals(
    intervals = intervals,
    format_single = format_single,
    format_multi = format_multi
  )[i_row]
  is_dup <- duplicated(nodes_std)
  if (any(is_dup)) {
    i2 <- match(TRUE, is_dup)
    i1 <- match(nodes_std[[i2]], nodes_std)
    if (identical(nodes[[i1]], nodes[[i2]])) {
      msg <- "{.arg nodes} includes {.val {nodes[[i1]]}} more than once."
    } else {
      msg <- paste("{.arg nodes} includes {.val {nodes[[i1]]}} and",
                   "{.val {nodes[[i2]]}}, which describe the same {noun}.")
    }
    cli::cli_abort(msg, call = user_frame())
  }
  pairs <- tree_find_partial_overlaps(m)
  if (nrow(pairs) > 0L) {
    lab1 <- nodes[[pairs[1L, 1L]]]
    lab2 <- nodes[[pairs[1L, 2L]]]
    cli::cli_abort(c(
      "{noun_broad}s do not form a tree.",
      i = "{.val {lab1}} and {.val {lab2}} overlap, but neither contains the other."
    ), call = user_frame())
  }
  nodes_std
}
