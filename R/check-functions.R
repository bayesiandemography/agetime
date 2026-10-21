#' Check Breaks
#'
#' @param breaks Increasing vector of break points.
#' @returns Return value used internally.
#'
#' @noRd
check_breaks <- function(breaks) {
  if (length(breaks) < 2L) {
    cli::cli_abort(c("{.arg breaks} has length {.val {length(breaks)}}.",
      i = "Use at least two break points?"
    ), call = user_frame())
  }
  check_incr_nonneg_integers(
    x = breaks,
    nm_x = "breaks",
    min_length = 2L
  )
}

#' Check Flag
#'
#' @param x Single logical flag (`TRUE`, `FALSE`, `1L`, or `0L`).
#' @param nm_x Argument name used in error messages.
#' @returns Return value used internally.
#'
#' @noRd
check_flag <- function(x, nm_x) {
  if (length(x) != 1L) {
    cli::cli_abort(c("{.arg {nm_x}} has length {.val {length(x)}}.",
      i = "Supply a single value?"
    ), call = user_frame())
  }
  if (is.na(x)) {
    cli::cli_abort("{.arg {nm_x}} is {.val {NA}}.", call = user_frame())
  }
  if (!(x %in% c(TRUE, FALSE, 1L, 0L))) {
    cli::cli_abort(c("{.arg {nm_x}} is {.val {x}}.",
      i = "Use {.val {TRUE}} or {.val {FALSE}}?"
    ), call = user_frame())
  }
  invisible(TRUE)
}

#' Check Open Flag
#'
#' @param x Single logical flag (`TRUE`, `FALSE`, `1L`, or `0L`), or `NULL`
#' to infer from `labels` later.
#' @param nm_x Argument name used in error messages.
#' @returns Return value used internally.
#'
#' @noRd
check_open_flag <- function(x, nm_x) {
  if (is.null(x)) {
    return(invisible(TRUE))
  }
  check_flag(x = x, nm_x = nm_x)
}

#' Check In Limits Intervals
#'
#' @param x Numeric break points.
#' @param nm_x Argument name used in error messages.
#' @param intervals An `agetime_intervals` object.
#' @param nm_intervals Argument name for the label vector in error messages.
#' @param label_type Label domain: `"age"`, `"cohort"`, or `"period"`.
#' @returns Return value used internally.
#'
#' @noRd
check_in_limits_intervals <- function(x,
                                      nm_x,
                                      intervals,
                                      nm_intervals,
                                      label_type) {
  m <- get_m(intervals)
  labels <- get_labels_unique(intervals)
  lower <- m[, 1L]
  upper <- m[, 2L]
  if (all(is.na(lower)) || all(is.na(upper))) {
    return(invisible(TRUE))
  }
  i_lowest <- which.min(lower)
  i_highest <- which.max(upper)
  lowest <- lower[[i_lowest]]
  highest <- upper[[i_highest]]
  is_in <- (lowest <= x) & (x < highest)
  i_not_in <- match(FALSE, is_in, nomatch = 0L)
  if (i_not_in > 0L) {
    x_not_in <- x[[i_not_in]]
    label_lowest <- labels[[i_lowest]]
    label_highest <- labels[[i_highest]]
    msg_envir <- list2env(
      list(
        nm_x = nm_x,
        x_not_in = x_not_in,
        label_lowest = label_lowest,
        label_highest = label_highest
      ),
      parent = environment()
    )
    x_msg <- cli::format_inline(
      "{.arg {nm_x}} is {.val {x_not_in}}.",
      .envir = msg_envir
    )
    label_lowest_msg <- cli::format_inline(
      "Lowest interval: {.val {label_lowest}}.",
      .envir = msg_envir
    )
    label_highest_msg <- cli::format_inline(
      "Highest interval: {.val {label_highest}}.",
      .envir = msg_envir
    )
    cli::cli_abort(c(
      paste0(
        "{.arg {nm_x}} is outside the range covered by ",
        "{label_name(label_type)}s in {.arg {nm_intervals}}."
      ),
      i = x_msg,
      i = label_lowest_msg,
      i = label_highest_msg,
      i = paste0(
        "Use values within the range covered by ",
        "{label_name(label_type)}s in {.arg {nm_intervals}}?"
      )
    ), call = user_frame())
  }
  invisible(TRUE)
}

