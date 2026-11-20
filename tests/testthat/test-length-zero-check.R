# *_diagnose_*() / *_assert_*(): empty input is valid. Universal conditions like
# no_overlap are TRUE on empty input; has_* conditions are FALSE, like any().

test_that("has_* checks work on length-0 input", {
  val <- age_df_diagnose_values(data.frame(age = character(0)), age = "age", has_zero = TRUE)
  expect_false(diagnostic_ok(val))
  expect_identical(diagnostic_details(val)$passed, FALSE)

  val <- age_df_diagnose_values(data.frame(age = character(0)), age = "age", has_open_right = TRUE)
  expect_false(diagnostic_ok(val))
  expect_identical(diagnostic_details(val)$passed, FALSE)

  val <- cohort_df_diagnose_values(data.frame(cohort = character(0)), cohort = "cohort", has_open_left = TRUE)
  expect_false(diagnostic_ok(val))
  expect_identical(diagnostic_details(val)$passed, FALSE)

  val <- cohort_df_diagnose_values(data.frame(cohort = character(0)), cohort = "cohort", has_open_right = TRUE)
  expect_false(diagnostic_ok(val))
  expect_identical(diagnostic_details(val)$passed, FALSE)
})

test_that("universal checks pass on length-0 input", {
  x <- character(0)
  expect_true(diagnostic_ok(age_df_diagnose_values(data.frame(age = x), age = "age", no_overlap = TRUE)))
  expect_true(diagnostic_ok(age_df_diagnose_values(data.frame(age = x), age = "age", no_gap = TRUE)))
  expect_true(diagnostic_ok(age_df_diagnose_values(data.frame(age = x), age = "age", no_total = TRUE)))
  expect_true(diagnostic_ok(age_df_diagnose_values(data.frame(age = x), age = "age", no_missing = TRUE)))
  expect_true(diagnostic_ok(age_df_diagnose_values(data.frame(age = x), age = "age", valid_life = TRUE)))
  expect_true(diagnostic_ok(age_df_diagnose_values(data.frame(age = x), age = "age", no_open_right = TRUE)))
  expect_true(diagnostic_ok(period_df_diagnose_values(data.frame(period = x), period = "period", no_open_left = TRUE)))
  expect_true(diagnostic_ok(cohort_df_diagnose_values(data.frame(cohort = x), cohort = "cohort", no_open_right = TRUE)))

  expect_true(diagnostic_ok(period_df_diagnose_values(data.frame(period = x), period = "period", no_overlap = TRUE)))
  expect_true(diagnostic_ok(period_df_diagnose_values(data.frame(period = x), period = "period", no_gap = TRUE)))
  expect_true(diagnostic_ok(period_df_diagnose_values(data.frame(period = x), period = "period", no_total = TRUE)))
  expect_true(diagnostic_ok(period_df_diagnose_values(data.frame(period = x), period = "period", no_missing = TRUE)))

  expect_true(diagnostic_ok(cohort_df_diagnose_values(data.frame(cohort = x), cohort = "cohort", no_overlap = TRUE)))
  expect_true(diagnostic_ok(cohort_df_diagnose_values(data.frame(cohort = x), cohort = "cohort", no_gap = TRUE)))
  expect_true(diagnostic_ok(cohort_df_diagnose_values(data.frame(cohort = x), cohort = "cohort", no_total = TRUE)))
  expect_true(diagnostic_ok(cohort_df_diagnose_values(data.frame(cohort = x), cohort = "cohort", no_missing = TRUE)))
})

test_that("universal checks pass on empty factor input", {
  x <- factor()
  expect_true(diagnostic_ok(age_diagnose_levels(x, no_overlap = TRUE)))
  expect_true(diagnostic_ok(period_diagnose_levels(x, no_total = TRUE)))
  expect_true(diagnostic_ok(cohort_diagnose_levels(x, no_missing = TRUE)))
  expect_true(diagnostic_ok(age_df_diagnose_values(data.frame(age = x), age = "age", no_overlap = TRUE)))
})

test_that("has_* asserts fail cleanly on length-0 input", {
  expect_error(
    age_df_assert_values(data.frame(age = character(0)), age = "age", has_zero = TRUE),
    "has_zero"
  )
  expect_error(
    age_df_assert_values(data.frame(age = character(0)), age = "age", has_open_right = TRUE),
    "has_open_right"
  )
  expect_error(
    cohort_df_assert_values(data.frame(cohort = character(0)), cohort = "cohort", has_open_left = TRUE),
    "has_open_left"
  )
})

test_that("universal asserts succeed on length-0 input", {
  expect_invisible(age_df_assert_values(data.frame(age = character(0)), age = "age", no_overlap = TRUE))
  expect_invisible(age_df_assert_values(data.frame(age = character(0)), age = "age", no_gap = TRUE))
  expect_invisible(period_df_assert_values(data.frame(period = character(0)), period = "period", no_total = TRUE))
  expect_invisible(cohort_df_assert_values(data.frame(cohort = character(0)), cohort = "cohort", no_missing = TRUE))
})

test_that("no checks requested passes on length-0 input", {
  expect_true(diagnostic_ok(age_df_diagnose_values(data.frame(age = character(0)), age = "age")))
  expect_identical(nrow(diagnostic_details(age_df_diagnose_values(data.frame(age = character(0)), age = "age"))), 0L)
  expect_invisible(age_df_assert_values(data.frame(age = character(0)), age = "age"))
})
