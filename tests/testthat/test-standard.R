
test_that("age_standard() standardizes messy character labels", {
  ans <- age_standard(age_messy)
  expect_type(ans, "character")
  expect_false(is.factor(ans))
  expect_identical(ans, c("5-9", "10-14", "100+"))
})

test_that("age_standard() leaves standard labels unchanged", {
  ans <- age_standard(age_closed)
  expect_identical(ans, age_closed)
})

test_that("age_standard() preserves NA and Total", {
  expect_identical(age_standard(age_with_na), c("5-9", NA, "10-14"))
  expect_identical(age_standard(age_with_total), c("5-9", "Total", "10-14"))
})

test_that("age_standard() errors on unparseable labels by default", {
  expect_error(age_standard("young people"), "Don't know how to interpret")
})

test_that("age_standard() with x_fail = silent returns NA for invalid labels", {
  expect_identical(age_standard(c("0-4", "young people"), x_fail = "silent"),
                   c("0-4", NA))
})

test_that("age_standard() errors on invalid intervals by default", {
  expect_error(age_standard("50-40"), "Lower limit greater than upper limit")
})

test_that("period_standard() standardizes messy character labels", {
  ans <- period_standard(period_messy)
  expect_type(ans, "character")
  expect_false(is.factor(ans))
  expect_identical(ans, c("2025-2030", "1910-1914", "2022"))
})

test_that("period_standard() leaves standard labels unchanged", {
  ans <- period_standard(period_multi)
  expect_identical(ans, period_multi)
})

test_that("period_standard() preserves NA and Total", {
  expect_identical(period_standard(period_with_na),
                   c("2020-2025", NA, "2025-2030"))
  expect_identical(period_standard(period_with_total),
                   c("2020-2025", "Total", "2025-2030"))
})

test_that("period_standard() with x_fail = silent returns NA for invalid labels", {
  expect_identical(period_standard(c("2020-2025", "long time ago"),
                                   x_fail = "silent"),
                   c("2020-2025", NA))
  expect_identical(period_standard("2030-2020", x_fail = "silent"), NA_character_)
})

test_that("cohort_standard() standardizes messy character labels", {
  ans <- cohort_standard(cohort_messy)
  expect_type(ans, "character")
  expect_false(is.factor(ans))
  expect_identical(ans, c("2025-2030", "1910-1914", "<2022"))
})

test_that("cohort_standard() leaves standard labels unchanged", {
  ans <- cohort_standard(cohort_multi)
  expect_identical(ans, cohort_multi)
})

test_that("cohort_standard() preserves NA and Total", {
  expect_identical(cohort_standard(cohort_with_na),
                   c("2025-2030", NA, "2030-2035"))
  expect_identical(cohort_standard(cohort_with_total),
                   c("2025-2030", "Total", "2030-2035"))
})

test_that("cohort_standard() with x_fail = silent returns NA for invalid labels", {
  expect_identical(cohort_standard(c("2025-2030", "long time ago"),
                                   x_fail = "silent"),
                   c("2025-2030", NA))
})
