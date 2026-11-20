for (domain in c("age", "period", "cohort")) {
  detail <- if (domain == "age") c("0-4", "5-9") else c("2020-2025", "2025-2030")
  subtotal <- if (domain == "age") "0-9" else "2020-2030"

  for (on in c("values", "levels")) {
    diagnose <- get(paste0(domain, "_diagnose_", on))
    assert <- get(paste0(domain, "_assert_", on))
    as_input <- if (on == "levels") factor else identity
    present <- as_input(c(detail, subtotal, "Total", "Missing"))
    absent <- as_input(detail)

    test_that(paste(domain, on, "support all four new checks"), {
      for (condition in c("no_subtotal", "has_subtotal", "has_total", "has_missing")) {
        pass <- if (condition == "no_subtotal") absent else present
        fail <- if (condition == "no_subtotal") present else absent
        args <- setNames(list(TRUE), condition)
        val <- do.call(diagnose, c(list(pass), args))
        expect_true(val$ok)
        expect_identical(val$details$condition, condition)
        expect_identical(val$details$comment, NA_character_)
        expect_identical(withVisible(do.call(assert, c(list(pass), args))),
                         list(value = pass, visible = FALSE))
        val <- do.call(diagnose, c(list(fail), args))
        expect_false(val$ok)
        expect_identical(val$details$passed, FALSE)
        expect_match(val$details$comment, paste("among", on))
        expect_error(do.call(assert, c(list(fail), args)), condition)
      }
    })

    test_that(paste(domain, on, "check absence and presence on empty input"), {
      empty <- as_input(character(0))
      expect_true(diagnose(empty, no_subtotal = TRUE)$ok)
      expect_identical(assert(empty, no_subtotal = TRUE), empty)
      for (condition in c("has_total", "has_subtotal", "has_missing")) {
        args <- setNames(list(TRUE), condition)
        expect_false(do.call(diagnose, c(list(empty), args))$ok)
        expect_error(do.call(assert, c(list(empty), args)), condition)
      }
    })

    test_that(paste(domain, on, "report each requested condition independently"), {
      val <- diagnose(present, no_subtotal = TRUE, has_subtotal = TRUE,
                      has_total = TRUE, has_missing = TRUE)
      expect_false(val$ok)
      expect_identical(val$details$condition,
                       c("no_subtotal", "has_total", "has_subtotal", "has_missing"))
      expect_identical(val$details$passed, c(FALSE, TRUE, TRUE, TRUE))
      expect_match(val$details$comment[[1L]], subtotal, fixed = TRUE)
      expect_identical(nrow(diagnose(present)$details), 0L)
    })
  }

  test_that(paste(domain, "presence checks distinguish unused levels from values"), {
    diagnose_values <- get(paste0(domain, "_diagnose_values"))
    diagnose_levels <- get(paste0(domain, "_diagnose_levels"))
    fac <- factor(detail, levels = c(detail, subtotal, "Total", "Missing"))
    expect_true(diagnose_values(fac, no_subtotal = TRUE)$ok)
    expect_false(diagnose_levels(fac, no_subtotal = TRUE)$ok)
    for (condition in c("has_total", "has_subtotal", "has_missing")) {
      args <- setNames(list(TRUE), condition)
      expect_false(do.call(diagnose_values, c(list(fac), args))$ok)
      expect_true(do.call(diagnose_levels, c(list(fac), args))$ok)
    }
    # An unused component can complete the tiling of a used broad interval.
    fac <- factor(c(detail[[1L]], subtotal), levels = c(detail, subtotal))
    expect_false(diagnose_values(fac, has_subtotal = TRUE)$ok)
    expect_true(diagnose_levels(fac, has_subtotal = TRUE)$ok)
    # Actual NA values count for values even though NA is not a factor level.
    fac <- factor(c(detail, NA))
    expect_true(diagnose_values(fac, has_missing = TRUE)$ok)
    expect_false(diagnose_values(fac, no_missing = TRUE)$ok)
    expect_false(diagnose_levels(fac, has_missing = TRUE)$ok)
  })

  test_that(paste(domain, "subtotal checks agree with is_subtotal"), {
    diagnose <- get(paste0(domain, "_diagnose_values"))
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
      expect_identical(diagnose(labels, has_subtotal = TRUE,
                                interpret_fail = "silent")$ok, has)
      expect_identical(diagnose(labels, no_subtotal = TRUE,
                                interpret_fail = "silent")$ok, !has)
    }
    expect_true(diagnose(c(detail, "ALL"), has_total = TRUE)$ok)
    expect_false(diagnose(c(detail, subtotal), has_total = TRUE)$ok)
    expect_true(diagnose(c(detail, "not stated"), has_missing = TRUE)$ok)
    expect_true(diagnose(c(detail, NA), has_missing = TRUE)$ok)
    expect_warning(diagnose(c(detail, subtotal, "young"), has_subtotal = TRUE,
                            interpret_fail = "warn"), "young")
    expect_error(diagnose(c(detail, "young"), has_subtotal = TRUE), "young")
  })
}

test_that("subtotal checks respect interval interpretation and open intervals", {
  labels <- c("2020-2025", "2025-2030", "2020-2030")
  for (domain in c("period", "cohort")) {
    diagnose <- get(paste0(domain, "_diagnose_values"))
    expect_true(diagnose(labels, has_subtotal = TRUE, interpret_multi = "at_upper")$ok)
    expect_false(diagnose(labels, has_subtotal = TRUE,
                          interpret_multi = "below_upper")$ok)
    expect_true(diagnose(c("<2020", "2020-2025", "<2025"),
                         has_subtotal = TRUE, interpret_multi = "at_upper")$ok)
  }
  expect_true(age_diagnose_values(c("90+", "90-94", "95+"),
                                  has_subtotal = TRUE)$ok)
  expect_false(age_diagnose_values(c("0-4", "3-7"), has_subtotal = TRUE)$ok)
  expect_true(age_diagnose_values(c("0-4", "3-7"), no_subtotal = TRUE)$ok)
})

test_that("new checks preserve caller and argument names in assertion errors", {
  check_age <- function(x) {
    age_assert_values(x, no_subtotal = TRUE, x_arg = "data$age",
                      call = rlang::current_env())
  }
  err <- expect_error(check_age(c("0-4", "5-9", "0-9")), "data\\$age")
  expect_identical(err$call[[1L]], quote(check_age))
  expect_match(conditionMessage(err), "no_subtotal")
})
