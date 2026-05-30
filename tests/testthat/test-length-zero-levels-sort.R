
# *_levels_sort(): same length-0 behaviour as *_levels_fill() (without breaks).

test_that("age_levels_sort() with length-0 input returns empty factor", {
  expect_identical(age_levels_sort(character(0)), factor())
  expect_identical(age_levels_sort(factor()), factor())
})

test_that("age_levels_sort() with length-0 factor sorts levels", {
  lev <- c("20-24", "0-4", "5-9")
  fx <- factor(character(0), levels = lev)
  f_ref <- factor(lev, levels = lev)
  expect_identical(
    levels(age_levels_sort(fx)),
    levels(age_levels_sort(f_ref))
  )
})

test_that("age_levels_sort() preserves ordered on length-0 factor", {
  lev <- c("20-24", "0-4", "5-9")
  fx <- ordered(character(0), levels = lev)
  f_ref <- ordered(lev, levels = lev)
  out <- age_levels_sort(fx)
  expect_true(is.ordered(out))
  expect_identical(levels(out), levels(age_levels_sort(f_ref)))
})

test_that("period_levels_sort() with length-0 input returns empty factor", {
  expect_identical(period_levels_sort(character(0)), factor())
})

test_that("cohort_levels_sort() with length-0 factor sorts levels", {
  lev <- c("2025-2050", "2020-2025")
  fx <- factor(character(0), levels = lev)
  f_ref <- factor(lev, levels = lev)
  expect_identical(
    levels(cohort_levels_sort(fx)),
    levels(cohort_levels_sort(f_ref))
  )
})
