
test_that("label_parser_na() returns NA bounds for a missing label", {
  expect_identical(
    agetime:::label_parser_na(NA_character_),
    c(NA_real_, NA_real_)
  )
})
