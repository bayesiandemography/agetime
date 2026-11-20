test_that("age data-frame coarsening matches named columns and preserves source rows", {
  x <- data.frame(country = c("A", "B", "A", "B", "A"),
                   year = 2023, sex = "Female",
                   age = c("0-4", "0-4", "5-9", "5-9", "0-4"),
                   deaths = 1:5, note = letters[1:5], row.names = letters[1:5])
  y <- data.frame(code = c("B", "A", "B", "C"), year = 2023, sex = "Female",
                   band = c("0-4", "0-9", "5-9", "young"), popn = 100)
  obtained <- age_df_coarsen_to(x, y, age = c(age = "band"),
                                by = c(country = "code", "year", "sex"))
  expected <- x
  expected$age <- factor(c("0-9", "0-4", "0-9", "5-9", "0-9"),
                         levels = c("0-9", "0-4", "5-9"))
  expect_identical(obtained, expected)
  expect_identical(x$age, c("0-4", "0-4", "5-9", "5-9", "0-4"))
  expect_identical(y$band, c("0-4", "0-9", "5-9", "young"))
})

test_that("by is explicit and NULL uses one whole-data classification", {
  x <- data.frame(age = c("0-4", "5-9"), n = 1:2)
  to <- data.frame(age = "0-9")
  expected <- transform(x, age = factor(c("0-9", "0-9")))
  expect_identical(age_df_coarsen_to(x, to, age = "age", by = NULL), expected)
  expect_identical(age_df_coarsen_to(x, to, age = "age", by = character()), expected)
  expect_error(age_df_coarsen_to(x, to, age = "age"), "by")
  expect_error(age_df_coarsen_to(x, to, by = NULL), "age")
})

test_that("compatible and missing grouping keys match, and source-only groups fail", {
  x <- data.frame(country = factor(c("A", "A", NA, NA)), year = 2023L,
                   age = rep(c("0-4", "5-9"), 2), n = 1:4)
  to <- data.frame(country = c(NA, "A", "B"), year = 2023,
                    age = c("0-9", "0-9", "young"))
  obtained <- age_df_coarsen_to(x, to, age = "age", by = c("country", "year"))
  expect_identical(as.character(obtained$age), rep("0-9", 4))
  expect_identical(obtained$country, x$country)
  expect_error(age_df_coarsen_to(x, to[1, ], age = "age", by = c("country", "year")),
               "country = A")
  expect_error(age_df_coarsen_to(x, to[FALSE, ], age = "age", by = "country"),
               "No target classification")
  expect_error(age_df_coarsen_to(x, transform(to, year = as.character(year)),
                                 age = "age", by = c("country", "year")),
               "combine|convert|cast|incompatible")
})

test_that("factors use observed categories and retain target factor order", {
  x <- data.frame(age = ordered(c("5-9", "0-4"),
                                levels = c("0-4", "5-9", "young", "Total")), n = 1:2)
  to <- data.frame(age = factor(c("5-9", "0-4"),
                                levels = c("0-4", "5-9", "0-9", "young")))
  obtained <- age_df_coarsen_to(x, to, age = "age", by = NULL)
  expect_identical(obtained$age, ordered(c("5-9", "0-4"), levels = c("0-4", "5-9")))
  expect_identical(obtained$n, x$n)
  expect_identical(nrow(age_df_coarsen_to(x[FALSE, ], to, age = "age", by = NULL)), 0L)
  expect_identical(nrow(age_df_coarsen_to(x[FALSE, ], to[FALSE, , drop = FALSE], age = "age", by = NULL)), 0L)
})

test_that("coverage is checked on distinct source intervals", {
  x <- data.frame(age = c("0", "infant", "1-4", "1-4"), n = 1:4)
  to <- data.frame(age = c("0-4", "0-4"))
  obtained <- age_df_coarsen_to(x, to, age = "age", by = NULL)
  expect_identical(as.character(obtained$age), rep("0-4", 4))
  expect_identical(obtained$n, x$n)
  expect_error(age_df_coarsen_to(data.frame(age = c("0-4", "0-4")),
                                 data.frame(age = "0-9"), age = "age", by = NULL), "5-9")
  expect_error(age_df_coarsen_to(x, data.frame(age = c("0-4", "under 5")),
                                 age = "age", by = NULL), "overlap|same interval")
})

