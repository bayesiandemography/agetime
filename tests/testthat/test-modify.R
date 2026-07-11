test_that("age_modify() recodes to wider age groups", {
  x <- c("1-4", "87-89", "0", "50-54")
  ans <- age_modify(x, breaks = c(0, 10, 40, 90))

  expect_s3_class(ans, "factor")
  expect_identical(length(ans), length(x))
  expect_values(ans, c("0-9", "40-89", "0-9", "40-89"))
})

test_that("age_modify() infers closed top from labels by default", {
  x <- c("1-4", "87-89", "0", "50-54")

  expect_identical(
    levels(age_modify(x, breaks = c(0, 10, 40, 90))),
    c("0-9", "10-39", "40-89")
  )
})

test_that("age_modify() with open_right = FALSE omits an open top group", {
  x <- c("1-4", "87-89", "0", "50-54")

  expect_values(
    age_modify(x, breaks = c(0, 10, 40, 90), open_right = FALSE),
    c("0-9", "40-89", "0-9", "40-89")
  )
  expect_identical(
    levels(age_modify(x, breaks = c(0, 10, 40, 90), open_right = FALSE)),
    c("0-9", "10-39", "40-89")
  )
})

test_that("age_modify() with open_right = TRUE adds structural open top", {
  x <- c("1-4", "87-89", "0", "50-54")

  expect_identical(
    levels(age_modify(x, breaks = c(0, 10, 40, 90), open_right = TRUE)),
    c("0-9", "10-39", "40-89", "90+")
  )
})

test_that("age_modify() returns factor with updated levels", {
  fx <- factor(c("0-4", "5-9"))
  ans <- age_modify(fx, breaks = c(0, 10, 90))

  expect_s3_class(ans, "factor")
  expect_false(is.ordered(ans))
  expect_identical(as.character(ans), c("0-9", "0-9"))
  expect_identical(levels(ans), c("0-9", "10-89"))
})

test_that("age_modify_five() recodes to five-year age groups", {
  x <- c("1-3", "87-89", "0", "91+", "total", "52")
  ans <- age_modify_five(x)

  expect_s3_class(ans, "factor")
  expect_values(ans, c("0-4", "85-89", "0-4", "90+", "Total", "50-54"))
})

test_that("age_modify_five() infers open top from labels by default", {
  fx <- factor(c("1-3", "91+"), levels = c("1-3", "91+"))
  expect_true("90+" %in% levels(age_modify_five(fx)))
})

test_that("age_modify_five() omits open top for closed labels by default", {
  fx <- factor(c("1-3", "52"), levels = c("1-3", "52"))
  expect_false("50+" %in% levels(age_modify_five(fx)))
})

test_that("age_modify_five() with open_right = TRUE adds structural open top", {
  fx <- factor(c("1-3", "52"), levels = c("1-3", "52"))
  expect_true("50+" %in% levels(age_modify_five(fx, open_right = TRUE)))
})

test_that("age_modify_five() with open_right = FALSE errors on open labels", {
  fx <- factor(c("1-3", "91+"), levels = c("1-3", "91+"))
  expect_error(
    age_modify_five(fx, open_right = FALSE),
    regexp = "contains age group open on the right: \"91\\+\""
  )
})

test_that("age_modify_life() recodes to life-table age groups", {
  x <- c("1-3", "87-89", "0")
  ans <- age_modify_life(x)

  expect_values(ans, c("1-4", "85-89", "0"))
})

test_that("age_modify_life() leaves single-year zero as 0", {
  expect_values(age_modify_life("0"), "0")
})

test_that("age_modify_life() recodes a young multi-year group to 1-4", {
  expect_values(age_modify_life("1-3"), "1-4")
})

test_that("age_modify_life() recodes closed groups to 5-year labels", {
  expect_values(age_modify_life("5-9"), "5-9")
  expect_values(age_modify_life("10-14"), "10-14")
  expect_values(age_modify_life("87-89"), "85-89")
})

test_that("age_modify_life() omits open top for closed labels by default", {
  fx <- factor("87-89")
  expect_values(age_modify_life("87-89"), "85-89")
  expect_false("90+" %in% levels(age_modify_life(fx)))
})

test_that("age_modify_life() with open_right = TRUE adds structural open top", {
  fx <- factor("87-89")
  expect_true("90+" %in% levels(age_modify_life(fx, open_right = TRUE)))
})

test_that("age_modify_life() with open_right = FALSE errors on open labels", {
  fx <- factor("90+")
  expect_error(
    age_modify_life(fx, open_right = FALSE),
    regexp = "open on the right.*90"
  )
})

test_that("age_modify_life() rounds max upper to a 5-year break", {
  expect_values(age_modify_life("6-8"), "5-9")
})

test_that("age_modify_life() preserves 90+ on the life-table open top", {
  expect_values(age_modify_life("90+"), "90+")
})

test_that("age_modify_life() recodes 86+ to 85+", {
  expect_values(age_modify_life("86+"), "85+")
})

test_that("age_modify_life() errors for 0-4", {
  expect_error(
    age_modify_life("0-4"),
    "cannot each lie in exactly one new age group"
  )
})

test_that("age_modify_five() fills factor levels", {
  fx <- factor(c("1-3", "52"), levels = c("1-3", "52"))
  ans <- age_modify_five(fx)

  expect_s3_class(ans, "factor")
  expect_identical(as.character(ans), c("0-4", "50-54"))
  expect_identical(
    levels(ans),
    c(
      "0-4", "5-9", "10-14", "15-19", "20-24", "25-29",
      "30-34", "35-39", "40-44", "45-49", "50-54"
    )
  )
})

test_that("period/cohort modify-five recode to five-year groups", {
  x <- c("2021", "2026-2028")
  expect_values(period_modify_five(x), c("2020-2025", "2025-2030"))
  expect_values(cohort_modify_five(x), c("2020-2025", "2025-2030"))
})

test_that("cohort_modify() adds structural open_right level", {
  labels <- c("2001-2004", "1987-1989", "2000")
  expect_identical(
    levels(cohort_modify(labels, breaks = c(1980, 2000, 2050), open_right = TRUE)),
    c("1980-2000", "2000-2050", "2050+")
  )
})

test_that("cohort_modify() omits open_right by default for closed labels", {
  labels <- c("2001-2004", "1987-1989", "2000")
  expect_identical(
    levels(cohort_modify(labels, breaks = c(1980, 2000, 2050))),
    c("1980-2000", "2000-2050")
  )
})

test_that("cohort_modify_five() infers open_left from labels by default", {
  x <- c("<2020", "2020-2024")
  expect_values(
    cohort_modify_five(x),
    c("<2020", "2020-2025")
  )
})

test_that("cohort_modify_five() can suppress inferred open_left", {
  x <- c("<2020", "2020-2024")
  expect_error(
    cohort_modify_five(x, open_left = FALSE),
    regexp = "contains cohort open on the left: \"<2020\""
  )
})
