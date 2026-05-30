
# *_mapping(): empty x or y (character(0) or factor with no levels) -> empty
# mapping. Empty factor with levels still maps normally.

test_that("age_mapping() with length-0 input returns empty data frame", {
  expect_identical(age_mapping(character(0)),
                   tibble::tibble(x = character(0), y = character(0)))
  expect_identical(age_mapping(factor()),
                   tibble::tibble(x = character(0), y = character(0)))
})

test_that("age_mapping() with length-0 input returns empty matrix", {
  expect_identical(
    age_mapping(character(0), return_val = "matrix"),
    matrix(integer(0),
           nrow = 0L,
           ncol = 0L,
           dimnames = list(x = character(0), y = character(0)))
  )
})

test_that("age_mapping() with empty y returns empty mapping", {
  y <- c("0-4", "5-9")
  expect_identical(
    age_mapping(character(0), y = y),
    tibble::tibble(x = character(0), y = character(0))
  )
  expect_identical(
    age_mapping(c("0-4", "5-9"), y = character(0)),
    tibble::tibble(x = character(0), y = character(0))
  )
})

test_that("age_mapping() with length-0 factor with levels still maps", {
  fx <- factor(character(0), levels = c("0-4", "5-9"))
  f_ref <- factor(c("0-4", "5-9"))
  expect_identical(
    age_mapping(fx, return_val = "matrix"),
    age_mapping(f_ref, return_val = "matrix")
  )
})

test_that("period_mapping() with length-0 input returns empty mapping", {
  expect_identical(
    period_mapping(character(0)),
    tibble::tibble(x = character(0), y = character(0))
  )
})

test_that("cohort_mapping() with length-0 input returns empty mapping", {
  expect_identical(
    cohort_mapping(factor()),
    tibble::tibble(x = character(0), y = character(0))
  )
})
