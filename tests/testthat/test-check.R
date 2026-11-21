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
    interpret_multi = "below_upper",
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
    interpret_multi = "below_upper",
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
  expect_identical(diagnostic_ok(val), ok)
  expect_identical(nrow(diagnostic_details(val)), 1L)
  expect_identical(diagnostic_details(val)$condition, condition)
  expect_identical(diagnostic_details(val)$passed, passed)
}

test_that("no_overlap check passes for non-overlapping age groups", {
  val <- age_df_diagnose_values(data.frame(age = age_closed), age = "age", no_overlap = TRUE)
  expect_diagnose_result(val, "no_overlap", TRUE)
})

test_that("no_overlap check fails for overlapping age groups", {
  val <- age_df_diagnose_values(data.frame(age = age_overlap), age = "age", no_overlap = TRUE)
  expect_diagnose_result(val, "no_overlap", FALSE)
})

test_that("no_overlap check fails for synonyms describing the same interval", {
  val <- age_df_diagnose_values(data.frame(age = c("0", "infant", "1-4", "5+")), age = "age", no_overlap = TRUE)
  expect_diagnose_result(val, "no_overlap", FALSE)
  expect_match(diagnostic_details(val)$comment, "'0' and 'infant' describe the same interval")
  val <- age_df_diagnose_values(data.frame(age = c("0-4", "0 to 4", "5+")), age = "age", no_overlap = TRUE)
  expect_diagnose_result(val, "no_overlap", FALSE)
  val <- cohort_df_diagnose_values(data.frame(cohort = c("<2000", "before 2000", "2000-2004")), cohort = "cohort", no_overlap = TRUE, interpret_multi = "at_upper")
  expect_diagnose_result(val, "no_overlap", FALSE)
})

test_that("no_overlap check fails for repeated values but not repeated levels", {
  x <- c("0", "0", "1-4", "1-4", "5+")
  val <- age_df_diagnose_values(data.frame(age = x), age = "age", no_overlap = TRUE)
  expect_diagnose_result(val, "no_overlap", FALSE)
  val <- age_diagnose_levels(factor(x), no_overlap = TRUE)
  expect_diagnose_result(val, "no_overlap", TRUE)
})

test_that("no_overlap check ignores synonyms for NA, and unparsed labels", {
  val <- age_df_diagnose_values(data.frame(age = c("unknown", "NA", "0-4")), age = "age", no_overlap = TRUE)
  expect_diagnose_result(val, "no_overlap", TRUE)
  val <- age_df_diagnose_values(data.frame(age = c("0-4", "young", "old")), age = "age", no_overlap = TRUE, interpret_fail = "silent")
  expect_diagnose_result(val, "no_overlap", TRUE)
})

test_that("no_overlap check ignores totals, which no_total reports", {
  val <- age_df_diagnose_values(data.frame(age = c("0-4", "5-9", "Total")), age = "age", no_overlap = TRUE)
  expect_diagnose_result(val, "no_overlap", TRUE)
  val <- age_df_diagnose_values(data.frame(age = c("0-4", "5-9", "All ages")), age = "age", no_overlap = TRUE)
  expect_diagnose_result(val, "no_overlap", TRUE)
  val <- period_df_diagnose_values(data.frame(period = c("2000-2005", "2005-2010", "Total")), period = "period", no_overlap = TRUE)
  expect_diagnose_result(val, "no_overlap", TRUE)
  val <- age_df_diagnose_values(data.frame(age = c("0-4", "3-7", "Total")), age = "age", no_overlap = TRUE)
  expect_diagnose_result(val, "no_overlap", FALSE)
  fac <- factor(c("0-4", "5-9"), levels = c("0-4", "5-9", "Total"))
  expect_true(diagnostic_ok(age_diagnose_levels(fac, no_overlap = TRUE)))
})

test_that("no_overlap check for synonyms uses levels or values", {
  x <- factor(c("0", "1-4"), levels = c("0", "infant", "1-4"))
  val <- age_diagnose_levels(x, no_overlap = TRUE)
  expect_diagnose_result(val, "no_overlap", FALSE)
  val <- age_df_diagnose_values(data.frame(age = x), age = "age", no_overlap = TRUE)
  expect_diagnose_result(val, "no_overlap", TRUE)
})

