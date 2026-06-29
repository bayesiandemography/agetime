test_that("inner_levels_fill() errors with breaks and width", {
  expect_error(
    agetime:::inner_levels_fill(
      labels = "0-4",
      breaks = c(0, 10),
      width = 5L,
      label_type = "age",
      interpret_single = "lower",
      interpret_range = "exclude",
      interpret_fail = "error"
    ),
    "Internal error: 'breaks' and 'width' both supplied"
  )
})

test_that("inner_levels_fill() coerces character input with one level", {
  ans <- agetime:::inner_levels_fill(
    labels = "0-4",
    breaks = NULL,
    width = NULL,
    label_type = "age",
    interpret_single = "lower",
    interpret_range = "exclude",
    interpret_fail = "error"
  )

  expect_s3_class(ans, "factor")
  expect_identical(as.character(ans), "0-4")
  expect_identical(levels(ans), "0-4")
})
