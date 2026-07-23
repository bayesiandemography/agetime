# *_coarsen(): empty character -> character() for width-based helpers, factor()
# with levels for breaks-based coarsen. Empty factor with no levels -> factor().
# Empty factor with levels -> levels still coarsened.

test_that("age_coarsen() with length-0 input returns empty factor with levels", {
  expect_identical(
    age_coarsen(character(0), breaks = c(0, 10, 90)),
    factor(levels = c("0-9", "10-89"))
  )
})

test_that("age_coarsen() with length-0 input and open_right adds level", {
  expect_identical(
    levels(age_coarsen(character(0), breaks = c(0, 10, 90), open_right = TRUE)),
    c("0-9", "10-89", "90+")
  )
})

test_that("age_coarsen() with length-0 factor updates levels", {
  expect_identical(
    age_coarsen(factor(), breaks = c(0, 10, 90)),
    factor(levels = c("0-9", "10-89"))
  )
  fx <- factor(character(0), levels = c("0-4", "5-9"))
  expect_identical(
    age_coarsen(fx, breaks = c(0, 10, 90)),
    factor(character(0), levels = c("0-9", "10-89"))
  )
})

test_that("age_coarsen_five() with length-0 input returns empty character", {
  expect_identical(age_coarsen_five(character(0)), character(0))
})

test_that("inner_coarsen() with no unique labels uses minimal empty levels", {
  expect_identical(
    agetime:::inner_coarsen(
      labels = character(0),
      breaks = c(0, 5, 10),
      is_open_left = FALSE,
      is_open_right = FALSE,
      label_type = "age",
      interpret_single = "lower",
      interpret_multi = "exclude",
      interpret_fail = "error",
      minimal_levels = TRUE,
      preserve_input_type = TRUE
    ),
    character(0)
  )
  expect_identical(
    agetime:::inner_coarsen(
      labels = character(0),
      breaks = c(0, 5, 10),
      is_open_left = FALSE,
      is_open_right = TRUE,
      label_type = "age",
      interpret_single = "lower",
      interpret_multi = "exclude",
      interpret_fail = "error",
      minimal_levels = TRUE,
      preserve_input_type = FALSE
    ),
    factor(levels = "10+")
  )
})

test_that("age_coarsen_five() with length-0 factor updates levels", {
  expect_identical(age_coarsen_five(factor()), factor())
  lev <- c("0-4", "5-9", "50-54")
  fx <- factor(character(0), levels = lev)
  f_ref <- factor(lev, levels = lev)
  expect_identical(
    levels(age_coarsen_five(fx)),
    levels(age_coarsen_five(f_ref))
  )
})

test_that("age_coarsen_life() with length-0 input returns empty character", {
  expect_identical(age_coarsen_life(character(0)), character(0))
  expect_identical(age_coarsen_life(factor()), factor())
  lev <- c("0", "1-4", "5-9", "50-54")
  fx <- factor(character(0), levels = lev)
  f_ref <- factor(lev, levels = lev)
  expect_identical(
    levels(age_coarsen_life(fx)),
    levels(age_coarsen_life(f_ref))
  )
})

# period_coarsen() / cohort_coarsen() have interpret_single and
# interpret_multi; defaults suffice.

test_that("period_coarsen() with length-0 input returns empty factor with levels", {
  expect_identical(
    period_coarsen(character(0), breaks = c(2000, 2010, 2020)),
    factor(levels = c("2000-2010", "2010-2020"))
  )
})

test_that("period_coarsen() with length-0 factor updates levels", {
  fx <- factor(character(0), levels = c("2000-2004", "2005-2009"))
  expect_identical(
    period_coarsen(fx, breaks = c(2000, 2010, 2020)),
    factor(character(0), levels = c("2000-2010", "2010-2020"))
  )
})

test_that("cohort_coarsen() with length-0 input returns empty factor with levels", {
  expect_identical(
    cohort_coarsen(character(0), breaks = c(2000, 2010, 2020)),
    factor(levels = c("2000-2010", "2010-2020"))
  )
})

test_that("cohort_coarsen() with length-0 input and open_right adds level", {
  expect_identical(
    levels(cohort_coarsen(character(0), breaks = c(2000, 2010, 2020), open_right = TRUE)),
    c("2000-2010", "2010-2020", "2020+")
  )
})

test_that("cohort_coarsen() with length-0 factor updates levels", {
  fx <- factor(character(0), levels = c("2000-2004", "2005-2009"))
  expect_identical(
    cohort_coarsen(fx, breaks = c(2000, 2010, 2020)),
    factor(character(0), levels = c("2000-2010", "2010-2020"))
  )
})

test_that("period_coarsen_five() with length-0 input returns empty character", {
  expect_identical(period_coarsen_five(character(0)), character(0))
})

test_that("period_coarsen_five() with length-0 factor updates levels", {
  lev <- c("2000-2004", "2005-2009", "2015-2019")
  fx <- factor(character(0), levels = lev)
  f_ref <- factor(lev, levels = lev)
  expect_identical(
    levels(period_coarsen_five(fx)),
    levels(period_coarsen_five(f_ref))
  )
})

test_that("cohort_coarsen_five() with length-0 input returns empty character", {
  expect_identical(cohort_coarsen_five(character(0)), character(0))
})

test_that("cohort_coarsen_five() with length-0 factor updates levels", {
  lev <- c("2000-2004", "2005-2009", "2015-2019")
  fx <- factor(character(0), levels = lev)
  f_ref <- factor(lev, levels = lev)
  expect_identical(
    levels(cohort_coarsen_five(fx)),
    levels(cohort_coarsen_five(f_ref))
  )
})

test_that("age_coarsen_ten() with length-0 input returns empty character", {
  expect_identical(age_coarsen_ten(character(0)), character(0))
})

test_that("age_coarsen_ten() with length-0 factor updates levels", {
  expect_identical(age_coarsen_ten(factor()), factor())
  lev <- c("0-4", "5-9", "50-54")
  fx <- factor(character(0), levels = lev)
  f_ref <- factor(lev, levels = lev)
  expect_identical(
    levels(age_coarsen_ten(fx)),
    levels(age_coarsen_ten(f_ref))
  )
})

test_that("period_coarsen_ten() with length-0 input returns empty character", {
  expect_identical(period_coarsen_ten(character(0)), character(0))
})

test_that("period_coarsen_ten() with length-0 factor updates levels", {
  lev <- c("2000-2004", "2005-2009")
  fx <- factor(character(0), levels = lev)
  f_ref <- factor(lev, levels = lev)
  expect_identical(
    levels(period_coarsen_ten(fx)),
    levels(period_coarsen_ten(f_ref))
  )
})

test_that("cohort_coarsen_ten() with length-0 input returns empty character", {
  expect_identical(cohort_coarsen_ten(character(0)), character(0))
})

test_that("cohort_coarsen_ten() with length-0 factor updates levels", {
  lev <- c("2000-2004", "2005-2009")
  fx <- factor(character(0), levels = lev)
  f_ref <- factor(lev, levels = lev)
  expect_identical(
    levels(cohort_coarsen_ten(fx)),
    levels(cohort_coarsen_ten(f_ref))
  )
})
