test_that("coarsening checks accept exact aggregation and preserve the source", {
  labels <- c(older = "10+", younger = "0-4", middle = "5-9")
  to <- c("0-9", "10+")
  result <- age_diagnose_coarsen(labels, to)
  expect_true(result$ok)
  expect_true(all(result$details$passed))
  expect_true(all(is.na(result$details$comment)))
  expect_named(result, c("ok", "details"))
  expect_named(result$details, c("condition", "passed", "comment"))
  expect_identical(withVisible(age_assert_coarsen(labels, to)),
                   list(value = labels, visible = FALSE))
  expect_identical(as.character(age_coarsen_to(labels, to)), c("10+", "0-9", "0-9"))
  expect_true(age_diagnose_coarsen(labels, to, include_equals = FALSE)$ok)
  expect_true(age_diagnose_coarsen(c(0, 1, 2), "0-2")$ok)
})

test_that("equality depends on intervals and not spelling or order", {
  labels <- c("5-9 years", "infant", "1-4", "10+")
  to <- c("0", "1-4", "5-9", "10 or older")
  expect_true(age_diagnose_coarsen(labels, to)$ok)
  result <- age_diagnose_coarsen(labels, to, include_equals = FALSE)
  expect_false(result$ok)
  expect_identical(tail(result$details$condition, 1), "not_equal")
  expect_error(age_assert_coarsen(labels, to, include_equals = FALSE),
               "same classification")
  expect_true(age_diagnose_coarsen(c("0", "1-4", "5+"), c("0-4", "5+"),
                                  include_equals = FALSE)$ok)
  expect_true(age_diagnose_coarsen(labels, to, include_equals = 1L)$ok)
  expect_false(age_diagnose_coarsen(labels, to, include_equals = 0L)$ok)
})

test_that("coarsening checks distinguish matched gaps from incomplete targets", {
  expect_true(age_diagnose_coarsen(c("0-4", "5-9", "20+"), c("0-9", "20+"))$ok)
  cases <- list(
    list(labels = c("0-4", "10+"), to = c("0-9", "10+"), gap = "5-9"),
    list(labels = c("1-4", "5-9"), to = "0-9", gap = "0"),
    list(labels = c("0-4", "10-14"), to = "0-14", gap = "5-9"),
    list(labels = c("0-4", "10-14"), to = c("0-4", "5-9", "10-14"), gap = "5-9"),
    list(labels = c("0-4", "5-9"), to = "0+", gap = "10+"),
    list(labels = c("0-4", "5-8"), to = "0-9", gap = "9")
  )
  for (case in cases) {
    result <- age_diagnose_coarsen(case$labels, case$to)
    expect_false(result$ok)
    expect_identical(tail(result$details$condition, 1), "complete")
    expect_match(tail(result$details$comment, 1), case$gap, fixed = TRUE)
    expect_error(age_assert_coarsen(case$labels, case$to), "not fully covered")
  }
})

test_that("boundary crossings and source ages outside the target fail", {
  cases <- list(
    list(labels = c("0-6", "7+"), to = c("0-9", "10+"), bad = "7+"),
    list(labels = c("0-9", "10+"), to = c("0-4", "5+"), bad = "0-9"),
    list(labels = c("0-4", "5-9"), to = "0-4", bad = "5-9"),
    list(labels = "0+", to = "0-99", bad = "0+")
  )
  for (case in cases) {
    result <- age_diagnose_coarsen(case$labels, case$to)
    expect_false(result$ok)
    expect_identical(tail(result$details$condition, 1), "contained")
    expect_match(tail(result$details$comment, 1), case$bad, fixed = TRUE)
    expect_error(age_assert_coarsen(case$labels, case$to), "does not fit wholly")
  }
})

test_that("overlaps, repeats, synonyms, and subtotals fail on either side", {
  cases <- list(
    c("0-4", "0-4", "5+"),
    c("0-4", "3-7", "8+"),
    c("0", "infant", "1+"),
    c("0-4", "under 5", "5+"),
    c("0-4", "5-9", "0-9", "10+")
  )
  for (labels in cases) {
    result <- age_diagnose_coarsen(labels, "0+")
    expect_false(result$ok)
    expect_identical(result$details$passed[result$details$condition == "labels_no_overlap"], FALSE)
    expect_error(age_assert_coarsen(labels, "0+"), "overlap or repeat")
    result <- age_diagnose_coarsen("0+", labels)
    expect_false(result$ok)
    expect_identical(result$details$passed[result$details$condition == "to_no_overlap"], FALSE)
    expect_error(age_assert_coarsen("0+", labels), "overlap or repeat")
  }
})

