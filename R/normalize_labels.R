#' Make Labels Normalizers
#'
#' @param use_tolower Whether to apply `norm_tolower()`.
#' @param use_wordnum Whether to apply `norm_wordnum()`.
#' @param use_dashes Whether to apply `norm_dashes()`.
#' @param use_leadingzeros Whether to apply `norm_leadingzeros()`.
#' @param use_years Whether to apply `norm_years()`.
#' @param use_apostrophes Whether to apply `norm_apostrophes()`.
#' @param use_whitespace Whether to apply `norm_whitespace()`.
#' @param use_lessthan Whether to apply `norm_lessthan()`.
#' @param use_plus Whether to apply `norm_plus()`.
#' @param use_range Whether to apply `norm_range()`.
#' @param use_total Whether to apply `norm_total()`.
#' @param use_na Whether to apply `norm_na()`.
#' @param use_infant Whether to apply `norm_infant()`.
#' @returns List of normalizer functions in application order.
#'
#' @noRd
make_labels_normalizers <- function(use_tolower,
                                    use_wordnum,
                                    use_dashes,
                                    use_leadingzeros,
                                    use_years,
                                    use_apostrophes,
                                    use_whitespace,
                                    use_lessthan,
                                    use_plus,
                                    use_range,
                                    use_total,
                                    use_na,
                                    use_infant) {
  ans <- list()
  if (use_tolower) {
    ans <- append(ans, norm_tolower)
  }
  if (use_wordnum) {
    ans <- append(ans, norm_wordnum)
  }
  if (use_dashes) {
    ans <- append(ans, norm_dashes)
  }
  if (use_leadingzeros) {
    ans <- append(ans, norm_leadingzeros)
  }
  if (use_years) {
    ans <- append(ans, norm_years)
  }
  if (use_apostrophes) {
    ans <- append(ans, norm_apostrophes)
  }
  if (use_whitespace) {
    ans <- append(ans, norm_whitespace)
  }
  if (use_lessthan) {
    ans <- append(ans, norm_lessthan)
  }
  if (use_plus) {
    ans <- append(ans, norm_plus)
  }
  if (use_range) {
    ans <- append(ans, norm_range)
  }
  if (use_total) {
    ans <- append(ans, norm_total)
  }
  if (use_na) {
    ans <- append(ans, norm_na)
  }
  if (use_infant) {
    ans <- append(ans, norm_infant)
  }
  ans
}

#' Make Labels Normalizers Age
#'
#' @returns List of normalizers for age labels.
#'
#' @noRd
make_labels_normalizers_age <- function() {
  make_labels_normalizers(
    use_tolower = TRUE,
    use_wordnum = TRUE,
    use_dashes = TRUE,
    use_leadingzeros = TRUE,
    use_years = TRUE,
    use_apostrophes = TRUE,
    use_whitespace = TRUE,
    use_lessthan = FALSE,
    use_plus = TRUE,
    use_range = TRUE,
    use_total = TRUE,
    use_na = TRUE,
    use_infant = TRUE
  )
}

#' Make Labels Normalizers Cohort
#'
#' @returns List of normalizers for cohort labels.
#'
#' @noRd
make_labels_normalizers_cohort <- function() {
  make_labels_normalizers(
    use_tolower = TRUE,
    use_wordnum = FALSE,
    use_dashes = TRUE,
    use_leadingzeros = TRUE,
    use_years = FALSE,
    use_apostrophes = TRUE,
    use_whitespace = TRUE,
    use_lessthan = TRUE,
    use_plus = FALSE,
    use_range = TRUE,
    use_total = TRUE,
    use_na = TRUE,
    use_infant = FALSE
  )
}

#' Make Labels Normalizers Period
#'
#' @returns List of normalizers for period labels.
#'
#' @noRd
make_labels_normalizers_period <- function() {
  make_labels_normalizers(
    use_tolower = TRUE,
    use_wordnum = FALSE,
    use_dashes = TRUE,
    use_leadingzeros = TRUE,
    use_years = FALSE,
    use_apostrophes = TRUE,
    use_whitespace = TRUE,
    use_lessthan = FALSE,
    use_plus = FALSE,
    use_range = TRUE,
    use_total = TRUE,
    use_na = TRUE,
    use_infant = FALSE
  )
}

#' Normalize Labels
#'
#' @param labels Vector of labels.
#' @param labels_normalizers List of label normalizer functions.
#' @returns Normalized labels.
#'
#' The order of `labels_normalizers` matters; each normalizer runs on the output
#' of the previous one.
#'
#' @noRd
normalize_labels <- function(labels, labels_normalizers) {
  is_na <- is.na(labels)
  for (labels_normalizer in labels_normalizers) {
    labels[!is_na] <- labels_normalizer(labels[!is_na])
  }
  labels
}
