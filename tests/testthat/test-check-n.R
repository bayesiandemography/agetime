
test_that("check_n() returns TRUE invisibly for valid input", {
  expect_invisible(agetime:::check_n(10L, "n", NULL, NULL, NULL))
  expect_invisible(agetime:::check_n(10.0, "n", NULL, NULL, NULL))
  expect_invisible(agetime:::check_n(10L, "width", 0L, 100L, 5L))
  expect_invisible(agetime:::check_n(10L, "n", 10L, 10L, NULL))
})

test_that("check_n() errors for invalid type, length, and missing values", {
  expect_error(
    agetime:::check_n("10", "n", NULL, NULL, NULL),
    "`n` is non-numeric"
  )
  expect_error(
    agetime:::check_n(c(1L, 2L), "n", NULL, NULL, NULL),
    "`n` has length 2"
  )
  expect_error(
    agetime:::check_n(NA_integer_, "n", NULL, NULL, NULL),
    "`n` is NA"
  )
  expect_error(
    agetime:::check_n(Inf, "n", NULL, NULL, NULL),
    "`n` is Inf"
  )
  expect_error(
    agetime:::check_n(-Inf, "open", NULL, NULL, NULL),
    "`open` is -Inf"
  )
})

test_that("check_n() errors when n is not a whole number", {
  expect_error(
    agetime:::check_n(1.5, "n", NULL, NULL, NULL),
    "`n` is 1.5"
  )
  expect_error(
    agetime:::check_n(1.5, "n", NULL, NULL, NULL),
    "Use a whole number"
  )
})

test_that("check_n() errors when n is outside min or max", {
  expect_error(
    agetime:::check_n(3L, "n", 5L, NULL, NULL),
    "Use a value of at least 5"
  )
  expect_error(
    agetime:::check_n(10L, "n", NULL, 5L, NULL),
    "Use a value of at most 5"
  )
})

test_that("check_n() errors when n is not divisible by divisible_by", {
  expect_error(
    agetime:::check_n(7L, "n", NULL, NULL, 5L),
    "`n` is 7"
  )
  expect_error(
    agetime:::check_n(7L, "n", NULL, NULL, 5L),
    "Use a value divisible by 5"
  )
})
