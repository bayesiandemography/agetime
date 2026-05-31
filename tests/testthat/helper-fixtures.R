# Canonical label vectors for non-zero-length tests.

age_closed <- c("0-4", "5-9", "10-14")
age_mixed <- c("5-9", "10-14", "100+")

period_multi <- c("2025-2030", "2020-2025", "2030-2035")
period_one <- "2025"

cohort_multi <- c("2025-2030", "<2025", "2030-2035")
cohort_one <- "2025"

age_with_na <- c("5-9", NA, "10-14")
age_with_total <- c("5-9", "Total", "10-14")

period_with_na <- c("2020-2025", NA, "2025-2030")
period_with_total <- c("2020-2025", "Total", "2025-2030")

cohort_with_na <- c("2025-2030", NA, "2030-2035")
cohort_with_total <- c("2025-2030", "Total", "2030-2035")

expect_values <- function(object, expected) {
  expect_identical(unname(object), unname(expected))
}

expect_extract_lengths <- function(x, lower, upper, width, mid) {
  n <- length(x)
  expect_identical(length(lower), n)
  expect_identical(length(upper), n)
  expect_identical(length(width), n)
  expect_identical(length(mid), n)
  expect_type(lower, "double")
  expect_type(upper, "double")
  expect_type(width, "double")
  expect_type(mid, "double")
}

expect_closed_intervals_consistent <- function(lower, upper, width, mid) {
  closed <- is.finite(lower) & is.finite(upper) & is.finite(width)
  expect_identical(upper[closed] - lower[closed], width[closed])
  expect_identical(mid[closed], lower[closed] + 0.5 * width[closed])
}
