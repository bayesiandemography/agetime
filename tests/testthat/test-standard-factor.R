test_that("age_standard() preserves factor for non-empty x", {
  x <- factor(c("5to9", "10--14"), levels = c("5to9", "10--14", "100plus"))
  ans <- age_standard(x)
  expect_true(is.factor(ans))
  expect_false(is.ordered(ans))
  expect_identical(as.character(ans), c("5-9", "10-14"))
  expect_identical(levels(ans), c("5-9", "10-14", "100+"))
})

test_that("age_standard() preserves ordered factor", {
  x <- ordered(c("5to9", "5to9"), levels = c("5to9", "10--14"))
  ans <- age_standard(x)
  expect_true(is.ordered(ans))
  expect_identical(levels(ans), c("5-9", "10-14"))
})

test_that("age_standard() collapses levels that standardize to the same label", {
  x <- factor(character(0), levels = c("5to9", "5-9"))
  ans <- age_standard(x)
  expect_identical(levels(ans), "5-9")
})

test_that("age_standard() maps invalid levels to NA with x_fail = silent", {
  x <- factor(character(0), levels = c("0-4", "not a label"))
  ans <- age_standard(x, x_fail = "silent")
  expect_identical(levels(ans), c("0-4", NA))
})

test_that("period_standard() preserves factor for non-empty x", {
  x <- factor(c("2025to2030", "2022"), levels = c("2025to2030", "2022"))
  ans <- period_standard(x)
  expect_true(is.factor(ans))
  expect_identical(as.character(ans), c("2025-2030", "2022"))
  expect_identical(levels(ans), c("2025-2030", "2022"))
})

test_that("cohort_standard() preserves factor for non-empty x", {
  x <- factor(c("2025to2030", "< 2022 "), levels = c("2025to2030", "< 2022 "))
  ans <- cohort_standard(x)
  expect_true(is.factor(ans))
  expect_identical(as.character(ans), c("2025-2030", "<2022"))
  expect_identical(levels(ans), c("2025-2030", "<2022"))
})
