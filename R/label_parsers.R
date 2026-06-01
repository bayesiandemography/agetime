#' Label Parser Total
#'
#' @param label Single label string.
#' @returns Length-2 numeric vector for total labels, or `NULL`.
#'
#' @noRd

label_parser_total <- function(label) {
  if (identical(label, "total"))
    c(NA_real_, NA_real_)
  else
    NULL
}
#' Label Parser Na
#'
#' @param label Single label string.
#' @returns Length-2 numeric vector for missing labels, or `NULL`.
#'
#' @noRd

label_parser_na <- function(label) {
  if (is.na(label))
    c(NA_real_, NA_real_)
  else
    NULL
}
#' Label Parser Range
#'
#' @param label Single label string.
#' @param x_multi Rule for multi-year labels: `"include"` or `"exclude"`.
#' @returns Length-2 numeric vector for range labels, or `NULL`.
#'
#' With `x_multi = "exclude"`, the parsed upper bound is incremented by 1.
#'
#' @noRd

label_parser_range <- function(label, x_multi) {
  x_multi <- match.arg(x_multi, choices = c("include", "exclude"))
  m <- regexec("^(\\d+)-(\\d+)$", label, perl = TRUE)
  mm <- regmatches(label, m)[[1L]]
  if (length(mm) == 0L)
    return(NULL)
  l <- as.double(mm[[2L]])
  u <- as.double(mm[[3L]])
  if (x_multi == "exclude")
    u <- u + 1
  c(l, u)
}
#' Label Parser One
#'
#' @param label Single label string.
#' @param x_one Rule for one-year labels: `"lower"` or `"upper"`.
#' @returns Length-2 numeric vector for one-year labels, or `NULL`.
#'
#' @noRd

label_parser_one <- function(label, x_one) {
  x_one <- match.arg(x_one, choices = c("lower", "upper"))
  m <- regexec("^(\\d+)$", label, perl = TRUE)
  mm <- regmatches(label, m)[[1L]]
  if (length(mm) == 0L)
    return(NULL)
  if (x_one == "lower") {
    l <- as.double(mm[[2L]])
    u <- l + 1
  }
  else {
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
  if (length(mm) == 0L)
    return(NULL)
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
  if (length(mm) == 0L)
    return(NULL)
  l <- as.double(mm[[2L]])
  u <- Inf
  c(l, u)
}
