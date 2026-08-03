# *_diagnose() / *_assert(): empty input is valid. Universal conditions like
# no_overlap are TRUE on empty input; has_* conditions are FALSE, like any().

test_that("has_* checks work on length-0 input", {
  val <- age_diagnose(character(0), has_zero = TRUE)
  expect_false(val$ok)
  expect_identical(val$details$passed, FALSE)

  val <- age_diagnose(character(0), has_open_right = TRUE)
  expect_false(val$ok)
  expect_identical(val$details$passed, FALSE)

  val <- cohort_diagnose(character(0), has_open_left = TRUE)
  expect_false(val$ok)
  expect_identical(val$details$passed, FALSE)

  val <- cohort_diagnose(character(0), has_open_right = TRUE)
  expect_false(val$ok)
  expect_identical(val$details$passed, FALSE)
})

test_that("universal checks pass on length-0 input", {
  x <- character(0)
  expect_true(age_diagnose(x, no_overlap = TRUE)$ok)
  expect_true(age_diagnose(x, no_gap = TRUE)$ok)
  expect_true(age_diagnose(x, no_total = TRUE)$ok)
  expect_true(age_diagnose(x, no_na = TRUE)$ok)
  expect_true(age_diagnose(x, valid_life = TRUE)$ok)

  expect_true(period_diagnose(x, no_overlap = TRUE)$ok)
  expect_true(period_diagnose(x, no_gap = TRUE)$ok)
  expect_true(period_diagnose(x, no_total = TRUE)$ok)
  expect_true(period_diagnose(x, no_na = TRUE)$ok)

  expect_true(cohort_diagnose(x, no_overlap = TRUE)$ok)
  expect_true(cohort_diagnose(x, no_gap = TRUE)$ok)
  expect_true(cohort_diagnose(x, no_total = TRUE)$ok)
  expect_true(cohort_diagnose(x, no_na = TRUE)$ok)
})

test_that("universal checks pass on empty factor input", {
  x <- factor()
  expect_true(age_diagnose(x, no_overlap = TRUE)$ok)
  expect_true(period_diagnose(x, no_total = TRUE)$ok)
  expect_true(cohort_diagnose(x, no_na = TRUE)$ok)
})

test_that("has_* asserts fail cleanly on length-0 input", {
  expect_error(
    age_assert(character(0), has_zero = TRUE),
    "Assertion failed\\."
  )
  expect_error(
    age_assert(character(0), has_open_right = TRUE),
    "Assertion failed\\."
  )
  expect_error(
    cohort_assert(character(0), has_open_left = TRUE),
    "Assertion failed\\."
  )
})

test_that("universal asserts succeed on length-0 input", {
  expect_invisible(age_assert(character(0), no_overlap = TRUE))
  expect_invisible(age_assert(character(0), no_gap = TRUE))
  expect_invisible(period_assert(character(0), no_total = TRUE))
  expect_invisible(cohort_assert(character(0), no_na = TRUE))
})

test_that("no checks requested passes on length-0 input", {
  expect_true(age_diagnose(character(0))$ok)
  expect_identical(nrow(age_diagnose(character(0))$details), 0L)
  expect_invisible(age_assert(character(0)))
})
