test_that("age extract functions return expected values for mixed labels", {
  lo <- age_lower(age_mixed)
  hi <- age_upper(age_mixed)
  wd <- age_width(age_mixed)
  md <- age_mid(age_mixed)

  expect_extract_lengths(age_mixed, lo, hi, wd, md)
  expect_values(lo, c(5, 10, 100))
  expect_values(hi, c(10, 15, Inf))
  expect_values(wd, c(5, 5, Inf))
  expect_values(md, c(7.5, 12.5, 102.5))
})

test_that("age extract functions are consistent on closed intervals", {
  lo <- age_lower(age_closed)
  hi <- age_upper(age_closed)
  wd <- age_width(age_closed)
  md <- age_mid(age_closed)

  expect_closed_intervals_consistent(lo, hi, wd, md)
})

test_that("age extract functions return NA for NA and Total labels", {
  expected <- list(
    lo = c(5, NA, 10),
    hi = c(10, NA, 15),
    wd = c(5, NA, 5),
    md = c(7.5, NA, 12.5)
  )

  for (x in list(age_with_na, age_with_total)) {
    lo <- age_lower(x)
    hi <- age_upper(x)
    wd <- age_width(x)
    md <- age_mid(x)

    expect_extract_lengths(x, lo, hi, wd, md)
    expect_values(lo, expected$lo)
    expect_values(hi, expected$hi)
    expect_values(wd, expected$wd)
    expect_values(md, expected$md)
  }
})

test_that("age_lower() returns NA silently for invalid labels", {
  x <- c("0-4", "young people", "50plus")
  expect_values(age_lower(x, interpret_fail = "silent"), c(0, NA, 50))
})

test_that("period extract functions handle multi-year labels", {
  lo <- period_lower(period_multi)
  hi <- period_upper(period_multi)
  wd <- period_width(period_multi)
  md <- period_mid(period_multi)

  expect_extract_lengths(period_multi, lo, hi, wd, md)
  expect_values(lo, c(2025, 2020, 2030))
  expect_values(hi, c(2030, 2025, 2035))
  expect_values(wd, c(5, 5, 5))
  expect_values(md, c(2027.5, 2022.5, 2032.5))
  expect_closed_intervals_consistent(lo, hi, wd, md)
})

test_that("period extract functions return NA for NA and Total labels", {
  expected <- list(
    lo = c(2020, NA, 2025),
    hi = c(2025, NA, 2030),
    wd = c(5, NA, 5),
    md = c(2022.5, NA, 2027.5)
  )

  for (x in list(period_with_na, period_with_total)) {
    lo <- period_lower(x)
    hi <- period_upper(x)
    wd <- period_width(x)
    md <- period_mid(x)

    expect_extract_lengths(x, lo, hi, wd, md)
    expect_values(lo, expected$lo)
    expect_values(hi, expected$hi)
    expect_values(wd, expected$wd)
    expect_values(md, expected$md)
  }
})

test_that("period extractors respect interpret_single", {
  expect_values(period_lower(period_one), 2025)
  expect_values(period_upper(period_one), 2026)
  expect_values(period_width(period_one), 1)

  expect_values(period_lower(period_one, interpret_single = "upper"), 2024)
  expect_values(period_upper(period_one, interpret_single = "upper"), 2025)
  expect_values(period_width(period_one, interpret_single = "upper"), 1)
})

test_that("period extractors respect interpret_multi", {
  x <- "2025-2030"

  expect_values(period_upper(x), 2030)
  expect_values(period_width(x), 5)

  expect_values(period_upper(x, interpret_multi = "exclude"), 2031)
  expect_values(period_width(x, interpret_multi = "exclude"), 6)
})

test_that("period_lower() returns NA silently for invalid labels", {
  x <- c("2000-2005", "long time ago")
  expect_values(period_lower(x, interpret_fail = "silent"), c(2000, NA))
})

test_that("period extract functions handle open-left and open-right labels", {
  x <- c("2020-2030", "2030+")
  lo <- period_lower(x)
  hi <- period_upper(x)
  wd <- period_width(x)

  expect_values(lo, c(2020, 2030))
  expect_values(hi, c(2030, Inf))
  expect_values(wd, c(10, Inf))
})

test_that("period extract functions handle open-left labels", {
  x <- c("<2020", "2020-2025")
  expect_values(period_lower(x), c(-Inf, 2020))
  expect_values(period_upper(x), c(2020, 2025))
})

test_that("cohort extract functions handle open-right labels", {
  x <- c("2025-2030", "2030+")
  lo <- cohort_lower(x)
  hi <- cohort_upper(x)
  wd <- cohort_width(x)

  expect_values(lo, c(2025, 2030))
  expect_values(hi, c(2030, Inf))
  expect_values(wd, c(5, Inf))
})

test_that("age functions treat '<N' as the age group from 0 to N - 1", {
  expect_values(age_lower("<5"), 0)
  expect_values(age_upper("<5"), 5)
  expect_identical(age_standard("<5"), "0-4")
})

test_that("period and cohort functions treat '<N' as open on the left", {
  expect_values(cohort_lower("<2000"), -Inf)
  expect_values(period_upper("<2000"), 2000)
})

