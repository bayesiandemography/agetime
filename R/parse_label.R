#' Make Label Parsers
#'
#' @param interpret_single Rule for one-year labels: `"lower"` or `"upper"`.
#' @param interpret_multi Rule for multi-year labels: `"include"`
#' or `"exclude"`.
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
    interpret_multi = "exclude",
    allow_openleft = FALSE,
    allow_openright = TRUE
  )
}
#' Make Label Parsers Cohort
#'
#' @param interpret_single Rule for one-year labels: `"lower"` or `"upper"`.
#' @param interpret_multi Rule for multi-year labels: `"include"`
#' or `"exclude"`.
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
#' @param interpret_multi Rule for multi-year labels: `"include"`
#' or `"exclude"`.
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
#' @param label Single label string.
#' @param label_parsers List of label parser functions.
#' @param interpret_fail How to handle unparsable labels.
#' @param interpret_multi Rule for multi-year labels: `"include"`
#' or `"exclude"`.
#' @param label_type Label domain: `"age"`, `"cohort"`, or `"period"`.
#' @returns Length-2 numeric interval vector for one label.
#'
#' @noRd
x_label <- function(label,
                    label_parsers,
                    interpret_fail,
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
        return(x_label_fail(msg = msg, interpret_fail = interpret_fail))
      }
      if (is_one_year_range_label(label = label, l = l, u = u)) {
        msg <- c(
          "Label {.val {label}} describes a one-year {label_name(label_type)}.",
          i = paste0(
            "With {.arg interpret_multi} = {.val {interpret_multi}}, ",
            "{.val {label}} is the interval [{l}, {u})."
          ),
          i = paste0(
            "Write one-year {label_name(label_type)}s as a single year, ",
            "e.g. {.val {as.character(l)}}?"
          )
        )
        if (identical(interpret_multi, "include")) {
          msg <- c(
            msg,
            i = paste0(
              "Or set {.arg interpret_multi} to {.val {\"exclude\"}} ",
              "if {.val {label}} is meant to be two years?"
            )
          )
        }
        return(x_label_fail(msg = msg, interpret_fail = interpret_fail))
      }
      return(val)
    }
  }
  msg <- "Don't know how to interpret label {.val {label}}."
  x_label_fail(msg = msg, interpret_fail = interpret_fail)
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
    grepl("^\\d+-\\d+$", label, perl = TRUE)
}

#' Handle a Label Parse Failure
#'
#' @param msg Error or warning message.
#' @param interpret_fail How to handle unparsable labels.
#' @returns `c(NA_real_, NA_real_)` when not aborting.
#'
#' @noRd
x_label_fail <- function(msg, interpret_fail) {
  envir <- parent.frame()
  if (interpret_fail == "error") {
    cli::cli_abort(msg, .envir = envir)
  }
  if (interpret_fail == "warn") {
    cli::cli_warn(msg, .envir = envir)
  }
  c(NA_real_, NA_real_)
}
