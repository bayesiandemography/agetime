
# *_check() / *_assert(): empty input is valid. Universal checks like no_overlap
# are TRUE on empty input; include_* checks are FALSE on empty input (like any()).

test_that("include_* checks work on length-0 input", {
  val <- age_check(character(0), include_zero = TRUE)
  expect_false(val$ok)
  expect_identical(val$details$observed, FALSE)

  val <- age_check(character(0), include_open = TRUE)
  expect_false(val$ok)
  expect_identical(val$details$observed, FALSE)

  val <- cohort_check(character(0), include_open = TRUE)
  expect_false(val$ok)
  expect_identical(val$details$observed, FALSE)
})

test_that("universal checks pass on length-0 input", {
  x <- character(0)
  expect_true(age_check(x, no_overlap = TRUE)$ok)
  expect_true(age_check(x, no_gap = TRUE)$ok)
  expect_true(age_check(x, no_total = TRUE)$ok)
  expect_true(age_check(x, no_na = TRUE)$ok)
  expect_true(age_check(x, valid_life = TRUE)$ok)

  expect_true(period_check(x, no_overlap = TRUE)$ok)
  expect_true(period_check(x, no_gap = TRUE)$ok)
  expect_true(period_check(x, no_total = TRUE)$ok)
  expect_true(period_check(x, no_na = TRUE)$ok)

  expect_true(cohort_check(x, no_overlap = TRUE)$ok)
  expect_true(cohort_check(x, no_gap = TRUE)$ok)
  expect_true(cohort_check(x, no_total = TRUE)$ok)
  expect_true(cohort_check(x, no_na = TRUE)$ok)
})

test_that("universal checks pass on empty factor input", {
  x <- factor()
  expect_true(age_check(x, no_overlap = TRUE)$ok)
  expect_true(period_check(x, no_total = TRUE)$ok)
  expect_true(cohort_check(x, no_na = TRUE)$ok)
})

test_that("include_* asserts fail cleanly on length-0 input", {
  expect_error(age_assert(character(0), include_zero = TRUE),
               "Check failed\\.")
  expect_error(age_assert(character(0), include_open = TRUE),
               "Check failed\\.")
  expect_error(cohort_assert(character(0), include_open = TRUE),
               "Check failed\\.")
})

test_that("universal asserts succeed on length-0 input", {
  expect_invisible(age_assert(character(0), no_overlap = TRUE))
  expect_invisible(age_assert(character(0), no_gap = TRUE))
  expect_invisible(period_assert(character(0), no_total = TRUE))
  expect_invisible(cohort_assert(character(0), no_na = TRUE))
})

test_that("universal asserts fail when asserted condition is false on length-0 input",
          {
  expect_error(age_assert(character(0), no_overlap = FALSE), "Check failed\\.")
  expect_false(age_check(character(0), no_total = FALSE)$ok)
})
