test_that("x_label() returns NA with a failure record for an uninterpretable label", {
  parsers <- agetime:::make_label_parsers_age()
  ans <- agetime:::x_label(
    label = "young people",
    label_orig = "young people",
    label_parsers = parsers,
    interpret_multi = "below_upper",
    label_type = "age"
  )
  expect_identical(as.numeric(ans), c(NA_real_, NA_real_))
  fail <- attr(ans, "fail")
  expect_identical(fail$label_orig, "young people")
  expect_true(fail$unknown)
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

test_that("parse errors list all uninterpretable labels at once", {
  expect_error(
    age_standard(c("0-4", "bad1", "5-9", "bad2")),
    "Don't know how to interpret 2 labels: \"bad1\" and \"bad2\""
  )
  err <- expect_error(age_lower(c("0-4", paste0("bad", 1:12))))
  msg <- conditionMessage(err)
  expect_match(msg, "12 labels")
  expect_match(msg, "\"bad1\"")
  expect_match(msg, "\"bad12\"")
  expect_no_match(msg, "\"bad6\"")
})

test_that("a parse failure with hints is shown in full, followed by the other failures", {
  err <- expect_error(age_lower(c("50-40", "bad1", "bad2")))
  msg <- conditionMessage(err)
  expect_match(msg, "Label \"50-40\" invalid")
  expect_match(msg, "Lower limit greater than upper limit")
  expect_match(msg, "Also can't interpret 2 other labels: \"bad1\" and \"bad2\"")
})

test_that("parse warnings for several labels are combined into one warning", {
  n_warn <- 0L
  ans <- withCallingHandlers(
    age_lower(c("bad1", "0-4", "bad2"), interpret_fail = "warn"),
    warning = function(w) {
      n_warn <<- n_warn + 1L
      invokeRestart("muffleWarning")
    }
  )
  expect_identical(n_warn, 1L)
  expect_identical(ans, c(NA, 0, NA))
})
