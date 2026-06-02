
test_that("inner_modify_width() uses upper bounds for start when open on the left (lines 104-105)", {
  x <- c("<2020", "2020-2024")
  ans <- agetime:::inner_modify_width(
    x,
    width = 5L,
    offset = 0L,
    label_type = "cohort",
    x_one = "lower",
    x_multi = "exclude",
    x_fail = "error"
  )

  expect_identical(ans, c("<2020", "2020-2024"))
})

test_that("inner_modify_width() aligns open-left start when offset leaves a remainder (line 114)", {
  x <- c("<2020", "2020-2024")
  intervals <- intervals(
    labels = x,
    label_type = "cohort",
    x_one = "lower",
    x_multi = "exclude",
    x_fail = "error"
  )
  expect_true(agetime:::int_is_open_left(intervals))

  start <- min(agetime:::get_upper(intervals), na.rm = TRUE)
  expect_identical(start, 2020)

  width <- 5L
  offset <- 2L
  remainder_start <- (start - offset) %% width
  expect_equal(start + width - remainder_start, 2022)

  expect_error(
    agetime:::inner_modify_width(
      x,
      width = width,
      offset = offset,
      label_type = "cohort",
      x_one = "lower",
      x_multi = "exclude",
      x_fail = "error"
    ),
    "cannot each lie in exactly one new cohort"
  )
})
