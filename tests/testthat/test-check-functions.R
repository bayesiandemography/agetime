test_that("check_breaks() returns TRUE invisibly for valid breaks", {
  expect_invisible(agetime:::check_breaks(c(0, 10, 90)))
  expect_invisible(agetime:::check_breaks(c(0L, 5L, 10L)))
})

test_that("check_breaks() errors when breaks are too short", {
  expect_error(
    agetime:::check_breaks(5L),
    "`breaks` has length 1"
  )
  expect_error(
    agetime:::check_breaks(5L),
    "Use at least two break points"
  )
})

test_that("check_incr_nonneg_integers() errors for invalid input", {
  expect_error(
    agetime:::check_incr_nonneg_integers("a", "breaks", 1L),
    "`breaks` is non-numeric"
  )
  expect_error(
    agetime:::check_incr_nonneg_integers(c(1, NA), "breaks", 1L),
    "`breaks` has NA"
  )
  expect_error(
    agetime:::check_incr_nonneg_integers(c(1, 1.5), "breaks", 1L),
    "`breaks` has value 1.5 that is not a whole number"
  )
  expect_error(
    agetime:::check_incr_nonneg_integers(c(-1, 0), "breaks", 1L),
    "`breaks` has negative value"
  )
  expect_error(
    agetime:::check_incr_nonneg_integers(c(5, 3), "breaks", 1L),
    "`breaks` has non-increasing values"
  )
  expect_error(
    agetime:::check_incr_nonneg_integers(1L, "breaks", 2L),
    "Use at least 2 values"
  )
})

test_that("check_in_limits_intervals() passes when breaks lie within interval bounds", {
  intervals <- intervals(
    labels = c("5-9", "10-14"),
    label_type = "age",
    x_one = "lower",
    x_multi = "exclude",
    x_fail = "error"
  )
  expect_invisible(agetime:::check_in_limits_intervals(
    7,
    "breaks",
    intervals,
    "x",
    "age"
  ))
})

test_that("check_not_in_intervals() passes when breaks are not inside intervals", {
  intervals <- intervals(
    labels = c("0-4", "20-24"),
    label_type = "age",
    x_one = "lower",
    x_multi = "exclude",
    x_fail = "error"
  )
  expect_invisible(agetime:::check_not_in_intervals(
    7,
    "breaks",
    intervals,
    "x",
    "age"
  ))
})

test_that("check_not_in_intervals() errors when a break falls inside an interval", {
  intervals <- intervals(
    labels = c("0-4", "20-24"),
    label_type = "age",
    x_one = "lower",
    x_multi = "exclude",
    x_fail = "error"
  )
  expect_error(
    agetime:::check_not_in_intervals(3, "breaks", intervals, "x", "age"),
    "`breaks` lies inside an existing age group"
  )
})

test_that("check_m_contains() passes when each old label maps to one new label", {
  m_contains <- matrix(
    c(1L, 0L, 0L, 1L),
    nrow = 2L,
    ncol = 2L,
    dimnames = list(c("0-9", "10-19"), c("0-4", "10-14"))
  )
  expect_invisible(agetime:::check_m_contains(m_contains, "age"))
})

test_that("check_m_contains() errors when old labels do not map uniquely", {
  m_contains <- matrix(
    c(1L, 1L, 0L, 0L),
    nrow = 2L,
    ncol = 2L,
    dimnames = list(c("0-9", "10-19"), c("0-4", "10-14"))
  )
  expect_error(
    agetime:::check_m_contains(m_contains, "age"),
    "cannot each lie in exactly one new age group"
  )
})

test_that("check_x_lt_y() returns TRUE invisibly when x < y", {
  expect_invisible(agetime:::check_x_lt_y(0, 5, "lower", "upper"))
})

test_that("check_x_lt_y() errors when x is greater than y", {
  expect_error(
    agetime:::check_x_lt_y(5, 3, "lower", "upper"),
    "`lower` \\(5\\) is greater than `upper` \\(3\\)"
  )
})

test_that("check_x_lt_y() errors when x equals y", {
  expect_error(
    agetime:::check_x_lt_y(5, 5, "lower", "upper"),
    "`lower` equals `upper` \\(5\\)"
  )
})
