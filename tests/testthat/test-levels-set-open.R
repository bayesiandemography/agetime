test_that("age_set_open_right() relabels groups at or above breakpoint", {
  x <- c("20-24", "80-84", "100+")

  ans <- age_set_open_right(x, at = 80)
  expect_s3_class(ans, "factor")
  expect_identical(as.character(ans), c("20-24", "80+", "80+"))
  expect_identical(levels(ans), c("20-24", "80+"))

  ans <- age_set_open_right(x, at = 50)
  expect_identical(as.character(ans), c("20-24", "50+", "50+"))
  expect_identical(levels(ans), c("20-24", "50+"))
})

test_that("age_set_open_right() can add an unobserved open level", {
  ans <- age_set_open_right(c("0-4", "60-64"), at = 70)
  expect_identical(as.character(ans), c("0-4", "60-64"))
  expect_identical(levels(ans), c("0-4", "60-64", "70+"))
})

test_that("age_set_open_right() relabels factor levels", {
  fx <- factor(c("80-84", "20-24"), levels = c("20-24", "80-84", "100+"))
  ans <- age_set_open_right(fx, at = 80)

  expect_s3_class(ans, "factor")
  expect_identical(as.character(ans), c("80+", "20-24"))
  expect_identical(levels(ans), c("20-24", "80+"))
})

test_that("age_set_open_right() errors when breakpoint splits an interval", {
  expect_error(
    age_set_open_right(c("70-89", "80-84"), at = 80),
    "Interval .70-89. would be split"
  )
})

test_that("age_set_open_right() relabels already-open groups", {
  expect_identical(
    as.character(age_set_open_right("100+", at = 100)),
    "100+"
  )
  expect_identical(
    as.character(age_set_open_right("100+", at = 80)),
    "80+"
  )
})

test_that("cohort_set_open_left() relabels groups to left-open cohorts", {
  x <- c("2020-2024", "<2000", "2015")

  ans <- cohort_set_open_left(x, at = 2020)
  expect_s3_class(ans, "factor")
  expect_identical(as.character(ans), c("2020-2024", "<2020", "<2020"))
  expect_identical(levels(ans), c("<2020", "2020-2024"))

  ans <- cohort_set_open_left(x, at = 2005)
  expect_identical(as.character(ans), c("2020-2024", "<2005", "2015"))
  expect_identical(levels(ans), c("<2005", "2015", "2020-2024"))
})

test_that("cohort_set_open_left() can add an unobserved open level", {
  ans <- cohort_set_open_left(
    c("2000-2004", "2010-2014"),
    at = 1990,
    interpret_multi = "ex"
  )
  expect_identical(as.character(ans), c("2000-2004", "2010-2014"))
  expect_identical(levels(ans), c("<1990", "2000-2004", "2010-2014"))
})

test_that("cohort_set_open_left() errors when breakpoint splits", {
  expect_error(
    cohort_set_open_left(c("2010-2019", "2015"), at = 2015),
    "Interval .2010-2019. would be split"
  )
})

test_that("cohort_set_open_right() relabels groups to right-open cohorts", {
  x <- c("2020-2024", "2025-2029", "2030")

  ans <- cohort_set_open_right(x, at = 2030)
  expect_s3_class(ans, "factor")
  expect_identical(as.character(ans), c("2020-2024", "2025-2029", "2030+"))
  expect_identical(levels(ans), c("2020-2024", "2025-2029", "2030+"))
})

test_that("period_set_open_left() relabels groups to left-open periods", {
  x <- c("2010-2020", "2025-2029")

  ans <- period_set_open_left(x, at = 2020)
  expect_s3_class(ans, "factor")
  expect_identical(as.character(ans), c("<2020", "2025-2029"))
  expect_identical(levels(ans), c("<2020", "2025-2029"))
})

test_that("period_set_open_right() relabels groups to right-open periods", {
  x <- c("2020-2024", "2025-2029", "2030")

  ans <- period_set_open_right(x, at = 2030)
  expect_s3_class(ans, "factor")
  expect_identical(as.character(ans), c("2020-2024", "2025-2029", "2030+"))
  expect_identical(levels(ans), c("2020-2024", "2025-2029", "2030+"))
})

test_that("inner_levels_set_open() errors when no open direction is specified", {
  expect_error(
    agetime:::inner_levels_set_open(
      labels = c("0-4", "5-9"),
      open_boundary = 10,
      nm_open_boundary = "at",
      make_open_left = FALSE,
      make_open_right = FALSE,
      label_type = "age",
      interpret_single = "lower",
      interpret_multi = "exclude",
      interpret_fail = "error"
    ),
    "Internal error: no open direction specified."
  )
})
