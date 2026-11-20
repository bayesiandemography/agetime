# Shared data-frame assertion and diagnostic engine. Cached results contain
# only condition details; group keys and error context are attached on use.
inner_df_diagnose_values <- function(data, column, by, by_missing, label_type,
                                      checks, interpret_single, interpret_multi,
                                      interpret_fail, data_arg, assert) {
  check_df_coarsen_data(data, data_arg)
  column <- df_values_columns(column, label_type, data, single = TRUE)
  rowwise <- by_missing && inherits(data, "rowwise_df")
  if (by_missing && inherits(data, c("grouped_df", "rowwise_df"))) {
    by <- dplyr::group_vars(data)
  } else {
    by <- df_values_columns(by, "by", data, single = FALSE)
  }
  if (column %in% by) {
    cli::cli_abort("The label column cannot also be selected in {.arg by}.",
                   call = user_frame())
  }
  reserved <- intersect(by, c("condition", "passed", "comment"))
  if (length(reserved)) {
    cli::cli_abort(c(
      "Grouping columns {.val {reserved}} conflict with diagnostic field names.",
      i = "Rename these grouping columns before checking values."
    ), call = user_frame())
  }
  column_arg <- paste0(data_arg, "$", column)
  ## Parsing helpers obtain the selected-column name from the outer call's
  ## temporary registration, cleared when the public entry point exits.
  if (is.null(caller_env$args$labels)) caller_env$args$labels <- column_arg
  labels <- to_character_or_factor(data[[column]], column_arg, TRUE)
  ## Character observations exclude unused factor levels, while retaining NA
  ## and repeats. The ordered observations also determine diagnostic examples.
  labels <- as.character(labels)
  if (label_type != "age") {
    interpret_multi <- resolve_interpret_multi(
      interpret_multi, labels, NULL, label_type, interpret_single
    )
  }
  keys <- df_coarsen_keys(data, by)
  groups <- if (rowwise) {
    list(key = keys, loc = lapply(seq_len(nrow(data)), function(i) i))
  } else if (!length(by)) {
    list(key = vctrs::new_data_frame(list(), n = 1L),
         loc = list(seq_len(nrow(data))))
  } else {
    vctrs::vec_group_loc(keys)
  }
  observations <- lapply(groups$loc, function(rows) labels[rows])
  classification <- vctrs::vec_group_id(vctrs::new_data_frame(
    list(labels = observations), n = length(observations)
  ))
  cache <- vector("list", length(observations))
  reports <- vector("list", length(observations))
  for (i in seq_along(observations)) {
    id <- classification[[i]]
    result <- cache[[id]]
    if (is.null(result)) {
      warned <- FALSE
      result <- tryCatch(
        withCallingHandlers(
          do.call(inner_diagnose, c(list(
            labels = observations[[i]], label_type = label_type,
            interpret_single = interpret_single, interpret_multi = interpret_multi,
            interpret_fail = interpret_fail, on = "values", x_arg = column_arg
          ), checks)),
          warning = function(cnd) {
            warned <<- TRUE
            ## Keep the original warning class and parsing details.
            cnd$message <- paste(conditionMessage(cnd),
              df_values_group(groups, i, rowwise), sep = "\n")
            cnd$call <- rlang::frame_call(user_frame())
            warning(cnd)
            invokeRestart("muffleWarning")
          }
        ),
        error = function(cnd) {
          cli::cli_abort(c(
            "Can't check labels in {.arg {column_arg}}.",
            i = "{df_values_group(groups, i, rowwise)}"
          ), parent = cnd, call = user_frame())
        }
      )
      ## Recheck warning-producing groups so their warnings retain context.
      if (!warned) cache[[id]] <- result
    }
    if (assert && !result$ok) {
      failed <- result$details[!result$details$passed, , drop = FALSE]
      conditions <- failed$condition
      comments <- failed$comment
      needs_stop <- !is.na(comments) & !grepl("\\.$", comments)
      comments[needs_stop] <- paste0(comments[needs_stop], ".")
      label <- label_name(label_type)
      label <- paste0(toupper(substr(label, 1L, 1L)), substring(label, 2L))
      bullets <- paste0("{.arg {conditions[[", seq_along(conditions),
                        "]]}}: {comments[[", seq_along(conditions), "]]}")
      names(bullets) <- rep("x", length(bullets))
      cli::cli_abort(c(
        "{label} labels in {.arg {column_arg}} fail {cli::qty(length(conditions))}check{?s} {.arg {conditions}}.",
        i = "{df_values_group(groups, i, rowwise)}",
        bullets,
        i = "Use {.fn {label_type}_df_diagnose_values} to report checks for every group."
      ), call = user_frame())
    }
    if (!assert) {
      details <- result$details
      key <- vctrs::vec_slice(groups$key, rep.int(i, nrow(details)))
      reports[[i]] <- vctrs::vec_cbind(key, details)
    }
  }
  if (assert) return(invisible(data))
  prototype <- vctrs::vec_cbind(
    vctrs::vec_slice(groups$key, integer()),
    tibble::tibble(condition = character(), passed = logical(), comment = character())
  )
  tibble::as_tibble(vctrs::vec_rbind(!!!reports, .ptype = prototype))
}

# Evaluate captured selectors once per call. These select existing columns;
# renaming and source-to-target mappings belong to other operations.
df_values_columns <- function(x, arg, data, single) {
  selected <- tidyselect::eval_select(x, data, allow_rename = FALSE,
                                      error_call = user_frame())
  if (single && length(selected) != 1L) {
    cli::cli_abort("{.arg {arg}} must select exactly one column.",
                   call = user_frame())
  }
  names(selected)
}

df_values_group <- function(groups, i, rowwise) {
  if (rowwise && !ncol(groups$key)) {
    return(paste0("Input row ", groups$loc[[i]][[1L]], "."))
  }
  if (!ncol(groups$key)) return("Checking the whole dataset.")
  df_coarsen_group(groups$key, i)
}
