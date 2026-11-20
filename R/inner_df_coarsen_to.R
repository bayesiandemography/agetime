#' Recode a Data-Frame Column to Group-Specific Classifications
#'
#' @param data,to Source and target data frames.
#' @param column Selected label column or source-to-target name mapping.
#' @param by Grouping column names or source-to-target name mappings.
#' @param label_type Label domain: `"age"`, `"period"`, or `"cohort"`.
#' @param interpret_single,interpret_multi Interpretation rules.
#' @param interpret_fail How to handle uninterpretable labels.
#' @param data_arg,to_arg Names of the data frames used in messages.
#' @returns The source data frame with its selected column recoded.
#' @noRd
inner_df_coarsen_to <- function(data, to, column, by, label_type,
                                interpret_single, interpret_multi, interpret_fail,
                                data_arg, to_arg) {
  check_df_coarsen_data(data, data_arg)
  check_df_coarsen_data(to, to_arg)
  column <- df_coarsen_columns(column, label_type, data, to, single = TRUE)
  by <- df_coarsen_columns(by, "by", data, to, single = FALSE)
  if (column$data %in% by$data || column$to %in% by$to) {
    cli::cli_abort("The label column cannot also be selected in {.arg by}.",
                    call = user_frame())
  }
  if (!is.null(interpret_multi)) {
    interpret_multi <- match.arg(interpret_multi, c("at_upper", "below_upper"))
  }
  source_arg <- paste0(data_arg, "$", column$data)
  target_arg <- paste0(to_arg, "$", column$to)
  labels <- to_character_or_factor(data[[column$data]], source_arg, TRUE)
  targets <- to_character_or_factor(to[[column$to]], target_arg, TRUE)
  groups_data <- vctrs::vec_group_loc(df_coarsen_keys(data, by$data))
  groups_to <- vctrs::vec_group_loc(df_coarsen_keys(to, by$to, by$data))
  ## Common key types allow, for instance, a character key to match a factor.
  key_type <- vctrs::vec_ptype2(groups_data$key, groups_to$key,
                               x_arg = data_arg, y_arg = to_arg)
  key_data <- vctrs::vec_cast(groups_data$key, key_type, x_arg = data_arg)
  key_to <- vctrs::vec_cast(groups_to$key, key_type, x_arg = to_arg)
  matches <- vctrs::vec_match(key_data, key_to)
  labels_chr <- as.character(labels)
  targets_chr <- as.character(targets)
  source_labels <- lapply(groups_data$loc, function(rows) unique(labels_chr[rows]))
  target_labels <- lapply(matches, function(j) {
    if (is.na(j)) character(0) else unique(targets_chr[groups_to$loc[[j]]])
  })
  ## Reuse validated mappings within this call for identical classification
  ## pairs. Label order matters, since it determines output factor levels.
  ## Keep default period/cohort interpretation messages once per group.
  reuse_mapping <- label_type == "age" || !is.null(interpret_multi)
  classification <- if (reuse_mapping) {
    vctrs::vec_group_id(vctrs::new_data_frame(
      list(source = source_labels, target = target_labels), n = length(matches)
    ))
  } else seq_along(matches)
  mappings <- vector("list", length(matches))
  recoded <- character(nrow(data))
  levels_output <- character(0)
  for (i in seq_along(groups_data$loc)) {
    if (is.na(matches[[i]])) {
      cli::cli_abort(c("No target classification in {.arg {to_arg}} for a group in {.arg {data_arg}}.",
                       i = "{df_coarsen_group(groups_data$key, i)}"), call = user_frame())
    }
    rows <- groups_data$loc[[i]]
    id <- classification[[i]]
    mapped <- mappings[[id]]
    if (is.null(mapped)) {
      mapped <- tryCatch(
        df_coarsen_classification(
          source_labels[[i]], target_labels[[i]],
          label_type, interpret_single, interpret_multi, interpret_fail,
          source_arg, target_arg
        ),
        error = function(cnd) {
          cli::cli_abort(c("Can't coarsen {.arg {source_arg}} to {.arg {target_arg}}.",
                           i = "{df_coarsen_group(groups_data$key, i)}"),
                          parent = cnd, call = user_frame())
        }
      )
      if (reuse_mapping) mappings[[id]] <- mapped
    }
    recoded[rows] <- mapped$values[match(labels_chr[rows], mapped$labels)]
    levels_output <- unique(c(levels_output, mapped$levels))
  }
  ## Retain target factor ordering, but not unused levels or target-only groups.
  if (is.factor(targets)) {
    levels_output <- levels(targets)[levels(targets) %in% levels_output]
  }
  data[[column$data]] <- factor(recoded, levels = levels_output,
                                ordered = is.ordered(labels))
  ## Grouped tibble assignment rebuilds its groups; rowwise tibbles need this
  ## explicitly when their grouping columns include the recoded column.
  if (inherits(data, "rowwise_df")) {
    data <- dplyr::rowwise(data, !!!rlang::syms(dplyr::group_vars(data)))
  }
  data
}

