# *_fill(): empty character -> factor(). Empty factor with no levels ->
# factor(). Empty factor with levels -> levels still filled. With breaks and no
# levels, levels are built from breaks.

test_that("age_fill() with length-0 input returns empty factor", {
  expect_identical(age_fill(character(0)), factor())
  expect_identical(age_fill(factor()), factor())
})

test_that("age_fill() with length-0 input and breaks builds levels", {
  expect_identical(
    levels(age_fill(character(0), breaks = c(0, 10, 20))),
    c("0-9", "10-19")
  )
  expect_identical(
    levels(age_fill(factor(), breaks = c(0, 10, 20))),
    c("0-9", "10-19")
  )
})

test_that("age_fill_five() with length-0 input returns empty factor", {
  expect_identical(age_fill_five(character(0)), factor())
})

test_that("age_fill() with length-0 factor updates levels", {
  lev <- c("0-4", "20-24")
  fx <- factor(character(0), levels = lev)
  f_ref <- factor(lev, levels = lev)
  expect_identical(
    levels(age_fill_five(fx)),
    levels(age_fill_five(f_ref))
  )
})

test_that("age_fill() preserves ordered on length-0 factor", {
  lev <- c("0-4", "20-24")
  fx <- ordered(character(0), levels = lev)
  f_ref <- ordered(lev, levels = lev)
  out <- age_fill_five(fx)
  expect_true(is.ordered(out))
  expect_identical(levels(out), levels(age_fill_five(f_ref)))
})

test_that("age_fill_life() returns ordered empty factor", {
  fx <- ordered(character(0))
  out <- age_fill_life(fx)

  expect_true(is.ordered(out))
  expect_identical(out, ordered())
})

test_that("age_fill_life() with length-0 factor updates levels", {
  expect_identical(age_fill_life(character(0)), factor())
  expect_identical(age_fill_life(factor()), factor())
  lev <- c("0", "5-9", "10-14")
  fx <- factor(character(0), levels = lev)
  f_ref <- factor(lev, levels = lev)
  expect_identical(
    levels(age_fill_life(fx)),
    levels(age_fill_life(f_ref))
  )
})

# period_fill() / cohort_fill() have interpret_single
# and interpret_multi; defaults
# suffice when length(x) == 0.

test_that("period_fill() with length-0 input and breaks builds levels", {
  expect_identical(
    levels(period_fill(character(0), breaks = c(2000, 2010, 2020))),
    c("2000-2010", "2010-2020")
  )
})

test_that("cohort_fill_five() with length-0 factor updates levels", {
  expect_identical(cohort_fill_five(character(0)), factor())
  lev <- c("2000-2004", "2009-2013")
  fx <- factor(character(0), levels = lev)
  f_ref <- factor(lev, levels = lev)
  expect_identical(
    levels(cohort_fill_five(fx)),
    levels(cohort_fill_five(f_ref))
  )
})