#' Check 'x' Consists of Increasing Non-Negative Integers
#'
#' @param x Numeric vector of non-negative whole numbers.
#' @param nm_x Argument name used in error messages.
#' @param min_length Minimum required length.
#' @returns Return value used internally.
#'
#' @noRd
check_incr_nonneg_integers <- function(x, nm_x, min_length) {
  eps <- 1e-8
  if (length(x) < min_length) {
    cli::cli_abort(c("{.arg {nm_x}} has length {.val {length(x)}}.",
      i = "Use at least {min_length} value{?s}?"
    ), call = user_frame())
  }
  if (!is.numeric(x)) {
    cli::cli_abort(c("{.arg {nm_x}} is non-numeric.",
      i = "{.arg {nm_x}} has class {.cls {class(x)}}."
    ), call = user_frame())
  }
  n_na <- sum(is.na(x))
  if (n_na > 0L) {
    cli::cli_abort("{.arg {nm_x}} has {cli::qty(n_na)} NA{?s}.", call = user_frame())
  }
  is_integerish <- abs(x - round(x)) < eps
  i_not_integerish <- match(FALSE, is_integerish, nomatch = 0L)
  if (i_not_integerish > 0L) {
    cli::cli_abort(paste0(
      "{.arg {nm_x}} has value {.val {x[[i_not_integerish]]}} ",
      "that is not a whole number."
    ), call = user_frame())
  }
  n_neg <- sum(x < 0L)
  if (n_neg > 0L) {
    cli::cli_abort("{.arg {nm_x}} has {cli::qty(n_neg)} negative value{?s}.", call = user_frame())
  }
  is_non_incr <- diff(x) <= 0L
  i_non_incr <- match(TRUE, is_non_incr, nomatch = 0L)
  if (i_non_incr > 0L) {
    x_non <- x[c(i_non_incr, i_non_incr + 1L)]
    msg_envir <- list2env(
      list(nm_x = nm_x, x_non = x_non),
      parent = environment()
    )
    msg <- cli::format_inline(
      "{.arg {nm_x}} has non-increasing values: {.val {x_non}}.",
      .envir = msg_envir
    )
    cli::cli_abort(msg, call = user_frame())
  }
  invisible(TRUE)
}

#' Check Coarsen Open Flags
#'
#' @param is_open_left Whether to include an open-left interval, or `NULL`
#' to infer from `intervals`.
#' @param is_open_right Whether to include an open-right interval, or `NULL`
#' to infer from `intervals`.
#' @param intervals An `agetime_intervals` object.
#' @param label_type Label domain: `"age"`, `"cohort"`, or `"period"`.
#' @returns Return value used internally.
#'
#' @noRd
check_coarsen_open_flags <- function(is_open_left,
                                    is_open_right,
                                    intervals,
                                    label_type) {
  ln <- label_name(label_type)
  if (!is.null(is_open_left) && !isTRUE(is_open_left)) {
    is_orl <- get_is_open_left(intervals)
    if (any(is_orl)) {
      labels_open <- get_labels_unique_norm_unique(intervals)[is_orl]
      n <- length(labels_open)
      cli::cli_abort(c(
        "{.arg labels} contains {cli::qty(n)} {ln}{?s} open on the left: {.val {labels_open}}.",
        i = "{.arg open_left} is {.val {FALSE}}.",
        i = "Remove open-left labels from {.arg labels}?",
        i = "Or unset {.arg open_left}, or pass {.val {TRUE}}?"
      ), call = user_frame())
    }
  }
  if (!is.null(is_open_right) && !isTRUE(is_open_right)) {
    is_orr <- get_is_open_right(intervals)
    if (any(is_orr)) {
      labels_open <- get_labels_unique_norm_unique(intervals)[is_orr]
      n <- length(labels_open)
      cli::cli_abort(c(
        "{.arg labels} contains {cli::qty(n)} {ln}{?s} open on the right: {.val {labels_open}}.",
        i = "{.arg open_right} is {.val {FALSE}}.",
        i = "Remove open-right labels from {.arg labels}?",
        i = "Or unset {.arg open_right}, or pass {.val {TRUE}}?"
      ), call = user_frame())
    }
  }
  invisible(TRUE)
}

