test_that("the values API replaces vector exports and has matching pairs", {
  exports <- getNamespaceExports("agetime")
  for (domain in c("age", "period", "cohort")) {
    diagnose <- paste0(domain, "_df_diagnose_values")
    assert <- paste0(domain, "_df_assert_values")
    expect_true(all(c(diagnose, assert) %in% exports))
    expect_false(any(paste0(domain, c("_diagnose_values", "_assert_values")) %in% exports))
    expect_identical(formals(get(diagnose)), formals(get(assert)))
  }
})

test_that("reports are flat, complete, ordered, and retain grouping key types", {
  data <- data.frame(
    group = factor(c("B", "A", "B", "A", NA, NA), levels = c("A", "B", "C")),
    year = as.Date("2020-01-01") + c(0, 1, 0, 1, 2, 2),
    age = c("0-4", "0-4", "10-14", "5-9", "0-4", "5-9")
  )
  report <- age_df_diagnose_values(data, "age", by = c("group", "year"),
                                    no_overlap = TRUE, no_gap = TRUE)
  expect_s3_class(report, "tbl_df")
  expect_false(inherits(report, "grouped_df"))
  expect_named(report, c("group", "year", "condition", "passed", "comment"))
  expect_identical(report$group, data$group[c(1, 1, 2, 2, 5, 5)])
  expect_identical(report$year, data$year[c(1, 1, 2, 2, 5, 5)])
  expect_identical(report$condition, rep(c("no_overlap", "no_gap"), 3))
  expect_identical(report$passed, c(TRUE, FALSE, TRUE, TRUE, TRUE, TRUE))
  expect_true(all(is.na(report$comment[report$passed])))
})

test_that("omitted by infers groups and explicit by overrides them", {
  data <- data.frame(country = c("B", "B", "A", "A"),
                     year = c(2020L, 2020L, 2021L, 2021L),
                     age = rep(c("0-4", "5-9"), 2))
  grouped <- dplyr::group_by(data, country)
  inferred <- age_df_diagnose_values(grouped, "age", no_overlap = TRUE)
  expect_identical(inferred,
    age_df_diagnose_values(data, "age", by = "country", no_overlap = TRUE))
  replaced <- age_df_diagnose_values(grouped, "age", by = "year", no_overlap = TRUE)
  expect_named(replaced, c("year", "condition", "passed", "comment"))
  expect_true(all(replaced$passed))
  whole <- age_df_diagnose_values(grouped, "age", by = NULL, no_overlap = TRUE)
  expect_named(whole, c("condition", "passed", "comment"))
  expect_false(whole$passed)
  expect_identical(whole,
    age_df_diagnose_values(grouped, "age", by = character(), no_overlap = TRUE))
  expect_identical(whole,
    age_df_diagnose_values(data, "age", no_overlap = TRUE))

  wrapper <- function(data, by) {
    if (missing(by)) age_df_diagnose_values(data, "age", no_overlap = TRUE)
    else age_df_diagnose_values(data, "age", by = {{ by }}, no_overlap = TRUE)
  }
  expect_identical(wrapper(grouped), inferred)
  expect_identical(wrapper(grouped, NULL), whole)
})

test_that("assertions preserve complete frames and their grouping", {
  data <- tibble::tibble(country = c("B", "B", "A", "A"),
    age = ordered(rep(c("0-4", "5-9"), 2), levels = c("0-4", "5-9", "Unused")),
    value = list(1, "two", NULL, as.Date("2020-01-01")))
  grouped <- dplyr::group_by(data, country)
  for (x in list(as.data.frame(data), data, grouped)) {
    expect_identical(withVisible(age_df_assert_values(x, "age", by = "country",
                                                       no_overlap = TRUE)),
                     list(value = x, visible = FALSE))
  }
  expect_identical(age_df_assert_values(grouped, "age", by = NULL, no_gap = TRUE),
                   grouped)
})

