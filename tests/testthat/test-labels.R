
test_that("age_labels_one() creates one-year age groups", {
  expect_identical(
    age_labels_one(lower_first = 15, lower_last = 17, open = FALSE),
    c("15", "16", "17")
  )
})

test_that("age_labels_ten() creates ten-year age groups", {
  expect_identical(
    age_labels_ten(lower_first = 0, lower_last = 20, open = FALSE),
    c("0-9", "10-19", "20-29")
  )
})

test_that("period_labels() creates labels from breaks", {
  expect_identical(
    period_labels(breaks = c(2000, 2005, 2010, 2015), include_total = TRUE),
    c("2000-2005", "2005-2010", "2010-2015", "Total")
  )
})

test_that("age_labels_five() creates default five-year age groups", {
  ans <- age_labels_five()

  expect_type(ans, "character")
  expect_false(is.factor(ans))
  expect_identical(length(ans), 21L)
  expect_identical(head(ans, 3L), c("0-4", "5-9", "10-14"))
  expect_identical(tail(ans, 2L), c("95-99", "100+"))
})

test_that("age_labels_five() ends with an open group at lower_last", {
  expect_identical(
    tail(age_labels_five(lower_last = 80), 2L),
    c("75-79", "80+")
  )
})

test_that("age_labels_five() with open = FALSE creates closed groups", {
  expect_identical(
    age_labels_five(lower_first = 15, lower_last = 45, open = FALSE),
    c("15-19", "20-24", "25-29", "30-34", "35-39", "40-44", "45-49")
  )
})

test_that("age_labels() creates labels from breaks", {
  expect_identical(
    age_labels(breaks = c(0, 5, 10, 14, 18), open = FALSE),
    c("0-4", "5-9", "10-13", "14-17")
  )
})

test_that("age_labels_life() creates life-table age groups", {
  expect_identical(
    age_labels_life(lower_last = 75),
    c("0", "1-4", "5-9", "10-14", "15-19", "20-24", "25-29", "30-34",
      "35-39", "40-44", "45-49", "50-54", "55-59", "60-64", "65-69",
      "70-74", "75+")
  )
})

test_that("age_labels_five() can include Total and NA", {
  ans <- age_labels_five(lower_last = 20,
                         include_total = TRUE,
                         include_na = TRUE)
  expect_identical(ans, c("0-4", "5-9", "10-14", "15-19", "20+", "Total", NA))
})

test_that("period_labels_five() creates five-year period labels", {
  expect_identical(
    period_labels_five(lower_first = 2000, lower_last = 2010),
    c("2000-2005", "2005-2010", "2010-2015")
  )
})

test_that("period_labels_one() respects x_one = upper", {
  expect_identical(
    period_labels_one(lower_first = 2000, lower_last = 2002, x_one = "upper"),
    c("2001", "2002", "2003")
  )
})

test_that("period_labels_ten() can include Total and NA", {
  expect_identical(
    period_labels_ten(lower_first = 2000,
                      lower_last = 2010,
                      include_total = TRUE,
                      include_na = TRUE),
    c("2000-2010", "2010-2020", "Total", NA)
  )
})

test_that("cohort_labels_five() creates five-year cohort labels", {
  expect_identical(
    cohort_labels_five(lower_first = 2000, lower_last = 2010),
    c("2000-2005", "2005-2010", "2010-2015")
  )
})

test_that("cohort_labels_five() with open = TRUE starts with a left-open cohort", {
  expect_identical(
    head(cohort_labels_five(lower_first = 1960,
                            lower_last = 1970,
                            open = TRUE),
         2L),
    c("<1960", "1960-1965")
  )
})

test_that("cohort_labels_ten() can include Total and NA", {
  expect_identical(
    cohort_labels_ten(lower_first = 2000,
                      lower_last = 2010,
                      include_total = TRUE,
                      include_na = TRUE),
    c("2000-2010", "2010-2020", "Total", NA)
  )
})

test_that("label generators error when lower_first is not less than lower_last", {
  expect_error(
    age_labels_five(lower_first = 50, lower_last = 20),
    "`lower_first` is not less than `lower_last`"
  )
  expect_error(
    cohort_labels_one(lower_first = 2010, lower_last = 2000),
    "`lower_first` is not less than `lower_last`"
  )
})
