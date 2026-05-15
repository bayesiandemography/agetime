
label_parser_total <- function(label) {
  if (identical(label, "total"))
    c(NA_real_, NA_real_)
  else
    NULL
}

label_parser_na <- function(label) {
  if (is.na(label))
    c(NA_real_, NA_real_)
  else
    NULL
}

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

label_parser_openleft <- function(label) {
  m <- regexec("^<(\\d+)$", label, perl = TRUE)
  mm <- regmatches(label, m)[[1L]]
  if (length(mm) == 0L)
    return(NULL)
  l <- -Inf
  u <- as.double(mm[[2L]])
  c(l, u)
}

label_parser_openright <- function(label) {
  m <- regexec("^(\\d+)\\+$", label, perl = TRUE)
  mm <- regmatches(label, m)[[1L]]
  if (length(mm) == 0L)
    return(NULL)
  l <- as.double(mm[[2L]])
  u <- Inf
  c(l, u)
}
