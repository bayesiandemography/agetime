
label_parser_range <- function(label, label_multi) {
  label_multi <- match.arg(label_multi, choices = c("include", "exclude"))
  m <- regexec("^(\\d+)-(\\d+)$", label, perl = TRUE)
  mm <- regmatches(label, m)[[1L]]
  if (length(mm) == 0L)
    return(NULL)
  l <- as.double(mm[[2L]])
  u <- as.double(mm[[3L]])
  if (label_multi == "exclude")
    u <- u + 1
  c(l, u)
}

label_parser_single <- function(label, label_single) {
  label_single <- match.arg(label_single, choices = c("lower", "upper"))
  m <- regexec("^(\\d+)$", label, perl = TRUE)
  mm <- regmatches(label, m)[[1L]]
  if (length(mm) == 0L)
    return(NULL)
  if (label_single == "lower") {
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