#' Check if Any Labels Do Not Fit into New Set
#'
#' Every old label must lie in exactly one new interval. A label
#' that lies in none either overlaps two or more new intervals
#' (it would be split), or lies partly or wholly outside the new
#' intervals (it is not fully covered). A total or `NA` label that
#' does not fit has no matching category in `to`. The error message describes
#' each problem separately, and suggests fixes.
#'
#' @param m_contains Containment matrix from new intervals (rows)
#' to old labels (columns).
#' @param m_new Two-column matrix of new intervals, one row per
#' row of `m_contains`.
#' @param m_old Two-column matrix of old intervals, one row per
#' column of `m_contains`.
#' @param label_type Label domain: `"age"`, `"cohort"`, or `"period"`.
#' @param source Where the new intervals come from: `"breaks"`
#' (`*_coarsen()` and variants) or `"to"` (`*_coarsen_to()`).
#' @returns `TRUE`, invisibly, or an error.
#'
#' @noRd
check_m_contains <- function(m_contains,
                             m_new,
                             m_old,
                             label_type,
                             source = c("breaks", "to")) {
  source <- match.arg(source)
  is_not_fit <- colSums(m_contains) != 1L
  if (!any(is_not_fit)) {
    return(invisible(TRUE))
  }
  labels_old <- colnames(m_contains)
  labels_new <- rownames(m_contains)
  overlaps <- does_m1_overlap_m2(m1 = m_new, m2 = m_old)
  overlaps[is.na(overlaps)] <- FALSE
  n_overlap <- colSums(overlaps)
  is_special <- is_not_fit & is.na(m_old[, 1L]) & is.na(m_old[, 2L])
  is_split <- is_not_fit & !is_special & n_overlap > 1L
  is_outside <- is_not_fit & !is_special & !is_split
  nm <- label_name(label_type)
  nm_cap <- paste0(toupper(substr(nm, 1L, 1L)), substring(nm, 2L))
  new_desc <- if (source == "breaks") paste0("the new ", nm, "s") else "the labels in {.arg to}"
  env <- new.env(parent = environment())
  bullets <- character()
  if (any(is_split)) {
    i_first <- which(is_split)[[1L]]
    env$split_labels <- describe_labels_shown(labels_old[is_split])
    env$split_n <- sum(is_split)
    env$split_more <- describe_labels_more(labels_old[is_split])
    env$split_first <- labels_old[[i_first]]
    env$split_over <- labels_new[overlaps[, i_first]]
    bullets <- c(
      bullets,
      x = paste0("{cli::qty(split_n)}", nm_cap, "{?s} {.val {split_labels}}{split_more} ",
                 "would be split by ", new_desc, "."),
      i = "{.val {split_first}} overlaps {.val {split_over}}."
    )
  }
  if (any(is_outside)) {
    env$outside_labels <- describe_labels_shown(labels_old[is_outside])
    env$outside_n <- sum(is_outside)
    env$outside_more <- describe_labels_more(labels_old[is_outside])
    bullets <- c(
      bullets,
      x = paste0("{cli::qty(outside_n)}", nm_cap, "{?s} {.val {outside_labels}}{outside_more} ",
                 "{cli::qty(outside_n)}{?is/are} not fully covered by ", new_desc, ".")
    )
    is_interval <- !is.na(m_new[, 1L]) & !is.na(m_new[, 2L])
    if (source == "breaks" && any(is_interval)) {
      lower_new <- min(m_new[is_interval, 1L])
      upper_new <- max(m_new[is_interval, 2L])
      env$cover <- paste0("[", lower_new, ", ", upper_new, ")")
      bullets <- c(bullets, i = paste0("New ", nm, "s cover {cover}."))
      m_outside <- m_old[is_outside, , drop = FALSE]
      if (any(m_outside[, 2L] > upper_new, na.rm = TRUE)) {
        bullets <- c(bullets, i = paste0(
          "Set {.code open_right = TRUE} to include ", nm, "s above ", upper_new, "?"
        ))
      }
      if (any(m_outside[, 1L] < lower_new, na.rm = TRUE)) {
        hint <- if (label_type == "age") {
          "Add a lower break?"
        } else {
          "Set {.code open_left = TRUE}, or add a lower break?"
        }
        bullets <- c(bullets, i = hint)
      }
    }
    if (source == "to") {
      bullets <- c(bullets, i = "Add labels to {.arg to} that cover {cli::qty(outside_n)}{?it/them}?")
    }
  }
  if (any(is_special)) {
    env$special_labels <- labels_old[is_special]
    env$special_labels[is.na(env$special_labels)] <- "NA"
    env$special_n <- sum(is_special)
    bullets <- c(
      bullets,
      x = paste0("{.arg to} has no category for {.val {special_labels}}."),
      i = "Add {cli::qty(special_n)}{?it/them} to {.arg to}?"
    )
  }
  cli::cli_abort(
    c(paste0("Can't coarsen ", nm, "s."), bullets),
    .envir = env,
    call = user_frame()
  )
}


