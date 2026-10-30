test_that("_levels() functions throw an error for non-factors", {
  expect_error(age_diagnose_levels("0-4"), "`labels` is not a factor.")
  expect_error(age_assert_levels(c("0", "0")), "age_assert_values")
  expect_error(period_diagnose_levels(2020), "`labels` is not a factor.")
  expect_error(cohort_assert_levels("2020-2025"), "cohort_diagnose_values")
})

test_that("age_diagnose_levels() checks unused levels and age_diagnose_values() does not", {
  fac <- factor(c("0-4", "0-4"), levels = c("0-4", "5-9", "20-24"))
  expect_false(age_diagnose_levels(fac, no_gap = TRUE)$ok)
  expect_true(age_diagnose_values(fac, no_gap = TRUE)$ok)
})

test_that("age_diagnose_levels() detects overlap from unused factor levels", {
  fac <- factor("0-4", levels = c("0-4", "3-7"))
  expect_false(age_diagnose_levels(fac, no_overlap = TRUE)$ok)
  expect_true(age_diagnose_values(fac, no_overlap = TRUE)$ok)
})

test_that("age_diagnose_levels() detects open interval from unused factor level", {
  fac <- factor(c("0-4", "5-9"), levels = c("0-4", "5-9", "100+"))
  expect_true(age_diagnose_levels(fac, has_open_right = TRUE)$ok)
  expect_false(age_diagnose_values(fac, has_open_right = TRUE)$ok)
})

test_that("age_diagnose_levels() detects zero interval from unused factor level", {
  fac <- factor(c("5-9", "10-14"), levels = c("0", "5-9", "10-14"))
  expect_true(age_diagnose_levels(fac, has_zero = TRUE)$ok)
  expect_false(age_diagnose_values(fac, has_zero = TRUE)$ok)
})

test_that("age_diagnose_levels() detects Total from unused factor level", {
  fac <- factor(c("0-4", "5-9"), levels = c("0-4", "5-9", "Total"))
  expect_false(age_diagnose_levels(fac, no_total = TRUE)$ok)
  expect_true(age_diagnose_values(fac, no_total = TRUE)$ok)
})

test_that("period_diagnose_levels() checks unused levels", {
  fac <- factor("2020-2025", levels = c("2020-2025", "2030-2035"))
  expect_false(period_diagnose_levels(fac, no_gap = TRUE)$ok)
  expect_true(period_diagnose_values(fac, no_gap = TRUE)$ok)
})

test_that("period_diagnose_levels() detects overlap from unused factor levels", {
  fac <- factor("2020-2025", levels = c("2020-2025", "2023-2028"))
  expect_false(period_diagnose_levels(fac, no_overlap = TRUE)$ok)
  expect_true(period_diagnose_values(fac, no_overlap = TRUE)$ok)
  expect_identical(period_assert_values(fac, no_overlap = TRUE), fac)
})

test_that("cohort_diagnose_levels() checks unused levels", {
  fac <- factor("2020-2025", levels = c("2020-2025", "2030-2035"))
  expect_false(cohort_diagnose_levels(fac, no_gap = TRUE)$ok)
  expect_true(cohort_diagnose_values(fac, no_gap = TRUE)$ok)
})

test_that("cohort_diagnose_levels() detects Total from unused factor level", {
  fac <- factor(
    c("2020-2025", "2025-2030"),
    levels = c("2020-2025", "2025-2030", "Total")
  )
  expect_false(cohort_diagnose_levels(fac, no_total = TRUE)$ok)
  expect_true(cohort_diagnose_values(fac, no_total = TRUE)$ok)
  expect_identical(cohort_assert_values(fac, no_total = TRUE), fac)
})

test_that("repeated values count as overlapping", {
  expect_false(age_diagnose_values(c(0, 0), no_overlap = TRUE)$ok)
  expect_false(age_diagnose_values(factor(c(0, 0)), no_overlap = TRUE)$ok)
  expect_false(
    period_diagnose_values(c("2020-2025", "2020-2025"), no_overlap = TRUE)$ok
  )
  expect_false(
    cohort_diagnose_values(c("2020-2025", "2020-2025"), no_overlap = TRUE)$ok
  )
  expect_false(age_diagnose_values(c("Total", "Total"), no_overlap = TRUE)$ok)
})

test_that("levels cannot repeat, so factor(c(0, 0)) passes _levels()", {
  expect_true(age_diagnose_levels(factor(c(0, 0)), no_overlap = TRUE)$ok)
})

test_that("repeated missing or unparsed values do not count as overlapping", {
  x <- c("0", "1-4", NA, NA, "Not stated", "Not stated")
  expect_true(age_diagnose_values(x, no_overlap = TRUE)$ok)
  x <- c("0", "young", "young")
  expect_true(
    age_diagnose_values(x, no_overlap = TRUE, interpret_fail = "silent")$ok
  )
})

test_that("repeats do not affect checks other than no_overlap", {
  char_once <- c("0-4", "5-9")
  char_dup <- c("0-4", "0-4", "5-9", "5-9")
  expect_identical(
    age_diagnose_values(char_once, no_gap = TRUE, has_zero = TRUE),
    age_diagnose_values(char_dup, no_gap = TRUE, has_zero = TRUE)
  )
})

test_that("repeated values pass no_overlap within groups", {
  skip_if_not_installed("dplyr")
  df <- dplyr::tibble(
    age = c("0", "1-4", "0", "1-4"),
    sex = c("F", "F", "M", "M")
  )
  ans <- df |>
    dplyr::group_by(sex) |>
    dplyr::mutate(age = age_assert_values(age, no_overlap = TRUE))
  expect_identical(ans$age, df$age)
  expect_error(
    dplyr::mutate(df, age = age_assert_values(age, no_overlap = TRUE)),
    "appears 2 times"
  )
})

test_that("age_assert_values() preserves the original factor", {
  fac <- factor("0-4", levels = c("0-4", "3-7"))
  expect_error(
    age_assert_levels(fac, no_overlap = TRUE),
    "Age group labels fail check `no_overlap`."
  )
  expect_identical(age_assert_values(fac, no_overlap = TRUE), fac)
})

test_that("failure comments name levels or values", {
  fac <- factor("0-4", levels = c("0-4", "3-7"))
  expect_match(
    age_diagnose_levels(fac, no_overlap = TRUE)$details$comment,
    "among levels"
  )
  expect_match(
    age_diagnose_values(c("0-4", "3-7"), no_overlap = TRUE)$details$comment,
    "among values"
  )
  expect_match(
    age_diagnose_values(c("0", "0"), no_overlap = TRUE)$details$comment,
    "among values: '0' appears 2 times"
  )
})

test_that("age_assert_levels() error mentions levels for unused overlap", {
  fac <- factor("0-4", levels = c("0-4", "3-7"))
  expect_error(age_assert_levels(fac, no_overlap = TRUE), "among levels")
})
