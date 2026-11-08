breaks_census <- c(0, 5, 10, 15, seq(20, 70, 10))

test_that("age_labels_tree() creates census tree in tree order", {
  ans <- age_labels_tree(breaks = breaks_census, nodes = c("0-14", "15+"))
  expect_identical(
    ans,
    c("0-4", "5-9", "10-14", "15-19", "20-29", "30-39", "40-49",
      "50-59", "60-69", "70+", "0-14", "15+", "Missing")
  )
})

test_that("age_labels_tree() handles three levels, given in any order", {
  ans <- age_labels_tree(breaks = seq(0, 85, 5),
                         nodes = c("65+", "15-64", "15+", "0-14"))
  expect_identical(
    ans,
    c(age_labels_five(lower_last = 85),
      "0-14", "15-64", "65+", "15+", "Missing")
  )
})

test_that("age_labels_tree() handles leaves at different depths", {
  ans <- age_labels_tree(breaks = c(0, 5, 65, 75), nodes = "65+")
  expect_identical(ans, c("0-4", "5-64", "65-74", "75+", "65+", "Missing"))
})

test_that("age_labels_tree() with no nodes matches age_labels(), plus Missing", {
  expect_identical(
    age_labels_tree(breaks = breaks_census),
    c(age_labels(breaks = breaks_census), "Missing")
  )
  expect_identical(
    age_labels_tree(breaks = breaks_census, nodes = character()),
    c(age_labels(breaks = breaks_census), "Missing")
  )
  expect_identical(
    age_labels_tree(breaks = breaks_census, include_missing = FALSE),
    age_labels(breaks = breaks_census)
  )
})

test_that("age_labels_tree() works with open_right = FALSE", {
  ans <- age_labels_tree(breaks = seq(0, 20, 5), nodes = "0-9",
                         open_right = FALSE)
  expect_identical(ans, c("0-4", "5-9", "10-14", "15-19", "0-9", "Missing"))
})

test_that("age_labels_tree() standardises node labels", {
  ans <- age_labels_tree(breaks = breaks_census,
                         nodes = c("Under 15", "15 and over"))
  expect_identical(ans[11:12], c("0-14", "15+"))
})

test_that("age_labels_tree() output passes valid_tree and keeps tree order", {
  ans <- age_labels_tree(breaks = seq(0, 85, 5),
                         nodes = c("0-14", "15+", "15-64", "65+"))
  expect_identical(
    age_assert_values(ans, valid_tree = TRUE, has_zero = TRUE,
                      has_open_right = TRUE, no_total = TRUE),
    ans
  )
  expect_identical(levels(age_set_order_tree(ans)), ans)
})

test_that("age_labels_tree() throws expected errors for invalid nodes", {
  expect_snapshot(age_labels_tree(breaks_census, nodes = 5), error = TRUE)
  expect_snapshot(age_labels_tree(breaks_census, nodes = c("0-14", NA)), error = TRUE)
  expect_snapshot(age_labels_tree(breaks_census, nodes = "15+x"), error = TRUE)
  expect_snapshot(age_labels_tree(breaks_census, nodes = c("0-14", "Missing")), error = TRUE)
  expect_snapshot(age_labels_tree(breaks_census, nodes = "Total"), error = TRUE)
  expect_snapshot(age_labels_tree(breaks_census, nodes = "15-25"), error = TRUE)
  expect_snapshot(age_labels_tree(breaks_census, nodes = "12+"), error = TRUE)
  expect_snapshot(
    age_labels_tree(seq(0, 20, 5), nodes = "10+", open_right = FALSE),
    error = TRUE
  )
  expect_snapshot(age_labels_tree(breaks_census, nodes = "20-29"), error = TRUE)
  expect_snapshot(age_labels_tree(breaks_census, nodes = "0+"), error = TRUE)
  expect_snapshot(
    age_labels_tree(breaks_census, nodes = c("0-14", "Under 15")),
    error = TRUE
  )
  expect_snapshot(age_labels_tree(breaks_census, nodes = c("0-14", "0-14")), error = TRUE)
  expect_snapshot(age_labels_tree(breaks_census, nodes = c("0-29", "20-39")), error = TRUE)
})

test_that("age_labels_tree() checks breaks, open_right, and include_missing", {
  expect_error(age_labels_tree(breaks = 0), "`breaks` has length")
  expect_error(age_labels_tree(breaks_census, open_right = NA), "`open_right` is")
  expect_error(age_labels_tree(breaks_census, include_missing = "yes"),
               "`include_missing`")
})


## period and cohort ----------------------------------------------------------

test_that("period_labels_tree() creates open-left tree", {
  ans <- period_labels_tree(breaks = seq(2000, 2020, 5), nodes = "<2010",
                            open_left = TRUE)
  expect_identical(
    ans,
    c("<2000", "2000-2005", "2005-2010", "2010-2015", "2015-2020",
      "<2010", "Missing")
  )
})

test_that("period_labels_tree() interprets and formats nodes using format_multi", {
  ans <- period_labels_tree(breaks = seq(2000, 2020, 5),
                            nodes = c("2010-2019", "2000-2009"),
                            format_multi = "below_upper")
  expect_identical(
    ans,
    c("2000-2004", "2005-2009", "2010-2014", "2015-2019",
      "2000-2009", "2010-2019", "Missing")
  )
  expect_error(
    period_labels_tree(breaks = seq(2000, 2020, 5), nodes = "2000-2009"),
    "does not line up"
  )
})

test_that("period_labels_tree() works with single-year leaves and format_single", {
  ans <- period_labels_tree(breaks = 2000:2004, nodes = "2000-2002")
  expect_identical(ans, c("2000", "2001", "2002", "2003", "2000-2002", "Missing"))
  ans <- period_labels_tree(breaks = 2000:2004, nodes = "2000-2002",
                            format_single = "upper", include_missing = FALSE)
  expect_identical(ans, c("2001", "2002", "2003", "2004", "2000-2002"))
})

test_that("cohort_labels_tree() creates open-left tree, with three levels", {
  ans <- cohort_labels_tree(breaks = seq(1940, 2000, 10),
                            nodes = c("<1960", "1960-2000", "1980-2000"),
                            open_left = TRUE)
  expect_identical(
    ans,
    c("<1940", "1940-1950", "1950-1960", "1960-1970", "1970-1980",
      "1980-1990", "1990-2000", "<1960", "1980-2000", "1960-2000", "Missing")
  )
  expect_identical(
    cohort_assert_values(ans, valid_tree = TRUE, interpret_multi = "at_upper"),
    ans
  )
  expect_identical(
    levels(cohort_set_order_tree(ans, interpret_multi = "at_upper")),
    ans
  )
})

test_that("period_labels_tree() and cohort_labels_tree() throw errors", {
  expect_snapshot(
    period_labels_tree(breaks = seq(2000, 2020, 5), nodes = "<2010"),
    error = TRUE
  )
  expect_snapshot(
    cohort_labels_tree(breaks = seq(1940, 2000, 10), nodes = "1945-1960"),
    error = TRUE
  )
  expect_error(period_labels_tree(seq(2000, 2020, 5), open_left = NA), "`open_left` is")
  expect_error(cohort_labels_tree(seq(2000, 2020, 5), format_multi = "x"),
               "should be one of")
})
