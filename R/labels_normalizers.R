
## Normalization functions - listed in the order in which they should be run

## Convert to Lower Case
norm_tolower <- function(x) tolower(x)

## Translate Number Words (Less than 10) to Numbers
norm_wordnum <- function(x) {
  num <- c("zero","one","two","three","four","five","six","seven","eight","nine")
  out <- x
  for (k in seq_along(num)) {
    out <- gsub(paste0("\\b", num[[k]], "\\b"), as.character(k - 1L), out, perl = TRUE)
  }
  out
}

## Convert Unicode Dashes to ASCII
norm_dashes <- function(x) {
  gsub("[\u2013\u2014]", "-", x, perl = TRUE)
}

## Trim Leading Zeros that Precede a Number
norm_leadingzeros <- function(x) {
  gsub("(?<![0-9])0+(?=[0-9])", "", x, perl = TRUE)
}

## Remove Years or Abbreviations for Years
norm_years <- function(x) {
  gsub("\\b(year|years|yr|yrs)\\b", "", x, perl = TRUE)
}

## Remove White Space
norm_whitespace <- function(x) gsub("\\s+", "", x, perl = TRUE)

## Convert Synonyms for Less Than to Less Than
norm_lessthan <- function(x) {
  lessthan <- "^(upto|before|under|lessthan|lt)"
  x <- sub(lessthan, "<", x, perl = TRUE)
  x <- sub("^[-_]", "<", x, perl = TRUE)
  x <- sub("^<+", "<", x, perl = TRUE)
  x
}

## Convert Synonyms for Plus to Plus
norm_plus <- function(x) {
  plus <- "(andabove|andmore|andover|andolder|ormore|orolder|orover|plus)$"
  x <- sub(plus, "+", x, perl = TRUE)
  x <- sub("[-_]+$", "+", x, perl = TRUE)
  x
}

## Range to Hyphen
norm_range <- function(x) {
  x <- sub("^(\\d+)to(\\d+)$", "\\1-\\2", x, perl = TRUE)
  x <- sub("^(\\d+)[-\\._:/_]+(\\d+)$", "\\1-\\2", x, perl = TRUE)
  x
}

## Replace Synonyms for Infant with 0
norm_infant <- function(x) {
  infant <- "^(infants?|in1st|lessthan1|under1|lessthanone|in1styear|0-0|0_0)$"
  sub(infant, "0", x, perl = TRUE)
}





