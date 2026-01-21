
## 'labels_age' ---------------------------------------------------------------

test_that("'labels_age' works with valid inputs", {
  limits <- list(c(5L, 6L), c(5L, 10L), c(5L, NA))
  expect_identical(labels_age(limits = limits, factor = FALSE),
                   c("5", "5-9", "5+"))
  expect_identical(labels_age(limits = limits, factor = FALSE),
                   c("5", "5-9", "5+"))
  

## 'translate_age_labels' -----------------------------------------------------

test_that("'translate_age_labels' correctly interprets valid labels", {
    x <- c("0 Year", "1 to 4 Years", "5 to 9 Years", "10 Years And Over")
    ans_obtained <- translate_age_labels(x)
    ans_expected <- c("0", "1-4", "5-9", "10+")
    expect_identical(ans_obtained, ans_expected)
    x <- c("0 yr", "1--4 yrs", "5--9 yrs", "10plus")
    ans_obtained <- translate_age_labels(x)
    ans_expected <- c("0", "1-4", "5-9", "10+")
    expect_identical(ans_obtained, ans_expected)
    x <- c("infants", "one", "two", "three")
    ans_obtained <- translate_age_labels(x)
    ans_expected <- c("0", "1", "2", "3")
    expect_identical(ans_obtained, ans_expected)
    x <- c("00", "01.04", "05.09", "10.14")
    ans_obtained <- translate_age_labels(x)
    ans_expected <- c("0", "1-4", "5-9", "10-14")
    expect_identical(ans_obtained, ans_expected)
    x <- c("one month", "2 months", "zero months", "100 m and over")
    ans_obtained <- translate_age_labels(x)
    ans_expected <- c("1month", "2months", "0months", "100m+")
    expect_identical(ans_obtained, ans_expected)
    x <- c("11 qtrs", "five quarters or more", "0 qu", "100  quarter")
    ans_obtained <- translate_age_labels(x)
    ans_expected <- c("11qtrs", "5quarters+", "0qu", "100quarter")
    expect_identical(ans_obtained, ans_expected)
    x <- "10 "
    ans_obtained <- translate_age_labels(x)
    ans_expected <- "10"
    expect_identical(ans_obtained, ans_expected)
    x <- c("0-0", "0_0")
    ans_obtained <- translate_age_labels(x)
    ans_expected <- c("0", "0")
    expect_identical(ans_obtained, ans_expected)
    x <- c("100-", "100_", "100--", "100__")
    ans_obtained <- translate_age_labels(x)
    ans_expected <- c("100+", "100+", "100+", "100+")
    expect_identical(ans_obtained, ans_expected)
    x <- "In 1st year"
    ans_obtained <- translate_age_labels(x)
    ans_expected <- "0"
    expect_identical(ans_obtained, ans_expected)
    x <- "80 years or older"
    ans_obtained <- translate_age_labels(x)
    ans_expected <- "80+"
    expect_identical(ans_obtained, ans_expected)
    x <- "80 and older"
    ans_obtained <- translate_age_labels(x)
    ans_expected <- "80+"
    expect_identical(ans_obtained, ans_expected)
    x <- "80 or older"
    ans_obtained <- translate_age_labels(x)
    ans_expected <- "80+"
    expect_identical(ans_obtained, ans_expected)
})
