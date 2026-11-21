test_that("valid_life accepts full abridged classifications", {
  classifications <- list(
    c("0", "1-4", "5-9", "10+"),
    c("10+", "1-4", "0", "5-9"),
    c("0", "1-4", "5-14", "15+"),
    age_labels_life()
  )
  for (age in classifications) {
    data <- data.frame(age = age)
    fac <- factor(age)
    expect_true(diagnostic_ok(age_diagnose_levels(fac, valid_life = TRUE)))
    expect_identical(age_assert_levels(fac, valid_life = TRUE), fac)
    report <- age_df_diagnose_values(data, age, valid_life = TRUE)
    expect_identical(report$condition, "valid_life")
    expect_identical(report$passed, TRUE)
    expect_identical(report$comment, NA_character_)
    expect_identical(age_df_assert_values(data, age, valid_life = TRUE), data)
  }
})

test_that("valid_life rejects incomplete and overlapping classifications", {
  cases <- list(
    list(age = c("0", "1-4", "10+"), comment = "gap"),
    list(age = c("1-4", "5-9", "10+"), comment = "Lowest interval"),
    list(age = c("0", "1-4", "5-9"), comment = "Highest interval"),
    list(age = c("0", "1-4", "5-14", "10+"), comment = "overlap"),
    list(age = c("0", "1-4", "5-9", "10+", "infant"), comment = "same interval"),
    list(age = c("0-4", "5+"), comment = "Not valid for life table")
  )
  for (case in cases) {
    data <- data.frame(age = case$age)
    fac <- factor(case$age)
    levels <- diagnostic_details(age_diagnose_levels(fac, valid_life = TRUE))
    values <- age_df_diagnose_values(data, age, valid_life = TRUE)
    for (report in list(levels, values)) {
      expect_identical(report$condition, "valid_life")
      expect_identical(report$passed, FALSE)
      expect_match(report$comment, case$comment)
    }
    expect_error(age_assert_levels(fac, valid_life = TRUE), "valid_life")
    expect_error(age_df_assert_values(data, age, valid_life = TRUE), "valid_life")
  }
})

test_that("valid_life uses observed groups and declared factor levels appropriately", {
  age <- c("0", "1-4", "5-9", "10+")
  fac <- factor(age[-2L], levels = age)
  expect_true(diagnostic_ok(age_diagnose_levels(fac, valid_life = TRUE)))
  expect_false(age_df_diagnose_values(data.frame(age = fac), age,
                                     valid_life = TRUE)$passed)

  data <- data.frame(country = rep(c("A", "B"), each = 4), age = rep(age, 2))
  expect_identical(age_df_assert_values(data, age, by = country,
                                        valid_life = TRUE), data)
  expect_error(age_df_assert_values(data, age, valid_life = TRUE), "appears 2 times")
  grouped <- dplyr::group_by(data, country)
  expect_identical(age_df_assert_values(grouped, age, valid_life = TRUE), grouped)

  data <- data[-6L, ] # country B lacks ages 1-4
  report <- age_df_diagnose_values(data, age, by = country, valid_life = TRUE)
  expect_identical(report$country, c("A", "B"))
  expect_identical(report$passed, c(TRUE, FALSE))
  expect_match(report$comment[[2L]], "gap")
  expect_error(age_df_assert_values(data, age, by = country,
                                    valid_life = TRUE), "valid_life")
})

test_that("valid_life ignores totals and missing labels but needs age intervals", {
  age <- c("0", "1-4", "5-9", "10+", "Total", "Missing", NA)
  expect_true(diagnostic_ok(age_diagnose_levels(factor(age), valid_life = TRUE)))
  report <- age_df_diagnose_values(data.frame(age = age), age,
    valid_life = TRUE, no_total = TRUE, no_missing = TRUE)
  expect_identical(report$condition, c("no_total", "no_missing", "valid_life"))
  expect_identical(report$passed, c(FALSE, FALSE, TRUE))

  for (age in list(character(), c("Total", "Missing", NA))) {
    fac <- factor(age)
    data <- data.frame(age = age)
    expect_false(diagnostic_ok(age_diagnose_levels(fac, valid_life = TRUE)))
    expect_false(age_df_diagnose_values(data, age, valid_life = TRUE)$passed)
    expect_error(age_assert_levels(fac, valid_life = TRUE), "valid_life")
    expect_error(age_df_assert_values(data, age, valid_life = TRUE), "valid_life")
  }

  empty <- data.frame(age = character(), country = character())
  report <- age_df_diagnose_values(empty, age, by = country, valid_life = TRUE)
  expect_identical(nrow(report), 0L)
  expect_identical(age_df_assert_values(empty, age, by = country,
                                        valid_life = TRUE), empty)
})
