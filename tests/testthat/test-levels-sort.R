test_that("age_levels_sort() sorts levels without changing observed values", {
  x <- factor(c("20-24", "0-4", "5-9"), levels = c("20-24", "0-4", "5-9"))
  ans <- age_levels_sort(x)

  expect_s3_class(ans, "factor")
  expect_identical(as.character(ans), c("20-24", "0-4", "5-9"))
  expect_identical(levels(ans), c("0-4", "5-9", "20-24"))
})

test_that("age_levels_sort() converts character input to a sorted factor", {
  x <- c("25-29", "0-4", "5-9")
  ans <- age_levels_sort(x)

  expect_s3_class(ans, "factor")
  expect_identical(as.character(ans), x)
  expect_identical(levels(ans), c("0-4", "5-9", "25-29"))
})

test_that("age_levels_sort() with decreasing = TRUE sorts levels in reverse", {
  x <- factor(c("20-24", "0-4", "5-9"), levels = c("20-24", "0-4", "5-9"))
  ans <- age_levels_sort(x, decreasing = TRUE)

  expect_identical(as.character(ans), c("20-24", "0-4", "5-9"))
  expect_identical(levels(ans), c("20-24", "5-9", "0-4"))
})

test_that("age_levels_sort() puts NA second-to-last and Total last", {
  x <- c("0-4", "50+", "Total", NA, "20-24")
  ans <- age_levels_sort(x)

  expect_identical(as.character(ans), x)
  expect_identical(levels(ans), c("0-4", "20-24", "50+", NA, "Total"))
})

test_that("age_levels_sort() preserves ordered factors", {
  x <- ordered(c("20-24", "0-4"), levels = c("20-24", "0-4"))
  ans <- age_levels_sort(x)

  expect_true(is.ordered(ans))
  expect_identical(as.character(ans), c("20-24", "0-4"))
  expect_identical(levels(ans), c("0-4", "20-24"))
})

test_that("age_levels_sort() leaves a single level unchanged", {
  x <- factor("0-4")
  ans <- age_levels_sort(x)

  expect_identical(as.character(ans), "0-4")
  expect_identical(levels(ans), "0-4")
})

test_that("period_levels_sort() and cohort_levels_sort() sort levels", {
  x <- c("2025-2030", "2020-2025")
  expected <- c("2020-2025", "2025-2030")
  expect_identical(levels(period_levels_sort(x)), expected)
  expect_identical(levels(cohort_levels_sort(x)), expected)
  expect_identical(as.character(period_levels_sort(x)), x)
  expect_identical(as.character(cohort_levels_sort(x)), x)
})
