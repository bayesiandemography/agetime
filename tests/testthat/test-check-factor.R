test_that("_levels() functions throw an error for non-factors", {
  labels <- "0-4"
  expect_error(age_diagnose_levels(labels), "`labels` is not a factor.")
  expect_error(age_assert_levels(c("0", "0")), "age_df_assert_values")
  x <- 2020
  expect_error(period_diagnose_levels(x), "`x` is not a factor.")
  expect_error(cohort_assert_levels("2020-2025"), "cohort_df_diagnose_values")
})

test_that("age_diagnose_levels() checks unused levels and age_df_diagnose_values() does not", {
  fac <- factor(c("0-4", "0-4"), levels = c("0-4", "5-9", "20-24"))
  expect_false(diagnostic_ok(age_diagnose_levels(fac, no_gap = TRUE)))
  expect_true(diagnostic_ok(age_df_diagnose_values(data.frame(age = fac), age = "age", no_gap = TRUE)))
})

test_that("age_diagnose_levels() detects overlap from unused factor levels", {
  fac <- factor("0-4", levels = c("0-4", "3-7"))
  expect_false(diagnostic_ok(age_diagnose_levels(fac, no_overlap = TRUE)))
  expect_true(diagnostic_ok(age_df_diagnose_values(data.frame(age = fac), age = "age", no_overlap = TRUE)))
})

test_that("age_diagnose_levels() detects open interval from unused factor level", {
  fac <- factor(c("0-4", "5-9"), levels = c("0-4", "5-9", "100+"))
  expect_true(diagnostic_ok(age_diagnose_levels(fac, has_open_right = TRUE)))
  expect_false(diagnostic_ok(age_df_diagnose_values(data.frame(age = fac), age = "age", has_open_right = TRUE)))
})

test_that("age_diagnose_levels() detects zero interval from unused factor level", {
  fac <- factor(c("5-9", "10-14"), levels = c("0", "5-9", "10-14"))
  expect_true(diagnostic_ok(age_diagnose_levels(fac, has_zero = TRUE)))
  expect_false(diagnostic_ok(age_df_diagnose_values(data.frame(age = fac), age = "age", has_zero = TRUE)))
})

test_that("age_diagnose_levels() detects Total from unused factor level", {
  fac <- factor(c("0-4", "5-9"), levels = c("0-4", "5-9", "Total"))
  expect_false(diagnostic_ok(age_diagnose_levels(fac, no_total = TRUE)))
  expect_true(diagnostic_ok(age_df_diagnose_values(data.frame(age = fac), age = "age", no_total = TRUE)))
})

test_that("period_diagnose_levels() checks unused levels", {
  fac <- factor("2020-2025", levels = c("2020-2025", "2030-2035"))
  expect_false(diagnostic_ok(period_diagnose_levels(fac, no_gap = TRUE)))
  expect_true(diagnostic_ok(period_df_diagnose_values(data.frame(period = fac), period = "period", no_gap = TRUE)))
})

test_that("period_diagnose_levels() detects overlap from unused factor levels", {
  fac <- factor("2020-2025", levels = c("2020-2025", "2023-2028"))
  expect_false(diagnostic_ok(period_diagnose_levels(fac, no_overlap = TRUE)))
  expect_true(diagnostic_ok(period_df_diagnose_values(data.frame(period = fac), period = "period", no_overlap = TRUE)))
  expect_identical(period_df_assert_values(data.frame(period = fac), period = "period", no_overlap = TRUE), data.frame(period = fac))
})

test_that("cohort_diagnose_levels() checks unused levels", {
  fac <- factor("2020-2025", levels = c("2020-2025", "2030-2035"))
  expect_false(diagnostic_ok(cohort_diagnose_levels(fac, no_gap = TRUE)))
  expect_true(diagnostic_ok(cohort_df_diagnose_values(data.frame(cohort = fac), cohort = "cohort", no_gap = TRUE)))
})

test_that("cohort_diagnose_levels() detects Total from unused factor level", {
  fac <- factor(
    c("2020-2025", "2025-2030"),
    levels = c("2020-2025", "2025-2030", "Total")
  )
  expect_false(diagnostic_ok(cohort_diagnose_levels(fac, no_total = TRUE)))
  expect_true(diagnostic_ok(cohort_df_diagnose_values(data.frame(cohort = fac), cohort = "cohort", no_total = TRUE)))
  expect_identical(cohort_df_assert_values(data.frame(cohort = fac), cohort = "cohort", no_total = TRUE), data.frame(cohort = fac))
})

