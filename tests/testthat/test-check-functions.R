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

test_that("check_in_limits_intervals() passes for in-bound breaks", {
  intervals <- intervals(
    labels = c("5-9", "10-14"),
    label_type = "age",
    interpret_single = "lower",
    interpret_multi = "below_upper",
    interpret_fail = "error"
  )
  expect_invisible(agetime:::check_in_limits_intervals(
    7,
    "breaks",
    intervals,
    "x",
    "age"
  ))
})

test_that("check_not_in_intervals() passes for out-of-interval breaks", {
  intervals <- intervals(
    labels = c("0-4", "20-24"),
    label_type = "age",
    interpret_single = "lower",
    interpret_multi = "below_upper",
    interpret_fail = "error"
  )
  expect_invisible(agetime:::check_not_in_intervals(
    7,
    "breaks",
    intervals,
    "x",
    "age"
  ))
})

test_that("check_not_in_intervals() errors for internal breaks", {
  intervals <- intervals(
    labels = c("0-4", "20-24"),
    label_type = "age",
    interpret_single = "lower",
    interpret_multi = "below_upper",
    interpret_fail = "error"
  )
  expect_error(
    agetime:::check_not_in_intervals(3, "breaks", intervals, "x", "age"),
    "`breaks` lies inside an existing age group"
  )
})

test_that("check_m_contains() passes when old labels map uniquely", {
  m_contains <- matrix(
    c(1L, 0L, 0L, 1L),
    nrow = 2L,
    ncol = 2L,
    dimnames = list(c("0-9", "10-19"), c("0-4", "10-14"))
  )
  expect_invisible(agetime:::check_m_contains(m_contains, "age"))
})

test_that("check_m_contains() returns TRUE when every old label fits", {
  m_contains <- matrix(c(TRUE, FALSE, FALSE, TRUE), nrow = 2L,
                       dimnames = list(c("0-9", "10-19"), c("0-4", "10-14")))
  expect_true(agetime:::check_m_contains(m_contains,
                                         m_new = rbind(c(0, 10), c(10, 20)),
                                         m_old = rbind(c(0, 5), c(10, 15)),
                                         label_type = "age"))
})

test_that("check_m_contains() distinguishes split labels from labels not covered", {
  m_contains <- matrix(FALSE, nrow = 2L, ncol = 2L,
                       dimnames = list(c("0-6", "7-9"), c("5-9", "10-14")))
  expect_snapshot(
    agetime:::check_m_contains(m_contains,
                               m_new = rbind(c(0, 7), c(7, 10)),
                               m_old = rbind(c(5, 10), c(10, 15)),
                               label_type = "age"),
    error = TRUE
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
