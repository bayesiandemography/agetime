
## Note that order of normalizers matters
make_labels_normalizers <- function(use_tolower,
                                    use_wordnum,
                                    use_dashes,
                                    use_leadingzeros,
                                    use_years,
                                    use_whitespace,
                                    use_lessthan,
                                    use_plus,
                                    use_range,
                                    use_infant) {
  ans <- list()
  if (use_tolower)
    ans <- append(ans, norm_tolower)
  if (use_wordnum)
    ans <- append(ans, norm_wordnum)
  if (use_dashes)
    ans <- append(ans, norm_dashes)
  if (use_leadingzeros)
    ans <- append(ans, norm_leadingzeros)
  if (use_years)
    ans <- append(ans, norm_years)
  if (use_whitespace)
    ans <- append(ans, norm_whitespace)
  if (use_lessthan)
    ans <- append(ans, norm_lessthan)
  if (use_plus)
    ans <- append(ans, norm_plus)
  if (use_range)
    ans <- append(ans, norm_range)
  if (use_infant)
    ans <- append(ans, norm_infant)
  ans
}


make_labels_normalizers_age <- function()
  make_labels_normalizers(use_tolower = TRUE,
                          use_wordnum = TRUE,
                          use_dashes = TRUE,
                          use_leadingzeros = TRUE,
                          use_years = TRUE,
                          use_whitespace = TRUE,
                          use_lessthan = FALSE,
                          use_plus = TRUE,
                          use_range = TRUE,
                          use_infant = TRUE)


make_labels_normalizers_cohort <- function()
  make_labels_normalizers(use_tolower = TRUE,
                          use_wordnum = FALSE,
                          use_dashes = TRUE,
                          use_leadingzeros = TRUE,
                          use_years = FALSE,
                          use_whitespace = TRUE,
                          use_lessthan = TRUE,
                          use_plus = FALSE,
                          use_range = TRUE,
                          use_infant = FALSE)

make_labels_normalizers_period <- function() 
  make_labels_normalizers(use_tolower = TRUE,
                          use_wordnum = FALSE,
                          use_dashes = TRUE,
                          use_leadingzeros = TRUE,
                          use_years = FALSE,
                          use_whitespace = TRUE,
                          use_lessthan = FALSE,
                          use_plus = FALSE,
                          use_range = TRUE,
                          use_infant = FALSE)


normalize_labels <- function(labels, labels_normalizers) {
  is_na <- is.na(labels)
  for (labels_normalizer in labels_normalizers)
    labels[!is_na] <- labels_normalizer(labels[!is_na])
  labels
}