#' Labels to Show in an Error Message
#'
#' At most three labels are shown. If there are more,
#' `describe_labels_more()` gives the remaining count.
#'
#' @param labels Character vector of labels.
#' @returns Character vector, or a `cli_vec` without a final "and"
#' when some labels are left out.
#'
#' @noRd
describe_labels_shown <- function(labels) {
  if (length(labels) <= 3L) {
    return(labels)
  }
  cli::cli_vec(labels[1:3], style = list("vec-last" = ", "))
}


#' Count of Labels Left Out of an Error Message
#'
#' @param labels Character vector of labels.
#' @returns A string such as `", and 2 others"`, or `""`.
#'
#' @noRd
describe_labels_more <- function(labels) {
  n_more <- length(labels) - 3L
  if (n_more <= 0L) {
    return("")
  }
  paste0(", and ", n_more, " other", if (n_more > 1L) "s" else "")
}


#' Check That Target Labels Do Not Overlap
#'
#' @param intervals_to Intervals parsed from `to`.
#' @param label_type Label domain: `"age"`, `"cohort"`, or `"period"`.
#' @returns Return value used internally.
#'
#' @noRd
check_coarsen_to_no_overlap <- function(intervals_to, label_type) {
  if (int_is_empty(intervals_to)) {
    return(invisible(TRUE))
  }
  m <- get_m(intervals_to)
  i_xun_to_xunu <- get_i_xun_to_xunu(intervals_to)
  m_xu <- m[i_xun_to_xunu, , drop = FALSE]
  is_skip <- get_is_total(intervals_to)[i_xun_to_xunu] |
    get_is_na(intervals_to)[i_xun_to_xunu]
  m_overlap <- does_m1_overlap_m2(m1 = m_xu, m2 = m_xu)
  m_overlap[is_skip, ] <- FALSE
  m_overlap[, is_skip] <- FALSE
  m_overlap[row(m_overlap) >= col(m_overlap)] <- FALSE
  if (any(m_overlap, na.rm = TRUE)) {
    labels_unique <- get_labels_unique(intervals_to)
    i_overlap <- match(TRUE, m_overlap)
    i1 <- row(m_overlap)[[i_overlap]]
    i2 <- col(m_overlap)[[i_overlap]]
    lab1 <- labels_unique[[i1]]
    lab2 <- labels_unique[[i2]]
    ln <- label_name(label_type)
    cli::cli_abort(c(
      "{.arg to} has overlapping {ln}s {.val {lab1}} and {.val {lab2}}.",
      i = "Supply {ln}s in {.arg to} that do not overlap?"
    ), call = user_frame())
  }
  invisible(TRUE)
}


