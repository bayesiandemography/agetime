test_that("x_label() warns and returns NA for an uninterpretable label", {
  parsers <- agetime:::make_label_parsers_age()

  expect_warning(
    ans <- agetime:::x_label(
      label = "young people",
      label_orig = "young people",
      label_parsers = parsers,
      interpret_fail = "warn",
      interpret_multi = "below_upper",
      label_type = "age"
    ),
    "Don't know how to interpret label"
  )
  expect_identical(ans, c(NA_real_, NA_real_))
})

test_that("parse errors quote the label as supplied, not the normalized label", {
  expect_error(
    age_standard(c("0-4", "Age not stated4")),
    "Age not stated4"
  )
  expect_error(
    period_standard("2020 - 2021"),
    "2020 - 2021"
  )
  expect_warning(
    ans <- age_lower(c("0-4", "Age 5.5"), interpret_fail = "warn"),
    "Age 5.5"
  )
  expect_identical(ans, c(0, NA))
})
