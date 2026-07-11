test_that("age_check() uses levels() for factors and unique() for character", {
  vals <- c("0-4", "0-4")
  char <- vals
  fac <- factor(vals, levels = c("0-4", "5-9", "20-24"))

  expect_true(age_check(char, no_gap = TRUE)$ok)
  expect_false(age_check(fac, no_gap = TRUE)$ok)
})

test_that("age_check() detects overlap from unused factor levels", {
  char <- "0-4"
  fac <- factor("0-4", levels = c("0-4", "3-7"))

  expect_true(age_check(char, no_overlap = TRUE)$ok)
  expect_false(age_check(fac, no_overlap = TRUE)$ok)
})

test_that("age_check() detects open interval from unused factor level", {
  char <- c("0-4", "5-9")
  fac <- factor(char, levels = c("0-4", "5-9", "100+"))

  expect_false(age_check(char, has_open_right = TRUE)$ok)
  expect_true(age_check(fac, has_open_right = TRUE)$ok)
})

test_that("age_check() detects zero interval from unused factor level", {
  char <- c("5-9", "10-14")
  fac <- factor(char, levels = c("0", "5-9", "10-14"))

  expect_false(age_check(char, has_zero = TRUE)$ok)
  expect_true(age_check(fac, has_zero = TRUE)$ok)
})

test_that("age_check() detects Total from unused factor level", {
  char <- c("0-4", "5-9")
  fac <- factor(char, levels = c("0-4", "5-9", "Total"))

  expect_true(age_check(char, no_total = TRUE)$ok)
  expect_false(age_check(fac, no_total = TRUE)$ok)
})

test_that("period_check() uses levels() for factors and unique() for character", {
  char <- "2020-2025"
  fac <- factor(char, levels = c("2020-2025", "2030-2035"))

  expect_true(period_check(char, no_gap = TRUE)$ok)
  expect_false(period_check(fac, no_gap = TRUE)$ok)
})

test_that("period_check() detects overlap from unused factor levels", {
  char <- "2020-2025"
  fac <- factor(char, levels = c("2020-2025", "2023-2028"))

  expect_true(period_check(char, no_overlap = TRUE)$ok)
  expect_false(period_check(fac, no_overlap = TRUE)$ok)
})

test_that("cohort_check() uses levels() for factors and unique() for character", {
  char <- "2020-2025"
  fac <- factor(char, levels = c("2020-2025", "2030-2035"))

  expect_true(cohort_check(char, no_gap = TRUE)$ok)
  expect_false(cohort_check(fac, no_gap = TRUE)$ok)
})

test_that("cohort_check() detects Total from unused factor level", {
  char <- c("2020-2025", "2025-2030")
  fac <- factor(char, levels = c("2020-2025", "2025-2030", "Total"))

  expect_true(cohort_check(char, no_total = TRUE)$ok)
  expect_false(cohort_check(fac, no_total = TRUE)$ok)
})

test_that("character checks ignore duplicated labels", {
  char_once <- c("0-4", "5-9")
  char_dup <- c("0-4", "0-4", "5-9", "5-9")

  expect_true(age_check(char_once, no_gap = TRUE)$ok)
  expect_identical(
    age_check(char_once, no_gap = TRUE)$ok,
    age_check(char_dup, no_gap = TRUE)$ok
  )
})