test_that("totals and missing values cannot stand in for age intervals", {
  for (label in c("Total", "All", "Missing", "Not stated", NA_character_)) {
    result <- age_diagnose_coarsen(c("0+", label), "0+")
    expect_false(result$ok)
    expect_false(result$details$passed[result$details$condition == "labels_intervals"])
    expect_error(age_assert_coarsen(c("0+", label), "0+"), "not an age interval")
    expect_false(age_diagnose_coarsen("0+", c("0+", label))$ok)
  }
  result <- age_diagnose_coarsen("Total", "Missing")
  expect_identical(result$details$passed, c(FALSE, FALSE))
})

test_that("factors are checked on values, including actual missing values", {
  labels <- ordered(c("0-4", "5-9", "10+"),
                    levels = c("0-4", "5-9", "10+", "young", "Total"))
  to <- factor(c("0-9", "10+"), levels = c("0-9", "10+", "0+", "young"))
  expect_true(age_diagnose_coarsen(labels, to)$ok)
  expect_identical(age_assert_coarsen(labels, to), labels)
  expect_false(age_diagnose_coarsen(factor("0-4", levels = c("0-4", "5-9")), "0-9")$ok)
  expect_true(age_diagnose_coarsen("0-4", factor("0-4", levels = c("0-4", "5-9")))$ok)
  expect_false(age_diagnose_coarsen(factor(c("0+", NA)), "0+")$ok)
  expect_false(age_diagnose_coarsen("0+", factor(c("0+", NA)))$ok)
})

test_that("empty input follows equality and coverage rules", {
  expect_true(age_diagnose_coarsen(character(), character())$ok)
  expect_identical(age_assert_coarsen(character(), character()), character())
  expect_false(age_diagnose_coarsen(character(), character(), include_equals = FALSE)$ok)
  expect_false(age_diagnose_coarsen(character(), "0+")$ok)
  expect_false(age_diagnose_coarsen("0+", character())$ok)
  expect_true(age_diagnose_coarsen(factor(levels = "0+"), factor())$ok)
})

test_that("parse failures and invalid arguments use the public caller", {
  expect_error(age_diagnose_coarsen("young", "0+"), "Can't interpret labels in `\"young\"`")
  expect_error(age_diagnose_coarsen("0+", "young"), "Can't interpret labels in `\"young\"`")
  expect_false(age_diagnose_coarsen("young", "0+", interpret_fail = "silent")$ok)
  expect_warning(result <- age_diagnose_coarsen("0+", "young", interpret_fail = "warn"), "young")
  expect_false(result$ok)
  for (flag in list(NA, NULL, c(TRUE, FALSE), 2)) {
    expect_error(age_diagnose_coarsen("0+", "0+", include_equals = flag), "include_equals")
  }
  expect_error(age_assert_coarsen(list("0+"), "0+"), "is a list")
  expect_error(age_assert_coarsen("0+", data.frame(age = "0+")), "is a data frame")
  f <- function(x, target) {
    age_assert_coarsen(x, target, x_arg = "data$age", to_arg = "target$age",
                        call = rlang::current_env())
  }
  err <- expect_error(f("0-4", "0-9"), "data\\$age")
  expect_match(conditionMessage(err), "target$age", fixed = TRUE)
  expect_match(conditionMessage(err), "5-9", fixed = TRUE)
  expect_identical(err$call[[1L]], quote(f))
  err <- expect_error(f("0+", "young"), "target\\$age")
  expect_identical(err$call[[1L]], quote(f))
  err <- expect_error(f("young", "0+"), "data\\$age")
  expect_identical(err$call[[1L]], quote(f))
  expect_false(caller_env$active)
})

test_that("coarsening assertions work inside grouped aggregation", {
  skip_if_not_installed("dplyr")
  df <- data.frame(sex = rep(c("Female", "Male"), each = 3),
                   age = rep(c("0-4", "5-9", "10+"), 2),
                   deaths = 1:6)
  target <- c("0-9", "10+")
  checked <- dplyr::mutate(df, age = age_assert_coarsen(age, target), .by = sex)
  expect_identical(checked, df)
  result <- checked |>
    dplyr::mutate(age = age_coarsen_to(age, target), .by = sex) |>
    dplyr::summarise(deaths = sum(deaths), .by = c(sex, age))
  expect_identical(result$deaths, c(3L, 3L, 9L, 6L))
  expect_error(dplyr::mutate(df[-2L, ], age = age_assert_coarsen(age, target), .by = sex),
               "not fully covered")
})
