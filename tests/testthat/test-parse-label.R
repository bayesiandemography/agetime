test_that("x_label() warns and returns NA for an uninterpretable label", {
  parsers <- agetime:::make_label_parsers_age()

  expect_warning(
    ans <- agetime:::x_label(
      label = "young people",
      label_parsers = parsers,
      interpret_fail = "warn"
    ),
    "Don't know how to interpret label"
  )
  expect_identical(ans, c(NA_real_, NA_real_))
})
