test_that("age_set_order() sorts levels without changing observed values", {
  x <- factor(c("20-24", "0-4", "5-9"), levels = c("20-24", "0-4", "5-9"))
  ans <- age_set_order(x)

  expect_s3_class(ans, "factor")
  expect_identical(as.character(ans), c("20-24", "0-4", "5-9"))
  expect_identical(levels(ans), c("0-4", "5-9", "20-24"))
})

test_that("age_set_order() converts character input to a sorted factor", {
  x <- c("25-29", "0-4", "5-9")
  ans <- age_set_order(x)

  expect_s3_class(ans, "factor")
  expect_identical(as.character(ans), x)
  expect_identical(levels(ans), c("0-4", "5-9", "25-29"))
})

test_that("age_set_order() with decreasing = TRUE sorts levels in reverse", {
  x <- factor(c("20-24", "0-4", "5-9"), levels = c("20-24", "0-4", "5-9"))
  ans <- age_set_order(x, decreasing = TRUE)

  expect_identical(as.character(ans), c("20-24", "0-4", "5-9"))
  expect_identical(levels(ans), c("20-24", "5-9", "0-4"))
})

test_that("age_set_order() puts NA second-to-last and Total last", {
  x <- c("0-4", "50+", "Total", NA, "20-24")
  ans <- age_set_order(x)

  expect_identical(as.character(ans), x)
  expect_identical(levels(ans), c("0-4", "20-24", "50+", NA, "Total"))
})

test_that("age_set_order() preserves input order among total synonyms", {
  x <- c("0-4", "10+", "all", "total", NA)
  ans <- age_set_order(x)

  expect_identical(as.character(ans), x)
  expect_identical(
    levels(ans),
    c("0-4", "10+", NA, "all", "total")
  )

  x_rev <- c("0-4", "10+", "total", "all", NA)
  ans_rev <- age_set_order(x_rev)
  expect_identical(
    levels(ans_rev),
    c("0-4", "10+", NA, "total", "all")
  )
})

test_that("age_set_order() preserves ordered factors", {
  x <- ordered(c("20-24", "0-4"), levels = c("20-24", "0-4"))
  ans <- age_set_order(x)

  expect_true(is.ordered(ans))
  expect_identical(as.character(ans), c("20-24", "0-4"))
  expect_identical(levels(ans), c("0-4", "20-24"))
})

test_that("age_set_order() leaves a single level unchanged", {
  x <- factor("0-4")
  ans <- age_set_order(x)

  expect_identical(as.character(ans), "0-4")
  expect_identical(levels(ans), "0-4")
})

test_that("period_set_order() and cohort_set_order() sort levels", {
  x <- c("2025-2030", "2020-2025")
  expected <- c("2020-2025", "2025-2030")
  expect_identical(levels(period_set_order(x)), expected)
  expect_identical(levels(cohort_set_order(x)), expected)
  expect_identical(as.character(period_set_order(x)), x)
  expect_identical(as.character(cohort_set_order(x)), x)
})
