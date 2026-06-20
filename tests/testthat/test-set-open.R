test_that("age_set_open() relabels groups with lower limit at or above open", {
  x <- c("20-24", "80-84", "100+")

  expect_values(age_set_open(x, open = 80), c("20-24", "80+", "80+"))
  expect_values(age_set_open(x, open = 50), c("20-24", "50+", "50+"))
})

test_that("age_set_open() leaves groups below open unchanged", {
  expect_values(
    age_set_open(c("0-4", "80-84", "20-24"), open = 80),
    c("0-4", "80+", "20-24")
  )
})

test_that("age_set_open() relabels factor levels", {
  fx <- factor(c("80-84", "20-24"), levels = c("20-24", "80-84", "100+"))
  ans <- age_set_open(fx, open = 80)

  expect_s3_class(ans, "factor")
  expect_identical(as.character(ans), c("80+", "20-24"))
  expect_identical(levels(ans), c("20-24", "80+"))
})

test_that("age_set_open() errors when open would split an interval", {
  expect_error(
    age_set_open(c("70-89", "80-84"), open = 80),
    "Interval .70-89. would be split"
  )
})

test_that("age_set_open() relabels already-open groups to the new threshold", {
  expect_identical(age_set_open("100+", open = 100), "100+")
  expect_identical(age_set_open("100+", open = 80), "80+")
})

test_that("cohort_set_open() relabels groups to left-open cohorts", {
  x <- c("2020-2024", "<2000", "2015")

  expect_values(
    cohort_set_open(x, open = 2020),
    c("2020-2024", "<2020", "<2020")
  )
  expect_values(
    cohort_set_open(x, open = 2005),
    c("2020-2024", "<2005", "2015")
  )
})

test_that("cohort_set_open() errors when open would split an interval", {
  expect_error(
    cohort_set_open(c("2010-2019", "2015"), open = 2015),
    "Interval .2010-2019. would be split"
  )
})
