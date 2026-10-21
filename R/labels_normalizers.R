## Normalization functions - listed in the order in which they should be run

## Tokens for whole label (tolower, apostrophes, whitespace) ------------------

NA_TOKENS <- c(
  "unknown",
  "unk",
  "unk-na",
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
  "allperiods",
  "allyear",
  "allyears"
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
#' Remove year words, including when attached to
#' digits (`"5-9yrs"`) and when followed by `"old"`
#' (`"0-4 years old"`).
#'
#' @param x Vector of labels.
#' @returns Labels with year words removed.
#'
#' @noRd
norm_years <- function(x) {
  gsub("(?:\\b|(?<=\\d))(?:years|year|yrs|yr)(?:\\s*old)?\\b", "", x, perl = TRUE)
}

#' Norm Age Prefix
#'
#' Remove a leading `"age"`, `"ages"`, or `"aged"`,
#' as in `"Age 0-4"` or `"Age not stated"`. The prefix
#' is only removed when it is followed by a number, `"<"`,
#' or a word for a missing value or a total.
#'
#' @param x Vector of labels, after whitespace has been removed.
#' @returns Labels with the prefix removed.
#'
#' @noRd
norm_age_prefix <- function(x) {
  followers <- paste(c("[0-9<]", NA_TOKENS, TOTAL_TOKENS), collapse = "|")
  followers <- gsub("/", "\\/", followers, fixed = TRUE)
  p <- paste0("^(ages|aged|age)(?=", followers, ")")
  sub(p, "", x, perl = TRUE)
}

#' Norm Under
#'
#' For ages, `"under N"`, `"less than N"`, and `"<N"`
#' describe the closed interval from 0 to `N - 1`,
#' so `"under 5"` becomes `"0-4"` and `"under 1"`
#' becomes `"0"`.
#'
#' @param x Vector of labels, after whitespace has been removed.
#' @returns Labels with under-N synonyms converted to ranges.
#'
#' @noRd
norm_under <- function(x) {
  p <- "^(under|lessthan|lt|<)([0-9]+)$"
  is_under <- grepl(p, x, perl = TRUE)
  n <- suppressWarnings(as.integer(sub(p, "\\2", x[is_under], perl = TRUE)))
  val <- ifelse(n == 1L, "0", paste0("0-", n - 1L))
  val[is.na(n) | n < 1L] <- x[is_under][is.na(n) | n < 1L]
  x[is_under] <- val
  x
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

#' Shift a Year Given in a Label
#'
#' Helper for `norm_lessthan()` and `norm_plus()`.
#' Words such as `"before"`, `"or earlier"`, and `"or more"` refer
#' to the year *label* next to them, while the symbols `"<"` and
#' `"+"` refer to a *boundary*. Converting words to symbols
#' therefore depends on how one-year labels are interpreted:
#' with `"lower"`, the label `"2000"` is `[2000, 2001)`, and with
#' `"upper"`, it is `[1999, 2000)`.
#'
#' @param year Numeric vector of years taken from labels.
#' @param side `"lower"` to return the lower limit of the
#' one-year interval with label `year`, or `"upper"` to
#' return its upper limit.
#' @param interpret_single Rule for one-year labels: `"lower"` or `"upper"`.
#' @returns Character vector of boundaries.
#'
#' @noRd
label_year_to_boundary <- function(year, side, interpret_single) {
  if (interpret_single == "lower") {
    ans <- if (side == "lower") year else year + 1
  } else {
    ans <- if (side == "lower") year - 1 else year
  }
  format(ans, scientific = FALSE, trim = TRUE)
}

#' Norm Lessthan
#'
#' Convert words for intervals that are open on the left to `"<"`.
#'
#' - Prefixes `"before"`, `"under"`, `"less than"`, and `"lt"`
#'   exclude the year that follows, so `"before 2000"` ends at
#'   the lower limit of `"2000"`.
#' - Prefix `"up to"`, and suffixes such as `"or earlier"` and
#'   `"or less"`, include the year, so `"2000 or earlier"` ends
#'   at the upper limit of `"2000"`.
#'
#' With `interpret_single = "lower"`, `"before 2000"` becomes
#' `"<2000"` and `"2000 or earlier"` becomes `"<2001"`. With
#' `"upper"`, they become `"<1999"` and `"<2000"`.
#' The symbol `"<"` is left unchanged.
#'
#' @param x Vector of labels.
#' @param interpret_single Rule for one-year labels: `"lower"` or `"upper"`.
#' @returns Labels with less-than synonyms normalized to `<`.
#'
#' @noRd
norm_lessthan <- function(x, interpret_single = "lower") {
  interpret_single <- match.arg(interpret_single, choices = c("lower", "upper"))
  p_prefix_excl <- "^(before|under|lessthan|lt)(\\d+)$"
  p_prefix_incl <- "^(upto)(\\d+)$"
  p_suffix_incl <- paste0(
    "^(\\d+)(orless|andunder|andbelow|andless|",
    "orearlier|andearlier|orbefore|andbefore)$"
  )
  replace <- function(x, p, i_year, side) {
    is_match <- !is.na(x) & grepl(p, x, perl = TRUE)
    if (any(is_match)) {
      year <- as.double(sub(p, paste0("\\", i_year), x[is_match], perl = TRUE))
      boundary <- label_year_to_boundary(year = year,
                                         side = side,
                                         interpret_single = interpret_single)
      x[is_match] <- paste0("<", boundary)
    }
    x
  }
  x <- replace(x, p = p_prefix_excl, i_year = 2L, side = "lower")
  x <- replace(x, p = p_prefix_incl, i_year = 2L, side = "upper")
  x <- replace(x, p = p_suffix_incl, i_year = 1L, side = "upper")
  x <- sub("^[-_]", "<", x, perl = TRUE)
  x <- sub("^<+", "<", x, perl = TRUE)
  x
}

#' Norm Plus
#'
#' Convert words for intervals that are open on the right,
#' such as `"or more"` and `"and over"`, to `"+"`. The words
#' include the year or age that precedes them, so the interval
#' starts at the lower limit of that label. For ages, and for
#' periods and cohorts with `interpret_single = "lower"`,
#' `"2000 or more"` becomes `"2000+"`. For periods and cohorts with
#' `"upper"`, it becomes `"1999+"`. The symbol `"+"`, and
#' trailing `"-"` or `"_"`, are left unchanged.
#'
#' `"or older"` and `"and older"` are only recognized when
#' `allow_older` is `TRUE` (ages). For cohorts, an older cohort
#' is an earlier one, so these words would be misleading.
#'
#' @param x Vector of labels.
#' @param interpret_single Rule for one-year labels: `"lower"` or `"upper"`.
#' @param allow_older Whether to recognize `"or older"` and `"and older"`.
#' @returns Labels with plus-style synonyms normalized to `+`.
#'
#' @noRd
norm_plus <- function(x, interpret_single = "lower", allow_older = TRUE) {
  interpret_single <- match.arg(interpret_single, choices = c("lower", "upper"))
  words <- c("andabove", "andmore", "andover", "andup",
             "ormore", "orover", "orabove",
             "&above", "&over", "&up", "plus")
  if (allow_older) {
    words <- c(words, "andolder", "orolder", "&older")
  }
  p <- paste0("^(\\d+)(", paste(words, collapse = "|"), ")$")
  is_match <- !is.na(x) & grepl(p, x, perl = TRUE)
  if (any(is_match)) {
    year <- as.double(sub(p, "\\1", x[is_match], perl = TRUE))
    boundary <- label_year_to_boundary(year = year,
                                       side = "lower",
                                       interpret_single = interpret_single)
    x[is_match] <- paste0(boundary, "+")
  }
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
  x <- sub("^(\\d+)[-_:/]+(\\d+)$", "\\1-\\2", x, perl = TRUE)
  x
}


## Translate entire label -----------------------------------------------------

#' Norm Total
#'
#' "total" followed by another total synonym, as in
#' "Total, all ages" or "Total (all ages)", is also a total.
#'
#' @param x Vector of labels.
#' @returns Labels with total synonyms normalized to `"total"`.
#'
#' @noRd
norm_total <- function(x) {
  rest <- sub("^total[,:;-]?\\(?(.*?)\\)?$", "\\1", x, perl = TRUE)
  is_total <- x %in% TOTAL_TOKENS | (startsWith(x, "total") & rest %in% TOTAL_TOKENS)
  x[is_total] <- "total"
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
