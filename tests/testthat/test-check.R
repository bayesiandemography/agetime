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
    x_one = "lower",
    x_multi = "exclude",
    x_fail = "error"
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
    x_one = "lower",
    x_multi = "exclude",
    x_fail = "error"
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


expect_check <- function(val, check, asserted, observed, ok = NULL) {
  if (is.null(ok)) {
    ok <- isTRUE(asserted == observed)
  }
  expect_identical(val$ok, ok)
  expect_identical(nrow(val$details), 1L)
  expect_identical(val$details$check, check)
  expect_identical(val$details$asserted, asserted)
  expect_identical(val$details$observed, observed)
}

test_that("no_overlap check passes for non-overlapping age groups", {
  val <- age_check(age_closed, no_overlap = TRUE)
  expect_check(val, "no_overlap", TRUE, TRUE)
})

test_that("no_overlap check fails for overlapping age groups", {
  val <- age_check(age_overlap, no_overlap = TRUE)
  expect_check(val, "no_overlap", TRUE, FALSE)
})

test_that("no_gap check passes for contiguous age groups", {
  val <- age_check(age_closed, no_gap = TRUE)
  expect_check(val, "no_gap", TRUE, TRUE)
})

test_that("no_gap check fails when there is a gap", {
  val <- age_check(age_life_gap, no_gap = TRUE)
  expect_check(val, "no_gap", TRUE, FALSE)
})

test_that("no_total check fails when x includes Total", {
  val <- age_check(age_with_total, no_total = TRUE)
  expect_check(val, "no_total", TRUE, FALSE)
})

test_that("no_na check fails when x includes NA", {
  val <- age_check(age_with_na, no_na = TRUE)
  expect_check(val, "no_na", TRUE, FALSE)
})

test_that("include_zero check passes when a group starts at zero", {
  val <- age_check(age_closed, include_zero = TRUE)
  expect_check(val, "include_zero", TRUE, TRUE)
})

test_that("include_zero check fails when no group starts at zero", {
  val <- age_check(age_no_zero, include_zero = TRUE)
  expect_check(val, "include_zero", TRUE, FALSE)
})

test_that("include_open check passes when x includes an open age group", {
  val <- age_check(age_mixed, include_open = TRUE)
  expect_check(val, "include_open", TRUE, TRUE)
})

test_that("include_open check fails when all age groups are closed", {
  val <- age_check(age_closed, include_open = TRUE)
  expect_check(val, "include_open", TRUE, FALSE)
})

test_that("valid_life passes for life-table labels even when there is a gap", {
  val <- age_check(age_life_gap, valid_life = TRUE)
  expect_check(val, "valid_life", TRUE, TRUE)
  expect_false(age_check(age_life_gap, no_gap = TRUE)$ok)
})

test_that("valid_life check fails for non-life-table age groups", {
  val <- age_check(age_invalid_life, valid_life = TRUE)
  expect_check(val, "valid_life", TRUE, FALSE)
})

test_that("period checks pass for contiguous non-overlapping periods", {
  expect_check(
    period_check(period_multi, no_overlap = TRUE),
    "no_overlap", TRUE, TRUE
  )
  expect_check(
    period_check(period_multi, no_gap = TRUE),
    "no_gap", TRUE, TRUE
  )
  expect_check(
    period_check(period_multi, no_total = TRUE),
    "no_total", TRUE, TRUE
  )
  expect_check(
    period_check(period_multi, no_na = TRUE),
    "no_na", TRUE, TRUE
  )
})

test_that("period no_gap check fails when there is a gap", {
  val <- period_check(period_gap, no_gap = TRUE)
  expect_check(val, "no_gap", TRUE, FALSE)
})

test_that("period no_overlap check fails for overlapping periods", {
  val <- period_check(period_overlap, no_overlap = TRUE)
  expect_check(val, "no_overlap", TRUE, FALSE)
})

test_that("period no_total and no_na checks fail for special labels", {
  expect_check(
    period_check(period_with_total, no_total = TRUE),
    "no_total", TRUE, FALSE
  )
  expect_check(
    period_check(period_with_na, no_na = TRUE),
    "no_na", TRUE, FALSE
  )
})

test_that("cohort checks pass for contiguous non-overlapping cohorts", {
  expect_check(
    cohort_check(cohort_multi, no_overlap = TRUE),
    "no_overlap", TRUE, TRUE
  )
  expect_check(
    cohort_check(cohort_multi, no_gap = TRUE),
    "no_gap", TRUE, TRUE
  )
  expect_check(
    cohort_check(cohort_multi, no_total = TRUE),
    "no_total", TRUE, TRUE
  )
  expect_check(
    cohort_check(cohort_multi, no_na = TRUE),
    "no_na", TRUE, TRUE
  )
})

test_that("cohort no_gap check fails when there is a gap", {
  val <- cohort_check(period_gap, no_gap = TRUE)
  expect_check(val, "no_gap", TRUE, FALSE)
})

test_that("age_assert succeeds and fails as expected", {
  expect_invisible(age_assert(age_closed, no_overlap = TRUE))
  expect_error(age_assert(age_overlap, no_overlap = TRUE), "Check failed\\.")
  expect_invisible(age_assert(age_life_gap, valid_life = TRUE))
  expect_error(age_assert(age_life_gap, no_gap = TRUE), "Check failed\\.")
})
