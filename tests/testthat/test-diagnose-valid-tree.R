## 'valid_tree' condition of *_diagnose_*() and *_assert_*() -------------------

census_tree <- c("Missing", "15+", "0-14", "70+", "60-69", "50-59", "40-49",
                 "30-39", "20-29", "15-19", "10-14", "5-9", "0-4")

valid_tree_row <- function(x, ...) {
  diagnostic_details(age_df_diagnose_values(data.frame(age = x), age = "age", valid_tree = TRUE, ...))
}

test_that("valid_tree passes census tree", {
  ans <- age_df_diagnose_values(data.frame(age = census_tree), age = "age", valid_tree = TRUE)
  expect_true(diagnostic_ok(ans))
  expect_identical(diagnostic_details(ans)$condition, "valid_tree")
  expect_true(is.na(diagnostic_details(ans)$comment))
})

test_that("valid_tree passes three-level, unbalanced tree", {
  x <- c(age_labels_five(lower_last = 85), "0-14", "15+", "15-64", "65+")
  expect_true(diagnostic_ok(age_df_diagnose_values(data.frame(age = x), age = "age", valid_tree = TRUE)))
  x <- c("0-4", "5-64", "65-74", "75+", "65+")
  expect_true(diagnostic_ok(age_df_diagnose_values(data.frame(age = x), age = "age", valid_tree = TRUE)))
})

test_that("valid_tree passes labels with no internal nodes", {
  expect_true(diagnostic_ok(age_df_diagnose_values(data.frame(age = c("0-4", "5-9", "10+")), age = "age", valid_tree = TRUE)))
})

test_that("valid_tree allows repeated values and synonyms, unlike no_overlap", {
  x <- c(census_tree, census_tree, "Under 5", NA)
  expect_true(diagnostic_ok(age_df_diagnose_values(data.frame(age = x), age = "age", valid_tree = TRUE)))
  expect_false(diagnostic_ok(age_df_diagnose_values(data.frame(age = x), age = "age", no_overlap = TRUE)))
})

test_that("valid_tree passes empty input", {
  expect_true(diagnostic_ok(age_df_diagnose_values(data.frame(age = character()), age = "age", valid_tree = TRUE)))
  expect_true(diagnostic_ok(age_df_diagnose_values(data.frame(age = "Missing"), age = "age", valid_tree = TRUE)))
})

test_that("valid_tree fails when labels overlap without nesting", {
  ans <- valid_tree_row(c("0-4", "10-19", "15-24", "0-9"))
  expect_false(ans$passed)
  expect_identical(
    ans$comment,
    "Example: '10-19' and '15-24' overlap, but neither contains the other"
  )
})

test_that("valid_tree fails with gap between leaves", {
  ans <- valid_tree_row(c("0-4", "5-9", "15-19", "0-19"))
  expect_false(ans$passed)
  expect_identical(
    ans$comment,
    "Example: gap among most detailed age groups between '5-9' and '15-19'"
  )
})

test_that("valid_tree fails when leaves do not reach upper limit of node", {
  ans <- valid_tree_row(c("0-4", "5-9", "0-14"))
  expect_false(ans$passed)
  expect_identical(
    ans$comment,
    "Example: most detailed age groups do not reach upper limit of '0-14'"
  )
})

test_that("valid_tree fails when leaves do not reach lower limit of node", {
  ans <- valid_tree_row(c("5-14", "10-14"))
  expect_false(ans$passed)
  expect_identical(
    ans$comment,
    "Example: most detailed age groups do not reach lower limit of '5-14'"
  )
})

test_that("valid_tree comment names narrowest node containing gap", {
  ans <- valid_tree_row(c("0-4", "5-9", "0-14", "0-19", "15-19"))
  expect_identical(
    ans$comment,
    "Example: gap among most detailed age groups between '5-9' and '15-19'"
  )
  ans <- valid_tree_row(c("0-4", "5-9", "0-14", "0+"))
  expect_identical(
    ans$comment,
    "Example: most detailed age groups do not reach upper limit of '0+'"
  )
})

test_that("valid_tree ignores totals, but adds hint when it fails", {
  expect_true(diagnostic_ok(age_df_diagnose_values(data.frame(age = c(census_tree, "Total")), age = "age", valid_tree = TRUE)))
  ans <- valid_tree_row(c("0-4", "5-9", "0-14", "Total"))
  expect_identical(
    ans$comment,
    paste("Example: most detailed age groups do not reach upper limit of '0-14'.",
          "If a total means age not stated, recode it to 'Missing'")
  )
})

test_that("valid_tree works with levels, including unused levels", {
  x <- factor("0-4", levels = c("0-4", "5-9", "0-14"))
  expect_false(diagnostic_ok(age_diagnose_levels(x, valid_tree = TRUE)))
  expect_true(diagnostic_ok(age_df_diagnose_values(data.frame(age = x), age = "age", valid_tree = TRUE)))
})

