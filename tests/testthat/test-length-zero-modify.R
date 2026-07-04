# *_modify(): character(0) -> character(0). Factor in -> factor out.
# Empty x still updates levels from breaks.

test_that("age_modify() with length-0 input returns character(0)", {
  expect_identical(
    age_modify(character(0), breaks = c(0, 10, 90)),
    character(0)
  )
})

test_that("age_modify() with length-0 factor updates levels", {
  expect_identical(
    age_modify(factor(), breaks = c(0, 10, 90)),
    factor(levels = c("0-9", "10-89", "90+"))
  )
  fx <- factor(character(0), levels = c("0-4", "5-9"))
  expect_identical(
    age_modify(fx, breaks = c(0, 10, 90)),
    factor(character(0), levels = c("0-9", "10-89", "90+"))
  )
})

test_that("age_modify_five() with length-0 input returns character(0)", {
  expect_identical(age_modify_five(character(0)), character(0))
})

test_that("age_modify_five() with length-0 factor updates levels", {
  expect_identical(age_modify_five(factor()), factor())
  lev <- c("0-4", "5-9", "50-54")
  fx <- factor(character(0), levels = lev)
  f_ref <- factor(lev, levels = lev)
  expect_identical(
    levels(age_modify_five(fx)),
    levels(age_modify_five(f_ref))
  )
})

test_that("age_modify_life() with length-0 factor updates levels", {
  expect_identical(age_modify_life(character(0)), character(0))
  expect_identical(age_modify_life(factor()), factor())
  lev <- c("0", "1-4", "5-9", "50-54")
  fx <- factor(character(0), levels = lev)
  f_ref <- factor(lev, levels = lev)
  expect_identical(
    levels(age_modify_life(fx)),
    levels(age_modify_life(f_ref))
  )
})

# period_modify() / cohort_modify() have interpret_single and
# interpret_multi; defaults suffice.

test_that("period_modify() with length-0 input returns character(0)", {
  expect_identical(
    period_modify(character(0), breaks = c(2000, 2010, 2020)),
    character(0)
  )
})

test_that("period_modify() with length-0 factor updates levels", {
  fx <- factor(character(0), levels = c("2000-2004", "2005-2009"))
  expect_identical(
    period_modify(fx, breaks = c(2000, 2010, 2020)),
    factor(character(0), levels = c("2000-2010", "2010-2020"))
  )
})

test_that("cohort_modify() with length-0 input returns character(0)", {
  expect_identical(
    cohort_modify(character(0), breaks = c(2000, 2010, 2020)),
    character(0)
  )
})

test_that("cohort_modify() with length-0 factor updates levels", {
  fx <- factor(character(0), levels = c("2000-2004", "2005-2009"))
  expect_identical(
    cohort_modify(fx, breaks = c(2000, 2010, 2020)),
    factor(character(0), levels = c("2000-2010", "2010-2020"))
  )
})

test_that("period_modify_five() with length-0 factor updates levels", {
  expect_identical(period_modify_five(character(0)), character(0))
  lev <- c("2000-2004", "2005-2009", "2015-2019")
  fx <- factor(character(0), levels = lev)
  f_ref <- factor(lev, levels = lev)
  expect_identical(
    levels(period_modify_five(fx)),
    levels(period_modify_five(f_ref))
  )
})

test_that("cohort_modify_five() with length-0 factor updates levels", {
  expect_identical(cohort_modify_five(character(0)), character(0))
  lev <- c("2000-2004", "2005-2009", "2015-2019")
  fx <- factor(character(0), levels = lev)
  f_ref <- factor(lev, levels = lev)
  expect_identical(
    levels(cohort_modify_five(fx)),
    levels(cohort_modify_five(f_ref))
  )
})

test_that("age_modify_ten() with length-0 input returns character(0)", {
  expect_identical(age_modify_ten(character(0)), character(0))
})

test_that("age_modify_ten() with length-0 factor updates levels", {
  expect_identical(age_modify_ten(factor()), factor())
  lev <- c("0-4", "5-9", "50-54")
  fx <- factor(character(0), levels = lev)
  f_ref <- factor(lev, levels = lev)
  expect_identical(
    levels(age_modify_ten(fx)),
    levels(age_modify_ten(f_ref))
  )
})

test_that("period_modify_ten() with length-0 factor updates levels", {
  expect_identical(period_modify_ten(character(0)), character(0))
  lev <- c("2000-2004", "2005-2009")
  fx <- factor(character(0), levels = lev)
  f_ref <- factor(lev, levels = lev)
  expect_identical(
    levels(period_modify_ten(fx)),
    levels(period_modify_ten(f_ref))
  )
})

test_that("cohort_modify_ten() with length-0 factor updates levels", {
  expect_identical(cohort_modify_ten(character(0)), character(0))
  lev <- c("2000-2004", "2005-2009")
  fx <- factor(character(0), levels = lev)
  f_ref <- factor(lev, levels = lev)
  expect_identical(
    levels(cohort_modify_ten(fx)),
    levels(cohort_modify_ten(f_ref))
  )
})
