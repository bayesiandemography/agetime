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

test_that("age_extend() with include_labels = FALSE returns only new groups", {
  x <- c("0-4", "5-9")
  ans <- age_extend(x, n = 2, include_labels = FALSE)

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

  ans_new <- age_extend(fx, n = 2, include_labels = FALSE)
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

test_that("extend functions start at the highest upper limit, not the last element", {
  expect_identical(age_extend(c("5-9", "0-4")), c("5-9", "0-4", "10-14"))
  expect_identical(period_extend(c("2010-2015", "2000-2005")),
                   c("2010-2015", "2000-2005", "2015-2020"))
  expect_identical(cohort_extend(c("2001", "2000"), interpret_single = "upper"),
                   c("2001", "2000", "2002"))
})

test_that("extend functions take width from the narrowest interval with the highest upper limit", {
  expect_identical(age_extend(c("0-9", "5-9")), c("0-9", "5-9", "10-14"))
  expect_identical(age_extend(c("0-9", "10-14", "5-9"), n = 2, include_labels = FALSE),
                   c("15-19", "20-24"))
})

test_that("extend functions use levels, including unused levels, for factors", {
  fx <- factor("0-4", levels = c("0-4", "5-9"))
  ans <- age_extend(fx)
  expect_identical(ans, factor(c("0-4", "10-14"), levels = c("0-4", "5-9", "10-14")))
  fx <- factor(c("0-4", "10-14", "5-9"))
  ans <- age_extend(fx)
  expect_identical(as.character(ans), c("0-4", "10-14", "5-9", "15-19"))
  expect_identical(levels(ans), c("0-4", "10-14", "5-9", "15-19"))
})

test_that("extend functions give new levels in the order created", {
  ans <- age_extend(factor("0-4"), n = 3, include_labels = FALSE)
  expect_identical(levels(ans), c("5-9", "10-14", "15-19"))
})

test_that("extend functions keep ordered factors ordered", {
  ans <- age_extend(ordered(c("0-4", "5-9")))
  expect_true(is.ordered(ans))
  expect_identical(levels(ans), c("0-4", "5-9", "10-14"))
  ans <- age_extend(ordered("0-4"), include_labels = FALSE)
  expect_true(is.ordered(ans))
})

test_that("extend functions give an error for intervals open on the right", {
  expect_error(age_extend(c("0-4", "100+")), "\"100\\+\" is open on the right")
  expect_error(age_extend(c("85+", "80-84")), "\"85\\+\" is open on the right")
  expect_error(period_extend(c("2020+", "2010-2015")), "open on the right")
})

test_that("extend functions give an error for totals anywhere in labels", {
  expect_error(age_extend(c("0-4", "Total", "5-9")),
               "includes a total \\(\"Total\"\\)")
  expect_error(age_extend(c("0-4", "Total")), "age_is_total")
  expect_error(cohort_extend(c("Total", "2000")), "cohort_is_total")
})

test_that("extend functions give an error for missing values anywhere in labels", {
  expect_error(age_extend(c("0-4", NA, "5-9")), "includes a missing value")
  expect_error(age_extend(c("0-4", "Not stated")), "age_is_missing")
  expect_error(age_extend(factor(c("0-4", NA))), "includes a missing value")
  expect_error(period_extend(c(NA, "2000")), "period_is_missing")
})

test_that("extend functions handle intervals open on the left", {
  expect_identical(cohort_extend(c("<2000", "2000-2005")),
                   c("<2000", "2000-2005", "2005-2010"))
  expect_error(period_extend("<2000"), "Supply a value for `width`")
  expect_identical(period_extend("<2000", width = 5, n = 2),
                   c("<2000", "2000-2005", "2005-2010"))
})

test_that("extend functions give an error when no label can be read", {
  expect_identical(age_extend(c("0-4", "junk"), interpret_fail = "silent"),
                   c("0-4", "junk", "5-9"))
  expect_error(age_extend("junk", interpret_fail = "silent"),
               "no valid age groups to extend from")
})
