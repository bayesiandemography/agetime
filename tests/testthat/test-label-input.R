
intervals_with_bounds <- function(label, lower, upper) {
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

test_that("label_non_life() flags an interval with lower 1 and upper 4", {
  intervals <- intervals_with_bounds("1-4", lower = 1, upper = 4)
  expect_identical(agetime:::label_non_life(intervals), "1-4")
})

test_that("label_non_life() flags an interval with lower 10 and upper 13", {
  intervals <- intervals_with_bounds("10-13", lower = 10, upper = 13)
  expect_identical(agetime:::label_non_life(intervals), "10-13")
})

test_that("label_name() errors for an invalid label_type", {
  expect_error(
    agetime:::label_name("bogus"),
    'Internal error: "bogus" is not a valid value for `label_type`.'
  )
})
