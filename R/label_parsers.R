#' Label Parser Total
#'
#' @param label Single label string.
#' @returns Length-2 numeric vector for total labels, or `NULL`.
#'
#' @noRd

label_parser_total <- function(label) {
  if (identical(label, "total")) {
    c(NA_real_, NA_real_)
  } else {
    NULL
  }
}
#' Label Parser Na
#'
#' @param label Single label string.
#' @returns Length-2 numeric vector for missing labels, or `NULL`.
#'
#' @noRd

label_parser_na <- function(label) {
  if (is.na(label)) {
    c(NA_real_, NA_real_)
  } else {
    NULL
  }
}
#' Label Parser Range
#'
#' @param label Single label string.
#' @param interpret_multi Rule for multi-year labels: `"include"`
#' or `"exclude"`.
#' @returns Length-2 numeric vector for range labels, or `NULL`.
#'
#' With `interpret_multi = "exclude"`, the parsed upper bound is
#' incremented by 1.
#'
#' @noRd

label_parser_range <- function(label, interpret_multi) {
  interpret_multi <- match.arg(interpret_multi,
    choices = c("include", "exclude")
  )
  m <- regexec("^(\\d+)-(\\d+)$", label, perl = TRUE)
  mm <- regmatches(label, m)[[1L]]
  if (length(mm) == 0L) {
    return(NULL)
  }
  l <- as.double(mm[[2L]])
  u <- as.double(mm[[3L]])
  if (interpret_multi == "exclude") {
    u <- u + 1
  }
  c(l, u)
}
#' Label Parser One
#'
#' @param label Single label string.
#' @param interpret_single Rule for one-year labels: `"lower"` or `"upper"`.
#' @returns Length-2 numeric vector for one-year labels, or `NULL`.
#'
#' @noRd

label_parser_one <- function(label, interpret_single) {
  interpret_single <- match.arg(interpret_single, choices = c("lower", "upper"))
  m <- regexec("^(\\d+)$", label, perl = TRUE)
  mm <- regmatches(label, m)[[1L]]
  if (length(mm) == 0L) {
    return(NULL)
  }
  if (interpret_single == "lower") {
    l <- as.double(mm[[2L]])
    u <- l + 1
  } else {
    u <- as.double(mm[[2L]])
    l <- u - 1
  }
  c(l, u)
}
#' Label Parser Openleft
#'
#' @param label Single label string.
#' @returns Length-2 numeric vector for open-left labels, or `NULL`.
#'
#' @noRd

label_parser_openleft <- function(label) {
  m <- regexec("^<(\\d+)$", label, perl = TRUE)
  mm <- regmatches(label, m)[[1L]]
  if (length(mm) == 0L) {
    return(NULL)
  }
  l <- -Inf
  u <- as.double(mm[[2L]])
  c(l, u)
}
#' Label Parser Openright
#'
#' @param label Single label string.
#' @returns Length-2 numeric vector for open-right labels, or `NULL`.
#'
#' @noRd

label_parser_openright <- function(label) {
  m <- regexec("^(\\d+)\\+$", label, perl = TRUE)
  mm <- regmatches(label, m)[[1L]]
  if (length(mm) == 0L) {
    return(NULL)
  }
  l <- as.double(mm[[2L]])
  u <- Inf
  c(l, u)
}
