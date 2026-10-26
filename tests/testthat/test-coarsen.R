test_that("age_coarsen() recodes to wider age groups", {
  x <- c("1-4", "87-89", "0", "50-54")
  ans <- age_coarsen(x, breaks = c(0, 10, 40, 90))

  expect_s3_class(ans, "factor")
  expect_identical(length(ans), length(x))
  expect_values(ans, c("0-9", "40-89", "0-9", "40-89"))
})

test_that("age_coarsen() infers closed top from labels by default", {
  x <- c("1-4", "87-89", "0", "50-54")

  expect_identical(
    levels(age_coarsen(x, breaks = c(0, 10, 40, 90))),
    c("0-9", "10-39", "40-89")
  )
})

test_that("age_coarsen() with open_right = FALSE omits an open top group", {
  x <- c("1-4", "87-89", "0", "50-54")

  expect_values(
    age_coarsen(x, breaks = c(0, 10, 40, 90), open_right = FALSE),
    c("0-9", "40-89", "0-9", "40-89")
  )
  expect_identical(
    levels(age_coarsen(x, breaks = c(0, 10, 40, 90), open_right = FALSE)),
    c("0-9", "10-39", "40-89")
  )
})

test_that("age_coarsen() with open_right = TRUE adds structural open top", {
  x <- c("1-4", "87-89", "0", "50-54")

  expect_identical(
    levels(age_coarsen(x, breaks = c(0, 10, 40, 90), open_right = TRUE)),
    c("0-9", "10-39", "40-89", "90+")
  )
})

test_that("age_coarsen() returns factor with updated levels", {
  fx <- factor(c("0-4", "5-9"))
  ans <- age_coarsen(fx, breaks = c(0, 10, 90))

  expect_s3_class(ans, "factor")
  expect_false(is.ordered(ans))
  expect_identical(as.character(ans), c("0-9", "0-9"))
  expect_identical(levels(ans), c("0-9", "10-89"))
})

test_that("age_coarsen_five() recodes to five-year age groups", {
  x <- c("1-3", "87-89", "0", "91+", "total", "52")
  ans <- age_coarsen_five(x)

  expect_s3_class(ans, "factor")
  expect_values(as.character(ans), c("0-4", "85-89", "0-4", "90+", "Total", "50-54"))
})

test_that("age_coarsen_five() infers open top from labels by default", {
  fx <- factor(c("1-3", "91+"), levels = c("1-3", "91+"))
  expect_true("90+" %in% levels(age_coarsen_five(fx)))
})

test_that("age_coarsen_five() omits open top for closed labels by default", {
  fx <- factor(c("1-3", "52"), levels = c("1-3", "52"))
  expect_false("50+" %in% levels(age_coarsen_five(fx)))
})

test_that("age_coarsen_five() with open_right = TRUE adds structural open top", {
  fx <- factor(c("1-3", "52"), levels = c("1-3", "52"))
  expect_true("50+" %in% levels(age_coarsen_five(fx, open_right = TRUE)))
})

test_that("age_coarsen_five() with open_right = FALSE errors on open labels", {
  fx <- factor(c("1-3", "91+"), levels = c("1-3", "91+"))
  expect_error(
    age_coarsen_five(fx, open_right = FALSE),
    regexp = "contains age group open on the right: \"91\\+\""
  )
})

test_that("age_coarsen_life() recodes to life-table age groups", {
  x <- c("1-3", "87-89", "0")
  ans <- age_coarsen_life(x)

  expect_values(ans, c("1-4", "85-89", "0"))
})

test_that("age_coarsen_life() leaves single-year zero as 0", {
  expect_values(age_coarsen_life("0"), "0")
})

test_that("age_coarsen_life() recodes a young multi-year group to 1-4", {
  expect_values(age_coarsen_life("1-3"), "1-4")
})

test_that("age_coarsen_life() recodes closed groups to 5-year labels", {
  expect_values(age_coarsen_life("5-9"), "5-9")
  expect_values(age_coarsen_life("10-14"), "10-14")
  expect_values(age_coarsen_life("87-89"), "85-89")
})

test_that("age_coarsen_life() omits open top for closed labels by default", {
  fx <- factor("87-89")
  expect_values(age_coarsen_life("87-89"), "85-89")
  expect_false("90+" %in% levels(age_coarsen_life(fx)))
})

test_that("age_coarsen_life() with open_right = TRUE adds structural open top", {
  fx <- factor("87-89")
  expect_true("90+" %in% levels(age_coarsen_life(fx, open_right = TRUE)))
})

test_that("age_coarsen_life() with open_right = FALSE errors on open labels", {
  fx <- factor("90+")
  expect_error(
    age_coarsen_life(fx, open_right = FALSE),
    regexp = "open on the right.*90"
  )
})

test_that("age_coarsen_life() rounds max upper to a 5-year break", {
  expect_values(age_coarsen_life("6-8"), "5-9")
})

test_that("age_coarsen_life() preserves 90+ on the life-table open top", {
  expect_values(age_coarsen_life("90+"), "90+")
})

test_that("age_coarsen_life() recodes 86+ to 85+", {
  expect_values(age_coarsen_life("86+"), "85+")
})

test_that("age_coarsen_life() errors for 0-4", {
  expect_error(
    age_coarsen_life("0-4"),
    "Age group \"0-4\" would be split by the new age groups."
  )
})

