# *_set_open_*(): empty inputs return factors with the open level.
# Existing factor levels are still relabelled, even when there are no values.

test_that("age_set_open_right() with length-0 input adds an open level", {
  expect_identical(
    age_set_open_right(character(0), at = 65),
    factor(character(0), levels = "65+")
  )
  expect_identical(
    age_set_open_right(factor(), at = 65),
    factor(character(0), levels = "65+")
  )
})

test_that("age_set_open_right() adds a level when no labels qualify", {
  expect_identical(
    age_set_open_right("80-84", at = 90),
    factor("80-84", levels = c("80-84", "90+"))
  )
})

test_that("age_set_open_right() with length-0 factor relabels levels", {
  lev <- c("0-4", "80-84")
  fx <- factor(character(0), levels = lev)
  f_ref <- factor(lev, levels = lev)
  out <- age_set_open_right(fx, at = 80)
  expect_identical(
    out,
    factor(levels = levels(age_set_open_right(f_ref, at = 80)))
  )
  expect_identical(length(out), 0L)
  expect_identical(levels(out), c("0-4", "80+"))
})

test_that("cohort_set_open_left() with length-0 input adds an open level", {
  expect_identical(
    cohort_set_open_left(character(0), at = 2020),
    factor(character(0), levels = "<2020")
  )
})

test_that("cohort_set_open_left() with length-0 factor relabels levels", {
  lev <- c("2010-2014", "2025-2029")
  fx <- factor(character(0), levels = lev)
  f_ref <- factor(lev, levels = lev)
  out <- cohort_set_open_left(fx, at = 2025)
  expect_identical(
    out,
    factor(levels = levels(cohort_set_open_left(f_ref, at = 2025)))
  )
  expect_identical(length(out), 0L)
  expect_identical(levels(out), c("<2025", "2025-2029"))
})
