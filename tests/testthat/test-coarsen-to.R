test_that("age_coarsen_to() recodes labels to a target classification", {
  labels <- c("0", "1", "5", "10", "11")
  to <- c("0-4", "5-9", "10-14")
  ans <- age_coarsen_to(labels, to)

  expect_s3_class(ans, "factor")
  expect_identical(length(ans), length(labels))
  expect_values(ans, c("0-4", "0-4", "5-9", "10-14", "10-14"))
  expect_identical(levels(ans), to)
})

test_that("age_coarsen_to() keeps unused target labels as levels", {
  to <- c("0-4", "5-9", "10-14")
  ans <- age_coarsen_to(c("0", "1"), to)

  expect_values(ans, c("0-4", "0-4"))
  expect_identical(levels(ans), to)
})

test_that("age_coarsen_to() preserves the order of labels in to", {
  to <- c("10-14", "0-4", "5-9")
  ans <- age_coarsen_to("0", to)

  expect_identical(levels(ans), to)
  expect_values(ans, "0-4")
})

test_that("age_coarsen_to() recodes equal intervals with different spelling", {
  ans <- age_coarsen_to(c("0--4", "5--9"), to = c("0-4", "5-9"))

  expect_values(ans, c("0-4", "5-9"))
})

test_that("age_coarsen_to() allows gaps in to when labels nest", {
  to <- c("0-4", "10-14")
  ans <- age_coarsen_to(c("0", "11"), to)

  expect_values(ans, c("0-4", "10-14"))
  expect_identical(levels(ans), to)
})

test_that("age_coarsen_to() recodes into an open age group", {
  to <- c("0-4", "5-84", "85+")
  ans <- age_coarsen_to(c("0", "90-94"), to)

  expect_values(ans, c("0-4", "85+"))
})

test_that("age_coarsen_to() maps totals and missing onto themselves", {
  to <- c("0-4", "5-9", "Total", NA)
  ans <- age_coarsen_to(c("0", "Total", NA, "6"), to)

  expect_values(ans, c("0-4", "Total", NA, "5-9"))
  expect_identical(levels(ans), to)
})

test_that("age_coarsen_to() returns a factor for factor input", {
  fx <- factor(c("0-4", "5-9"))
  ans <- age_coarsen_to(fx, to = c("0-9", "10-19"))

  expect_s3_class(ans, "factor")
  expect_false(is.ordered(ans))
  expect_values(ans, c("0-9", "0-9"))
  expect_identical(levels(ans), c("0-9", "10-19"))
})

test_that("age_coarsen_to() recodes unused factor levels in labels", {
  fx <- factor(c("0", "1"), levels = c("0", "1", "10"))
  ans <- age_coarsen_to(fx, to = c("0-4", "5-9", "10-14"))

  expect_values(ans, c("0-4", "0-4"))
  expect_identical(levels(ans), c("0-4", "5-9", "10-14"))
})

test_that("age_coarsen_to() preserves ordered factors", {
  fx <- ordered(c("5", "0"), levels = c("5", "0"))
  ans <- age_coarsen_to(fx, to = c("0-4", "5-9"))

  expect_true(is.ordered(ans))
  expect_values(ans, c("5-9", "0-4"))
  expect_identical(levels(ans), c("0-4", "5-9"))
})

test_that("age_coarsen_to() uses factor levels of to", {
  to <- factor(
    c("0-4", "10-14"),
    levels = c("0-4", "5-9", "10-14")
  )
  ans <- age_coarsen_to(c("0", "11"), to)

  expect_identical(levels(ans), levels(to))
  expect_values(ans, c("0-4", "10-14"))
})

test_that("age_coarsen_to() errors when to has overlapping intervals", {
  expect_error(
    age_coarsen_to(c("0", "1"), to = c("0-9", "5-14")),
    regexp = "overlapping"
  )
})

test_that("age_coarsen_to() errors when to has nested intervals", {
  expect_error(
    age_coarsen_to("0", to = c("0-4", "0-9")),
    regexp = "overlapping"
  )
})

test_that("age_coarsen_to() errors when a label would be split", {
  expect_error(
    age_coarsen_to("0-9", to = c("0-4", "5-9")),
    regexp = "cannot each lie in exactly one new age group"
  )
})

test_that("age_coarsen_to() errors when a label is not covered", {
  expect_error(
    age_coarsen_to("10", to = c("0-4", "5-9")),
    regexp = "cannot each lie in exactly one new age group"
  )
})

test_that("age_coarsen_to() errors when Total is missing from to", {
  expect_error(
    age_coarsen_to(c("0", "Total"), to = c("0-4", "5-9")),
    regexp = "cannot each lie in exactly one new age group"
  )
})

test_that("age_coarsen_to() errors when to has no labels", {
  expect_error(
    age_coarsen_to("0-4", to = character(0)),
    regexp = "to.*has no labels"
  )
})

test_that("period_coarsen_to() and cohort_coarsen_to() recode labels", {
  labels <- c("2020", "2021", "2025")
  to <- c("2020-2025", "2025-2030")

  expect_values(
    period_coarsen_to(labels, to),
    c("2020-2025", "2020-2025", "2025-2030")
  )
  expect_values(
    cohort_coarsen_to(labels, to),
    c("2020-2025", "2020-2025", "2025-2030")
  )
})

test_that("period_coarsen_to() respects interpret_single", {
  to <- c("2020-2025", "2025-2030")

  expect_values(
    period_coarsen_to("2025", to, interpret_single = "lower"),
    "2025-2030"
  )
  expect_values(
    period_coarsen_to("2025", to, interpret_single = "upper"),
    "2020-2025"
  )
})
