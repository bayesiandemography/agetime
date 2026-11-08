## 'tree_find_partial_overlaps' ------------------------------------------------

test_that("tree_find_partial_overlaps() returns pairs that overlap without nesting", {
  m <- rbind(c(0, 5), c(10, 20), c(15, 25), c(0, 10))
  expect_identical(
    tree_find_partial_overlaps(m),
    matrix(c(2L, 3L), nrow = 1L)
  )
})

test_that("tree_find_partial_overlaps() treats nested, disjoint, and equal intervals as fine", {
  m <- rbind(c(0, 5), c(5, 10), c(0, 15), c(15, Inf), c(0, 5))
  expect_identical(
    tree_find_partial_overlaps(m),
    matrix(integer(), nrow = 0L, ncol = 2L)
  )
})

test_that("tree_find_partial_overlaps() handles fewer than two intervals", {
  empty <- matrix(integer(), nrow = 0L, ncol = 2L)
  expect_identical(tree_find_partial_overlaps(matrix(numeric(), ncol = 2L)), empty)
  expect_identical(tree_find_partial_overlaps(rbind(c(0, 5))), empty)
})

test_that("tree_find_partial_overlaps() orders pairs by row", {
  m <- rbind(c(3, 8), c(0, 5), c(2, 6))
  expect_identical(
    tree_find_partial_overlaps(m),
    rbind(c(1L, 2L), c(1L, 3L), c(2L, 3L))
  )
})


## 'tree_is_leaf' --------------------------------------------------------------

test_that("tree_is_leaf() identifies intervals with nothing strictly inside", {
  m <- rbind(c(0, 5), c(5, 15), c(0, 15), c(15, Inf), c(5, 10))
  expect_identical(tree_is_leaf(m), c(TRUE, FALSE, FALSE, TRUE, TRUE))
})

test_that("tree_is_leaf() does not count equal intervals", {
  m <- rbind(c(0, 5), c(0, 5))
  expect_identical(tree_is_leaf(m), c(TRUE, TRUE))
})

test_that("tree_is_leaf() handles zero rows", {
  expect_identical(tree_is_leaf(matrix(numeric(), ncol = 2L)), logical())
})


## 'tree_order' ----------------------------------------------------------------

test_that("tree_order() puts leaves by lower limit, then internal nodes depth-first", {
  m <- rbind(
    c(15, Inf), # 1 15+
    c(0, 15),   # 2 0-14
    c(65, Inf), # 3 65+
    c(15, 65),  # 4 15-64
    c(10, 15),  # 5 10-14
    c(0, 10),   # 6 0-9
    c(75, Inf), # 7 75+
    c(65, 75),  # 8 65-74
    c(15, 65)   # 9 15-64 (synonym of 4)
  )
  ## nothing lies strictly inside 15-64, so rows 4 and 9 (synonyms)
  ## are both leaves; ties keep original order
  expect_identical(tree_order(m), c(6L, 5L, 4L, 9L, 8L, 7L, 2L, 3L, 1L))
})

test_that("tree_order() keeps related internal nodes together", {
  m <- rbind(c(0, 15), c(15, 30), c(15, 65), c(65, Inf),
             c(15, 20), c(20, 30), c(30, 65), c(0, 5), c(5, 15),
             c(65, 75), c(75, Inf))
  expect_identical(tree_order(m), c(8L, 9L, 5L, 6L, 7L, 10L, 11L, 1L, 2L, 3L, 4L))
})

test_that("tree_order() handles zero rows", {
  expect_identical(tree_order(matrix(numeric(), ncol = 2L)), integer())
})