test_that("rowwise inputs use individual rows, including repeated identifiers", {
  data <- data.frame(id = c("A", "A"), age = c("0-4", "0-4"))
  keyed <- dplyr::rowwise(data, id)
  report <- age_df_diagnose_values(keyed, "age", no_overlap = TRUE)
  expect_identical(report$id, c("A", "A"))
  expect_identical(report$passed, c(TRUE, TRUE))
  expect_identical(age_df_assert_values(keyed, "age", no_overlap = TRUE), keyed)
  expect_false(age_df_diagnose_values(keyed, "age", by = "id", no_overlap = TRUE)$passed)
  unkeyed <- dplyr::rowwise(data)
  report <- age_df_diagnose_values(unkeyed, "age", no_overlap = TRUE)
  expect_named(report, c("condition", "passed", "comment"))
  expect_identical(report$passed, c(TRUE, TRUE))
  expect_error(age_df_assert_values(unkeyed, "age", has_total = TRUE), "Input row 1")
})

test_that("empty groups, empty frames, and no checks have defined results", {
  data <- data.frame(g = factor("A", levels = c("A", "B")), age = "0-4")
  grouped <- dplyr::group_by(data, g, .drop = FALSE)
  report <- age_df_diagnose_values(grouped, "age", has_zero = TRUE)
  expect_identical(as.character(report$g), "A")
  expect_true(report$passed)
  empty <- data[FALSE, ]
  report <- age_df_diagnose_values(empty, "age", has_total = TRUE, no_gap = TRUE)
  expect_identical(report$passed, c(TRUE, FALSE))
  report <- age_df_diagnose_values(empty, "age", by = "g", has_total = TRUE)
  expect_identical(nrow(report), 0L)
  expect_identical(report$g, empty$g)
  expect_type(report$condition, "character")
  expect_type(report$passed, "logical")
  expect_type(report$comment, "character")
  expect_identical(age_df_assert_values(empty, "age", by = "g", has_total = TRUE), empty)
  expect_identical(nrow(age_df_diagnose_values(dplyr::rowwise(empty), "age",
                                               has_total = TRUE)), 0L)
  expect_identical(nrow(age_df_diagnose_values(grouped, "age")), 0L)
  expect_error(age_df_diagnose_values(data.frame(age = "bad"), "age"), "bad")
})

test_that("data and column selection errors are informative", {
  data <- data.frame(g = 1L, age = "0-4")
  expect_error(age_df_diagnose_values("0-4", "age"), "must be a data frame")
  for (column in list(NULL, character(), c("age", "g"))) {
    expect_error(age_df_diagnose_values(data, !!column), "age.*exactly one")
  }
  expect_error(age_df_diagnose_values(data, c(x = age)), "rename")
  expect_error(age_df_diagnose_values(data, age, by = c(x = g)), "rename")
  expect_error(age_df_diagnose_values(data, NA), "missing values")
  expect_error(age_df_diagnose_values(data, age, by = NA_character_), "missing values")
  expect_error(age_df_diagnose_values(data, "absent"), "absent.*exist")
  expect_error(age_df_diagnose_values(data, "age", by = "absent"), "absent.*exist")
  expect_error(age_df_diagnose_values(data, "age", by = "age"), "label column")
  for (name in c("condition", "passed", "comment")) {
    bad <- data
    names(bad)[1L] <- name
    expect_error(age_df_diagnose_values(bad, "age", by = all_of(name)), "Rename")
    expect_error(age_df_assert_values(dplyr::group_by(bad, .data[[name]]), "age"), "Rename")
  }
  names(data) <- c("age", "age")
  expect_error(age_df_diagnose_values(data, "age"), "unique")
  expect_error(age_df_diagnose_values(data.frame(age = I(list("0-4"))), "age"), "list")
})

test_that("cache keys preserve occurrences, spelling, order, and missing values", {
  inputs <- list(c("0-4", "5-9"), c("0-4", "5-9", "5-9"),
    c("0-4", "5-9", "0-9"), c("0-9", "5-9", "0-4"),
    c("Under 5", "5-9", "0-9"), c("0-4", "5-9", NA),
    c("0-4", "5-9", "Missing"), c("0-4", "5-9", "5-9"))
  data <- data.frame(g = rep(seq_along(inputs), lengths(inputs)), age = unlist(inputs))
  report <- age_df_diagnose_values(data, "age", by = "g",
    no_overlap = TRUE, no_missing = TRUE, no_subtotal = TRUE)
  expected <- lapply(inputs, function(age) {
    age_df_diagnose_values(data.frame(age), "age",
      no_overlap = TRUE, no_missing = TRUE, no_subtotal = TRUE)
  })
  expect_identical(report[-1], vctrs::vec_rbind(!!!expected))
  expect_identical(report$g, rep(seq_along(inputs), each = 3L))
})

