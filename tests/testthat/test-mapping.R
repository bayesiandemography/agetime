expect_mapping_tibble <- function(object, x, y) {
  expect_identical(object, tibble::tibble(x = x, y = y))
}

expect_mapping_matrix <- function(object, expected) {
  expect_identical(object, expected)
}

expect_same_mapping_formats <- function(x, y, relation = "equals", ...) {
  tb <- do.call(age_mapping, c(list(x = x, y = y, relation = relation), ...))
  mx <- do.call(age_mapping, c(
    list(x = x, y = y, relation = relation, format = "matrix"),
    ...
  ))
  idx <- which(mx == 1L, arr.ind = TRUE)
  pairs <- if (nrow(idx) == 0L) {
    tibble::tibble(x = character(0), y = character(0))
  } else {
    tibble::tibble(
      x = rownames(mx)[idx[, 1L]],
      y = colnames(mx)[idx[, 2L]]
    )
  }
  expect_identical(tb, pairs)
}

test_that("age_mapping() with equals finds identical intervals", {
  x <- c("0-4", "10", "5-7")
  y <- c("5-9", "0-4", "6-14")

  expect_mapping_tibble(age_mapping(x, y), "0-4", "0-4")
  expect_mapping_matrix(
    age_mapping(x, y, format = "matrix"),
    matrix(
      c(
        0L, 1L, 0L,
        0L, 0L, 0L,
        0L, 0L, 0L
      ),
      nrow = 3L,
      ncol = 3L,
      byrow = TRUE,
      dimnames = list(x = x, y = y)
    )
  )
  expect_same_mapping_formats(x, y)
})

test_that("age_mapping() with contains finds intervals in x that contain y", {
  x <- c("10--14", "0--9")
  y <- c("0-4", "5-9", "10-14")

  expect_mapping_matrix(
    age_mapping(x, y, relation = "contains", format = "matrix"),
    matrix(
      c(
        0L, 0L, 1L,
        1L, 1L, 0L
      ),
      nrow = 2L,
      ncol = 3L,
      byrow = TRUE,
      dimnames = list(x = x, y = y)
    )
  )
  expect_same_mapping_formats(x, y, relation = "contains")
})

test_that("age_mapping() with is-contained-in finds intervals in x inside y", {
  x <- c("10--14", "0--9")
  y <- c("0-4", "5-9", "10-14")

  expect_mapping_tibble(
    age_mapping(x, y, relation = "is-contained-in"),
    "10--14",
    "10-14"
  )
  expect_same_mapping_formats(x, y, relation = "is-contained-in")
})

test_that("age_mapping() with overlaps-with finds overlapping intervals", {
  x <- c("10--14", "0--9")
  y <- c("0-4", "5-9", "10-14")

  expect_mapping_tibble(
    age_mapping(x, y, relation = "overlaps-with"),
    c("0--9", "0--9", "10--14"),
    c("0-4", "5-9", "10-14")
  )
  expect_same_mapping_formats(x, y, relation = "overlaps-with")
})

test_that("age_mapping() maps x onto itself when y is NULL", {
  x <- c("0--4", "0-4", "5+")

  expect_mapping_tibble(
    age_mapping(x),
    c("0--4", "0-4", "0--4", "0-4", "5+"),
    c("0--4", "0--4", "0-4", "0-4", "5+")
  )
  expect_mapping_matrix(
    age_mapping(x, format = "matrix"),
    matrix(
      c(
        1L, 1L, 0L,
        1L, 1L, 0L,
        0L, 0L, 1L
      ),
      nrow = 3L,
      ncol = 3L,
      byrow = TRUE,
      dimnames = list(x = x, y = x)
    )
  )
})

test_that("age_mapping() maps unique labels only", {
  x <- c("5-9", "5-9", "10-14")
  y <- c("5-9", "10-14")
  ref <- c("5-9", "10-14")

  expect_identical(age_mapping(x, y), age_mapping(ref, y))
  expect_identical(
    age_mapping(x, y, format = "matrix"),
    age_mapping(ref, y, format = "matrix")
  )
})

test_that("period/cohort mappings match equals on shared fixtures", {
  expect_mapping_tibble(
    period_mapping(period_multi, y = c("2020-2025", "2025-2030")),
    c("2020-2025", "2025-2030"),
    c("2020-2025", "2025-2030")
  )
  expect_mapping_tibble(
    cohort_mapping(cohort_multi, y = c("2025-2030", "2030-2035")),
    c("2025-2030", "2030-2035"),
    c("2025-2030", "2030-2035")
  )
})
