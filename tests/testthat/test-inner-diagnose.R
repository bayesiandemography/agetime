test_that("inner_diagnose_no_gap() passes for contiguous intervals", {
  intervals <- intervals(
    labels = c("0-4", "5-9"),
    label_type = "age",
    interpret_single = "lower",
    interpret_multi = "exclude",
    interpret_fail = "error"
  )
  val <- agetime:::inner_diagnose_no_gap(intervals, on = "levels")

  expect_identical(val$condition, "no_gap")
  expect_identical(val$passed, TRUE)
  expect_identical(val$comment, NA_character_)
})

test_that("inner_diagnose_no_na() passes when there is no NA", {
  intervals <- intervals(
    labels = c("0-4", "5-9"),
    label_type = "age",
    interpret_single = "lower",
    interpret_multi = "exclude",
    interpret_fail = "error"
  )
  val <- agetime:::inner_diagnose_no_na(intervals, on = "levels")

  expect_identical(val$condition, "no_na")
  expect_identical(val$passed, TRUE)
  expect_identical(val$comment, NA_character_)
})

test_that("inner_diagnose_has_zero() passes when zero is present", {
  intervals <- intervals(
    labels = c("5-9", "0-4"),
    label_type = "age",
    interpret_single = "lower",
    interpret_multi = "exclude",
    interpret_fail = "error"
  )
  val <- agetime:::inner_diagnose_has_zero(intervals, on = "levels")

  expect_identical(val$condition, "has_zero")
  expect_identical(val$passed, TRUE)
  expect_identical(val$comment, NA_character_)
})

test_that("inner_diagnose_has_open_right() passes when open-right interval is present", {
  intervals <- intervals(
    labels = c("5-9", "60+"),
    label_type = "age",
    interpret_single = "lower",
    interpret_multi = "exclude",
    interpret_fail = "error"
  )
  val <- agetime:::inner_diagnose_has_open_right(intervals, on = "levels")

  expect_identical(val$condition, "has_open_right")
  expect_identical(val$passed, TRUE)
  expect_identical(val$comment, NA_character_)
})

test_that("inner_diagnose_has_open_left() passes when open-left cohort is present", {
  intervals <- intervals(
    labels = c("2020-2025", "<2020"),
    label_type = "cohort",
    interpret_single = "lower",
    interpret_multi = "include",
    interpret_fail = "error"
  )
  val <- agetime:::inner_diagnose_has_open_left(intervals, on = "levels")

  expect_identical(val$condition, "has_open_left")
  expect_identical(val$passed, TRUE)
  expect_identical(val$comment, NA_character_)
})

test_that("inner_diagnose_has_open_right() passes when open-right period is present", {
  intervals <- intervals(
    labels = c("2020-2030", "2030+"),
    label_type = "period",
    interpret_single = "lower",
    interpret_multi = "include",
    interpret_fail = "error"
  )
  val <- agetime:::inner_diagnose_has_open_right(intervals, on = "levels")

  expect_identical(val$condition, "has_open_right")
  expect_identical(val$passed, TRUE)
  expect_identical(val$comment, NA_character_)
})

test_that("inner_diagnose_valid_life() passes for valid labels", {
  intervals <- intervals(
    labels = c("0", "5-9"),
    label_type = "age",
    interpret_single = "lower",
    interpret_multi = "exclude",
    interpret_fail = "error"
  )
  val <- agetime:::inner_diagnose_valid_life(intervals, on = "levels")

  expect_identical(val$condition, "valid_life")
  expect_identical(val$passed, TRUE)
  expect_identical(val$comment, NA_character_)
})

test_that("inner_diagnose() skips checks when all flags are FALSE", {
  val <- agetime:::inner_diagnose(
    labels = c("0-4", "5-9"),
    label_type = "age",
    interpret_single = "lower",
    interpret_multi = "exclude",
    interpret_fail = "error",
    on = "levels",
    no_overlap = FALSE,
    no_gap = FALSE,
    no_total = FALSE,
    no_na = FALSE,
    has_zero = FALSE,
    has_open_left = FALSE,
    has_open_right = FALSE,
    valid_life = FALSE
  )

  expect_true(val$ok)
  expect_identical(nrow(val$details), 0L)
})