#' Check Whole Number
#'
#' Copied from 'poputils' with 'rvec' test dropped,
#' to avoid depending on 'poputils' or 'rvec'.
#'
#' Check that `n` is  finite, non-NA scalar that
#' is an integer or integerish (i.e., is equal to `round(n)`),
#' and optionally within a specified range
#' and divisible by a specified number.
#'
#' @param n Single numeric value (whole number).
#' @param nm_n Argument name used in error messages.
#' @param min Minimum allowed value, or `NULL`.
#' @param max Maximum allowed value, or `NULL`.
#' @param divisible_by Required divisor, or `NULL`.
#' @returns
#' If all tests pass, `check_n()` returns `TRUE` invisibly.
#' Otherwise it throws an error.
#'
#' @noRd
check_n <- function(n, nm_n, min, max, divisible_by) {
  if (!is.numeric(n)) {
    cli::cli_abort(c("{.arg {nm_n}} is non-numeric.",
      i = "{.arg {nm_n}} has class {.cls {class(n)}}."
    ), call = user_frame())
  }
  if (length(n) != 1L) {
    cli::cli_abort(c("{.arg {nm_n}} has length {.val {length(n)}}.",
      i = "Supply a single value?"
    ), call = user_frame())
  }
  if (is.na(n)) {
    cli::cli_abort("{.arg {nm_n}} is {.val {NA}}.", call = user_frame())
  }
  if (is.infinite(n)) {
    cli::cli_abort("{.arg {nm_n}} is {.val {n}}.", call = user_frame())
  }
  if (!isTRUE(all.equal(round(n), n))) {
    cli::cli_abort(c("{.arg {nm_n}} is {.val {n}}.",
      i = "Use a whole number?"
    ), call = user_frame())
  }
  if (!is.null(min) && (n < min)) {
    cli::cli_abort(c("{.arg {nm_n}} is {.val {n}}.",
      i = "Use a value of at least {.val {min}}?"
    ), call = user_frame())
  }
  if (!is.null(max) && (n > max)) {
    cli::cli_abort(c("{.arg {nm_n}} is {.val {n}}.",
      i = "Use a value of at most {.val {max}}?"
    ), call = user_frame())
  }
  if (!is.null(divisible_by) && (n %% divisible_by != 0L)) {
    cli::cli_abort(c("{.arg {nm_n}} is {.val {n}}.",
      i = "Use a value divisible by {.val {divisible_by}}?"
    ), call = user_frame())
  }
  invisible(TRUE)
}


#' Check Difference Is Divisible
#'
#' @param x First numeric value.
#' @param y Second numeric value.
#' @param nm_x Argument name used in error messages.
#' @param nm_y Argument name used in error messages.
#' @param divisible_by Required divisor.
#' @returns Return value used internally.
#'
#' @noRd
check_diff_divisible <- function(x, y, nm_x, nm_y, divisible_by) {
  diff <- y - x
  if (diff %% divisible_by != 0L) {
    cli::cli_abort(c(
      "Difference between {.arg {nm_x}} and {.arg {nm_y}} is {.val {diff}}.",
      i = paste0(
        "Use values whose difference is divisible by ",
        "{.val {divisible_by}}?"
      )
    ), call = user_frame())
  }
  invisible(TRUE)
}