test_that("valid_tree combines with other conditions", {
  ans <- age_df_diagnose_values(data.frame(age = census_tree), age = "age",
                             valid_tree = TRUE,
                             has_zero = TRUE,
                             has_open_right = TRUE,
                             no_total = TRUE)
  expect_true(diagnostic_ok(ans))
  expect_identical(
    diagnostic_details(ans)$condition,
    c("no_total", "has_open_right", "has_zero", "valid_tree")
  )
})

test_that("age_df_assert_values() with valid_tree returns labels or throws error", {
  expect_identical(age_df_assert_values(data.frame(age = census_tree), age = "age", valid_tree = TRUE), data.frame(age = census_tree))
  x <- factor(census_tree)
  expect_identical(age_assert_levels(x, valid_tree = TRUE), x)
  expect_snapshot(
    age_df_assert_values(data.frame(age = c("0-4", "5-9", "0-14")), age = "age", valid_tree = TRUE),
    error = TRUE
  )
})

test_that("valid_tree works for periods, including open left", {
  x <- c("2015-2019", "2010-2014", "<2000", "2000-2009", "<2010", "Missing")
  expect_true(
    diagnostic_ok(period_df_diagnose_values(data.frame(period = x), period = "period", valid_tree = TRUE, interpret_multi = "below_upper"))
  )
  expect_identical(
    period_df_assert_values(data.frame(period = x), period = "period", valid_tree = TRUE, interpret_multi = "below_upper"),
    data.frame(period = x)
  )
  x_gap <- c("2015-2019", "<2000", "2000-2009", "<2010")
  ans <- diagnostic_details(period_df_diagnose_values(data.frame(period = x_gap), period = "period", valid_tree = TRUE,
                                interpret_multi = "below_upper"))
  expect_identical(
    ans$comment,
    "Example: gap among most detailed periods between '2000-2009' and '2015-2019'"
  )
})

test_that("valid_tree works for cohorts, including open left", {
  x <- c("<1950", "1950-1959", "1960+", "<1960")
  expect_true(
    diagnostic_ok(cohort_df_diagnose_values(data.frame(cohort = x), cohort = "cohort", valid_tree = TRUE, interpret_multi = "below_upper"))
  )
  x_gap <- c("<1950", "1955-1959", "1960+", "<1960")
  ans <- diagnostic_details(cohort_df_diagnose_values(data.frame(cohort = x_gap), cohort = "cohort", valid_tree = TRUE,
                                interpret_multi = "below_upper"))
  expect_identical(
    ans$comment,
    "Example: gap among most detailed cohorts between '<1950' and '1955-1959'"
  )
  expect_identical(
    cohort_assert_levels(factor(x), valid_tree = TRUE, interpret_multi = "below_upper"),
    factor(x)
  )
})


## 'x_arg' and 'call' in assert functions -------------------------------------

test_that("assert functions name themselves by default", {
  age <- c("0-4", "5-9", "0-14")
  err <- expect_error(age_df_assert_values(data.frame(age = age), age = "age", valid_tree = TRUE))
  expect_identical(err$call[[1L]], quote(age_df_assert_values))
  expect_match(conditionMessage(err), "fail check")
})

test_that("assert functions use 'x_arg' and 'call' supplied by calling function", {
  foo <- function(data) {
    age_df_assert_values(data, age = "age", valid_tree = TRUE,
                      data_arg = "data", call = rlang::current_env())
  }
  err <- expect_error(foo(data.frame(age = c("0-4", "5-9", "0-14"))))
  expect_identical(err$call, quote(foo(data.frame(age = c("0-4", "5-9", "0-14")))))
  expect_match(conditionMessage(err), "fail check")
})

test_that("assert functions apply 'call' to errors raised while parsing labels", {
  foo <- function(x) age_df_assert_values(data.frame(age = x), age = "age", valid_tree = TRUE, call = rlang::current_env())
  err <- expect_error(foo(c("0-4", "foo")), "Don't know how to interpret")
  expect_identical(err$call, quote(foo(c("0-4", "foo"))))
  bar <- function(x) {
    age_assert_levels(x, valid_tree = TRUE, x_arg = "age", call = rlang::current_env())
  }
  err <- expect_error(bar("0-4"), "`age` is not a factor")
  expect_identical(err$call, quote(bar("0-4")))
})

test_that("period and cohort assert functions use 'x_arg' and 'call'", {
  foo <- function(x) {
    period_df_assert_values(data.frame(period = x), period = "period", no_total = TRUE, data_arg = "data",
                         call = rlang::current_env())
  }
  err <- expect_error(foo(c("2020", "Total")), "Period labels in `data$period`", fixed = TRUE)
  expect_identical(err$call, quote(foo(c("2020", "Total"))))
  bar <- function(x) {
    cohort_assert_levels(x, no_total = TRUE, x_arg = "cohort",
                         call = rlang::current_env())
  }
  err <- expect_error(bar(factor(c("2020", "Total"))), "Cohort labels in `cohort`")
  expect_identical(err$call, quote(bar(factor(c("2020", "Total")))))
})
