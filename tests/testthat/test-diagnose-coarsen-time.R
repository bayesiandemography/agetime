for (domain in c("period", "cohort")) {
  diagnose <- get(paste0(domain, "_diagnose_coarsen"))
  assert <- get(paste0(domain, "_assert_coarsen"))
  coarsen <- get(paste0(domain, "_coarsen_to"))
  labels <- c("<2000", "2000-2005", "2005-2010", "2010+")
  target <- c("<2000", "2000-2010", "2010+")

  test_that(paste(domain, "coarsening checks accept exact coverage and preserve inputs"), {
    result <- diagnose(labels, target)
    expect_true(result$ok)
    expect_true(all(result$details$passed))
    expect_true(all(is.na(result$details$comment)))
    expect_identical(withVisible(assert(labels, target)),
                     list(value = labels, visible = FALSE))
    expect_true(diagnose(labels, target, include_equals = FALSE)$ok)
    expect_identical(as.character(coarsen(labels, target)),
                     c("<2000", "2000-2010", "2000-2010", "2010+"))
    expect_true(diagnose(c("2000-2005", "2005-2010", "2020+"),
                         c("2000-2010", "2020+"))$ok)
    expect_true(diagnose(c("before 2000", "2000 to 2010", "2010 or later"),
                         target[c(3, 1, 2)])$ok)
    expect_false(diagnose(target, target, include_equals = FALSE)$ok)
    expect_error(assert(target, target, include_equals = FALSE),
                 paste0("no ", domain, "s would be merged"))
  })

  test_that(paste(domain, "gap messages follow the endpoint conventions"), {
    cases <- list(
      list(labels = "2000-2005", to = "2000-2010", gap = "2005-2010"),
      list(labels = "2000-2005", to = "<2005", gap = "<2000"),
      list(labels = "<2000", to = "<2005", gap = "2000-2005"),
      list(labels = "2000-2005", to = "2000+", gap = "2005+"),
      list(labels = "2000", to = "2000-2002", gap = "2001"),
      list(labels = character(), to = "<2000", gap = "<2000")
    )
    for (case in cases) {
      result <- diagnose(case$labels, case$to)
      expect_false(result$ok)
      expect_identical(tail(result$details$condition, 1), "complete")
      expect_match(tail(result$details$comment, 1), paste0("source ", domain, "s"))
      expect_match(tail(result$details$comment, 1), paste0("'", case$gap, "'"), fixed = TRUE)
      expect_error(assert(case$labels, case$to), "not fully covered")
    }
    result <- diagnose("2001", "2000-2002", interpret_single = "upper")
    expect_false(result$ok)
    expect_match(tail(result$details$comment, 1), "'2002'", fixed = TRUE)
    result <- diagnose("2000-2004", "2000-2009", interpret_multi = "below_upper")
    expect_false(result$ok)
    expect_match(tail(result$details$comment, 1), "'2005-2009'", fixed = TRUE)
  })

  test_that(paste(domain, "coarsening respects lower and upper interpretation rules"), {
    expect_true(diagnose(c(2000, 2001), "2000-2002")$ok)
    expect_true(diagnose(c(2001, 2002), "2000-2002", interpret_single = "upper")$ok)
    expect_false(diagnose(c(2000, 2001), "2000-2002", interpret_single = "upper")$ok)
    expect_true(diagnose(c("2000-2004", "2005-2009"), "2000-2009",
                         interpret_multi = "below_upper")$ok)
    expect_message(result <- diagnose(c("2000-2004", "2005-2009"), "2000-2009"),
                   "Interpreting")
    expect_false(result$ok)
    expect_error(diagnose(labels, target, interpret_single = "bad"), "arg")
    expect_error(diagnose(labels, target, interpret_multi = "bad"), "arg")
    expect_error(diagnose(labels, target, include_equals = NA), "include_equals")
  })

  test_that(paste(domain, "rejects source crossings, overlaps and non-intervals"), {
    expect_false(diagnose(c("2000-2007", "2007+"), c("2000-2010", "2010+"))$ok)
    expect_error(assert(c("2000-2007", "2007+"), c("2000-2010", "2010+")),
                 "does not fit wholly")
    for (bad in list(c("2000-2005", "2000-2005"),
                     c("2000-2005", "2003-2010"),
                     c("2000-2005", "2000 to 2005"))) {
      expect_error(assert(bad, "2000-2010"), "overlap or repeat")
      expect_error(assert("2000-2010", bad), "overlap or repeat")
    }
    for (bad in c("Total", "Missing", NA_character_)) {
      expect_false(diagnose(c("2000+", bad), "2000+")$ok)
      expect_false(diagnose("2000+", c("2000+", bad))$ok)
      expect_error(assert(c("2000+", bad), "2000+"), paste0("not a ", domain, " interval"))
    }
  })

  test_that(paste(domain, "uses only factor values and handles empty inputs"), {
    source_factor <- ordered("2000-2005", levels = c("2000-2005", "1990-1994", "young"))
    target_factor <- factor("2000-2005", levels = c("2000-2005", "1900-1904", "young"))
    expect_silent(result <- diagnose(source_factor, target_factor))
    expect_true(result$ok)
    expect_identical(assert(source_factor, target_factor), source_factor)
    expect_false(diagnose(factor(c("2000+", NA)), "2000+")$ok)
    expect_false(diagnose("2000+", factor(c("2000+", NA)))$ok)
    expect_true(diagnose(character(), character())$ok)
    expect_false(diagnose(character(), character(), include_equals = FALSE)$ok)
    expect_false(diagnose(character(), "2000+")$ok)
    expect_false(diagnose("2000+", character())$ok)
  })

  test_that(paste(domain, "errors use argument names and the calling function"), {
    f <- function(x, y) assert(x, y, x_arg = "data$time", to_arg = "target$time",
                                call = rlang::current_env())
    err <- expect_error(f("2000-2005", "2000-2010"), "data\\$time")
    expect_match(conditionMessage(err), "target$time", fixed = TRUE)
    expect_identical(err$call[[1L]], quote(f))
    err <- expect_error(f("2000+", "young"), "target\\$time")
    expect_identical(err$call[[1L]], quote(f))
    err <- expect_error(f("young", "2000+"), "data\\$time")
    expect_identical(err$call[[1L]], quote(f))
    expect_false(diagnose("young", "2000+", interpret_fail = "silent")$ok)
    expect_warning(result <- diagnose("2000+", "young", interpret_fail = "warn"), "young")
    expect_false(result$ok)
    expect_false(caller_env$active)
  })
}