#' Check Not In Intervals
#'
#' @param x Numeric break points.
#' @param nm_x Argument name used in error messages.
#' @param intervals An `agetime_intervals` object.
#' @param nm_intervals Argument name for the label vector in error messages.
#' @param label_type Label domain: `"age"`, `"cohort"`, or `"period"`.
#' @returns Return value used internally.
#'
#' @noRd
check_not_in_intervals <- function(x,
                                   nm_x,
                                   intervals,
                                   nm_intervals,
                                   label_type) {
  m <- get_m(intervals)
  labels <- get_labels_unique(intervals)
  lower <- m[, 1L]
  upper <- m[, 2L]
  for (i in seq_along(lower)) {
    l <- lower[[i]]
    u <- upper[[i]]
    is_finite <- is.finite(l) && is.finite(u)
    if (is_finite) {
      is_in <- (l < x) & (x < u)
      i_in <- match(TRUE, is_in, nomatch = 0L)
      if (i_in > 0L) {
        x_in <- x[[i_in]]
        label <- labels[[i]]
        msg_envir <- list2env(
          list(nm_x = nm_x, x_in = x_in, label = label),
          parent = environment()
        )
        value_msg <- cli::format_inline(
          "Value in {.arg {nm_x}}: {.val {x_in}}.",
          .envir = msg_envir
        )
        interval_msg <- cli::format_inline(
          "Interval: {.val {label}}.",
          .envir = msg_envir
        )
        cli::cli_abort(c(
          paste0(
            "{.arg {nm_x}} lies inside an existing ",
            "{label_name(label_type)}."
          ),
          i = value_msg,
          i = interval_msg
        ), call = user_frame())
      }
    }
  }
  invisible(TRUE)
}

#' Check X Lt Y
#'
#' @param x Numeric scalar; must be less than `y`.
#' @param y Numeric scalar.
#' @param nm_x Argument name used in error messages.
#' @param nm_y Argument name used in error messages.
#' @returns Return value used internally.
#'
#' @noRd
check_x_lt_y <- function(x, y, nm_x, nm_y) {
  if (x >= y) {
    if (x == y) {
      cli::cli_abort("{.arg {nm_x}} equals {.arg {nm_y}} ({.val {x}}).", call = user_frame())
    } else {
      cli::cli_abort(paste0(
        "{.arg {nm_x}} ({.val {x}}) is greater than ",
        "{.arg {nm_y}} ({.val {y}})."
      ), call = user_frame())
    }
  }
  invisible(TRUE)
}

#' Check Mapping Name
#'
#' @param x Single name for a mapping side: character, numeric, or factor.
#' @param nm_x Argument name used in error messages.
#' @returns Character string of length 1.
#'
#' @noRd
check_mapping_name <- function(x, nm_x) {
  if (length(x) != 1L) {
    cli::cli_abort(c("{.arg {nm_x}} has length {.val {length(x)}}.",
      i = "Supply a single name?"
    ), call = user_frame())
  }
  if (!(is.character(x) || is.numeric(x) || is.factor(x))) {
    cli::cli_abort(c("{.arg {nm_x}} is {.obj_type_friendly {x}}.",
      i = "Use a character, numeric, or factor name?"
    ), call = user_frame())
  }
  x <- as.character(x)
  if (is.na(x)) {
    cli::cli_abort("{.arg {nm_x}} is {.val {NA}}.", call = user_frame())
  }
  x <- trimws(x)
  if (!nzchar(x)) {
    cli::cli_abort(c("{.arg {nm_x}} is an empty string.",
      i = "Supply a non-empty name?"
    ), call = user_frame())
  }
  x
}

#' Check Mapping Names
#'
#' @param name_x Name for the `labels_x` side of a mapping.
#' @param name_y Name for the `labels_y` side of a mapping.
#' @returns List with character scalars `name_x` and `name_y`.
#'
#' @noRd
check_mapping_names <- function(name_x, name_y) {
  name_x <- check_mapping_name(x = name_x, nm_x = "name_x")
  name_y <- check_mapping_name(x = name_y, nm_x = "name_y")
  if (identical(name_x, name_y)) {
    cli::cli_abort(c(
      "{.arg name_x} and {.arg name_y} are both {.val {name_x}}.",
      i = "Supply two different names?"
    ), call = user_frame())
  }
  list(name_x = name_x, name_y = name_y)
}
