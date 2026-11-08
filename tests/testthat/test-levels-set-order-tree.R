test_that("age_set_order_tree() orders census-style tree: leaves, nodes, Missing", {
  x <- c("Missing", "15+", "0-14", "70+", "60-69", "50-59", "40-49",
         "30-39", "20-29", "15-19", "10-14", "5-9", "0-4")
  ans <- age_set_order_tree(x)

  expect_s3_class(ans, "factor")
  expect_identical(as.character(ans), x)
  expect_identical(
    levels(ans),
    c("0-4", "5-9", "10-14", "15-19", "20-29", "30-39", "40-49",
      "50-59", "60-69", "70+", "0-14", "15+", "Missing")
  )
})

test_that("age_set_order_tree() puts children before parents with three levels", {
  x <- c("Missing", "15+", "65+", "15-64", "0-14",
         age_labels_five(lower_last = 85))
  ans <- age_set_order_tree(x)

  expect_identical(
    levels(ans),
    c(age_labels_five(lower_last = 85),
      "0-14", "15-64", "65+", "15+", "Missing")
  )
})

test_that("age_set_order_tree() orders nested internal nodes depth-first", {
  x <- c("65+", "15-64", "15-29", "0-14",
         "0-4", "5-9", "10-14", "15-19", "20-29", "30-64", "65-74", "75+")
  ans <- age_set_order_tree(x)

  expect_identical(
    levels(ans),
    c("0-4", "5-9", "10-14", "15-19", "20-29", "30-64", "65-74", "75+",
      "0-14", "15-29", "15-64", "65+")
  )
})

test_that("age_set_order_tree() handles leaves at different depths", {
  x <- c("65+", "0-4", "5-64", "65-74", "75+")
  ans <- age_set_order_tree(x)

  expect_identical(levels(ans), c("0-4", "5-64", "65-74", "75+", "65+"))
})

test_that("age_set_order_tree() with no internal nodes orders by lower limit", {
  x <- c("20-24", "Missing", "0-4", "5-9")
  ans <- age_set_order_tree(x)

  expect_identical(levels(ans), c("0-4", "5-9", "20-24", "Missing"))
})

test_that("age_set_order_tree() does not require leaves to cover all ages", {
  x <- c("0-4", "20-24", "0-29")
  ans <- age_set_order_tree(x)

  expect_identical(levels(ans), c("0-4", "20-24", "0-29"))
})

test_that("age_set_order_tree() keeps synonyms together, in order of appearance", {
  x <- c("20-24", "Under 5", "0-4", NA, "Missing", "0-9", "5-9")
  ans <- age_set_order_tree(x)

  expect_identical(as.character(ans), x)
  expect_identical(
    levels(ans),
    c("Under 5", "0-4", "5-9", "20-24", "0-9", NA, "Missing")
  )
})

test_that("age_set_order_tree() works on factors, keeping unused levels", {
  x <- factor(c("0-14", "0-4"), levels = c("Missing", "0-14", "5-9", "0-4", "10-14"))
  ans <- age_set_order_tree(x)

  expect_identical(as.character(ans), c("0-14", "0-4"))
  expect_identical(levels(ans), c("0-4", "5-9", "10-14", "0-14", "Missing"))
})

test_that("age_set_order_tree() preserves ordered factors", {
  x <- ordered(c("0-14", "0-4", "5-9", "10-14"),
               levels = c("0-14", "0-4", "5-9", "10-14"))
  ans <- age_set_order_tree(x)

  expect_true(is.ordered(ans))
  expect_identical(levels(ans), c("0-4", "5-9", "10-14", "0-14"))
})

test_that("age_set_order_tree() places unparsed labels before missing", {
  x <- c("foo", "0-14", "Missing", "0-4", "5-9", "10-14")
  expect_identical(
    levels(age_set_order_tree(x, interpret_fail = "silent")),
    c("0-4", "5-9", "10-14", "0-14", "foo", "Missing")
  )
  expect_warning(
    ans <- age_set_order_tree(x, interpret_fail = "warn")
  )
  expect_identical(
    levels(ans),
    c("0-4", "5-9", "10-14", "0-14", "foo", "Missing")
  )
  expect_error(age_set_order_tree(x))
})

test_that("age_set_order_tree() throws error when labels overlap without nesting", {
  expect_snapshot(
    age_set_order_tree(c("0-4", "10-19", "15-24", "0-9")),
    error = TRUE
  )
})

test_that("age_set_order_tree() error lists at most three pairs", {
  expect_snapshot(
    age_set_order_tree(c("0-4", "10-19", "15-24", "0-9", "5-14", "3-7", "2-6")),
    error = TRUE
  )
})

test_that("age_set_order_tree() throws error with totals", {
  expect_snapshot(
    age_set_order_tree(c("0-4", "5+", "Total")),
    error = TRUE
  )
  expect_snapshot(
    age_set_order_tree(c("0-4", "Total", "all")),
    error = TRUE
  )
})
