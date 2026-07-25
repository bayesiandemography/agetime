## Normalization functions - listed in the order in which they should be run

## Tokens for whole label (tolower, apostrophes, whitespace) ------------------

NA_TOKENS <- c(
  "unknown",
  "unk",
  "unspecified",
  "notknown",
  "dontknow",
  "missing",
  "notstated",
  "na",
  "n/a"
)

TOTAL_TOKENS <- c(
  "total",
  "all",
  "overall",
  "allage",
  "allages",
  "allcohort",
  "allcohorts",
  "allperiod",
  "allperiods"
)

INFANT_TOKENS <- c(
  "infant",
  "infants",
  "in1st",
  "lessthan1",
  "under1",
  "lessthanone",
  "in1styear",
  "0-0"
)


## Translate, remove elements within label ------------------------------------

#' Norm Tolower
#'
#' @param x Vector of labels.
#' @returns Labels converted to lower case.
#'
#' @noRd
norm_tolower <- function(x) tolower(x)

#' Norm Wordnum
#'
#' @param x Vector of labels.
#' @returns Labels with number words translated to digits.
#'
#' @noRd
norm_wordnum <- function(x) {
  num <- c(
    "zero", "one", "two", "three", "four",
    "five", "six", "seven", "eight", "nine"
  )
  out <- x
  for (k in seq_along(num)) {
    out <- gsub(
      paste0("\\b", num[[k]], "\\b"),
      as.character(k - 1L),
      out,
      perl = TRUE
    )
  }
  out
}

#' Norm Dashes
#'
#' @param x Vector of labels.
#' @returns Labels with Unicode dashes converted to `-`.
#'
#' @noRd
norm_dashes <- function(x) {
  gsub("[\u2013\u2014]", "-", x, perl = TRUE)
}

#' Norm Leadingzeros
#'
#' @param x Vector of labels.
#' @returns Labels with leading numeric zeros trimmed.
#'
#' @noRd
norm_leadingzeros <- function(x) {
  gsub("(?<![0-9])0+(?=[0-9])", "", x, perl = TRUE)
}

#' Norm Years
#'
#' @param x Vector of labels.
#' @returns Labels with year words removed.
#'
#' @noRd
norm_years <- function(x) {
  gsub("\\b(year|years|yr|yrs)\\b", "", x, perl = TRUE)
}

#' Norm Apostrophes
#'
#' @param x Vector of labels.
#' @returns Labels with apostrophes removed.
#'
#' @noRd
norm_apostrophes <- function(x) {
  gsub("['\u2018\u2019]", "", x, perl = TRUE)
}

#' Norm Whitespace
#'
#' @param x Vector of labels.
#' @returns Labels with whitespace removed.
#'
#' @noRd
norm_whitespace <- function(x) gsub("\\s+", "", x, perl = TRUE)

#' Norm Lessthan
#'
#' @param x Vector of labels.
#' @returns Labels with less-than synonyms normalized to `<`.
#'
#' @noRd
norm_lessthan <- function(x) {
  lessthan <- "^(upto|before|under|lessthan|lt)"
  x <- sub(lessthan, "<", x, perl = TRUE)
  x <- sub("^[-_]", "<", x, perl = TRUE)
  x <- sub("^<+", "<", x, perl = TRUE)
  x
}

#' Norm Plus
#'
#' @param x Vector of labels.
#' @returns Labels with plus-style synonyms normalized to `+`.
#'
#' @noRd
norm_plus <- function(x) {
  plus <- "(andabove|andmore|andover|andolder|ormore|orolder|orover|plus)$"
  x <- sub(plus, "+", x, perl = TRUE)
  x <- sub("[-_]+$", "+", x, perl = TRUE)
  x
}

#' Norm Range
#'
#' @param x Vector of labels.
#' @returns Labels with range separators normalized to `-`.
#'
#' @noRd
norm_range <- function(x) {
  x <- sub("^(\\d+)to(\\d+)$", "\\1-\\2", x, perl = TRUE)
  x <- sub("^(\\d+)[-\\._:/_]+(\\d+)$", "\\1-\\2", x, perl = TRUE)
  x
}


## Translate entire label -----------------------------------------------------

#' Norm Total
#'
#' @param x Vector of labels.
#' @returns Labels with total synonyms normalized to `"total"`.
#'
#' @noRd
norm_total <- function(x) {
  x[x %in% TOTAL_TOKENS] <- "total"
  x
}

#' Norm Na
#'
#' @param x Vector of labels.
#' @returns Labels with missing-value tokens converted to `NA`.
#'
#' @noRd
norm_na <- function(x) {
  x[x %in% NA_TOKENS] <- NA
  x
}

#' Norm Infant
#'
#' @param x Vector of labels.
#' @returns Labels with infant synonyms normalized to `"0"`.
#'
#' @noRd
norm_infant <- function(x) {
  x[x %in% INFANT_TOKENS] <- "0"
  x
}