test_that("no_gap check passes for contiguous age groups", {
  val <- age_df_diagnose_values(data.frame(age = age_closed), age = "age", no_gap = TRUE)
  expect_diagnose_result(val, "no_gap", TRUE)
})

test_that("no_gap check fails when there is a gap", {
  val <- age_df_diagnose_values(data.frame(age = age_life_gap), age = "age", no_gap = TRUE)
  expect_diagnose_result(val, "no_gap", FALSE)
})

test_that("no_gap check still fails when a total is present", {
  val <- age_df_diagnose_values(data.frame(age = c("0-4", "10-14", "Total")), age = "age", no_gap = TRUE)
  expect_diagnose_result(val, "no_gap", FALSE)
  val <- age_df_diagnose_values(data.frame(age = c("0-4", "5-9", "Total")), age = "age", no_gap = TRUE)
  expect_diagnose_result(val, "no_gap", TRUE)
  val <- period_df_diagnose_values(data.frame(period = c("2000-2005", "2010-2015", "Total")), period = "period", no_gap = TRUE)
  expect_diagnose_result(val, "no_gap", FALSE)
  fac <- factor("0-4", levels = c("0-4", "10-14", "Total"))
  expect_false(diagnostic_ok(age_diagnose_levels(fac, no_gap = TRUE)))
})

test_that("no_total check fails when x includes Total", {
  val <- age_df_diagnose_values(data.frame(age = age_with_total), age = "age", no_total = TRUE)
  expect_diagnose_result(val, "no_total", FALSE)
})

test_that("no_missing check fails when x includes NA", {
  val <- age_df_diagnose_values(data.frame(age = age_with_na), age = "age", no_missing = TRUE)
  expect_diagnose_result(val, "no_missing", FALSE)
})

test_that("no_missing check quotes the missing label as supplied", {
  val <- age_df_diagnose_values(data.frame(age = c("0-4", "Not stated")), age = "age", no_missing = TRUE)
  expect_identical(
    diagnostic_details(val)$comment,
    "Values include missing value: 'Not stated'"
  )
  val <- age_df_diagnose_values(data.frame(age = c("0-4", NA)), age = "age", no_missing = TRUE)
  expect_identical(diagnostic_details(val)$comment, "Values include missing value: 'NA'")
  val <- age_diagnose_levels(factor("0-4", levels = c("0-4", "Unknown")), no_missing = TRUE)
  expect_identical(
    diagnostic_details(val)$comment,
    "Levels include missing value: 'Unknown'"
  )
})

test_that("has_zero check passes when a group starts at zero", {
  val <- age_df_diagnose_values(data.frame(age = age_closed), age = "age", has_zero = TRUE)
  expect_diagnose_result(val, "has_zero", TRUE)
})

test_that("has_zero check fails when no group starts at zero", {
  val <- age_df_diagnose_values(data.frame(age = age_no_zero), age = "age", has_zero = TRUE)
  expect_diagnose_result(val, "has_zero", FALSE)
})

test_that("has_open_right check passes when x includes an open age group", {
  val <- age_df_diagnose_values(data.frame(age = age_mixed), age = "age", has_open_right = TRUE)
  expect_diagnose_result(val, "has_open_right", TRUE)
})

test_that("has_open_right check fails when all age groups are closed", {
  val <- age_df_diagnose_values(data.frame(age = age_closed), age = "age", has_open_right = TRUE)
  expect_diagnose_result(val, "has_open_right", FALSE)
})

test_that("has_open_left check passes when x includes a left-open cohort", {
  val <- cohort_df_diagnose_values(data.frame(cohort = cohort_multi), cohort = "cohort", has_open_left = TRUE)
  expect_diagnose_result(val, "has_open_left", TRUE)
})

test_that("has_open_left check fails when all cohorts are closed on the left", {
  val <- cohort_df_diagnose_values(data.frame(cohort = c("2020-2025", "2025-2030")), cohort = "cohort", has_open_left = TRUE)
  expect_diagnose_result(val, "has_open_left", FALSE)
})

test_that("has_open_right check passes when x includes a right-open period", {
  val <- period_df_diagnose_values(data.frame(period = c("2020-2030", "2030+")), period = "period", has_open_right = TRUE)
  expect_diagnose_result(val, "has_open_right", TRUE)
})

test_that("no_open_right check passes when all age groups are closed", {
  val <- age_df_diagnose_values(data.frame(age = age_closed), age = "age", no_open_right = TRUE)
  expect_diagnose_result(val, "no_open_right", TRUE)
})

