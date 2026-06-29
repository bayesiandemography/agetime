test_that("age_levels_fill() fills gaps using default boundaries", {
  x <- factor(c("0-4", "20-24"))
  ans <- age_levels_fill(x)

  expect_s3_class(ans, "factor")
  expect_identical(as.character(ans), c("0-4", "20-24"))
  expect_identical(levels(ans), c("0-4", "5-19", "20-24"))
})

test_that("age_levels_fill_life() fills gaps using default boundaries", {
  x <- factor(c("0", "1-4", "10-14"))
  expect_identical(
    levels(age_levels_fill_life(x)),
    c("0", "1-4", "5-9", "10-14")
  )
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
    c("0-4", "5-14", "15-24", "25-29")
  )
})

test_that("levels-fill functions sort out-of-order input levels", {
  expect_identical(
    levels(age_levels_fill_five(c("10-14", "0-4"))),
    c("0-4", "5-9", "10-14")
  )
  expect_identical(
    levels(period_levels_fill_five(c("2030-2035", "2020-2025"))),
    c("2020-2025", "2025-2030", "2030-2035")
  )
  expect_identical(
    levels(cohort_levels_fill_five(c("2030-2035", "2020-2025"))),
    c("2020-2025", "2025-2030", "2030-2035")
  )
})

test_that("cohort_levels_fill() preserves original open-left values", {
  ans <- cohort_levels_fill_five(
    c("2010-2014", "2000-2004", "less than 1990"),
    interpret_range = "ex"
  )
  expect_identical(
    as.character(ans),
    c("2010-2014", "2000-2004", "less than 1990")
  )
  expect_identical(
    levels(ans),
    c(
      "less than 1990", "1990-1994", "1995-1999", "2000-2004",
      "2005-2009", "2010-2014"
    )
  )
})

test_that("age_levels_fill_life() fills life-table gaps", {
  expect_identical(
    levels(age_levels_fill_life(factor(c("0", "5-9")))),
    c("0", "1-4", "5-9")
  )
  expect_identical(
    levels(age_levels_fill_life(c("60+", "0"))),
    c(
      "0", "1-4", "5-9", "10-14", "15-19", "20-24", "25-29",
      "30-34", "35-39", "40-44", "45-49", "50-54", "55-59", "60+"
    )
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

test_that("age_levels_fill_one() fills gaps with one-year groups", {
  x <- factor(c("0-4", "20-24"))
  expect_identical(
    levels(age_levels_fill_one(x)),
    c(
      "0-4", "5", "6", "7", "8", "9", "10", "11", "12",
      "13", "14", "15", "16", "17", "18", "19", "20-24"
    )
  )
})

test_that("period_levels_fill_one() and cohort_levels_fill_one() fill gaps", {
  x <- factor(c("2000-2005", "2020-2025"))
  expected <- c(
    "2000-2005", "2005", "2006", "2007", "2008", "2009",
    "2010", "2011", "2012", "2013", "2014", "2015",
    "2016", "2017", "2018", "2019", "2020-2025"
  )
  expect_identical(levels(period_levels_fill_one(x)), expected)
  expect_identical(levels(cohort_levels_fill_one(x)), expected)
})

test_that("period_levels_fill_ten() and cohort_levels_fill_ten() fill gaps", {
  x <- c("2051-2061", "2021-2031")
  expected <- c("2021-2031", "2031-2041", "2041-2051", "2051-2061")
  expect_identical(levels(period_levels_fill_ten(x)), expected)
  expect_identical(levels(cohort_levels_fill_ten(x)), expected)
})

test_that("period/cohort fill-ten errors for indivisible gaps", {
  x <- c("2010-2019", "2030-2039")
  msg <- tryCatch(
    period_levels_fill_ten(x),
    error = function(e) conditionMessage(e)
  )
  expect_match(
    msg,
    "Gap between .2010-2019. and .2030-2039. is not divisible by 10"
  )
  expect_match(msg, "Choose a different .width.")
  expect_error(
    cohort_levels_fill_ten(x),
    "Gap between .2010-2019. and .2030-2039. is not divisible by 10"
  )
})

test_that("period/cohort fill-ten respect interpret_range exclude", {
  x <- c("2010-2019", "2030-2039")
  expected <- c("2010-2019", "2020-2029", "2030-2039")
  expect_identical(
    levels(period_levels_fill_ten(x, interpret_range = "exclude")),
    expected
  )
  expect_identical(
    levels(cohort_levels_fill_ten(x, interpret_range = "exclude")),
    expected
  )
})

test_that("cohort_levels_fill() fills gaps using default boundaries", {
  x <- factor(c("2020-2025", "2030-2035"))
  ans <- cohort_levels_fill(x)

  expect_s3_class(ans, "factor")
  expect_identical(as.character(ans), c("2020-2025", "2030-2035"))
  expect_identical(levels(ans), c("2020-2025", "2025-2030", "2030-2035"))
})

test_that("cohort_levels_fill() fills gaps using custom breaks", {
  x <- factor(c("2020-2025", "2030-2035"))
  expect_identical(
    levels(cohort_levels_fill(x, breaks = 2027)),
    c("2020-2025", "2025-2027", "2027-2030", "2030-2035")
  )
})

test_that("age_levels_fill_five() errors for indivisible gaps", {
  msg <- tryCatch(
    age_levels_fill_five(factor(c("0-4", "11-14"))),
    error = function(e) conditionMessage(e)
  )
  expect_match(msg, "Gap between .0-4. and .11-14. is not divisible by 5")
  expect_match(msg, "Choose a different .width.")
})

test_that("age_levels_fill_life() returns a factor for one level", {
  ans <- age_levels_fill_life("0")

  expect_s3_class(ans, "factor")
  expect_identical(as.character(ans), "0")
  expect_identical(levels(ans), "0")
})

test_that("age_levels_fill_life() errors for non-life-table labels", {
  expect_error(
    age_levels_fill_life(c("0-4", "5-9")),
    "Label .0-4. is not valid for a life table"
  )
})
