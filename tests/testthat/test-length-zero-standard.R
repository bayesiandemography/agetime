# *_standard(): character(0) -> character(0). Factor in -> factor out; empty x
# still standardizes the levels attribute (see test-standard-factor.R).

test_that("age_standard() with length-0 input returns character(0)", {
  expect_identical(age_standard(character(0)), character(0))
})

test_that("age_standard() with length-0 factor preserves factor and levels", {
  expect_identical(age_standard(factor()), factor())
  expect_identical(
    age_standard(factor(character(0), levels = c("5to9", "10--14"))),
    factor(character(0), levels = c("5-9", "10-14"))
  )
})

# period_standard() has x_one and x_multi; defaults suffice when length(x) == 0.

test_that("period_standard() with length-0 input returns character(0)", {
  expect_identical(period_standard(character(0)), character(0))
})

test_that("period_standard() preserves length-0 factor levels", {
  expect_identical(period_standard(factor()), factor())
  expect_identical(
    period_standard(factor(character(0), levels = c("2025to2030", " 2022 "))),
    factor(character(0), levels = c("2025-2030", "2022"))
  )
})

# cohort_standard() has x_one and x_multi; same reasoning as period_standard().

test_that("cohort_standard() with length-0 input returns character(0)", {
  expect_identical(cohort_standard(character(0)), character(0))
})

test_that("cohort_standard() preserves length-0 factor levels", {
  expect_identical(cohort_standard(factor()), factor())
  expect_identical(
    cohort_standard(factor(character(0), levels = c("2025to2030", "< 2022 "))),
    factor(character(0), levels = c("2025-2030", "<2022"))
  )
})
