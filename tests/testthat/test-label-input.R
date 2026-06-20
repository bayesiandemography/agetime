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

test_that("to_character_or_factor() returns character labels unchanged", {
  x <- c("0-4", "5-9")
  expect_identical(agetime:::to_character_or_factor(x, "x", TRUE), x)
})

test_that("to_character_or_factor() coerces numeric labels to character", {
  expect_identical(
    agetime:::to_character_or_factor(c(0, 5), "x", TRUE),
    c("0", "5")
  )
})

test_that("to_character_or_factor() returns factors unchanged", {
  x <- factor(c("0-4", "5-9"), ordered = TRUE)
  expect_identical(agetime:::to_character_or_factor(x, "x", TRUE), x)
})

test_that("to_character_or_factor() allows length-0 input", {
  expect_identical(
    agetime:::to_character_or_factor(character(0), "x", TRUE),
    character(0)
  )
})

test_that("to_character_or_factor() errors when length_zero_ok is FALSE", {
  expect_error(
    agetime:::to_character_or_factor(character(0), "labels", FALSE),
    "`labels` has length 0."
  )
})

test_that("to_character_or_factor() errors for non-vector inputs", {
  expect_error(
    agetime:::to_character_or_factor(data.frame(a = "0-4"), "x", TRUE),
    "`x` is a data frame."
  )
  expect_error(
    agetime:::to_character_or_factor(list("0-4"), "x", TRUE),
    "`x` is a list."
  )
  expect_error(
    agetime:::to_character_or_factor(matrix("0-4"), "x", TRUE),
    "`x` is not a vector."
  )
})

test_that("to_character_or_factor() errors when labels cannot be coerced", {
  assign(
    "as.character.agetime_test_no_as_character",
    function(x, ...) stop("cannot coerce"),
    envir = .GlobalEnv
  )
  on.exit(
    try(
      rm("as.character.agetime_test_no_as_character", envir = .GlobalEnv),
      silent = TRUE
    ),
    add = TRUE
  )
  x <- structure(1L, class = "agetime_test_no_as_character")
  expect_error(
    agetime:::to_character_or_factor(x, "x", TRUE),
    "`x` is not a vector of labels"
  )
  expect_error(
    agetime:::to_character_or_factor(x, "x", TRUE),
    "class <agetime_test_no_as_character>"
  )
})
