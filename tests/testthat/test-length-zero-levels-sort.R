# *_sort(): same length-0 behaviour as *_fill() (without breaks).

test_that("age_sort() with length-0 input returns empty factor", {
  expect_identical(age_sort(character(0)), factor())
  expect_identical(age_sort(factor()), factor())
})

test_that("age_sort() with length-0 factor sorts levels", {
  lev <- c("20-24", "0-4", "5-9")
  fx <- factor(character(0), levels = lev)
  f_ref <- factor(lev, levels = lev)
  expect_identical(
    levels(age_sort(fx)),
    levels(age_sort(f_ref))
  )
})

test_that("age_sort() preserves ordered on length-0 factor", {
  lev <- c("20-24", "0-4", "5-9")
  fx <- ordered(character(0), levels = lev)
  f_ref <- ordered(lev, levels = lev)
  out <- age_sort(fx)
  expect_true(is.ordered(out))
  expect_identical(levels(out), levels(age_sort(f_ref)))
})

test_that("period_sort() with length-0 input returns empty factor", {
  expect_identical(period_sort(character(0)), factor())
})

test_that("cohort_sort() with length-0 factor sorts levels", {
  lev <- c("2025-2050", "2020-2025")
  fx <- factor(character(0), levels = lev)
  f_ref <- factor(lev, levels = lev)
  expect_identical(
    levels(cohort_sort(fx)),
    levels(cohort_sort(f_ref))
  )
})
