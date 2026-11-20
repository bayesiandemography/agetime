# Convenience for domain-parametrized regressions on observed labels.
diagnose_observations <- function(domain) {
  force(domain)
  fn <- get(paste0(domain, "_df_diagnose_values"))
  function(labels, ...) {
    data <- setNames(data.frame(labels), domain)
    do.call(fn, c(list(data), setNames(list(domain), domain), list(...)))
  }
}

for (domain in c("age", "period", "cohort")) {
  detail <- if (domain == "age") c("0-4", "5-9") else c("2020-2025", "2025-2030")
  subtotal <- if (domain == "age") "0-9" else "2020-2030"

  for (on in c("values", "levels")) {
    diagnose_fn <- get(paste0(domain, if (on == "values") "_df_diagnose_values" else "_diagnose_levels"))
    assert_fn <- get(paste0(domain, if (on == "values") "_df_assert_values" else "_assert_levels"))
    column <- if (on == "values") setNames(list(domain), domain) else list()
    diagnose <- function(x, ...) do.call(diagnose_fn, c(list(x), column, list(...)))
    assert <- function(x, ...) do.call(assert_fn, c(list(x), column, list(...)))
    as_input <- if (on == "levels") factor else function(x) setNames(data.frame(x), domain)
    present <- as_input(c(detail, subtotal, "Total", "Missing"))
    absent <- as_input(detail)

    test_that(paste(domain, on, "support all four new checks"), {
      for (condition in c("no_subtotal", "has_subtotal", "has_total", "has_missing")) {
        pass <- if (condition == "no_subtotal") absent else present
        fail <- if (condition == "no_subtotal") present else absent
        args <- setNames(list(TRUE), condition)
        val <- do.call(diagnose, c(list(pass), args))
        expect_true(diagnostic_ok(val))
        expect_identical(diagnostic_details(val)$condition, condition)
        expect_identical(diagnostic_details(val)$comment, NA_character_)
        expect_identical(withVisible(do.call(assert, c(list(pass), args))),
                         list(value = pass, visible = FALSE))
        val <- do.call(diagnose, c(list(fail), args))
        expect_false(diagnostic_ok(val))
        expect_identical(diagnostic_details(val)$passed, FALSE)
        expect_match(diagnostic_details(val)$comment, paste("among", on))
        expect_error(do.call(assert, c(list(fail), args)), condition)
      }
    })

    test_that(paste(domain, on, "check absence and presence on empty input"), {
      empty <- as_input(character(0))
      expect_true(diagnostic_ok(diagnose(empty, no_subtotal = TRUE)))
      expect_identical(assert(empty, no_subtotal = TRUE), empty)
      for (condition in c("has_total", "has_subtotal", "has_missing")) {
        args <- setNames(list(TRUE), condition)
        expect_false(diagnostic_ok(do.call(diagnose, c(list(empty), args))))
        expect_error(do.call(assert, c(list(empty), args)), condition)
      }
    })

    test_that(paste(domain, on, "report each requested condition independently"), {
      val <- diagnose(present, no_subtotal = TRUE, has_subtotal = TRUE,
                      has_total = TRUE, has_missing = TRUE)
      expect_false(diagnostic_ok(val))
      expect_identical(diagnostic_details(val)$condition,
                       c("no_subtotal", "has_total", "has_subtotal", "has_missing"))
      expect_identical(diagnostic_details(val)$passed, c(FALSE, TRUE, TRUE, TRUE))
      expect_match(diagnostic_details(val)$comment[[1L]], subtotal, fixed = TRUE)
      expect_identical(nrow(diagnostic_details(diagnose(present))), 0L)
    })
  }

  test_that(paste(domain, "presence checks distinguish unused levels from values"), {
    diagnose_values <- diagnose_observations(domain)
    diagnose_levels <- get(paste0(domain, "_diagnose_levels"))
    fac <- factor(detail, levels = c(detail, subtotal, "Total", "Missing"))
    expect_true(diagnostic_ok(diagnose_values(fac, no_subtotal = TRUE)))
    expect_false(diagnostic_ok(diagnose_levels(fac, no_subtotal = TRUE)))
    for (condition in c("has_total", "has_subtotal", "has_missing")) {
      args <- setNames(list(TRUE), condition)
      expect_false(diagnostic_ok(do.call(diagnose_values, c(list(fac), args))))
      expect_true(diagnostic_ok(do.call(diagnose_levels, c(list(fac), args))))
    }
    # An unused component can complete the tiling of a used broad interval.
    fac <- factor(c(detail[[1L]], subtotal), levels = c(detail, subtotal))
    expect_false(diagnostic_ok(diagnose_values(fac, has_subtotal = TRUE)))
    expect_true(diagnostic_ok(diagnose_levels(fac, has_subtotal = TRUE)))
    # Actual NA values count for values even though NA is not a factor level.
    fac <- factor(c(detail, NA))
    expect_true(diagnostic_ok(diagnose_values(fac, has_missing = TRUE)))
    expect_false(diagnostic_ok(diagnose_values(fac, no_missing = TRUE)))
    expect_false(diagnostic_ok(diagnose_levels(fac, has_missing = TRUE)))
  })

  test_that(paste(domain, "subtotal checks agree with is_subtotal"), {
    diagnose <- diagnose_observations(domain)
    is_subtotal <- get(paste0(domain, "_is_subtotal"))
    cases <- list(
      c(detail, subtotal),
      c(detail, subtotal, detail, subtotal),
      c(detail[[1L]], subtotal),
      c(detail, "Total", "Missing", NA),
      c(detail, subtotal, "young")
    )
    for (labels in cases) {
      has <- any(is_subtotal(labels, interpret_fail = "silent"))
      expect_identical(diagnostic_ok(diagnose(labels, has_subtotal = TRUE,
                                interpret_fail = "silent")), has)
      expect_identical(diagnostic_ok(diagnose(labels, no_subtotal = TRUE,
                                interpret_fail = "silent")), !has)
    }
    expect_true(diagnostic_ok(diagnose(c(detail, "ALL"), has_total = TRUE)))
    expect_false(diagnostic_ok(diagnose(c(detail, subtotal), has_total = TRUE)))
    expect_true(diagnostic_ok(diagnose(c(detail, "not stated"), has_missing = TRUE)))
    expect_true(diagnostic_ok(diagnose(c(detail, NA), has_missing = TRUE)))
    expect_warning(diagnose(c(detail, subtotal, "young"), has_subtotal = TRUE,
                            interpret_fail = "warn"), "young")
    expect_error(diagnose(c(detail, "young"), has_subtotal = TRUE), "young")
  })
}

