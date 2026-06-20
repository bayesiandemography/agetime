test_that("inner_check_no_gap() notes contiguous intervals", {
  intervals <- intervals(
    labels = c("0-4", "5-9"),
    label_type = "age",
    x_one = "lower",
    x_multi = "exclude",
    x_fail = "error"
  )
  val <- agetime:::inner_check_no_gap(intervals, asserted = FALSE)

  expect_identical(val$check, "no_gap")
  expect_identical(val$asserted, FALSE)
  expect_identical(val$observed, TRUE)
  expect_identical(val$comment, "No gaps between intervals")
})

test_that("inner_check_no_na() notes absence of NA when asserted is FALSE", {
  intervals <- intervals(
    labels = c("0-4", "5-9"),
    label_type = "age",
    x_one = "lower",
    x_multi = "exclude",
    x_fail = "error"
  )
  val <- agetime:::inner_check_no_na(intervals, asserted = FALSE)

  expect_identical(val$check, "no_na")
  expect_identical(val$asserted, FALSE)
  expect_identical(val$observed, TRUE)
  expect_identical(val$comment, "No NA labels")
})

test_that("inner_check_include_zero() gives an example", {
  intervals <- intervals(
    labels = c("5-9", "0-4"),
    label_type = "age",
    x_one = "lower",
    x_multi = "exclude",
    x_fail = "error"
  )
  val <- agetime:::inner_check_include_zero(intervals, asserted = FALSE)

  expect_identical(val$check, "include_zero")
  expect_identical(val$asserted, FALSE)
  expect_identical(val$observed, TRUE)
  expect_identical(val$comment, "Example: '0-4'")
})

test_that("inner_check_include_open() gives an example", {
  intervals <- intervals(
    labels = c("5-9", "60+"),
    label_type = "age",
    x_one = "lower",
    x_multi = "exclude",
    x_fail = "error"
  )
  val <- agetime:::inner_check_include_open(intervals, asserted = FALSE)

  expect_identical(val$check, "include_open")
  expect_identical(val$asserted, FALSE)
  expect_identical(val$observed, TRUE)
  expect_identical(val$comment, "Example: '60+'")
})

test_that("inner_check_valid_life() notes valid labels", {
  intervals <- intervals(
    labels = c("0", "5-9"),
    label_type = "age",
    x_one = "lower",
    x_multi = "exclude",
    x_fail = "error"
  )
  val <- agetime:::inner_check_valid_life(intervals, asserted = FALSE)

  expect_identical(val$check, "valid_life")
  expect_identical(val$asserted, FALSE)
  expect_identical(val$observed, TRUE)
  expect_identical(val$comment, "All labels valid for life table.")
})