#' Check a Coarsening Data Frame
#' @param x A data frame.
#' @param arg Name used in messages.
#' @returns `NULL`, invisibly, or an error.
#' @noRd
check_df_coarsen_data <- function(x, arg) {
  if (!is.data.frame(x)) {
    cli::cli_abort("{.arg {arg}} must be a data frame.", call = user_frame())
  }
  nms <- names(x)
  if (anyNA(nms) || any(!nzchar(nms)) || anyDuplicated(nms)) {
    cli::cli_abort("{.arg {arg}} must have unique, nonmissing, nonempty column names.",
                    call = user_frame())
  }
  invisible(NULL)
}

#' Resolve Source and Target Column Names
#' @param x A character vector or `NULL`.
#' @param arg Argument name used in messages.
#' @param data,to Source and target frames.
#' @param single Whether exactly one column mapping is required.
#' @returns List with source and target column names.
#' @noRd
df_coarsen_columns <- function(x, arg, data, to, single) {
  if (is.null(x) && !single) {
    x <- character(0)
  }
  if (!is.character(x) || !is.null(dim(x)) || anyNA(x) || any(!nzchar(x)) ||
      (single && length(x) != 1L)) {
    cli::cli_abort(c("{.arg {arg}} must be {if (single) 'a single column name or named mapping' else 'a character vector of column names or named mappings, or NULL'}.",
                     i = "Use {.code c(source_column = \"target_column\")} when names differ."),
                    call = user_frame())
  }
  source <- names(x)
  if (is.null(source)) {
    source <- unname(x)
  } else {
    if (anyNA(source)) {
      cli::cli_abort("Names in {.arg {arg}} must not be missing.", call = user_frame())
    }
    source[!nzchar(source)] <- x[!nzchar(source)]
  }
  target <- unname(x)
  if (anyDuplicated(source) || anyDuplicated(target)) {
    cli::cli_abort("Each column can appear only once in {.arg {arg}}.", call = user_frame())
  }
  if (any(!source %in% names(data))) {
    missing <- source[!source %in% names(data)]
    cli::cli_abort("Source columns {.val {missing}} selected in {.arg {arg}} are missing from {.arg {arg_nm('data')}}.",
                    call = user_frame())
  }
  if (any(!target %in% names(to))) {
    missing <- target[!target %in% names(to)]
    cli::cli_abort("Target columns {.val {missing}} selected in {.arg {arg}} are missing from {.arg {arg_nm('to')}}.",
                    call = user_frame())
  }
  list(data = unname(source), to = target)
}

#' Extract Grouping Keys Without Data-Frame Subclass Behaviour
#' @param data A data frame.
#' @param columns Selected column names.
#' @param key_names Names to use for the key columns.
#' @returns A plain data frame of keys.
#' @noRd
df_coarsen_keys <- function(data, columns, key_names = columns) {
  keys <- lapply(columns, function(nm) data[[nm]])
  names(keys) <- key_names
  vctrs::new_data_frame(keys, n = nrow(data))
}

#' Describe a Source Group in Error Messages
#' @param keys Data frame of distinct grouping keys.
#' @param i Row number.
#' @returns A character string.
#' @noRd
df_coarsen_group <- function(keys, i) {
  if (!ncol(keys)) {
    return("Using one classification for the whole dataset (by = NULL).")
  }
  values <- vapply(names(keys), function(nm) {
    value <- format(keys[[nm]][i], trim = TRUE)
    paste0(nm, " = ", paste(value, collapse = ", "))
  }, character(1))
  paste0("In group: ", paste(values, collapse = ", "), ".")
}

