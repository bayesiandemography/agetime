test_that("construct_modify_mapping() adds an open-left row", {
  x <- c("<2020", "2020-2025", "2025-2030")
  intervals <- intervals(
    labels = x,
    label_type = "cohort",
    interpret_single = "lower",
    interpret_multi = "exclude",
    interpret_fail = "error"
  )
  breaks <- c(2020, 2025, 2030)
  levels_breaks <- agetime:::construct_labels_breaks(
    breaks = breaks,
    is_open_left = TRUE,
    is_open_right = FALSE,
    format_single = "lower",
    format_multi = "exclude",
    include_total = FALSE,
    include_na = FALSE
  )
  m_open <- agetime:::construct_modify_mapping(
    breaks = breaks,
    levels_breaks = levels_breaks,
    is_open_left = TRUE,
    is_open_right = FALSE,
    include_total = FALSE,
    include_na = FALSE,
    intervals = intervals
  )
  levels_closed <- agetime:::construct_labels_breaks(
    breaks = breaks,
    is_open_left = FALSE,
    is_open_right = FALSE,
    format_single = "lower",
    format_multi = "exclude",
    include_total = FALSE,
    include_na = FALSE
  )
  m_closed <- agetime:::construct_modify_mapping(
    breaks = breaks,
    levels_breaks = levels_closed,
    is_open_left = FALSE,
    is_open_right = FALSE,
    include_total = FALSE,
    include_na = FALSE,
    intervals = intervals
  )

  expect_identical(rownames(m_open), c("<2020", "2020-2024", "2025-2029"))
  expect_identical(nrow(m_open), nrow(m_closed) + 1L)
  expect_true(m_open["<2020", "<2020"])
  expect_false(any(m_open["2020-2024", , drop = FALSE]))
  expect_false(any(m_open["2025-2029", , drop = FALSE]))
})

test_that("construct_modify_mapping() maps NA only when include_na is TRUE", {
  x <- c("0-4", "5-9", NA)
  intervals <- intervals(
    labels = x,
    label_type = "age",
    interpret_single = "lower",
    interpret_multi = "exclude",
    interpret_fail = "error"
  )
  breaks <- c(0, 10)
  levels_with_na <- agetime:::construct_labels_breaks(
    breaks = breaks,
    is_open_left = FALSE,
    is_open_right = FALSE,
    format_single = "lower",
    format_multi = "exclude",
    include_total = FALSE,
    include_na = TRUE
  )
  m_with_na <- agetime:::construct_modify_mapping(
    breaks = breaks,
    levels_breaks = levels_with_na,
    is_open_left = FALSE,
    is_open_right = FALSE,
    include_total = FALSE,
    include_na = TRUE,
    intervals = intervals
  )
  i_na_row <- which(is.na(rownames(m_with_na)))
  i_na_col <- which(is.na(colnames(m_with_na)))

  expect_identical(rownames(m_with_na), c("0-9", NA))
  expect_identical(ncol(m_with_na), 3L)
  expect_true(m_with_na["0-9", "0-4"])
  expect_true(m_with_na["0-9", "5-9"])
  expect_false(any(m_with_na["0-9", i_na_col, drop = FALSE]))
  expect_true(m_with_na[i_na_row, i_na_col])
  expect_false(any(m_with_na[-i_na_row, i_na_col, drop = FALSE]))
})

test_that("construct_modify_mapping() omits NA row when include_na is FALSE", {
  x <- c("0-4", "5-9")
  intervals <- intervals(
    labels = x,
    label_type = "age",
    interpret_single = "lower",
    interpret_multi = "exclude",
    interpret_fail = "error"
  )
  breaks <- c(0, 10)
  levels_breaks <- agetime:::construct_labels_breaks(
    breaks = breaks,
    is_open_left = FALSE,
    is_open_right = FALSE,
    format_single = "lower",
    format_multi = "exclude",
    include_total = FALSE,
    include_na = FALSE
  )
  m <- agetime:::construct_modify_mapping(
    breaks = breaks,
    levels_breaks = levels_breaks,
    is_open_left = FALSE,
    is_open_right = FALSE,
    include_total = FALSE,
    include_na = FALSE,
    intervals = intervals
  )

  expect_identical(m, matrix(
    c(TRUE, TRUE),
    nrow = 1L,
    ncol = 2L,
    dimnames = list("0-9", c("0-4", "5-9"))
  ))
})

test_that("construct_mapping() errors for an invalid relation", {
  intervals_x <- intervals(
    labels = "0-4",
    label_type = "age",
    interpret_single = "lower",
    interpret_multi = "exclude",
    interpret_fail = "error"
  )
  intervals_y <- intervals(
    labels = "5-9",
    label_type = "age",
    interpret_single = "lower",
    interpret_multi = "exclude",
    interpret_fail = "error"
  )
  expect_error(
    agetime:::construct_mapping(
      intervals_x,
      intervals_y,
      relation = "bogus",
      format = "matrix"
    ),
    'Internal error: "bogus" is not a valid value for `relation`.'
  )
})
