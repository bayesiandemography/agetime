# *_set_open(): empty character or factor with no levels -> x unchanged.
# No qualifying labels -> x unchanged. Empty factor with levels -> levels act.

test_that("age_set_open() with length-0 input returns x unchanged", {
  expect_identical(age_set_open(character(0), lower_open = 65), character(0))
  expect_identical(age_set_open(factor(), lower_open = 65), factor())
})

test_that("age_set_open() returns x unchanged when no labels qualify", {
  expect_identical(age_set_open("80-84", lower_open = 90), "80-84")
  expect_identical(
    age_set_open(factor("80-84"), lower_open = 90),
    factor("80-84")
  )
})

test_that("age_set_open() with length-0 factor relabels qualifying levels", {
  lev <- c("0-4", "80-84")
  fx <- factor(character(0), levels = lev)
  f_ref <- factor(lev, levels = lev)
  out <- age_set_open(fx, lower_open = 80)
  expect_identical(
    out,
    factor(levels = levels(age_set_open(f_ref, lower_open = 80)))
  )
  expect_identical(length(out), 0L)
  expect_identical(levels(out), c("0-4", "80+"))
})

test_that("cohort_set_open() with length-0 input returns x unchanged", {
  expect_identical(
    cohort_set_open(character(0), upper_open = 2020),
    character(0)
  )
})

test_that("cohort_set_open() with length-0 factor relabels qualifying levels", {
  lev <- c("2010-2014", "2025-2029")
  fx <- factor(character(0), levels = lev)
  f_ref <- factor(lev, levels = lev)
  out <- cohort_set_open(fx, upper_open = 2025)
  expect_identical(
    out,
    factor(levels = levels(cohort_set_open(f_ref, upper_open = 2025)))
  )
  expect_identical(length(out), 0L)
  expect_identical(levels(out), c("<2025", "2025-2029"))
})