test_that("age_coarsen_five() recodes factor levels without intermediate breaks", {
  fx <- factor(c("1-3", "52"), levels = c("1-3", "52"))
  ans <- age_coarsen_five(fx)

  expect_s3_class(ans, "factor")
  expect_identical(as.character(ans), c("0-4", "50-54"))
  expect_identical(levels(ans), c("0-4", "50-54"))
})

test_that("age_coarsen_five() recodes all declared factor levels", {
  fx <- factor(c("0-1", "44+"), levels = c("0-1", "5-9", "20-24", "44+"))
  ans <- age_coarsen_five(fx)

  expect_identical(as.character(ans), c("0-4", "40+"))
  expect_identical(levels(ans), c("0-4", "5-9", "20-24", "40+"))
})

test_that("width-based coarsen functions return factors for character input", {
  x <- c("5-9", "44+", "0-1")
  ans <- age_coarsen_five(x)
  expect_identical(ans, factor(c("5-9", "40+", "0-4"), levels = c("0-4", "5-9", "40+")))
  expect_s3_class(age_coarsen_ten(x), "factor")
  expect_s3_class(age_coarsen_life(c("1-4", "44+")), "factor")
  expect_s3_class(period_coarsen_five(c("2001", "2010")), "factor")
  expect_s3_class(period_coarsen_ten(c("2001", "2010")), "factor")
  expect_s3_class(cohort_coarsen_five(c("2001", "2010")), "factor")
  expect_s3_class(cohort_coarsen_ten(c("2001", "2010")), "factor")
})

test_that("age_coarsen_five() preserves ordered factor level order", {
  fx <- ordered(
    c("20-24", "0-4"),
    levels = c("20-24", "0-4", "5-9")
  )
  ans <- age_coarsen_five(fx)

  expect_true(is.ordered(ans))
  expect_identical(as.character(ans), c("20-24", "0-4"))
  expect_identical(levels(ans), c("20-24", "0-4", "5-9"))
})

test_that("age_coarsen_life() appends open_right to ordered levels", {
  fx <- ordered(c("0", "1-4", "5-9"), levels = c("0", "1-4", "5-9"))
  ans <- age_coarsen_life(fx, open_right = TRUE)

  expect_true(is.ordered(ans))
  expect_identical(as.character(ans), c("0", "1-4", "5-9"))
  expect_identical(levels(ans), c("0", "1-4", "5-9", "10+"))
})

test_that("period/cohort coarsen-five recode to five-year groups", {
  x <- c("2021", "2026-2028")
  expect_values(period_coarsen_five(x), c("2020-2025", "2025-2030"))
  expect_values(cohort_coarsen_five(x), c("2020-2025", "2025-2030"))
})

test_that("cohort_coarsen() adds structural open_right level", {
  labels <- c("2001-2004", "1987-1989", "2000")
  expect_identical(
    levels(cohort_coarsen(labels, breaks = c(1980, 2000, 2050), open_right = TRUE)),
    c("1980-2000", "2000-2050", "2050+")
  )
})

test_that("cohort_coarsen() omits open_right by default for closed labels", {
  labels <- c("2001-2004", "1987-1989", "2000")
  expect_identical(
    levels(cohort_coarsen(labels, breaks = c(1980, 2000, 2050))),
    c("1980-2000", "2000-2050")
  )
})

test_that("cohort_coarsen_five() infers open_left from labels by default", {
  x <- c("<2020", "2020-2024")
  expect_values(
    cohort_coarsen_five(x, interpret_multi = "at_upper"),
    c("<2020", "2020-2025")
  )
})

test_that("cohort_coarsen_five() can suppress inferred open_left", {
  x <- c("<2020", "2020-2024")
  expect_error(
    cohort_coarsen_five(x, open_left = FALSE, interpret_multi = "at_upper"),
    regexp = "contains cohort open on the left: \"<2020\""
  )
})

test_that("coarsen error messages describe each problem and suggest fixes", {
  expect_snapshot(age_coarsen(c("3", "7", "12"), breaks = c(5, 10)), error = TRUE)
  expect_snapshot(
    age_coarsen(c("0-4", "5-9", "10-14", "15-19", "20-24", "25+"),
                breaks = c(2, 7, 12, 17, 22, 27)),
    error = TRUE
  )
  expect_snapshot(period_coarsen(c("2000", "2010"), breaks = c(2005, 2015)), error = TRUE)
  expect_snapshot(age_coarsen_to(c("0-4", "10-14", NA), to = c("0-2", "3-9")), error = TRUE)
})

test_that("errors from parsing and checks report the function the user called", {
  expect_error(age_standard(c("0-4", "young")), class = "rlang_error")
  cnd <- tryCatch(age_standard(c("0-4", "young")), error = function(e) e)
  expect_identical(deparse(cnd$call[[1]]), "age_standard")
  cnd <- tryCatch(age_coarsen_five("90+", open_right = FALSE), error = function(e) e)
  expect_identical(deparse(cnd$call[[1]]), "age_coarsen_five")
})

test_that("age_coarsen_five() gives a clear error when all labels are open and open_right is FALSE", {
  expect_error(age_coarsen_five("90+", open_right = FALSE),
               "`labels` contains age group open on the right")
})