test_that("repeated values count as overlapping", {
  expect_false(diagnostic_ok(age_df_diagnose_values(data.frame(age = c(0, 0)), age = "age", no_overlap = TRUE)))
  expect_false(diagnostic_ok(age_df_diagnose_values(data.frame(age = factor(c(0, 0))), age = "age", no_overlap = TRUE)))
  expect_false(
    diagnostic_ok(period_df_diagnose_values(data.frame(period = c("2020-2025", "2020-2025")), period = "period", no_overlap = TRUE))
  )
  expect_false(
    diagnostic_ok(cohort_df_diagnose_values(data.frame(cohort = c("2020-2025", "2020-2025")), cohort = "cohort", no_overlap = TRUE))
  )
})

test_that("levels cannot repeat, so factor(c(0, 0)) passes _levels()", {
  expect_true(diagnostic_ok(age_diagnose_levels(factor(c(0, 0)), no_overlap = TRUE)))
})

test_that("totals do not count as overlapping, even when repeated", {
  expect_true(diagnostic_ok(age_df_diagnose_values(data.frame(age = c("0-4", "Total")), age = "age", no_overlap = TRUE)))
  expect_true(diagnostic_ok(age_df_diagnose_values(data.frame(age = c("Total", "Total")), age = "age", no_overlap = TRUE)))
  expect_true(
    diagnostic_ok(age_df_diagnose_values(data.frame(age = c("0-4", "Total", "All ages")), age = "age", no_overlap = TRUE))
  )
  expect_true(
    diagnostic_ok(age_diagnose_levels(factor(c("Total", "All ages")), no_overlap = TRUE))
  )
  expect_false(
    diagnostic_ok(age_df_diagnose_values(data.frame(age = c("0-4", "Total", "Total")), age = "age", no_total = TRUE))
  )
})

test_that("repeated missing or unparsed values do not count as overlapping", {
  x <- c("0", "1-4", NA, NA, "Not stated", "Not stated")
  expect_true(diagnostic_ok(age_df_diagnose_values(data.frame(age = x), age = "age", no_overlap = TRUE)))
  x <- c("0", "young", "young")
  expect_true(
    diagnostic_ok(age_df_diagnose_values(data.frame(age = x), age = "age", no_overlap = TRUE, interpret_fail = "silent"))
  )
})

test_that("repeats do not affect checks other than no_overlap", {
  char_once <- c("0-4", "5-9")
  char_dup <- c("0-4", "0-4", "5-9", "5-9")
  expect_identical(
    age_df_diagnose_values(data.frame(age = char_once), age = "age", no_gap = TRUE, has_zero = TRUE),
    age_df_diagnose_values(data.frame(age = char_dup), age = "age", no_gap = TRUE, has_zero = TRUE)
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
    age_df_assert_values(age = "age", no_overlap = TRUE)
  expect_identical(ans$age, df$age)
  expect_error(
    age_df_assert_values(df, age = "age", no_overlap = TRUE),
    "appears 2 times"
  )
})

test_that("age_df_assert_values() preserves the original factor", {
  fac <- factor("0-4", levels = c("0-4", "3-7"))
  expect_error(
    age_assert_levels(fac, no_overlap = TRUE),
    "Age group labels in `fac` fail check `no_overlap`."
  )
  expect_identical(age_df_assert_values(data.frame(age = fac), age = "age", no_overlap = TRUE), data.frame(age = fac))
})

test_that("failure comments name levels or values", {
  fac <- factor("0-4", levels = c("0-4", "3-7"))
  expect_match(
    diagnostic_details(age_diagnose_levels(fac, no_overlap = TRUE))$comment,
    "among levels"
  )
  expect_match(
    diagnostic_details(age_df_diagnose_values(data.frame(age = c("0-4", "3-7")), age = "age", no_overlap = TRUE))$comment,
    "among values"
  )
  expect_match(
    diagnostic_details(age_df_diagnose_values(data.frame(age = c("0", "0")), age = "age", no_overlap = TRUE))$comment,
    "among values: '0' appears 2 times"
  )
})

test_that("age_assert_levels() error mentions levels for unused overlap", {
  fac <- factor("0-4", levels = c("0-4", "3-7"))
  expect_error(age_assert_levels(fac, no_overlap = TRUE), "among levels")
})

test_that("period_assert_levels() checks levels and returns labels invisibly", {
  fac <- factor("2020-2025", levels = c("2020-2025", "2025-2030"))
  expect_invisible(period_assert_levels(fac, no_gap = TRUE))
  expect_identical(period_assert_levels(fac, no_gap = TRUE), fac)
  fac <- factor("2020-2025", levels = c("2020-2025", "2030-2035"))
  expect_error(
    period_assert_levels(fac, no_gap = TRUE),
    "Period labels in `fac` fail check `no_gap`."
  )
})
