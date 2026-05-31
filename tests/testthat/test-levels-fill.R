
test_that("age_levels_fill() fills gaps using default boundaries", {
  x <- factor(c("0-4", "20-24"))
  ans <- age_levels_fill(x)

  expect_s3_class(ans, "factor")
  expect_identical(as.character(ans), c("0-4", "20-24"))
  expect_identical(levels(ans), c("0-4", "5-19", "20-24"))
})

test_that("age_levels_fill() fills gaps using custom breaks", {
  x <- factor(c("0-4", "20-24"))
  expect_identical(
    levels(age_levels_fill(x, breaks = c(8, 12))),
    c("0-4", "5-7", "8-11", "12-19", "20-24")
  )
})

test_that("age_levels_fill() converts character input to a factor", {
  x <- c("0-4", "20-24")
  fx <- factor(x, levels = x)
  ans <- age_levels_fill(x)

  expect_s3_class(ans, "factor")
  expect_identical(as.character(ans), x)
  expect_identical(length(ans), length(x))
  expect_identical(levels(ans), levels(age_levels_fill(fx)))
})

test_that("age_levels_fill_five() fills gaps with five-year groups", {
  x <- factor(c("0-4", "20-24"))
  expect_identical(
    levels(age_levels_fill_five(x)),
    c("0-4", "5-9", "10-14", "15-19", "20-24")
  )
})

test_that("age_levels_fill_ten() fills gaps with ten-year groups", {
  x <- c("25-29", "0-4")
  expect_identical(
    levels(age_levels_fill_ten(x)),
    c("25-29", "0-4", "5-14", "15-24")
  )
})

test_that("age_levels_fill_life() fills life-table gaps", {
  expect_identical(
    levels(age_levels_fill_life(factor(c("0", "5-9")))),
    c("0", "1-4", "5-9")
  )
  expect_identical(
    levels(age_levels_fill_life(c("60+", "0"))),
    c("60+", "0", "1-4", "5-9", "10-14", "15-19", "20-24", "25-29",
      "30-34", "35-39", "40-44", "45-49", "50-54", "55-59")
  )
})

test_that("age_levels_fill() leaves a single level unchanged", {
  x <- factor("0-4")
  ans <- age_levels_fill(x)

  expect_identical(as.character(ans), "0-4")
  expect_identical(levels(ans), "0-4")
})

test_that("age_levels_fill() preserves ordered factors", {
  x <- ordered(c("0-4", "20-24"), levels = c("0-4", "20-24"))
  ans <- age_levels_fill_five(x)

  expect_true(is.ordered(ans))
  expect_identical(
    levels(ans),
    levels(age_levels_fill_five(factor(c("0-4", "20-24"))))
  )
})

test_that("period_levels_fill_five() and cohort_levels_fill_five() fill gaps", {
  x <- factor(c("2020-2025", "2030-2035"))
  expected <- c("2020-2025", "2025-2030", "2030-2035")
  expect_identical(levels(period_levels_fill_five(x)), expected)
  expect_identical(levels(cohort_levels_fill_five(x)), expected)
})

test_that("age_levels_fill_five() errors when a gap is not divisible by width", {
  msg <- tryCatch(
    age_levels_fill_five(factor(c("0-4", "11-14"))),
    error = function(e) conditionMessage(e)
  )
  expect_match(msg, "Gap between .0-4. and .11-14. is not divisible by 5")
  expect_match(msg, "Choose a different .width.")
})

test_that("age_levels_fill_life() errors for non-life-table labels", {
  expect_error(
    age_levels_fill_life(c("0-4", "5-9")),
    "Label .0-4. is not valid for a life table"
  )
})