#' Check and Recode One Source Classification
#' @param labels,to Distinct observed source and target labels.
#' @param label_type Label domain.
#' @param interpret_single,interpret_multi Interpretation rules.
#' @param interpret_fail How to handle uninterpretable labels.
#' @param source_arg,target_arg Names used in messages.
#' @returns Source labels, recoded values, and target levels.
#' @noRd
df_coarsen_classification <- function(labels, to, label_type, interpret_single,
                                        interpret_multi, interpret_fail,
                                        source_arg, target_arg) {
  if (label_type != "age") {
    interpret_multi <- resolve_interpret_multi(interpret_multi, labels, to,
                                               label_type, interpret_single)
  }
  source <- intervals(labels, label_type, interpret_single, interpret_multi,
                       interpret_fail, nm_labels = source_arg)
  target <- intervals(to, label_type, interpret_single, interpret_multi,
                       interpret_fail, nm_labels = target_arg)
  m_source <- get_m(source)[get_i_xun_to_xunu(source), , drop = FALSE]
  m_target <- get_m(target)[get_i_xun_to_xunu(target), , drop = FALSE]
  for (side in c("source", "target")) {
    m <- if (side == "source") m_source else m_target
    labs <- if (side == "source") labels else to
    arg <- if (side == "source") source_arg else target_arg
    bad <- which(is.na(m[, 1L]) | is.na(m[, 2L]))
    if (length(bad)) {
      label <- labs[[bad[[1L]]]]
      cli::cli_abort("Label {.val {label}} in {.arg {arg}} does not describe an interval; totals and missing categories are not supported.",
                      call = user_frame())
    }
  }
  ## Repeated source observations and synonymous source labels describe a
  ## single category. Target synonyms would leave the output label ambiguous.
  unique_source <- !duplicated(as.data.frame(m_source))
  distinct_source <- m_source[unique_source, , drop = FALSE]
  check_df_coarsen_overlap(distinct_source, labels[unique_source], source_arg)
  check_df_coarsen_overlap(m_target, to, target_arg)
  contained <- outer(m_source[, 1L], m_target[, 1L], `>=`) &
    outer(m_source[, 2L], m_target[, 2L], `<=`)
  bad <- which(rowSums(contained) != 1L)
  if (length(bad)) {
    label <- labels[[bad[[1L]]]]
    cli::cli_abort("Source {.val {label}} does not fit wholly inside a single target interval in {.arg {target_arg}}; it crosses a boundary or lies outside the target classification.",
                    call = user_frame())
  }
  assignment <- max.col(contained, ties.method = "first")
  check_df_coarsen_coverage(distinct_source, m_target, assignment[unique_source], to,
                            label_type, interpret_single, interpret_multi,
                            source_arg, target_arg)
  list(labels = labels, values = to[assignment], levels = to)
}

#' Check That Distinct Intervals Do Not Overlap
#' @param m Matrix of intervals.
#' @param labels Labels corresponding to its rows.
#' @param arg Column name used in messages.
#' @returns `NULL`, invisibly, or an error.
#' @noRd
check_df_coarsen_overlap <- function(m, labels, arg) {
  ord <- order(m[, 1L], m[, 2L])
  n <- length(ord)
  if (n > 1L) {
    bad <- which(m[ord[-1L], 1L] < cummax(m[ord, 2L])[-n])
    if (length(bad)) {
      pair <- labels[ord[c(bad[[1L]], bad[[1L]] + 1L)]]
      cli::cli_abort("Intervals {.val {pair}} in {.arg {arg}} overlap or describe the same interval.",
                      call = user_frame())
    }
  }
  invisible(NULL)
}

#' Check Complete Coverage of Every Target Interval
#' @param m_source,m_target Matrices of source and target intervals.
#' @param assignment Target index for each source interval.
#' @param to Target labels.
#' @param label_type Label domain.
#' @param interpret_single,interpret_multi Interpretation rules.
#' @param source_arg,target_arg Column names used in messages.
#' @returns `NULL`, invisibly, or an error.
#' @noRd
check_df_coarsen_coverage <- function(m_source, m_target, assignment, to,
                                       label_type, interpret_single, interpret_multi,
                                       source_arg, target_arg) {
  for (j in seq_len(nrow(m_target))) {
    children <- m_source[assignment == j, , drop = FALSE]
    children <- children[order(children[, 1L]), , drop = FALSE]
    lower <- c(m_target[j, 1L], children[, 2L])
    upper <- c(children[, 1L], m_target[j, 2L])
    bad <- which(lower < upper)
    if (!length(bad)) next
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
    label <- to[[j]]
    cli::cli_abort("Target {.val {label}} in {.arg {target_arg}} is not fully covered; source {label_type}s {.val {gap}} are missing from {.arg {source_arg}}.",
                    call = user_frame())
  }
  invisible(NULL)
}
