#' Make Label Parsers
#'
#' @param interpret_single Rule for one-year labels: `"lower"` or `"upper"`.
#' @param interpret_range Rule for multi-year labels: `"include"`
#' or `"exclude"`.
#' @param allow_openleft Whether to allow open-left labels in parsing.
#' @param allow_openright Whether to allow open-right labels in parsing.
#' @returns List of parser functions.
#'
#' @noRd


make_label_parsers <- function(interpret_single,
                               interpret_range,
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
      interpret_range = interpret_range
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
    interpret_range = "exclude",
    allow_openleft = FALSE,
    allow_openright = TRUE
  )
}
#' Make Label Parsers Cohort
#'
#' @param interpret_single Rule for one-year labels: `"lower"` or `"upper"`.
#' @param interpret_range Rule for multi-year labels: `"include"`
#' or `"exclude"`.
#' @returns List of parser functions for cohort labels.
#'
#' @noRd

make_label_parsers_cohort <- function(interpret_single,
                                      interpret_range) {
  make_label_parsers(
    interpret_single = interpret_single,
    interpret_range = interpret_range,
    allow_openleft = TRUE,
    allow_openright = FALSE
  )
}
#' Make Label Parsers Period
#'
#' @param interpret_single Rule for one-year labels: `"lower"` or `"upper"`.
#' @param interpret_range Rule for multi-year labels: `"include"`
#' or `"exclude"`.
#' @returns List of parser functions for period labels.
#'
#' @noRd


make_label_parsers_period <- function(interpret_single,
                                      interpret_range) {
  make_label_parsers(
    interpret_single = interpret_single,
    interpret_range = interpret_range,
    allow_openleft = FALSE,
    allow_openright = FALSE
  )
}
#' Parse One Label to Interval
#'
#' @param label Single label string.
#' @param label_parsers List of label parser functions.
#' @param interpret_fail How to handle unparsable labels.
#' @returns Length-2 numeric interval vector for one label.
#'
#' @noRd


x_label <- function(label, label_parsers, interpret_fail) {
  na <- c(NA_real_, NA_real_)
  if (is.na(label)) {
    return(na)
  }
  for (label_parser in label_parsers) {
    val <- label_parser(label)
    if (!is.null(val)) {
      l <- val[[1L]]
      u <- val[[2L]]
      if (is.finite(l) && is.finite(u) && l >= u) {
        msg <- c("Label {.val {label}} invalid.")
        if (l == u) {
          msg <- c(msg, i = "Lower limit equals upper limit.")
        } else {
          msg <- c(msg, i = "Lower limit greater than upper limit.")
        }
        msg <- c(msg,
          i = "Lower limit: {.val {l}}.",
          i = "Upper limit: {.val {u}}."
        )
        if (interpret_fail == "error") {
          cli::cli_abort(msg)
        }
        if (interpret_fail == "warn") {
          cli::cli_warn(msg)
        }
        return(na)
      }
      return(val)
    }
  }
  msg <- "Don't know how to interpret label {.val {label}}."
  if (interpret_fail == "error") {
    cli::cli_abort(msg)
  }
  if (interpret_fail == "warn") {
    cli::cli_warn(msg)
  }
  na
}