test_that("no_open_right check fails when x includes an open age group", {
  val <- age_df_diagnose_values(data.frame(age = c("0-4", "5+")), age = "age", no_open_right = TRUE)
  expect_diagnose_result(val, "no_open_right", FALSE)
  expect_match(diagnostic_details(val)$comment, "'5\\+'")
})

test_that("no_open_right check does not treat totals or NA as open", {
  val <- age_df_diagnose_values(data.frame(age = c("0-4", "Total", NA)), age = "age", no_open_right = TRUE)
  expect_diagnose_result(val, "no_open_right", TRUE)
})

test_that("no_open_left check passes when all cohorts are closed on the left", {
  val <- cohort_df_diagnose_values(data.frame(cohort = c("2020-2025", "2025+")), cohort = "cohort", no_open_left = TRUE)
  expect_diagnose_result(val, "no_open_left", TRUE)
})

test_that("no_open_left check fails when x includes a left-open period", {
  val <- period_df_diagnose_values(data.frame(period = c("<2020", "2020-2025")), period = "period", no_open_left = TRUE)
  expect_diagnose_result(val, "no_open_left", FALSE)
})

test_that("no_open_right checks levels, and no_open_right in _values() checks values", {
  x <- factor("0-4", levels = c("0-4", "5+"))
  expect_false(diagnostic_ok(age_diagnose_levels(x, no_open_right = TRUE)))
  expect_true(diagnostic_ok(age_df_diagnose_values(data.frame(age = x), age = "age", no_open_right = TRUE)))
})

test_that("age_df_assert_values() reports a failed no_open_right check", {
  expect_error(
    age_df_assert_values(data.frame(age = c("0-4", "5+")), age = "age", no_open_right = TRUE),
    "no_open_right"
  )
  expect_error(
    period_df_assert_values(data.frame(period = c("2020-2025", "2025+")), period = "period", no_open_right = TRUE),
    "no_open_right"
  )
  expect_error(
    cohort_df_assert_values(data.frame(cohort = c("<2000", "2000-2005")), cohort = "cohort", no_open_left = TRUE),
    "no_open_left"
  )
})

test_that("valid_life fails for life-table labels when there is a gap", {
  val <- age_df_diagnose_values(data.frame(age = age_life_gap), age = "age", valid_life = TRUE)
  expect_diagnose_result(val, "valid_life", FALSE)
  expect_false(diagnostic_ok(age_df_diagnose_values(data.frame(age = age_life_gap), age = "age", no_gap = TRUE)))
})

test_that("valid_life check fails for non-life-table age groups", {
  val <- age_df_diagnose_values(data.frame(age = age_invalid_life), age = "age", valid_life = TRUE)
  expect_diagnose_result(val, "valid_life", FALSE)
})

test_that("valid_life names the invalid label when synonyms are present", {
  val <- age_df_diagnose_values(data.frame(age = c("0", "infant", "3-7")), age = "age", valid_life = TRUE)
  expect_diagnose_result(val, "valid_life", FALSE)
  expect_match(diagnostic_details(val)$comment, "3-7")
  expect_false(grepl("infant", diagnostic_details(val)$comment, fixed = TRUE))
})

test_that("period checks pass for contiguous non-overlapping periods", {
  expect_diagnose_result(
    period_df_diagnose_values(data.frame(period = period_multi), period = "period", no_overlap = TRUE),
    "no_overlap", TRUE
  )
  expect_diagnose_result(
    period_df_diagnose_values(data.frame(period = period_multi), period = "period", no_gap = TRUE),
    "no_gap", TRUE
  )
  expect_diagnose_result(
    period_df_diagnose_values(data.frame(period = period_multi), period = "period", no_total = TRUE),
    "no_total", TRUE
  )
  expect_diagnose_result(
    period_df_diagnose_values(data.frame(period = period_multi), period = "period", no_missing = TRUE),
    "no_missing", TRUE
  )
})

test_that("period no_gap check fails when there is a gap", {
  val <- period_df_diagnose_values(data.frame(period = period_gap), period = "period", no_gap = TRUE)
  expect_diagnose_result(val, "no_gap", FALSE)
})

test_that("period no_overlap check fails for overlapping periods", {
  val <- period_df_diagnose_values(data.frame(period = period_overlap), period = "period", no_overlap = TRUE)
  expect_diagnose_result(val, "no_overlap", FALSE)
})

