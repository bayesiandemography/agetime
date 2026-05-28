
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

test_that("include_* asserts fail cleanly on length-0 input", {
  expect_error(age_assert(character(0), include_zero = TRUE),
               "Check failed\\.")
  expect_error(age_assert(character(0), include_open = TRUE),
               "Check failed\\.")
  expect_error(cohort_assert(character(0), include_open = TRUE),
               "Check failed\\.")
})