test_that("parsing and checks are reused within a call for all three domains", {
  original <- inner_diagnose
  calls <- 0L
  testthat::local_mocked_bindings(inner_diagnose = function(...) {
    calls <<- calls + 1L
    original(...)
  })
  for (domain in c("age", "period", "cohort")) {
    labels <- if (domain == "age") c("0-4", "5-9") else c("2020-2025", "2025-2030")
    data <- data.frame(g = rep(1:4, each = 2), labels = rep(labels, 4))
    select <- setNames(list("labels"), domain)
    diagnose <- get(paste0(domain, "_df_diagnose_values"))
    assert <- get(paste0(domain, "_df_assert_values"))
    before <- calls
    report <- do.call(diagnose, c(list(data), select, list(by = "g", no_gap = TRUE)))
    expect_true(all(report$passed))
    expect_identical(calls - before, 1L)
    do.call(assert, c(list(data), select, list(by = "g", no_gap = TRUE)))
    expect_identical(calls - before, 2L) # a separate call has its own cache
    report <- do.call(diagnose, c(list(data), select, list(by = "g", has_total = TRUE)))
    expect_identical(report$passed, rep(FALSE, 4))
    expect_identical(report$g, 1:4)
    expect_identical(calls - before, 3L)
  }
})

test_that("errors and warnings retain each group's context and wrapper call", {
  data <- data.frame(g = rep(c("A", "B"), each = 2), age = c("0-4", "5-9", "0-4", "bad"))
  wrapper <- function(data) age_df_diagnose_values(data, "age", by = "g",
    no_gap = TRUE, data_arg = "observations", call = rlang::current_env())
  err <- expect_error(wrapper(data), "g = B")
  expect_match(conditionMessage(err), "observations$age", fixed = TRUE)
  expect_identical(err$call[[1L]], quote(wrapper))
  expect_false(caller_env$active)
  data$age <- rep(c("0-4", "bad"), 2)
  messages <- character()
  report <- withCallingHandlers(
    age_df_diagnose_values(data, "age", by = "g", no_gap = TRUE, interpret_fail = "warn"),
    warning = function(cnd) {
      messages <<- c(messages, conditionMessage(cnd))
      invokeRestart("muffleWarning")
    }
  )
  expect_length(messages, 2L)
  expect_match(messages[[1L]], "g = A")
  expect_match(messages[[2L]], "g = B")
  expect_true(all(report$passed))
  data$age <- rep(c("0-4", "0-4"), 2)
  err <- expect_error(age_df_assert_values(data, "age", by = "g",
                                           no_overlap = TRUE, has_total = TRUE), "g = A")
  expect_match(conditionMessage(err), "no_overlap")
  expect_match(conditionMessage(err), "has_total")
  expect_match(conditionMessage(err), "age_df_diagnose_values", fixed = TRUE)
})

test_that("time interpretation advice occurs once and ignores unused levels", {
  for (domain in c("period", "cohort")) {
    diagnose <- get(paste0(domain, "_df_diagnose_values"))
    data <- data.frame(g = rep(1:3, each = 2), labels = rep(c("2020-2024", "2025-2029"), 3))
    select <- setNames(list("labels"), domain)
    messages <- character()
    report <- withCallingHandlers(
      do.call(diagnose, c(list(data), select, list(by = "g", no_gap = TRUE))),
      message = function(cnd) {
        messages <<- c(messages, conditionMessage(cnd))
        invokeRestart("muffleMessage")
      }
    )
    expect_length(messages, 1L)
    expect_identical(report$passed, rep(FALSE, 3))
    below <- do.call(diagnose, c(list(data), select,
                                list(by = "g", no_gap = TRUE, interpret_multi = "below_upper")))
    expect_identical(below$passed, rep(TRUE, 3))
    data$labels <- factor(rep("2020", 6), levels = c("2020", "2020-2024"))
    expect_message(do.call(diagnose, c(list(data), select, list(by = "g", no_gap = TRUE))), NA)
    data$labels <- rep(c("2020", "2021"), 3)
    for (single in c("lower", "upper")) {
      report <- do.call(diagnose, c(list(data), select,
        list(by = "g", no_overlap = TRUE, interpret_single = single)))
      expect_true(all(report$passed))
    }
  }
})
