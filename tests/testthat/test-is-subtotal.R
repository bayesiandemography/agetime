expect_is_logical <- function(x, ans) {
  expect_identical(length(ans), length(x))
  expect_type(ans, "logical")
}

test_that("age_is_subtotal() returns logical(0) for length-0 input", {
  expect_identical(age_is_subtotal(character(0)), logical(0))
  expect_identical(age_is_subtotal(factor()), logical(0))
})

test_that("age_is_subtotal() coarse-only group has no subtotals", {
  labs <- c("0-64", "65-79", "80+")
  expect_values(age_is_subtotal(labs), c(FALSE, FALSE, FALSE))
})

test_that("age_is_subtotal() incomplete detail keeps broad band", {
  labs <- c("0-4", "5-9", "0-64", "65-79", "80+")
  expect_values(age_is_subtotal(labs), rep(FALSE, 5L))
})

test_that("age_is_subtotal() nested hierarchy marks every rebuildable band", {
  labs <- c("0", "1", "2", "3", "0-1", "2-3", "0-3")
  expect_values(
    age_is_subtotal(labs),
    c(FALSE, FALSE, FALSE, FALSE, TRUE, TRUE, TRUE)
  )
})

test_that("age_is_subtotal() overlapping alternative groupings still count", {
  labs <- c("90+", "90", "91+", "95+", "90-94")
  expect_values(
    age_is_subtotal(labs),
    c(TRUE, FALSE, FALSE, FALSE, FALSE)
  )
})

test_that("age_is_subtotal() rebuilds an open group from either tiling", {
  expect_true(age_is_subtotal(c("90+", "90", "91+", "90-94"))[[1L]])
  expect_true(age_is_subtotal(c("90+", "90", "95+", "90-94"))[[1L]])
  expect_true(age_is_subtotal(c("90+", "91+", "95+", "90-94"))[[1L]])
})

test_that("age_is_subtotal() needs two or more labels to rebuild", {
  expect_values(age_is_subtotal(c("90-94", "90")), c(FALSE, FALSE))
  expect_values(age_is_subtotal(c("91+", "95+")), c(FALSE, FALSE))
})

test_that("age_is_subtotal() mid-level bands partition parent without singles", {
  labs <- c("0-1", "2-3", "0-3")
  expect_values(age_is_subtotal(labs), c(FALSE, FALSE, TRUE))
})

test_that("age_is_subtotal() marks parent when fine bands fully partition", {
  labs <- c(
    "0", "1-4", "5-9", "10-14", "15-19",
    "20-24", "25-29", "30-34", "35-39", "40-44",
    "45-49", "50-54", "55-59", "60-64", "0-64", "65-79", "80+"
  )
  ans <- age_is_subtotal(labs)
  expect_is_logical(labs, ans)
  expect_true(ans[[match("0-64", labs)]])
  expect_false(any(ans[seq_len(14L)]))
})

test_that("age_is_subtotal() never marks grand totals", {
  labs <- c("0-4", "5-9", "Total")
  expect_values(age_is_subtotal(labs), c(FALSE, FALSE, FALSE))
  expect_values(age_is_total(labs), c(FALSE, FALSE, TRUE))
})

test_that("age_is_subtotal() and age_is_total() are mutually exclusive", {
  labs <- c("0", "1", "2", "3", "0-1", "2-3", "0-3", "Total")
  ans_sub <- age_is_subtotal(labs)
  ans_tot <- age_is_total(labs)
  expect_false(any(ans_sub & ans_tot))
})

test_that("age_is_subtotal() duplicates share subtotal flag", {
  labs <- c("0-1", "0-1", "0-3", "2-3", "0-3")
  expect_values(age_is_subtotal(labs), c(FALSE, FALSE, TRUE, FALSE, TRUE))
})

test_that("age_is_subtotal() uses character values for factors", {
  labs <- factor(c("0-1", "2-3", "0-3"), levels = c("0-3", "0-1", "2-3"))
  expect_values(age_is_subtotal(labs), c(FALSE, FALSE, TRUE))
})

test_that("age_is_subtotal() excludes missing labels from pool", {
  labs <- c("0-4", "5-9", NA, "not stated")
  expect_values(age_is_subtotal(labs), c(FALSE, FALSE, FALSE, FALSE))
})

test_that("period_is_subtotal() incomplete detail keeps broad period", {
  labs <- c("2020-2025", "2025-2030", "2020-2035")
  expect_values(period_is_subtotal(labs), rep(FALSE, 3L))
})

test_that("period_is_subtotal() never marks grand totals", {
  labs <- c("2020-2025", "2025-2030", "2020-2035", "Total")
  expect_values(period_is_subtotal(labs), c(FALSE, FALSE, FALSE, FALSE))
  expect_values(period_is_total(labs), c(FALSE, FALSE, FALSE, TRUE))
})

test_that("cohort_is_subtotal() incomplete detail keeps broad cohort", {
  labs <- c("2020-2025", "2025-2030", "2020-2035")
  expect_values(cohort_is_subtotal(labs), rep(FALSE, 3L))
})

test_that("cohort_is_subtotal() never marks grand totals", {
  labs <- c("2020-2025", "2025-2030", "2020-2035", "Total")
  expect_values(cohort_is_subtotal(labs), c(FALSE, FALSE, FALSE, FALSE))
  expect_values(cohort_is_total(labs), c(FALSE, FALSE, FALSE, TRUE))
})

test_that("children_can_rebuild_parent() finds a tiling among overlapping children", {
  parent <- c(90, Inf)
  children <- matrix(
    c(90, 91, 91, Inf, 95, Inf, 90, 95),
    ncol = 2,
    byrow = TRUE
  )
  expect_true(agetime:::children_can_rebuild_parent(parent, children))
})

test_that("children_can_rebuild_parent() fails when there is a gap", {
  parent <- c(0, 4)
  children <- matrix(c(0, 2, 3, 4), ncol = 2, byrow = TRUE)
  expect_false(agetime:::children_can_rebuild_parent(parent, children))
})

test_that("children_can_rebuild_parent() needs two or more children", {
  parent <- c(90, Inf)
  children <- matrix(c(91, Inf), ncol = 2, byrow = TRUE)
  expect_false(agetime:::children_can_rebuild_parent(parent, children))
})