test_that("incomplete coverage and crossings report the source group", {
  x <- data.frame(country = c("A", "A"), age = c("0-4", "10-14"))
  y <- data.frame(code = c("A", "A"), band = c("0-9", "10-14"))
  expect_error(age_df_coarsen_to(x, y, age = c(age = "band"), by = c(country = "code")),
               "country = A")
  expect_error(age_df_coarsen_to(x, y, age = c(age = "band"), by = c(country = "code")),
               "5-9")
  expect_error(age_df_coarsen_to(data.frame(age = c("0-6", "7+")),
                                 data.frame(age = c("0-9", "10+")), age = "age", by = NULL),
               "crosses a boundary")
  expect_error(age_df_coarsen_to(data.frame(age = "10+"), data.frame(age = "0-9"),
                                 age = "age", by = NULL), "outside")
  expect_error(age_df_coarsen_to(data.frame(age = "0-4"), data.frame(age = "0+"),
                                 age = "age", by = NULL), "5\\+")
  expect_error(age_df_coarsen_to(data.frame(age = c("0-4", "3-7")), data.frame(age = "0-7"),
                                 age = "age", by = NULL), "overlap")
  expect_true(is.data.frame(age_df_coarsen_to(
    data.frame(age = c("0-4", "5-9", "20+")), data.frame(age = c("0-9", "20+")),
    age = "age", by = NULL)))
})

test_that("non-interval labels fail even with suppressed parse messages", {
  for (bad in c("Total", "Missing", NA_character_)) {
    expect_error(age_df_coarsen_to(data.frame(age = c("0+", bad)), data.frame(age = "0+"),
                                   age = "age", by = NULL), "does not describe an interval")
    expect_error(age_df_coarsen_to(data.frame(age = "0+"), data.frame(age = bad),
                                   age = "age", by = NULL), "does not describe an interval")
  }
  expect_error(age_df_coarsen_to(data.frame(age = "young"), data.frame(age = "0+"),
                                 age = "age", by = NULL), "Can't interpret")
  expect_error(age_df_coarsen_to(data.frame(age = "young"), data.frame(age = "0+"),
                                 age = "age", by = NULL, interpret_fail = "silent"),
               "does not describe an interval")
  expect_warning(expect_error(age_df_coarsen_to(
    data.frame(age = "young"), data.frame(age = "0+"), age = "age", by = NULL,
    interpret_fail = "warn"), "does not describe an interval"), "young")
})

test_that("column mappings and data frames are validated", {
  x <- data.frame(age = "0+", sex = "F", year = 2023)
  for (column in list(NULL, character(), c("age", "sex"), NA_character_, 1, list("age"))) {
    expect_error(age_df_coarsen_to(x, x, age = column, by = NULL), "age")
  }
  expect_error(age_df_coarsen_to(x, x, age = "missing", by = NULL), "Source columns")
  expect_error(age_df_coarsen_to(x, x, age = c(age = "missing"), by = NULL), "Target columns")
  expect_error(age_df_coarsen_to(x, x, age = "age", by = "missing"), "Source columns")
  expect_error(age_df_coarsen_to(x, x, age = "age", by = c(sex = "missing")), "Target columns")
  expect_error(age_df_coarsen_to(x, x, age = "age", by = "age"), "label column")
  expect_error(age_df_coarsen_to(x, x, age = "age", by = c("sex", "sex")), "only once")
  expect_error(age_df_coarsen_to(x, x, age = "age", by = c(sex = "sex", year = "sex")), "only once")
  expect_error(age_df_coarsen_to(x, x, age = "age", by = 1), "by")
  expect_error(age_df_coarsen_to(x, x, age = "age", by = setNames("sex", NA_character_)), "missing")
  expect_error(age_df_coarsen_to(1:3, x, age = "age", by = NULL), "data frame")
  expect_error(age_df_coarsen_to(x, 1:3, age = "age", by = NULL), "data frame")
  duplicated <- x
  names(duplicated)[2] <- "age"
  expect_error(age_df_coarsen_to(duplicated, x, age = "age", by = NULL), "unique")
  bad <- data.frame(age = I(list("0+")))
  expect_error(age_df_coarsen_to(bad, x, age = "age", by = NULL), "is a list")
})

