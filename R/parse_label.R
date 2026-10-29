#' Make Label Parsers
#'
#' @param interpret_single Rule for one-year labels: `"lower"` or `"upper"`.
#' @param interpret_multi Rule for multi-year labels: `"at_upper"`
#' or `"below_upper"`.
#' @param allow_openleft Whether to allow open-left labels in parsing.
#' @param allow_openright Whether to allow open-right labels in parsing.
#' @returns List of parser functions.
#'
#' @noRd


make_label_parsers <- function(interpret_single,
                               interpret_multi,
                               allow_openleft,
                               allow_openright) {
  ans <- list(
    label_parser_total,
    label_parser_na
  )
  label_parser_one_inner <- function(label) {
    label_parser_one(
      label = label,
      interpret_single = interpret_single
    )
  }
  ans <- append(ans, label_parser_one_inner)
  label_parser_range_inner <- function(label) {
    label_parser_range(
      label = label,
      interpret_multi = interpret_multi
    )
  }
  ans <- append(ans, label_parser_range_inner)
  if (allow_openleft) {
    ans <- append(ans, label_parser_openleft)
  }
  if (allow_openright) {
    ans <- append(ans, label_parser_openright)
  }
  ans
}
#' Make Label Parsers Age
#'
#' @returns List of parser functions for age labels.
#'
#' @noRd


make_label_parsers_age <- function() {
  make_label_parsers(
    interpret_single = "lower",
    interpret_multi = "below_upper",
    allow_openleft = FALSE,
    allow_openright = TRUE
  )
}
#' Make Label Parsers Cohort
#'
#' @param interpret_single Rule for one-year labels: `"lower"` or `"upper"`.
#' @param interpret_multi Rule for multi-year labels: `"at_upper"`
#' or `"below_upper"`.
#' @returns List of parser functions for cohort labels.
#'
#' @noRd

make_label_parsers_cohort <- function(interpret_single,
                                      interpret_multi) {
  make_label_parsers(
    interpret_single = interpret_single,
    interpret_multi = interpret_multi,
    allow_openleft = TRUE,
    allow_openright = TRUE
  )
}
#' Make Label Parsers Period
#'
#' @param interpret_single Rule for one-year labels: `"lower"` or `"upper"`.
#' @param interpret_multi Rule for multi-year labels: `"at_upper"`
#' or `"below_upper"`.
#' @returns List of parser functions for period labels.
#'
#' @noRd


make_label_parsers_period <- function(interpret_single,
                                      interpret_multi) {
  make_label_parsers(
    interpret_single = interpret_single,
    interpret_multi = interpret_multi,
    allow_openleft = TRUE,
    allow_openright = TRUE
  )
}
#' Parse One Label to Interval
#'
#' @param label Single normalized label string.
#' @param label_orig The label as supplied by the user, before
#' normalization. Used in messages.
#' @param label_parsers List of label parser functions.
#' @param interpret_multi Rule for multi-year labels: `"at_upper"`
#' or `"below_upper"`.
#' @param label_type Label domain: `"age"`, `"cohort"`, or `"period"`.
#' @returns Length-2 numeric interval vector for one label. If the
#' label cannot be parsed, `c(NA_real_, NA_real_)` with a `"fail"`
#' attribute, which `signal_label_fails()` turns into a message.
#'
#' @noRd
x_label <- function(label,
                    label_orig,
                    label_parsers,
                    interpret_multi,
                    label_type) {
  na <- c(NA_real_, NA_real_)
  if (is.na(label)) {
    return(na)
  }
  for (label_parser in label_parsers) {
    val <- label_parser(label)
    if (!is.null(val)) {
      l <- val[[1L]]
      u <- val[[2L]]
      parsed_i <- msg_i_parsed_interval(label_type)
      if (is.finite(l) && is.finite(u) && l >= u) {
        if (l == u && is_two_value_label(label)) {
          msg <- c(
            "Label {.val {label_orig}} describes a zero-width {label_name(label_type)}.",
            i = parsed_i,
            i = paste0(
              "Write one-year {label_name(label_type)}s as a single year, ",
              "e.g. {.val {as.character(l)}}?"
            )
          )
        } else {
          msg <- c("Label {.val {label_orig}} invalid.")
          if (l == u) {
            msg <- c(msg, i = "Lower limit equals upper limit.")
          } else {
            msg <- c(msg, i = "Lower limit greater than upper limit.")
          }
          msg <- c(msg, i = parsed_i)
        }
        return(x_label_fail(msg = msg, label_orig = label_orig))
      }
      if (is_one_year_range_label(label = label, l = l, u = u)) {
        msg <- c(
          "Label {.val {label_orig}} describes a one-year {label_name(label_type)}.",
          i = parsed_i,
          i = paste0(
            "Write one-year {label_name(label_type)}s as a single year, ",
            "e.g. {.val {as.character(l)}}?"
          )
        )
        if (identical(interpret_multi, "at_upper")) {
          msg <- c(
            msg,
            i = paste0(
              "Or set {.arg interpret_multi} to {.val {\"below_upper\"}} ",
              "if {.val {label_orig}} is meant to be two years?"
            )
          )
        }
        return(x_label_fail(msg = msg, label_orig = label_orig))
      }
      return(val)
    }
  }
  if (startsWith(label, "-")) {
    msg <- c(
      "Can't interpret label {.val {label_orig}}.",
      i = "Labels starting with {.val -} are not accepted, since negative values are not allowed."
    )
    if (!identical(label_type, "age")) {
      year <- sub("^-+", "", label)
      msg <- c(
        msg,
        i = "For a {label_name(label_type)} that is open on the left, use {.val {paste0(\"<\", year)}}?"
      )
    }
    return(x_label_fail(msg = msg, label_orig = label_orig))
  }
  msg <- "Don't know how to interpret label {.val {label_orig}}."
  x_label_fail(msg = msg, label_orig = label_orig, unknown = TRUE)
}

