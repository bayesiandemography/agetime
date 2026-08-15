test_that("reversed range labels error by default", {
  expect_error(age_lower("50-40"), "Lower limit greater than upper limit")
  expect_error(
    period_lower("2030-2020"),
    "Lower limit greater than upper limit"
  )
  expect_error(
    cohort_lower("2030-2020"),
    "Lower limit greater than upper limit"
  )
})

test_that("reversed range labels warn or return NA with interpret_fail", {
  expect_warning(
    age_lower("50-40", interpret_fail = "warn"),
    "Lower limit greater than upper limit"
  )
  expect_values(age_lower("50-40", interpret_fail = "silent"), NA_real_)

  expect_warning(
    period_lower("2030-2020", interpret_fail = "warn"),
    "Lower limit greater than upper limit"
  )
  expect_values(period_lower("2030-2020", interpret_fail = "silent"), NA_real_)
})

test_that("zero-width range labels are rejected", {
  expect_error(period_lower("2030-2030"), "Lower limit equals upper limit")
  expect_error(age_lower("5-4"), "Lower limit equals upper limit")
})

test_that("valid range labels still parse", {
  expect_values(age_lower("5-9"), 5)
  expect_values(period_lower("2020-2025"), 2020)
  expect_values(cohort_lower("2025-2030"), 2025)
})

test_that("one-year period ranges are rejected under include", {
  expect_error(
    period_lower("2010-2011"),
    regexp = "describes a one-year period"
  )
  expect_error(
    period_lower("2010-2011"),
    regexp = "interpret_multi.*include"
  )
  expect_error(
    period_lower("2010-2011"),
    regexp = "exclude"
  )
})

test_that("one-year period ranges are accepted as two years under exclude", {
  expect_values(period_lower("2010-2011", interpret_multi = "exclude"), 2010)
  expect_values(period_upper("2010-2011", interpret_multi = "exclude"), 2012)
  expect_values(period_width("2010-2011", interpret_multi = "exclude"), 2)
})

test_that("equal-endpoint period ranges are rejected under exclude", {
  expect_error(
    period_lower("2010-2010", interpret_multi = "exclude"),
    regexp = "describes a one-year period"
  )
  expect_error(
    period_lower("2010-2010", interpret_multi = "exclude"),
    regexp = "single year"
  )
  err <- tryCatch(
    period_lower("2010-2010", interpret_multi = "exclude"),
    error = identity
  )
  expect_false(grepl("meant to be two years", conditionMessage(err)))
})

test_that("single-year and two-year include period labels still parse", {
  expect_values(period_lower("2010"), 2010)
  expect_values(period_upper("2010"), 2011)
  expect_values(period_lower("2010-2012"), 2010)
  expect_values(period_upper("2010-2012"), 2012)
})

test_that("one-year cohort ranges are rejected under include", {
  expect_error(
    cohort_lower("2010-2011"),
    regexp = "describes a one-year cohort"
  )
})

test_that("one-year cohort ranges are accepted as two years under exclude", {
  expect_values(cohort_width("2010-2011", interpret_multi = "exclude"), 2)
})

test_that("age 0-1 still parses as two years", {
  expect_values(age_lower("0-1"), 0)
  expect_values(age_upper("0-1"), 2)
  expect_values(age_width("0-1"), 2)
})

test_that("one-year period ranges respect interpret_fail", {
  expect_warning(
    period_lower("2010-2011", interpret_fail = "warn"),
    regexp = "describes a one-year period"
  )
  expect_values(
    period_lower("2010-2011", interpret_fail = "silent"),
    NA_real_
  )
})
