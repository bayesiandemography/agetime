# *_is_open_*() / *_is_total() return logical vectors (not numeric).

test_that("age_is_open_right() with length-0 input returns logical(0)", {
  expect_identical(age_is_open_right(character(0)), logical(0))
  expect_identical(age_is_open_right(factor()), logical(0))
})

test_that("age_is_total() with length-0 input returns logical(0)", {
  expect_identical(age_is_total(character(0)), logical(0))
  expect_identical(age_is_total(factor()), logical(0))
})

# period_is_total() has interpret_single and interpret_multi;
# defaults suffice when length(labels) == 0.

test_that("period_is_total() with length-0 input returns logical(0)", {
  expect_identical(period_is_total(character(0)), logical(0))
  expect_identical(period_is_total(factor()), logical(0))
})

test_that("period_is_open_left() with length-0 input returns logical(0)", {
  expect_identical(period_is_open_left(character(0)), logical(0))
  expect_identical(period_is_open_left(factor()), logical(0))
})

test_that("period_is_open_right() with length-0 input returns logical(0)", {
  expect_identical(period_is_open_right(character(0)), logical(0))
  expect_identical(period_is_open_right(factor()), logical(0))
})

# cohort_is_open_*() and cohort_is_total() have interpret_single
# and interpret_multi.

test_that("cohort_is_open_left() with length-0 input returns logical(0)", {
  expect_identical(cohort_is_open_left(character(0)), logical(0))
  expect_identical(cohort_is_open_left(factor()), logical(0))
})

test_that("cohort_is_open_right() with length-0 input returns logical(0)", {
  expect_identical(cohort_is_open_right(character(0)), logical(0))
  expect_identical(cohort_is_open_right(factor()), logical(0))
})

test_that("cohort_is_total() with length-0 input returns logical(0)", {
  expect_identical(cohort_is_total(character(0)), logical(0))
  expect_identical(cohort_is_total(factor()), logical(0))
})
