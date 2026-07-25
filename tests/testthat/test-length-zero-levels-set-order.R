# *_set_order(): same length-0 behaviour as *_fill() (without breaks).

test_that("age_set_order() with length-0 input returns empty factor", {
  expect_identical(age_set_order(character(0)), factor())
  expect_identical(age_set_order(factor()), factor())
})

test_that("age_set_order() with length-0 factor sorts levels", {
  lev <- c("20-24", "0-4", "5-9")
  fx <- factor(character(0), levels = lev)
  f_ref <- factor(lev, levels = lev)
  expect_identical(
    levels(age_set_order(fx)),
    levels(age_set_order(f_ref))
  )
})

test_that("age_set_order() preserves ordered on length-0 factor", {
  lev <- c("20-24", "0-4", "5-9")
  fx <- ordered(character(0), levels = lev)
  f_ref <- ordered(lev, levels = lev)
  out <- age_set_order(fx)
  expect_true(is.ordered(out))
  expect_identical(levels(out), levels(age_set_order(f_ref)))
})

test_that("period_set_order() with length-0 input returns empty factor", {
  expect_identical(period_set_order(character(0)), factor())
})

test_that("cohort_set_order() with length-0 factor sorts levels", {
  lev <- c("2025-2050", "2020-2025")
  fx <- factor(character(0), levels = lev)
  f_ref <- factor(lev, levels = lev)
  expect_identical(
    levels(cohort_set_order(fx)),
    levels(cohort_set_order(f_ref))
  )
})