test_that("period no_total and no_missing checks fail for special labels", {
  expect_diagnose_result(
    period_df_diagnose_values(data.frame(period = period_with_total), period = "period", no_total = TRUE),
    "no_total", FALSE
  )
  expect_diagnose_result(
    period_df_diagnose_values(data.frame(period = period_with_na), period = "period", no_missing = TRUE),
    "no_missing", FALSE
  )
})

test_that("cohort checks pass for contiguous non-overlapping cohorts", {
  expect_diagnose_result(
    cohort_df_diagnose_values(data.frame(cohort = cohort_multi), cohort = "cohort", no_overlap = TRUE),
    "no_overlap", TRUE
  )
  expect_diagnose_result(
    cohort_df_diagnose_values(data.frame(cohort = cohort_multi), cohort = "cohort", no_gap = TRUE),
    "no_gap", TRUE
  )
  expect_diagnose_result(
    cohort_df_diagnose_values(data.frame(cohort = cohort_multi), cohort = "cohort", no_total = TRUE),
    "no_total", TRUE
  )
  expect_diagnose_result(
    cohort_df_diagnose_values(data.frame(cohort = cohort_multi), cohort = "cohort", no_missing = TRUE),
    "no_missing", TRUE
  )
})

test_that("cohort no_gap check fails when there is a gap", {
  val <- cohort_df_diagnose_values(data.frame(cohort = period_gap), cohort = "cohort", no_gap = TRUE)
  expect_diagnose_result(val, "no_gap", FALSE)
})

test_that("age_df_assert_values succeeds and fails as expected", {
  expect_invisible(age_df_assert_values(data.frame(age = age_closed), age = "age", no_overlap = TRUE))
  expect_error(age_df_assert_values(data.frame(age = age_overlap), age = "age", no_overlap = TRUE),
               "fail check `no_overlap`")
  expect_error(age_df_assert_values(data.frame(age = age_life_gap), age = "age", valid_life = TRUE),
               "fail check `valid_life`")
  expect_error(age_df_assert_values(data.frame(age = age_life_gap), age = "age", no_gap = TRUE),
               "fail check `no_gap`")
})

test_that("assert error messages name each failed condition and give comments", {
  expect_snapshot(
    age_df_assert_values(data.frame(age = c("0-4", "3-7", "10-14")), age = "age", no_overlap = TRUE, no_gap = TRUE),
    error = TRUE
  )
  expect_snapshot(
    period_df_assert_values(data.frame(period = c("2020", "Total")), period = "period", no_total = TRUE),
    error = TRUE
  )
  expect_snapshot(
    cohort_df_assert_values(data.frame(cohort = c("2000-2004", "2005-2009")), cohort = "cohort", has_open_left = TRUE, interpret_multi = "at_upper"),
    error = TRUE
  )
})

test_that("has_* checks fail cleanly when there are no intervals", {
  for (x in list("Total", "Not stated", c("Total", "Not stated"))) {
    val <- age_df_diagnose_values(data.frame(age = x), age = "age", has_zero = TRUE, has_open_right = TRUE)
    expect_identical(diagnostic_details(val)$passed, c(FALSE, FALSE))
    expect_identical(
      diagnostic_details(val)$comment,
      rep("No intervals among values.", 2L)
    )
  }
  val <- period_df_diagnose_values(data.frame(period = "Total"), period = "period", has_open_left = TRUE)
  expect_identical(diagnostic_details(val)$passed, FALSE)
  expect_identical(diagnostic_details(val)$comment, "No intervals among values.")
  val <- cohort_diagnose_levels(factor("Total"), has_open_right = TRUE)
  expect_identical(diagnostic_details(val)$comment, "No intervals among levels.")
})

test_that("has_* comments name an interval, not a total", {
  val <- period_df_diagnose_values(data.frame(period = c("Total", "2020-2025")), period = "period", has_open_left = TRUE)
  expect_identical(
    diagnostic_details(val)$comment,
    "Lowest interval among values: '2020-2025'"
  )
  val <- age_df_diagnose_values(data.frame(age = c("Total", "5-9")), age = "age", has_open_right = TRUE)
  expect_identical(
    diagnostic_details(val)$comment,
    "Highest interval among values: '5-9'"
  )
})
