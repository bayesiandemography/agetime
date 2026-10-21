test_that("default interpret_multi gives a message for ranges of width 4, 9, 14, ...", {
  expect_snapshot(ans <- cohort_width(c("1990-1994", "1995-1999")))
  expect_identical(ans, c(4, 4))
  expect_message(period_lower("2010-2019"), "\\[2010, 2020\\)")
})

test_that("default interpret_multi gives no message for other widths", {
  expect_no_message(period_width(c("2015-2020", "2020-2030", "2031", "2040+")))
  expect_no_message(cohort_standard(c("<1990", "Total", NA)))
})

test_that("supplying interpret_multi silences the message", {
  x <- c("1990-1994", "1995-1999")
  expect_no_message(ans_at <- cohort_width(x, interpret_multi = "at_upper"))
  expect_identical(ans_at, c(4, 4))
  expect_no_message(ans_below <- cohort_width(x, interpret_multi = "below_upper"))
  expect_identical(ans_below, c(5, 5))
})

test_that("message quotes the label as supplied", {
  expect_message(period_lower("2020 to 2024"), "2020 to 2024")
})

test_that("message checks unused factor levels", {
  x <- factor("2000-2005", levels = c("2000-2005", "2005-2009"))
  expect_message(period_standard(x), "2005-2009")
})

test_that("message checks the second set of labels, and appears once", {
  msgs <- character()
  withCallingHandlers(
    period_coarsen_to(c("2020-2024", "2025-2029"), to = "2020-2029"),
    message = function(m) {
      msgs <<- c(msgs, conditionMessage(m))
      invokeRestart("muffleMessage")
    }
  )
  expect_length(msgs, 1L)
  expect_message(period_coarsen_to("2021", to = "2020-2024"), "2020-2024")
  expect_message(cohort_mapping("2000", "2000-2009"), "2000-2009")
})

test_that("invalid values of interpret_multi give an error", {
  expect_error(period_lower("2020", interpret_multi = "include"))
  expect_identical(
    agetime:::resolve_interpret_multi(
      interpret_multi = "below",
      labels = "2020",
      labels_other = NULL,
      label_type = "period",
      interpret_single = "lower"
    ),
    "below_upper"
  )
})

test_that("unparsable labels are left for the main parse to report", {
  expect_error(
    suppressMessages(period_lower(c("2020-2024", "long ago"))),
    "Don't know how to interpret"
  )
})
