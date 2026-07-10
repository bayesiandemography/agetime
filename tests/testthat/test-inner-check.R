test_that("inner_check_no_gap() passes for contiguous intervals", {
  intervals <- intervals(
    labels = c("0-4", "5-9"),
    label_type = "age",
    interpret_single = "lower",
    interpret_multi = "exclude",
    interpret_fail = "error"
  )
  val <- agetime:::inner_check_no_gap(intervals)

  expect_identical(val$check, "no_gap")
  expect_identical(val$passed, TRUE)
  expect_identical(val$comment, NA_character_)
})

test_that("inner_check_no_na() passes when there is no NA", {
  intervals <- intervals(
    labels = c("0-4", "5-9"),
    label_type = "age",
    interpret_single = "lower",
    interpret_multi = "exclude",
    interpret_fail = "error"
  )
  val <- agetime:::inner_check_no_na(intervals)

  expect_identical(val$check, "no_na")
  expect_identical(val$passed, TRUE)
  expect_identical(val$comment, NA_character_)
})

test_that("inner_check_has_zero() passes when zero is present", {
  intervals <- intervals(
    labels = c("5-9", "0-4"),
    label_type = "age",
    interpret_single = "lower",
    interpret_multi = "exclude",
    interpret_fail = "error"
  )
  val <- agetime:::inner_check_has_zero(intervals)

  expect_identical(val$check, "has_zero")
  expect_identical(val$passed, TRUE)
  expect_identical(val$comment, NA_character_)
})

test_that("inner_check_has_open() passes when open-right interval is present", {
  intervals <- intervals(
    labels = c("5-9", "60+"),
    label_type = "age",
    interpret_single = "lower",
    interpret_multi = "exclude",
    interpret_fail = "error"
  )
  val <- agetime:::inner_check_has_open(intervals)

  expect_identical(val$check, "has_open")
  expect_identical(val$passed, TRUE)
  expect_identical(val$comment, NA_character_)
})

test_that("inner_check_has_open() passes when open-left cohort is present", {
  intervals <- intervals(
    labels = c("2020-2025", "<2020"),
    label_type = "cohort",
    interpret_single = "lower",
    interpret_multi = "include",
    interpret_fail = "error"
  )
  val <- agetime:::inner_check_has_open(intervals)

  expect_identical(val$check, "has_open")
  expect_identical(val$passed, TRUE)
  expect_identical(val$comment, NA_character_)
})

test_that("inner_check_has_open() passes when open-right period is present", {
  intervals <- intervals(
    labels = c("2020-2030", "2030+"),
    label_type = "period",
    interpret_single = "lower",
    interpret_multi = "include",
    interpret_fail = "error"
  )
  val <- agetime:::inner_check_has_open(intervals)

  expect_identical(val$check, "has_open")
  expect_identical(val$passed, TRUE)
  expect_identical(val$comment, NA_character_)
})

test_that("inner_check_valid_life() passes for valid labels", {
  intervals <- intervals(
    labels = c("0", "5-9"),
    label_type = "age",
    interpret_single = "lower",
    interpret_multi = "exclude",
    interpret_fail = "error"
  )
  val <- agetime:::inner_check_valid_life(intervals)

  expect_identical(val$check, "valid_life")
  expect_identical(val$passed, TRUE)
  expect_identical(val$comment, NA_character_)
})

test_that("inner_check() skips checks when all flags are FALSE", {
  val <- agetime:::inner_check(
    labels = c("0-4", "5-9"),
    label_type = "age",
    interpret_single = "lower",
    interpret_multi = "exclude",
    interpret_fail = "error",
    no_overlap = FALSE,
    no_gap = FALSE,
    no_total = FALSE,
    no_na = FALSE,
    has_zero = FALSE,
    has_open = FALSE,
    valid_life = FALSE
  )

  expect_true(val$ok)
  expect_identical(nrow(val$details), 0L)
})
