# *_open_*(): empty inputs return factors with the open level.
# Existing factor levels are still relabelled, even when there are no values.

test_that("age_open_right() with length-0 input adds an open level", {
  expect_identical(
    age_open_right(character(0), lower_open = 65),
    factor(character(0), levels = "65+")
  )
  expect_identical(
    age_open_right(factor(), lower_open = 65),
    factor(character(0), levels = "65+")
  )
})

test_that("age_open_right() adds a level when no labels qualify", {
  expect_identical(
    age_open_right("80-84", lower_open = 90),
    factor("80-84", levels = c("80-84", "90+"))
  )
})

test_that("age_open_right() with length-0 factor relabels levels", {
  lev <- c("0-4", "80-84")
  fx <- factor(character(0), levels = lev)
  f_ref <- factor(lev, levels = lev)
  out <- age_open_right(fx, lower_open = 80)
  expect_identical(
    out,
    factor(levels = levels(age_open_right(f_ref, lower_open = 80)))
  )
  expect_identical(length(out), 0L)
  expect_identical(levels(out), c("0-4", "80+"))
})

test_that("cohort_open_left() with length-0 input adds an open level", {
  expect_identical(
    cohort_open_left(character(0), upper_open = 2020),
    factor(character(0), levels = "<2020")
  )
})

test_that("cohort_open_left() with length-0 factor relabels levels", {
  lev <- c("2010-2014", "2025-2029")
  fx <- factor(character(0), levels = lev)
  f_ref <- factor(lev, levels = lev)
  out <- cohort_open_left(fx, upper_open = 2025)
  expect_identical(
    out,
    factor(levels = levels(cohort_open_left(f_ref, upper_open = 2025)))
  )
  expect_identical(length(out), 0L)
  expect_identical(levels(out), c("<2025", "2025-2029"))
})
