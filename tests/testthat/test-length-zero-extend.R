# *_extend() needs at least one interval to extend from the final element of x.
# Length-0 input is an error even if a factor has non-empty levels.

test_that("*_extend() errors on length-0 input", {
  expect_error(age_extend(character(0)), "length 0")
  expect_error(period_extend(character(0)), "length 0")
  expect_error(cohort_extend(character(0)), "length 0")

  expect_error(age_extend(factor()), "length 0")
  expect_error(period_extend(factor()), "length 0")
  expect_error(cohort_extend(factor()), "length 0")

  fx <- factor(character(0), levels = c("0-4", "5-9"))
  expect_error(age_extend(fx), "length 0")
})

test_that("*_extend() errors on length-0 input even when width is supplied", {
  expect_error(
    age_extend(character(0), width = 5),
    "length 0"
  )
})

test_that("*_extend() suggests a label when x has length 0", {
  msg <- tryCatch(
    age_extend(character(0)),
    error = function(e) conditionMessage(e)
  )
  expect_match(msg, "`x` has length 0\\.")
  expect_match(msg, "Supply at least one label to extend from\\?")
})
