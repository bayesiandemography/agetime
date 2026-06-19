test_that("age_extend() appends groups using inferred width", {
  x <- c("0-4", "5-9")
  ans <- age_extend(x, n = 2)

  expect_type(ans, "character")
  expect_false(is.factor(ans))
  expect_identical(length(ans), length(x) + 2L)
  expect_values(ans, c("0-4", "5-9", "10-14", "15-19"))
})

test_that("age_extend() with default n appends one group", {
  x <- c("0-4", "5-9")
  expect_values(age_extend(x), c("0-4", "5-9", "10-14"))
})

test_that("age_extend() uses explicit width", {
  x <- c("0-4", "5-9")
  expect_values(
    age_extend(x, n = 2, width = 10),
    c("0-4", "5-9", "10-19", "20-29")
  )
})

test_that("age_extend() with include_x = FALSE returns only new groups", {
  x <- c("0-4", "5-9")
  ans <- age_extend(x, n = 2, include_x = FALSE)

  expect_type(ans, "character")
  expect_identical(length(ans), 2L)
  expect_values(ans, c("10-14", "15-19"))
})

test_that("age_extend() returns factor with updated levels for factor input", {
  x <- c("0-4", "5-9")
  fx <- factor(x, levels = x)
  ans <- age_extend(fx, n = 2)

  expect_s3_class(ans, "factor")
  expect_identical(as.character(ans), as.character(age_extend(x, n = 2)))
  expect_identical(levels(ans), c("0-4", "5-9", "10-14", "15-19"))

  ans_new <- age_extend(fx, n = 2, include_x = FALSE)
  expect_s3_class(ans_new, "factor")
  expect_identical(as.character(ans_new), c("10-14", "15-19"))
  expect_identical(levels(ans_new), c("10-14", "15-19"))
})

test_that("period_extend() and cohort_extend() append groups", {
  x <- c("2020-2025", "2025-2030")
  expect_values(
    period_extend(x, n = 1),
    c("2020-2025", "2025-2030", "2030-2035")
  )
  expect_values(
    cohort_extend(x, n = 1),
    c("2020-2025", "2025-2030", "2030-2035")
  )
})

test_that("age_extend() errors when the final label cannot be extended", {
  expect_error(age_extend(c("0-4", "100+")), "Final interval .100\\+. is open")
  expect_error(age_extend(c("0-4", NA)), "Final interval is NA")

  msg <- tryCatch(
    age_extend(c("0-4", "Total")),
    error = function(e) conditionMessage(e)
  )
  expect_match(msg, "Final interval .Total. is total")
  expect_match(msg, "Extend ordinary age groups and then add total if needed")
})
