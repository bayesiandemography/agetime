
intervals_with_m <- function(label, lower, upper) {
  m <- matrix(
    c(lower, upper),
    nrow = 1L,
    ncol = 2L,
    dimnames = list(label, c("1", "2"))
  )
  out <- list(
    labels_unique = label,
    labels_unique_norm_unique = label,
    m = m,
    i = 1L,
    i_x_to_xu = 1L,
    i_xun_to_xunu = 1L
  )
  class(out) <- c("agetime_intervals_age", "agetime_intervals")
  out
}

test_that("construct_labels_from_intervals() uses upper bounds for one-year labels when x_one is upper", {
  intervals <- intervals(
    labels = "15",
    label_type = "age",
    x_one = "lower",
    x_multi = "exclude",
    x_fail = "error"
  )
  expect_identical(
    agetime:::construct_labels_from_intervals(intervals, "upper", "exclude"),
    "16"
  )
})

test_that("construct_labels_from_intervals() errors for an invalid interval", {
  intervals <- intervals_with_m("bad", lower = 0, upper = 1.2)
  expect_error(
    agetime:::construct_labels_from_intervals(intervals, "lower", "exclude"),
    "Internal error: Invalid interval."
  )
})

test_that("construct_labels_from_intervals() errors for an invalid x_one", {
  intervals <- intervals(
    labels = "15",
    label_type = "age",
    x_one = "lower",
    x_multi = "exclude",
    x_fail = "error"
  )
  expect_error(
    agetime:::construct_labels_from_intervals(intervals, "bogus", "exclude"),
    "Internal error: 'x_one' invalid."
  )
})

test_that("construct_labels_from_intervals() errors for an invalid x_multi", {
  intervals <- intervals(
    labels = "15",
    label_type = "age",
    x_one = "lower",
    x_multi = "exclude",
    x_fail = "error"
  )
  expect_error(
    agetime:::construct_labels_from_intervals(intervals, "lower", "bogus"),
    "Internal error: 'x_multi' invalid."
  )
})