test_that("subtotal checks respect interval interpretation and open intervals", {
  labels <- c("2020-2025", "2025-2030", "2020-2030")
  for (domain in c("period", "cohort")) {
    diagnose <- diagnose_observations(domain)
    expect_true(diagnostic_ok(diagnose(labels, has_subtotal = TRUE, interpret_multi = "at_upper")))
    expect_false(diagnostic_ok(diagnose(labels, has_subtotal = TRUE,
                          interpret_multi = "below_upper")))
    expect_true(diagnostic_ok(diagnose(c("<2020", "2020-2025", "<2025"),
                         has_subtotal = TRUE, interpret_multi = "at_upper")))
  }
  expect_true(diagnostic_ok(age_df_diagnose_values(data.frame(age = c("90+", "90-94", "95+")), age = "age",
                                  has_subtotal = TRUE)))
  expect_false(diagnostic_ok(age_df_diagnose_values(data.frame(age = c("0-4", "3-7")), age = "age", has_subtotal = TRUE)))
  expect_true(diagnostic_ok(age_df_diagnose_values(data.frame(age = c("0-4", "3-7")), age = "age", no_subtotal = TRUE)))
})

test_that("new checks preserve caller and argument names in assertion errors", {
  check_age <- function(x) {
    age_df_assert_values(data.frame(age = x), age = "age", no_subtotal = TRUE, data_arg = "data",
                      call = rlang::current_env())
  }
  err <- expect_error(check_age(c("0-4", "5-9", "0-9")), "data\\$age")
  expect_identical(err$call[[1L]], quote(check_age))
  expect_match(conditionMessage(err), "no_subtotal")
})