#' Is Two-Value Label
#'
#' @param label Single label string.
#' @returns `TRUE` when `label` is a hyphenated pair of integers.
#'
#' @noRd
is_two_value_label <- function(label) {
  grepl("^\\d+-\\d+$", label, perl = TRUE)
}

#' Is One-Year Range Label
#'
#' @param label Single label string.
#' @param l,u Parsed interval bounds.
#' @returns `TRUE` when `label` is a two-value label with parsed width 1.
#'
#' @noRd
is_one_year_range_label <- function(label, l, u) {
  is.finite(l) && is.finite(u) && (u - l == 1) &&
    is_two_value_label(label)
}

#' Parsed-Interval Context Line
#'
#' @param label_type Label domain: `"age"`, `"cohort"`, or `"period"`.
#' @returns Character string for a `cli` `i` line. Placeholders are
#' interpolated later in `x_label()`.
#'
#' Age functions do not expose `interpret_multi`, so that argument is
#' named only for period and cohort.
#'
#' @noRd
msg_i_parsed_interval <- function(label_type) {
  if (identical(label_type, "age")) {
    "{.val {label_orig}} is the interval [{l}, {u})."
  } else {
    paste0(
      "With {.arg interpret_multi} = {.val {interpret_multi}}, ",
      "{.val {label_orig}} is the interval [{l}, {u})."
    )
  }
}

#' Record a Label Parse Failure
#'
#' @param msg Error or warning message, with placeholders to be
#' interpolated in the calling frame.
#' @param label_orig The label as supplied by the user.
#' @param unknown Whether the label is in no recognized format, as
#' opposed to being recognized but invalid.
#' @returns `c(NA_real_, NA_real_)` with a `"fail"` attribute.
#'
#' @noRd
x_label_fail <- function(msg, label_orig, unknown = FALSE) {
  fail <- list(
    msg = msg,
    envir = parent.frame(),
    label_orig = label_orig,
    unknown = unknown
  )
  structure(c(NA_real_, NA_real_), fail = fail)
}

#' Signal Label Parse Failures
#'
#' Signals all parse failures at once, so that users can fix every
#' unparsable label in one pass. If every failure is a label in no
#' recognized format, the labels are listed together. Otherwise the
#' first failure is shown in full, followed by a list of the others.
#'
#' @param fails List of `"fail"` attributes from `x_label_fail()`.
#' @param interpret_fail How to handle unparsable labels.
#' @returns `NULL`, invisibly, unless aborting.
#'
#' @noRd
signal_label_fails <- function(fails, interpret_fail) {
  if (identical(interpret_fail, "silent") || length(fails) == 0L) {
    return(invisible(NULL))
  }
  labels_fail <- vapply(fails, function(fail) fail$label_orig, "")
  is_unknown <- vapply(fails, function(fail) fail$unknown, TRUE)
  n_fail <- length(fails)
  if (n_fail > 1L && all(is_unknown)) {
    labels_fail <- cli::cli_vec(labels_fail, list("vec-trunc" = 5))
    msg <- "Don't know how to interpret {n_fail} labels: {.val {labels_fail}}."
    envir <- environment()
  } else {
    msg <- fails[[1L]]$msg
    envir <- fails[[1L]]$envir
    if (n_fail > 1L) {
      envir <- new.env(parent = envir)
      envir$n_other <- n_fail - 1L
      envir$labels_other <- cli::cli_vec(labels_fail[-1L], list("vec-trunc" = 5))
      msg <- c(
        msg,
        i = "Also can't interpret {n_other} other label{?s}: {.val {labels_other}}."
      )
    }
  }
  if (identical(interpret_fail, "error")) {
    cli::cli_abort(msg, .envir = envir, call = user_frame())
  }
  cli::cli_warn(msg, .envir = envir, call = user_frame())
  invisible(NULL)
}
