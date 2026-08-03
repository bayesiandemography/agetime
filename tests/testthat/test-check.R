test_that("check_flag fails when x is not a single value", {
  expect_error(
    check_flag(x = 1:2, nm_x = "x"),
    "`x` has length 2"
  )
})

test_that("check_flag fails when x is NA", {
  expect_error(
    check_flag(x = NA, nm_x = "x"),
    "`x` is NA"
  )
})

test_that("check_flag fails when x is not a logical value", {
  expect_error(
    check_flag(x = "a", nm_x = "x"),
    "`x` is \"a\""
  )
})

test_that("check_flag passes for valid logical flags", {
  expect_invisible(check_flag(x = TRUE, nm_x = "open"))
  expect_invisible(check_flag(x = FALSE, nm_x = "open"))
  expect_invisible(check_flag(x = 1L, nm_x = "open"))
  expect_invisible(check_flag(x = 0L, nm_x = "open"))
})

test_that("check_in_limits_intervals passes for all NA", {
  x <- "0-4"
  nm_x <- "x"
  intervals <- intervals(
    labels = NA,
    label_type = "age",
    interpret_single = "lower",
    interpret_multi = "exclude",
    interpret_fail = "error"
  )
  nm_intervals <- "int"
  expect_true(check_in_limits_intervals(
    x = x,
    nm_x = nm_x,
    intervals = intervals,
    nm_intervals = nm_intervals,
    label_type = "age"
  ))
})

test_that("check_in_limits_intervals errors when outside interval", {
  x <- "0-4"
  nm_x <- "x"
  intervals <- intervals(
    labels = "5-9",
    label_type = "age",
    interpret_single = "lower",
    interpret_multi = "exclude",
    interpret_fail = "error"
  )
  nm_intervals <- "int"
  expect_error(
    check_in_limits_intervals(
      x = x,
      nm_x = nm_x,
      intervals = intervals,
      nm_intervals = nm_intervals,
      label_type = "age"
    ),
    "`x` is outside the range covered by age groups in `int`."
  )
})


expect_diagnose_result <- function(val, condition, passed, ok = NULL) {
  if (is.null(ok)) {
    ok <- isTRUE(passed)
  }
  expect_identical(val$ok, ok)
  expect_identical(nrow(val$details), 1L)
  expect_identical(val$details$condition, condition)
  expect_identical(val$details$passed, passed)
}

test_that("no_overlap check passes for non-overlapping age groups", {
  val <- age_diagnose(age_closed, no_overlap = TRUE)
  expect_diagnose_result(val, "no_overlap", TRUE)
})

test_that("no_overlap check fails for overlapping age groups", {
  val <- age_diagnose(age_overlap, no_overlap = TRUE)
  expect_diagnose_result(val, "no_overlap", FALSE)
})

test_that("no_gap check passes for contiguous age groups", {
  val <- age_diagnose(age_closed, no_gap = TRUE)
  expect_diagnose_result(val, "no_gap", TRUE)
})

test_that("no_gap check fails when there is a gap", {
  val <- age_diagnose(age_life_gap, no_gap = TRUE)
  expect_diagnose_result(val, "no_gap", FALSE)
})

test_that("no_total check fails when x includes Total", {
  val <- age_diagnose(age_with_total, no_total = TRUE)
  expect_diagnose_result(val, "no_total", FALSE)
})

test_that("no_na check fails when x includes NA", {
  val <- age_diagnose(age_with_na, no_na = TRUE)
  expect_diagnose_result(val, "no_na", FALSE)
})

test_that("has_zero check passes when a group starts at zero", {
  val <- age_diagnose(age_closed, has_zero = TRUE)
  expect_diagnose_result(val, "has_zero", TRUE)
})

test_that("has_zero check fails when no group starts at zero", {
  val <- age_diagnose(age_no_zero, has_zero = TRUE)
  expect_diagnose_result(val, "has_zero", FALSE)
})

