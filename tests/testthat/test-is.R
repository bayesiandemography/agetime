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

test_that("age_is_missing() identifies NA and missing-label tokens", {
  x <- c("0-4", NA, "not stated", "Total", "missing")
  ans <- age_is_missing(x)
  expect_is_logical(x, ans)
  expect_values(ans, c(FALSE, TRUE, TRUE, FALSE, TRUE))
})

test_that("age_is_missing() treats dont know variants as missing", {
  x <- c("0-4", "dont know", "Don't Know", "don\u2019t know", "Total")
  expect_values(age_is_missing(x), c(FALSE, TRUE, TRUE, TRUE, FALSE))
})

test_that("age_is_missing() handles ordinary, NA, and Total labels", {
  expect_values(age_is_missing(age_closed), c(FALSE, FALSE, FALSE))
  expect_values(age_is_missing(age_with_na), c(FALSE, TRUE, FALSE))
  expect_values(age_is_missing(age_with_total), c(FALSE, FALSE, FALSE))
})

test_that("period_is_missing() identifies missing period labels", {
  expect_values(period_is_missing(period_with_na), c(FALSE, TRUE, FALSE))
  expect_values(period_is_missing(period_with_total), c(FALSE, FALSE, FALSE))
  expect_values(period_is_missing(period_multi), c(FALSE, FALSE, FALSE))
  expect_values(
    period_is_missing(c("2020-2025", "unknown", "ALL")),
    c(FALSE, TRUE, FALSE)
  )
})

test_that("cohort_is_missing() identifies missing cohort labels", {
  expect_values(cohort_is_missing(cohort_with_na), c(FALSE, TRUE, FALSE))
  expect_values(cohort_is_missing(cohort_with_total), c(FALSE, FALSE, FALSE))
  expect_values(
    cohort_is_missing(c("2020-2025", "N/A", "Total")),
    c(FALSE, TRUE, FALSE)
  )
})

test_that("age_is_open_right() identifies right-open age groups", {
  x <- c("20+", "infant", "100+", "60to79")
  ans <- age_is_open_right(x)
  expect_is_logical(x, ans)
  expect_values(ans, c(TRUE, FALSE, TRUE, FALSE))
  expect_values(age_is_open_right(age_mixed), c(FALSE, FALSE, TRUE))
  expect_values(age_is_open_right(age_with_na), c(FALSE, FALSE, FALSE))
  expect_values(age_is_open_right(age_closed), c(FALSE, FALSE, FALSE))
})

test_that("cohort_is_open_left() identifies left-open cohorts", {
  x <- c("2020", "<1900", "2040-2050", "2030+")
  ans <- cohort_is_open_left(x)
  expect_is_logical(x, ans)
  expect_values(ans, c(FALSE, TRUE, FALSE, FALSE))
  expect_values(cohort_is_open_left(cohort_multi), c(FALSE, TRUE, FALSE))
  expect_values(cohort_is_open_left(cohort_with_na), c(FALSE, FALSE, FALSE))
})

test_that("cohort_is_open_right() identifies right-open cohorts", {
  x <- c("2020", "<1900", "2040-2050", "2030+")
  ans <- cohort_is_open_right(x)
  expect_is_logical(x, ans)
  expect_values(ans, c(FALSE, FALSE, FALSE, TRUE))
  expect_values(cohort_is_open_right(cohort_multi), c(FALSE, FALSE, FALSE))
  expect_values(cohort_is_open_right(cohort_with_na), c(FALSE, FALSE, FALSE))
})

test_that("period_is_open_left() identifies left-open periods", {
  x <- c("2020", "<1900", "2020-2030", "2030+")
  ans <- period_is_open_left(x)
  expect_is_logical(x, ans)
  expect_values(ans, c(FALSE, TRUE, FALSE, FALSE))
  expect_values(period_is_open_left(period_multi), c(FALSE, FALSE, FALSE))
})

test_that("period_is_open_right() identifies right-open periods", {
  x <- c("2020", "<1900", "2020-2030", "2030+")
  ans <- period_is_open_right(x)
  expect_is_logical(x, ans)
  expect_values(ans, c(FALSE, FALSE, FALSE, TRUE))
  expect_values(period_is_open_right(period_multi), c(FALSE, FALSE, FALSE))
})

test_that("is functions accept factor input with the same results", {
  x <- factor(age_with_total, levels = age_with_total)
  expect_values(age_is_total(x), age_is_total(age_with_total))

  x <- factor(age_with_na, levels = age_with_na, exclude = NULL)
  expect_values(age_is_missing(x), age_is_missing(age_with_na))

  x <- factor(cohort_multi, levels = cohort_multi)
  expect_values(cohort_is_open_left(x), cohort_is_open_left(cohort_multi))
  expect_values(cohort_is_open_right(x), cohort_is_open_right(cohort_multi))

  x <- factor(c("2020-2030", "2030+"), levels = c("2020-2030", "2030+"))
  expect_values(period_is_open_right(x), period_is_open_right(c("2020-2030", "2030+")))
})

test_that("is_total() and is_missing() names match is_open() and extractors", {
  x <- c(a = "0-4", b = "5-9", c = "0-4", d = "Total")
  expect_identical(names(age_is_total(x)), names(age_is_open_right(x)))
  expect_identical(names(age_is_total(x)), names(age_lower(x)))

  x <- c("5to9", "10--14", "5to9")
  expect_identical(names(age_is_total(x)), x)
  expect_identical(names(age_is_open_right(x)), x)
  expect_identical(names(age_lower(x)), x)

  x <- c(a = "0-4", b = NA_character_, c = "missing")
  expect_identical(names(age_is_missing(x)), names(age_lower(x)))

  period <- c(a = "2020-2025", b = "Total", c = "2025-2030")
  expect_identical(names(period_is_total(period)), names(period_lower(period)))
  expect_identical(
    names(period_is_missing(c(a = "2020-2025", b = NA_character_))),
    names(period_lower(c(a = "2020-2025", b = NA_character_)))
  )

  cohort <- c(a = "2020-2025", b = "<2025", c = "Total")
  expect_identical(names(cohort_is_total(cohort)), names(cohort_is_open_left(cohort)))
  expect_identical(names(cohort_is_total(cohort)), names(cohort_lower(cohort)))
})
