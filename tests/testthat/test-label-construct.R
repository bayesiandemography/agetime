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

test_that("construct_labels_intervals() can use upper bounds", {
  intervals <- intervals(
    labels = "15",
    label_type = "age",
    interpret_single = "lower",
    interpret_range = "exclude",
    interpret_fail = "error"
  )
  expect_identical(
    agetime:::construct_labels_intervals(intervals,
      format_single = "upper",
      format_range = "exclude"
    ),
    "16"
  )
})

test_that("construct_labels_intervals() errors for an invalid interval", {
  intervals <- intervals_with_m("bad", lower = 0, upper = 1.2)
  expect_error(
    agetime:::construct_labels_intervals(intervals,
      format_single = "lower",
      format_range = "exclude"
    ),
    "Internal error: Invalid interval."
  )
})

test_that("construct_labels_intervals() errors for invalid format_single", {
  intervals <- intervals(
    labels = "15",
    label_type = "age",
    interpret_single = "lower",
    interpret_range = "exclude",
    interpret_fail = "error"
  )
  expect_error(
    agetime:::construct_labels_intervals(intervals,
      format_single = "bogus",
      format_range = "exclude"
    ),
    "Internal error: 'format_single' invalid."
  )
})

test_that("construct_labels_intervals() errors for invalid format_range", {
  intervals <- intervals(
    labels = "15",
    label_type = "age",
    interpret_single = "lower",
    interpret_range = "exclude",
    interpret_fail = "error"
  )
  expect_error(
    agetime:::construct_labels_intervals(intervals,
      format_single = "lower",
      format_range = "bogus"
    ),
    "Internal error: 'format_range' invalid."
  )
})
