test_that("age_lower() with length-0 input returns numeric(0)", {
  expect_identical(age_lower(character(0)), numeric(0))
  expect_identical(age_lower(factor()), numeric(0))
})

test_that("age_upper() with length-0 input returns numeric(0)", {
  expect_identical(age_upper(character(0)), numeric(0))
  expect_identical(age_upper(factor()), numeric(0))
})

test_that("age_width() with length-0 input returns numeric(0)", {
  expect_identical(age_width(character(0)), numeric(0))
  expect_identical(age_width(factor()), numeric(0))
})

test_that("age_mid() with length-0 input returns numeric(0)", {
  expect_identical(age_mid(character(0)), numeric(0))
  expect_identical(age_mid(factor()), numeric(0))
})

# period_*() also has x_one and x_multi, but those only affect how labels
# are parsed; with length-0 x there is nothing to parse, so defaults suffice.

test_that("period_lower() with length-0 input returns numeric(0)", {
  expect_identical(period_lower(character(0)), numeric(0))
  expect_identical(period_lower(factor()), numeric(0))
})

test_that("period_upper() with length-0 input returns numeric(0)", {
  expect_identical(period_upper(character(0)), numeric(0))
  expect_identical(period_upper(factor()), numeric(0))
})

test_that("period_width() with length-0 input returns numeric(0)", {
  expect_identical(period_width(character(0)), numeric(0))
  expect_identical(period_width(factor()), numeric(0))
})

test_that("period_mid() with length-0 input returns numeric(0)", {
  expect_identical(period_mid(character(0)), numeric(0))
  expect_identical(period_mid(factor()), numeric(0))
})

# cohort_*() also has x_one and x_multi; same reasoning as period_*() above.

test_that("cohort_lower() with length-0 input returns numeric(0)", {
  expect_identical(cohort_lower(character(0)), numeric(0))
  expect_identical(cohort_lower(factor()), numeric(0))
})

test_that("cohort_upper() with length-0 input returns numeric(0)", {
  expect_identical(cohort_upper(character(0)), numeric(0))
  expect_identical(cohort_upper(factor()), numeric(0))
})

test_that("cohort_width() with length-0 input returns numeric(0)", {
  expect_identical(cohort_width(character(0)), numeric(0))
  expect_identical(cohort_width(factor()), numeric(0))
})

test_that("cohort_mid() with length-0 input returns numeric(0)", {
  expect_identical(cohort_mid(character(0)), numeric(0))
  expect_identical(cohort_mid(factor()), numeric(0))
})
