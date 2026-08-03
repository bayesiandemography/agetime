test_that("age_diagnose() uses levels() for factors and unique() for character", {
  vals <- c("0-4", "0-4")
  char <- vals
  fac <- factor(vals, levels = c("0-4", "5-9", "20-24"))

  expect_true(age_diagnose(char, no_gap = TRUE)$ok)
  expect_false(age_diagnose(fac, no_gap = TRUE)$ok)
})

test_that("age_diagnose() detects overlap from unused factor levels", {
  char <- "0-4"
  fac <- factor("0-4", levels = c("0-4", "3-7"))

  expect_true(age_diagnose(char, no_overlap = TRUE)$ok)
  expect_false(age_diagnose(fac, no_overlap = TRUE)$ok)
})

test_that("age_diagnose() detects open interval from unused factor level", {
  char <- c("0-4", "5-9")
  fac <- factor(char, levels = c("0-4", "5-9", "100+"))

  expect_false(age_diagnose(char, has_open_right = TRUE)$ok)
  expect_true(age_diagnose(fac, has_open_right = TRUE)$ok)
})

test_that("age_diagnose() detects zero interval from unused factor level", {
  char <- c("5-9", "10-14")
  fac <- factor(char, levels = c("0", "5-9", "10-14"))

  expect_false(age_diagnose(char, has_zero = TRUE)$ok)
  expect_true(age_diagnose(fac, has_zero = TRUE)$ok)
})

test_that("age_diagnose() detects Total from unused factor level", {
  char <- c("0-4", "5-9")
  fac <- factor(char, levels = c("0-4", "5-9", "Total"))

  expect_true(age_diagnose(char, no_total = TRUE)$ok)
  expect_false(age_diagnose(fac, no_total = TRUE)$ok)
})

test_that("period_diagnose() uses levels() for factors and unique() for character", {
  char <- "2020-2025"
  fac <- factor(char, levels = c("2020-2025", "2030-2035"))

  expect_true(period_diagnose(char, no_gap = TRUE)$ok)
  expect_false(period_diagnose(fac, no_gap = TRUE)$ok)
})

test_that("period_diagnose() detects overlap from unused factor levels", {
  char <- "2020-2025"
  fac <- factor(char, levels = c("2020-2025", "2023-2028"))

  expect_true(period_diagnose(char, no_overlap = TRUE)$ok)
  expect_false(period_diagnose(fac, no_overlap = TRUE)$ok)
})

test_that("cohort_diagnose() uses levels() for factors and unique() for character", {
  char <- "2020-2025"
  fac <- factor(char, levels = c("2020-2025", "2030-2035"))

  expect_true(cohort_diagnose(char, no_gap = TRUE)$ok)
  expect_false(cohort_diagnose(fac, no_gap = TRUE)$ok)
})

test_that("cohort_diagnose() detects Total from unused factor level", {
  char <- c("2020-2025", "2025-2030")
  fac <- factor(char, levels = c("2020-2025", "2025-2030", "Total"))

  expect_true(cohort_diagnose(char, no_total = TRUE)$ok)
  expect_false(cohort_diagnose(fac, no_total = TRUE)$ok)
})

test_that("character checks ignore duplicated labels", {
  char_once <- c("0-4", "5-9")
  char_dup <- c("0-4", "0-4", "5-9", "5-9")

  expect_true(age_diagnose(char_once, no_gap = TRUE)$ok)
  expect_identical(
    age_diagnose(char_once, no_gap = TRUE)$ok,
    age_diagnose(char_dup, no_gap = TRUE)$ok
  )
})