test_that("cohort extract functions return expected values for mixed labels", {
  lo <- cohort_lower(cohort_multi)
  hi <- cohort_upper(cohort_multi)
  wd <- cohort_width(cohort_multi)
  md <- cohort_mid(cohort_multi)

  expect_extract_lengths(cohort_multi, lo, hi, wd, md)
  expect_values(lo, c(2025, -Inf, 2030))
  expect_values(hi, c(2030, 2025, 2035))
  expect_values(wd, c(5, Inf, 5))
  expect_values(md, c(2027.5, 2022.5, 2032.5))
})

test_that("cohort extract functions are consistent on closed labels", {
  x <- c("2025-2030", "2030-2035")
  lo <- cohort_lower(x)
  hi <- cohort_upper(x)
  wd <- cohort_width(x)
  md <- cohort_mid(x)

  expect_closed_intervals_consistent(lo, hi, wd, md)
})

test_that("cohort extract functions return NA for NA and Total labels", {
  expected <- list(
    lo = c(2025, NA, 2030),
    hi = c(2030, NA, 2035),
    wd = c(5, NA, 5),
    md = c(2027.5, NA, 2032.5)
  )

  for (x in list(cohort_with_na, cohort_with_total)) {
    lo <- cohort_lower(x)
    hi <- cohort_upper(x)
    wd <- cohort_width(x)
    md <- cohort_mid(x)

    expect_extract_lengths(x, lo, hi, wd, md)
    expect_values(lo, expected$lo)
    expect_values(hi, expected$hi)
    expect_values(wd, expected$wd)
    expect_values(md, expected$md)
  }
})

test_that("cohort extractors respect interpret_single", {
  expect_values(cohort_lower(cohort_one), 2025)
  expect_values(cohort_upper(cohort_one), 2026)
  expect_values(cohort_width(cohort_one), 1)

  expect_values(cohort_lower(cohort_one, interpret_single = "upper"), 2024)
  expect_values(cohort_upper(cohort_one, interpret_single = "upper"), 2025)
  expect_values(cohort_width(cohort_one, interpret_single = "upper"), 1)
})

test_that("cohort extractors respect interpret_multi", {
  x <- "2025-2030"

  expect_values(cohort_upper(x), 2030)
  expect_values(cohort_width(x), 5)

  expect_values(cohort_upper(x, interpret_multi = "exclude"), 2031)
  expect_values(cohort_width(x, interpret_multi = "exclude"), 6)
})

test_that("cohort_lower() returns NA silently for invalid labels", {
  x <- c("2000-2005", "long time ago")
  expect_values(cohort_lower(x, interpret_fail = "silent"), c(2000, NA))
})

test_that("extract functions accept factor input", {
  x_age <- factor(age_mixed, levels = age_mixed)
  expect_values(age_lower(x_age), age_lower(age_mixed))

  x_period <- factor(period_multi, levels = period_multi)
  expect_values(period_lower(x_period), period_lower(period_multi))

  x_cohort <- factor(cohort_multi, levels = cohort_multi)
  expect_values(cohort_lower(x_cohort), cohort_lower(cohort_multi))
})

test_that("extract functions give unnamed results for unnamed labels", {
  x <- age_messy
  expect_null(names(age_lower(x)))
  expect_null(names(age_upper(x)))
  expect_null(names(age_width(x)))
  expect_null(names(age_mid(x)))
  expect_null(names(age_lower(factor(x))))

  x <- period_messy
  expect_null(names(period_lower(x)))
  expect_null(names(period_upper(x)))

  x <- cohort_messy
  expect_null(names(cohort_lower(x)))
  expect_null(names(cohort_upper(x)))
})

test_that("extract functions keep names of named labels", {
  x <- c(a = "0-4", b = "5-9", c = "10+")
  expect_identical(names(age_lower(x)), c("a", "b", "c"))
  expect_identical(names(age_upper(x)), c("a", "b", "c"))
  expect_identical(names(age_width(x)), c("a", "b", "c"))
  expect_identical(names(age_mid(x)), c("a", "b", "c"))

  x <- c(p = "2020-2024", q = "2025")
  expect_identical(names(period_lower(x)), c("p", "q"))
  expect_identical(names(cohort_upper(x)), c("p", "q"))
})

test_that("mid functions give open intervals half the width of the nearest closed interval", {
  expect_identical(age_mid(c("0", "1-4", "5-9", "80+")), c(0.5, 3, 7.5, 82.5))
  expect_identical(age_mid(c("0", "1", "2", "90+")), c(0.5, 1.5, 2.5, 90.5))
  expect_identical(age_mid(c("60-69", "70-79", "80+")), c(65, 75, 85))
  expect_identical(age_mid(c("80+", "70-79")), c(85, 75))
  expect_identical(age_mid(c("0-4", NA, "Total", "5+")), c(2.5, NA, NA, 7.5))
  expect_identical(cohort_mid(c("<2000", "2000-2004", "2005+")), c(1998, 2002, 2007))
  expect_identical(period_mid(c("<2000", "2000", "2001+")), c(1999.5, 2000.5, 2001.5))
})

test_that("mid functions throw error when there are no closed intervals", {
  expect_error(age_mid("90+"),
               "Can't calculate midpoint of open age group \"90\\+\".")
  expect_error(age_mid(c("90+", NA)),
               "No closed age groups to take a width from.")
  expect_error(cohort_mid(c("<2000", "2000+")),
               "Can't calculate midpoint of open cohort")
  expect_identical(age_mid(character()), numeric())
})