test_that("has_open_right check passes when x includes an open age group", {
  val <- age_diagnose(age_mixed, has_open_right = TRUE)
  expect_diagnose_result(val, "has_open_right", TRUE)
})

test_that("has_open_right check fails when all age groups are closed", {
  val <- age_diagnose(age_closed, has_open_right = TRUE)
  expect_diagnose_result(val, "has_open_right", FALSE)
})

test_that("has_open_left check passes when x includes a left-open cohort", {
  val <- cohort_diagnose(cohort_multi, has_open_left = TRUE)
  expect_diagnose_result(val, "has_open_left", TRUE)
})

test_that("has_open_left check fails when all cohorts are closed on the left", {
  val <- cohort_diagnose(c("2020-2025", "2025-2030"), has_open_left = TRUE)
  expect_diagnose_result(val, "has_open_left", FALSE)
})

test_that("has_open_right check passes when x includes a right-open period", {
  val <- period_diagnose(c("2020-2030", "2030+"), has_open_right = TRUE)
  expect_diagnose_result(val, "has_open_right", TRUE)
})

test_that("valid_life passes for life-table labels even when there is a gap", {
  val <- age_diagnose(age_life_gap, valid_life = TRUE)
  expect_diagnose_result(val, "valid_life", TRUE)
  expect_false(age_diagnose(age_life_gap, no_gap = TRUE)$ok)
})

test_that("valid_life check fails for non-life-table age groups", {
  val <- age_diagnose(age_invalid_life, valid_life = TRUE)
  expect_diagnose_result(val, "valid_life", FALSE)
})

test_that("period checks pass for contiguous non-overlapping periods", {
  expect_diagnose_result(
    period_diagnose(period_multi, no_overlap = TRUE),
    "no_overlap", TRUE
  )
  expect_diagnose_result(
    period_diagnose(period_multi, no_gap = TRUE),
    "no_gap", TRUE
  )
  expect_diagnose_result(
    period_diagnose(period_multi, no_total = TRUE),
    "no_total", TRUE
  )
  expect_diagnose_result(
    period_diagnose(period_multi, no_na = TRUE),
    "no_na", TRUE
  )
})

test_that("period no_gap check fails when there is a gap", {
  val <- period_diagnose(period_gap, no_gap = TRUE)
  expect_diagnose_result(val, "no_gap", FALSE)
})

test_that("period no_overlap check fails for overlapping periods", {
  val <- period_diagnose(period_overlap, no_overlap = TRUE)
  expect_diagnose_result(val, "no_overlap", FALSE)
})

test_that("period no_total and no_na checks fail for special labels", {
  expect_diagnose_result(
    period_diagnose(period_with_total, no_total = TRUE),
    "no_total", FALSE
  )
  expect_diagnose_result(
    period_diagnose(period_with_na, no_na = TRUE),
    "no_na", FALSE
  )
})

test_that("cohort checks pass for contiguous non-overlapping cohorts", {
  expect_diagnose_result(
    cohort_diagnose(cohort_multi, no_overlap = TRUE),
    "no_overlap", TRUE
  )
  expect_diagnose_result(
    cohort_diagnose(cohort_multi, no_gap = TRUE),
    "no_gap", TRUE
  )
  expect_diagnose_result(
    cohort_diagnose(cohort_multi, no_total = TRUE),
    "no_total", TRUE
  )
  expect_diagnose_result(
    cohort_diagnose(cohort_multi, no_na = TRUE),
    "no_na", TRUE
  )
})

test_that("cohort no_gap check fails when there is a gap", {
  val <- cohort_diagnose(period_gap, no_gap = TRUE)
  expect_diagnose_result(val, "no_gap", FALSE)
})

test_that("age_assert succeeds and fails as expected", {
  expect_invisible(age_assert(age_closed, no_overlap = TRUE))
  expect_error(age_assert(age_overlap, no_overlap = TRUE), "Assertion failed\\.")
  expect_invisible(age_assert(age_life_gap, valid_life = TRUE))
  expect_error(age_assert(age_life_gap, no_gap = TRUE), "Assertion failed\\.")
})