test_that("data_arg, to_arg and call identify frames and columns in errors", {
  f <- function(x, y) {
    age_df_coarsen_to(x, y, age = c(age = "band"), by = NULL,
                       data_arg = "deaths", to_arg = "population",
                       call = rlang::current_env())
  }
  err <- expect_error(f(data.frame(age = "0-4"), data.frame(band = "0-9")), "deaths\\$age")
  expect_identical(err$call[[1L]], quote(f))
  expect_match(conditionMessage(err), "population$band", fixed = TRUE)
  err <- expect_error(f(data.frame(age = "young"), data.frame(band = "0-9")), "deaths\\$age")
  expect_identical(err$call[[1L]], quote(f))
  err <- expect_error(f(data.frame(age = "0-4"), data.frame(band = "young")), "population\\$band")
  expect_identical(err$call[[1L]], quote(f))
  expect_error(f(data.frame(age = "0+"), data.frame(wrong = "0+")), "population")
  bad_keys <- function(x, y) {
    age_df_coarsen_to(x, y, age = "age", by = "year",
                       data_arg = "events", to_arg = "targets",
                       call = rlang::current_env())
  }
  err <- expect_error(bad_keys(data.frame(age = "0+", year = 2023),
                                data.frame(age = "0+", year = "2023")))
  expect_identical(err$call[[1L]], quote(bad_keys))
  expect_false(caller_env$active)
})

test_that("tibbles and grouping metadata survive recoding", {
  skip_if_not_installed("dplyr")
  x <- tibble::tibble(country = "A", age = c("0-4", "5-9"), deaths = 1:2)
  to <- data.frame(age = "0-9")
  obtained <- x |> age_df_coarsen_to(to, age = "age", by = NULL)
  expect_s3_class(obtained, "tbl_df")
  expect_identical(obtained$deaths, x$deaths)
  grouped <- dplyr::group_by(x, country, age)
  obtained <- age_df_coarsen_to(grouped, to, age = "age", by = NULL)
  expect_identical(dplyr::group_vars(obtained), c("country", "age"))
  expect_identical(nrow(dplyr::group_data(obtained)), 1L)
  expect_identical(dplyr::group_data(obtained)$.rows[[1L]], 1:2)
  rowwise <- dplyr::rowwise(x, age)
  obtained <- age_df_coarsen_to(rowwise, to, age = "age", by = NULL)
  expect_s3_class(obtained, "rowwise_df")
  expect_identical(as.character(dplyr::group_data(obtained)$age), c("0-9", "0-9"))
  expect_identical(as.list(dplyr::group_data(obtained)$.rows), list(1L, 2L))
})

test_that("repeated classifications preserve each group's target labels and source rows", {
  x <- data.frame(country = rep(c("A", "B", "C", "D"), each = 3),
                   age = rep(c("0-4", "5-9", "10+"), 4), count = 1:12)
  x$age[10:12] <- rev(x$age[10:12])
  to <- data.frame(country = rep(c("A", "B", "C", "D"), each = 2),
                    age = c("0-9", "10+", "10+", "0-9", "0-9 years", "10 or older", "0-9", "10+"))
  result <- age_df_coarsen_to(x, to, age = "age", by = "country")
  expected <- x
  expected$age <- factor(c("0-9", "0-9", "10+", "0-9", "0-9", "10+",
                            "0-9 years", "0-9 years", "10 or older", "10+", "0-9", "0-9"),
                          levels = c("0-9", "10+", "0-9 years", "10 or older"))
  expect_identical(result, expected)
})

test_that("an earlier valid classification does not hide a later incomplete group", {
  x <- data.frame(country = c("A", "A", "B"), age = c("0-4", "5-9", "0-4"))
  to <- data.frame(country = c("A", "B"), age = "0-9")
  err <- expect_error(age_df_coarsen_to(x, to, age = "age", by = "country"), "5-9")
  expect_match(conditionMessage(err), "country = B", fixed = TRUE)
  x <- data.frame(country = rep(c("A", "B"), each = 2), age = rep(c("0-4", "5-9"), 2))
  to <- data.frame(country = c("A", "B", "B"), age = c("0-9", "0-9", "10-14"))
  err <- expect_error(age_df_coarsen_to(x, to, age = "age", by = "country"), "10-14")
  expect_match(conditionMessage(err), "country = B", fixed = TRUE)
})

test_that("classification reuse is confined to one call", {
  x <- data.frame(country = rep(c("A", "B"), each = 2), age = rep(c("0-4", "5-9"), 2))
  coarse <- data.frame(country = c("A", "B"), age = "0-9")
  expect_identical(as.character(age_df_coarsen_to(x, coarse, age = "age", by = "country")$age),
                     rep("0-9", 4))
  expect_identical(as.character(age_df_coarsen_to(x, x, age = "age", by = "country")$age), x$age)
  x$age <- rep(c("0-3", "4-8"), 2)
  expect_error(age_df_coarsen_to(x, coarse, age = "age", by = "country"), "9")
})
