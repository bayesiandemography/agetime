test_that("all six values functions accept bare columns and combined groups", {
  for (domain in c("age", "period", "cohort")) {
    labels <- if (domain == "age") c("0-4", "5-9") else c("2020-2025", "2025-2030")
    data <- data.frame(country = rep(c("A", "B"), each = 2),
                       year = 2020L, classification = rep(labels, 2))
    for (operation in c("diagnose", "assert")) {
      fn <- get(paste0(domain, "_df_", operation, "_values"))
      bare <- rlang::expr((!!fn)(!!data, classification,
        by = c(country, year), no_overlap = TRUE, no_gap = TRUE))
      quoted <- do.call(fn, c(list(data), setNames(list("classification"), domain),
        list(by = c("country", "year"), no_overlap = TRUE, no_gap = TRUE)))
      expect_identical(rlang::eval_bare(bare), quoted)
      if (operation == "assert") expect_identical(quoted, data)
    }
  }
})

test_that("selection helpers, ranges, positions, and exclusions work", {
  data <- data.frame(country = rep(c("A", "B"), each = 2), year = 2020L,
                     age_group = rep(c("0-4", "5-9"), 2))
  expected <- age_df_diagnose_values(data, age_group,
                                      by = c(country, year), no_overlap = TRUE)
  expect_identical(age_df_diagnose_values(data, starts_with("age"),
    by = country:year, no_overlap = TRUE), expected)
  expect_identical(age_df_diagnose_values(data, last_col(),
    by = -age_group, no_overlap = TRUE), expected)
  expect_identical(age_df_diagnose_values(data, 3,
    by = 1:2, no_overlap = TRUE), expected)
  expect_identical(age_df_diagnose_values(data, age_group,
    by = c(country, country, year), no_overlap = TRUE), expected)
  expect_identical(age_df_diagnose_values(data, age_group,
    by = c(where(is.numeric), country), no_overlap = TRUE), expected[c(2, 1, 3:5)])
  expect_identical(age_df_diagnose_values(data, "age_group",
    by = c("country", "year"), no_overlap = TRUE), expected)
})

test_that("programmatic selection and forwarding preserve caller environments", {
  data <- data.frame(country = rep(c("A", "B"), each = 2),
                     age = rep(c("0-4", "5-9"), 2))
  column <- "age"
  groups <- "country"
  expected <- age_df_diagnose_values(data, age, by = country, no_overlap = TRUE)
  expect_identical(age_df_diagnose_values(data, all_of(column),
    by = all_of(groups), no_overlap = TRUE), expected)
  expect_identical(age_df_diagnose_values(data, all_of(column),
    by = any_of(c(groups, "absent")), no_overlap = TRUE), expected)
  wrapper <- function(data, column, by) {
    if (missing(by)) {
      age_df_diagnose_values(data, {{ column }}, no_overlap = TRUE)
    } else {
      age_df_diagnose_values(data, {{ column }}, by = {{ by }}, no_overlap = TRUE)
    }
  }
  expect_identical(wrapper(data, age, country), expected)
  expect_identical(wrapper(data, all_of(column), all_of(groups)), expected)
  grouped <- dplyr::group_by(data, country)
  expect_identical(wrapper(grouped, age), expected)
  expect_false(wrapper(grouped, age, NULL)$passed)
  expect_false(wrapper(grouped, age, any_of("absent"))$passed)
  # Data columns take precedence over external variables with the same name.
  age <- "country"
  country <- "age"
  expect_identical(wrapper(data, age, country), expected)
})

test_that("selections require one label column and prohibit renaming", {
  data <- data.frame(g = 1L, age = "0-4", other = "5-9")
  expect_error(age_df_diagnose_values(data, starts_with("absent")), "exactly one")
  expect_error(age_df_assert_values(data, c(age, other)), "exactly one")
  expect_error(age_df_assert_values(data, any_of("absent")), "exactly one")
  expect_error(age_df_diagnose_values(data, c(renamed = age)), "rename")
  expect_error(age_df_assert_values(data, age, by = c(renamed = g)), "rename")
  expect_error(age_df_diagnose_values(data, age, by = everything()), "label column")
  expect_error(age_df_diagnose_values(data, all_of("absent")), "absent.*exist")
  expect_error(age_df_diagnose_values(data, age, by = all_of("absent")), "absent.*exist")
})

test_that("selection errors honor wrapper calls and clear temporary context", {
  wrapper <- function(data, column, by = NULL) {
    age_df_assert_values(data, {{ column }}, by = {{ by }},
      data_arg = "observations", call = rlang::current_env())
  }
  data <- data.frame(age = "0-4", g = 1L)
  err <- expect_error(wrapper(data, absent), "absent")
  expect_identical(err$call[[1L]], quote(wrapper))
  expect_false(caller_env$active)
  err <- expect_error(wrapper(data, age, absent), "absent")
  expect_identical(err$call[[1L]], quote(wrapper))
  expect_false(caller_env$active)
  err <- expect_error(wrapper(data, starts_with("nothing")), "exactly one")
  expect_identical(err$call[[1L]], quote(wrapper))
})

test_that("selectors run once per call, rather than once per group", {
  data <- data.frame(g = rep(1:10, each = 2), age = rep(c("0-4", "5-9"), 10))
  selections <- 0L
  choose <- function(name) {
    selections <<- selections + 1L
    name
  }
  result <- age_df_diagnose_values(data, choose("age"), by = choose("g"), no_gap = TRUE)
  expect_true(all(result$passed))
  expect_identical(selections, 2L)
})
