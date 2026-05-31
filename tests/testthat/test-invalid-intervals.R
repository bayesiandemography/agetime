
test_that("reversed range labels error by default", {
  expect_error(age_lower("50-40"), "Lower limit greater than upper limit")
  expect_error(period_lower("2030-2020"), "Lower limit greater than upper limit")
  expect_error(cohort_lower("2030-2020"), "Lower limit greater than upper limit")
})

test_that("reversed range labels warn or return NA with x_fail", {
  expect_warning(age_lower("50-40", x_fail = "warn"),
                 "Lower limit greater than upper limit")
  expect_values(age_lower("50-40", x_fail = "silent"), NA_real_)

  expect_warning(period_lower("2030-2020", x_fail = "warn"),
                 "Lower limit greater than upper limit")
  expect_values(period_lower("2030-2020", x_fail = "silent"), NA_real_)
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
