test_that("age_open_right() relabels groups at or above lower_open", {
  x <- c("20-24", "80-84", "100+")

  ans <- age_open_right(x, lower_open = 80)
  expect_s3_class(ans, "factor")
  expect_identical(as.character(ans), c("20-24", "80+", "80+"))
  expect_identical(levels(ans), c("20-24", "80+"))

  ans <- age_open_right(x, lower_open = 50)
  expect_identical(as.character(ans), c("20-24", "50+", "50+"))
  expect_identical(levels(ans), c("20-24", "50+"))
})

test_that("age_open_right() can add an unobserved open level", {
  ans <- age_open_right(c("0-4", "60-64"), lower_open = 70)
  expect_identical(as.character(ans), c("0-4", "60-64"))
  expect_identical(levels(ans), c("0-4", "60-64", "70+"))
})

test_that("age_open_right() relabels factor levels", {
  fx <- factor(c("80-84", "20-24"), levels = c("20-24", "80-84", "100+"))
  ans <- age_open_right(fx, lower_open = 80)

  expect_s3_class(ans, "factor")
  expect_identical(as.character(ans), c("80+", "20-24"))
  expect_identical(levels(ans), c("20-24", "80+"))
})

test_that("age_open_right() errors when lower_open splits an interval", {
  expect_error(
    age_open_right(c("70-89", "80-84"), lower_open = 80),
    "Interval .70-89. would be split"
  )
})

test_that("age_open_right() relabels already-open groups", {
  expect_identical(
    as.character(age_open_right("100+", lower_open = 100)),
    "100+"
  )
  expect_identical(
    as.character(age_open_right("100+", lower_open = 80)),
    "80+"
  )
})

test_that("cohort_open_left() relabels groups to left-open cohorts", {
  x <- c("2020-2024", "<2000", "2015")

  ans <- cohort_open_left(x, upper_open = 2020)
  expect_s3_class(ans, "factor")
  expect_identical(as.character(ans), c("2020-2024", "<2020", "<2020"))
  expect_identical(levels(ans), c("<2020", "2020-2024"))

  ans <- cohort_open_left(x, upper_open = 2005)
  expect_identical(as.character(ans), c("2020-2024", "<2005", "2015"))
  expect_identical(levels(ans), c("<2005", "2015", "2020-2024"))
})

test_that("cohort_open_left() can add an unobserved open level", {
  ans <- cohort_open_left(
    c("2000-2004", "2010-2014"),
    upper_open = 1990,
    interpret_multi = "ex"
  )
  expect_identical(as.character(ans), c("2000-2004", "2010-2014"))
  expect_identical(levels(ans), c("<1990", "2000-2004", "2010-2014"))
})

test_that("cohort_open_left() errors when upper_open splits", {
  expect_error(
    cohort_open_left(c("2010-2019", "2015"), upper_open = 2015),
    "Interval .2010-2019. would be split"
  )
})

test_that("cohort_open_right() relabels groups to right-open cohorts", {
  x <- c("2020-2024", "2025-2029", "2030")

  ans <- cohort_open_right(x, lower_open = 2030)
  expect_s3_class(ans, "factor")
  expect_identical(as.character(ans), c("2020-2024", "2025-2029", "2030+"))
  expect_identical(levels(ans), c("2020-2024", "2025-2029", "2030+"))
})

test_that("period_open_left() relabels groups to left-open periods", {
  x <- c("2010-2020", "2025-2029")

  ans <- period_open_left(x, upper_open = 2020)
  expect_s3_class(ans, "factor")
  expect_identical(as.character(ans), c("<2020", "2025-2029"))
  expect_identical(levels(ans), c("<2020", "2025-2029"))
})

test_that("period_open_right() relabels groups to right-open periods", {
  x <- c("2020-2024", "2025-2029", "2030")

  ans <- period_open_right(x, lower_open = 2030)
  expect_s3_class(ans, "factor")
  expect_identical(as.character(ans), c("2020-2024", "2025-2029", "2030+"))
  expect_identical(levels(ans), c("2020-2024", "2025-2029", "2030+"))
})
