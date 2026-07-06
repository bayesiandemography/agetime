expect_is_logical <- function(x, ans) {
  expect_identical(length(ans), length(x))
  expect_type(ans, "logical")
}

test_that("age_is_total() identifies Total and ALL labels", {
  x <- c("20-24", "Total", "100+", "ALL")
  ans <- age_is_total(x)
  expect_is_logical(x, ans)
  expect_values(ans, c(FALSE, TRUE, FALSE, TRUE))
})

test_that("age_is_total() handles ordinary, NA, and Total labels", {
  expect_values(age_is_total(age_closed), c(FALSE, FALSE, FALSE))
  expect_values(age_is_total(age_with_na), c(FALSE, FALSE, FALSE))
  expect_values(age_is_total(age_with_total), c(FALSE, TRUE, FALSE))
})

test_that("period_is_total() identifies Total labels", {
  expect_values(period_is_total(period_with_total), c(FALSE, TRUE, FALSE))
  expect_values(period_is_total(period_with_na), c(FALSE, FALSE, FALSE))
  expect_values(period_is_total(period_multi), c(FALSE, FALSE, FALSE))
})

test_that("cohort_is_total() identifies Total and ALL labels", {
  x <- c("2020-2025", "Total", "1999", "ALL")
  ans <- cohort_is_total(x)
  expect_is_logical(x, ans)
  expect_values(ans, c(FALSE, TRUE, FALSE, TRUE))
  expect_values(cohort_is_total(cohort_with_total), c(FALSE, TRUE, FALSE))
  expect_values(cohort_is_total(cohort_with_na), c(FALSE, FALSE, FALSE))
})

test_that("age_is_open() identifies open age groups", {
  x <- c("20+", "infant", "100+", "60to79")
  ans <- age_is_open(x)
  expect_is_logical(x, ans)
  expect_values(ans, c(TRUE, FALSE, TRUE, FALSE))
  expect_values(age_is_open(age_mixed), c(FALSE, FALSE, TRUE))
  expect_values(age_is_open(age_with_na), c(FALSE, FALSE, FALSE))
  expect_values(age_is_open(age_closed), c(FALSE, FALSE, FALSE))
})

test_that("cohort_is_open() identifies open cohorts", {
  x <- c("2020", "<1900", "2040-2050", "<2022")
  ans <- cohort_is_open(x)
  expect_is_logical(x, ans)
  expect_values(ans, c(FALSE, TRUE, FALSE, TRUE))
  expect_values(cohort_is_open(cohort_multi), c(FALSE, TRUE, FALSE))
  expect_values(cohort_is_open(cohort_with_na), c(FALSE, FALSE, FALSE))
})

test_that("is functions accept factor input with the same results", {
  x <- factor(age_with_total, levels = age_with_total)
  expect_values(age_is_total(x), age_is_total(age_with_total))

  x <- factor(cohort_multi, levels = cohort_multi)
  expect_values(cohort_is_open(x), cohort_is_open(cohort_multi))
})

test_that("is_total() names match is_open() and extractors", {
  x <- c(a = "0-4", b = "5-9", c = "0-4", d = "Total")
  expect_identical(names(age_is_total(x)), names(age_is_open(x)))
  expect_identical(names(age_is_total(x)), names(age_lower(x)))

  x <- c("5to9", "10--14", "5to9")
  expect_identical(names(age_is_total(x)), names(age_is_open(x)))
  expect_identical(names(age_is_total(x)), names(age_lower(x)))

  period <- c(a = "2020-2025", b = "Total", c = "2025-2030")
  expect_identical(names(period_is_total(period)), names(period_lower(period)))

  cohort <- c(a = "2020-2025", b = "<2025", c = "Total")
  expect_identical(names(cohort_is_total(cohort)), names(cohort_is_open(cohort)))
  expect_identical(names(cohort_is_total(cohort)), names(cohort_lower(cohort)))
})
