## Functions that return one value per label keep the names of
## 'labels' (see test-extract.R and test-is.R). Functions that
## return new labels drop them.

test_that("functions that return new age labels drop names", {
  x <- c(a = "0", b = "1-4", c = "5-9")
  fx <- factor(x)
  names(fx) <- names(x)
  for (labels in list(x, fx)) {
    expect_null(names(age_standard(labels)))
    expect_null(names(age_coarsen(labels, breaks = c(0, 5, 10))))
    expect_null(names(age_coarsen_five(labels)))
    expect_null(names(age_coarsen_ten(labels)))
    expect_null(names(age_coarsen_life(labels)))
    expect_null(names(age_coarsen_to(labels, to = c("0-9", "10-19"))))
    expect_null(names(age_fill(labels, breaks = c(1, 5))))
    expect_null(names(age_fill_five(labels)))
    expect_null(names(age_set_order(labels)))
    expect_null(names(age_set_open_right(labels, at = 5)))
    expect_null(names(age_extend(labels)))
  }
})

test_that("functions that return new period and cohort labels drop names", {
  x <- c(a = "2000", b = "2001-2005", c = "2005-2010")
  fx <- factor(x)
  names(fx) <- names(x)
  for (labels in list(x, fx)) {
    expect_null(names(period_standard(labels)))
    expect_null(names(period_coarsen(labels, breaks = c(2000, 2010))))
    expect_null(names(period_coarsen_ten(labels)))
    expect_null(names(period_coarsen_to(labels, to = "2000-2010")))
    expect_null(names(period_fill(labels, breaks = c(2001, 2005))))
    expect_null(names(period_set_order(labels)))
    expect_null(names(period_set_open_left(labels, at = 2005)))
    expect_null(names(period_set_open_right(labels, at = 2005)))
    expect_null(names(period_extend(labels)))
    expect_null(names(cohort_standard(labels)))
    expect_null(names(cohort_coarsen(labels, breaks = c(2000, 2010))))
    expect_null(names(cohort_coarsen_ten(labels)))
    expect_null(names(cohort_coarsen_to(labels, to = "2000-2010")))
    expect_null(names(cohort_fill(labels, breaks = c(2001, 2005))))
    expect_null(names(cohort_set_order(labels)))
    expect_null(names(cohort_set_open_left(labels, at = 2005)))
    expect_null(names(cohort_set_open_right(labels, at = 2005)))
    expect_null(names(cohort_extend(labels)))
  }
})
