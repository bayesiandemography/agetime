test_that("age_standard() standardizes messy character labels", {
  ans <- age_standard(age_messy)
  expect_type(ans, "character")
  expect_false(is.factor(ans))
  expect_identical(ans, c("5-9", "10-14", "100+"))
})

test_that("age_standard() leaves standard labels unchanged", {
  ans <- age_standard(age_closed)
  expect_identical(ans, age_closed)
})

test_that("age_standard() preserves NA and Total", {
  expect_identical(age_standard(age_with_na), c("5-9", NA, "10-14"))
  expect_identical(age_standard(age_with_total), c("5-9", "Total", "10-14"))
})

test_that("age_standard() errors on unparseable labels by default", {
  expect_error(age_standard("young people"), "Don't know how to interpret")
})

test_that("age_standard() returns NA silently for invalid labels", {
  expect_identical(
    age_standard(c("0-4", "young people"), interpret_fail = "silent"),
    c("0-4", NA)
  )
})

test_that("age_standard() errors on invalid intervals by default", {
  expect_error(age_standard("50-40"), "Lower limit greater than upper limit")
})

test_that("period_standard() standardizes messy character labels", {
  ans <- period_standard(period_messy, interpret_multi = "at_upper")
  expect_type(ans, "character")
  expect_false(is.factor(ans))
  expect_identical(ans, c("2025-2030", "1910-1914", "2022"))
})

test_that("period_standard() leaves standard labels unchanged", {
  ans <- period_standard(period_multi)
  expect_identical(ans, period_multi)
})

test_that("period_standard() preserves NA and Total", {
  expect_identical(
    period_standard(period_with_na),
    c("2020-2025", NA, "2025-2030")
  )
  expect_identical(
    period_standard(period_with_total),
    c("2020-2025", "Total", "2025-2030")
  )
})

test_that("period_standard() silently converts invalid labels to NA", {
  expect_identical(
    period_standard(c("2020-2025", "long time ago"),
      interpret_fail = "silent"
    ),
    c("2020-2025", NA)
  )
  expect_identical(
    period_standard("2030-2020", interpret_fail = "silent"),
    NA_character_
  )
})

test_that("cohort_standard() standardizes messy character labels", {
  ans <- cohort_standard(cohort_messy, interpret_multi = "at_upper")
  expect_type(ans, "character")
  expect_false(is.factor(ans))
  expect_identical(ans, c("2025-2030", "1910-1914", "<2022"))
})

test_that("cohort_standard() leaves standard labels unchanged", {
  ans <- cohort_standard(cohort_multi)
  expect_identical(ans, cohort_multi)
})

test_that("cohort_standard() preserves NA and Total", {
  expect_identical(
    cohort_standard(cohort_with_na),
    c("2025-2030", NA, "2030-2035")
  )
  expect_identical(
    cohort_standard(cohort_with_total),
    c("2025-2030", "Total", "2030-2035")
  )
})

test_that("cohort_standard() silently converts invalid labels to NA", {
  expect_identical(
    cohort_standard(c("2025-2030", "long time ago"),
      interpret_fail = "silent"
    ),
    c("2025-2030", NA)
  )
})


test_that("period_standard() respects interpretation rules", {
  x <- c("2025to2030", "1910--1914", " 2022 ")
  expect_identical(
    period_standard(x, interpret_single = "upper", interpret_multi = "below_upper"),
    c("2025-2031", "1910-1915", "2021")
  )
  expect_identical(
    period_standard(x, interpret_single = "upper", interpret_multi = "below_upper"),
    c("2025-2031", "1910-1915", "2021")
  )
  expect_identical(
    period_standard(x, interpret_single = "lower", interpret_multi = "at_upper"),
    c("2025-2030", "1910-1914", "2022")
  )
  expect_identical(
    period_standard(x, interpret_single = "lower", interpret_multi = "below_upper"),
    c("2025-2031", "1910-1915", "2022")
  )
  expect_identical(
    period_standard(x, interpret_single = "upper", interpret_multi = "at_upper"),
    c("2025-2030", "1910-1914", "2021")
  )
  expect_identical(
    period_standard(x, interpret_single = "upper", interpret_multi = "below_upper"),
    c("2025-2031", "1910-1915", "2021")
  )
})

test_that("cohort_standard() respects interpretation rules", {
  x <- c("2025to2030", "1910--1914", " 2022 ")
  expect_identical(
    cohort_standard(x, interpret_single = "upper", interpret_multi = "below_upper"),
    c("2025-2031", "1910-1915", "2021")
  )
  expect_identical(
    cohort_standard(x, interpret_single = "upper", interpret_multi = "below_upper"),
    c("2025-2031", "1910-1915", "2021")
  )
  expect_identical(
    cohort_standard(x, interpret_single = "lower", interpret_multi = "at_upper"),
    c("2025-2030", "1910-1914", "2022")
  )
  expect_identical(
    cohort_standard(x, interpret_single = "lower", interpret_multi = "below_upper"),
    c("2025-2031", "1910-1915", "2022")
  )
  expect_identical(
    cohort_standard(x, interpret_single = "upper", interpret_multi = "at_upper"),
    c("2025-2030", "1910-1914", "2021")
  )
  expect_identical(
    cohort_standard(x, interpret_single = "upper", interpret_multi = "below_upper"),
    c("2025-2031", "1910-1915", "2021")
  )
})

test_that("age_standard() treats 'under N' as the age group from 0 to N - 1", {
  expect_identical(
    age_standard(c("Under 1", "Under 5", "under 16", "less than 5", "<20", "under 5 years")),
    c("0", "0-4", "0-15", "0-4", "0-19", "0-4")
  )
  expect_error(age_standard("Under 0"), "Don't know how to interpret")
})

test_that("age_standard() removes leading 'age', 'ages', and 'aged'", {
  expect_identical(
    age_standard(c("Age 0-4", "Ages 5-9", "aged 15-19", "Age not stated", "Age unknown")),
    c("0-4", "5-9", "15-19", NA, NA)
  )
  expect_error(age_standard("agenda"), "Don't know how to interpret label \"agenda\"")
})

test_that("age_standard() removes year words attached to numbers, and 'years old'", {
  expect_identical(
    age_standard(c("5-9yrs", "85yrs+", "0-4 years old", "5 years old", "10yr")),
    c("5-9", "85+", "0-4", "5", "10")
  )
})

test_that("age_standard() understands more synonyms for open age groups", {
  expect_identical(
    age_standard(c("65 & over", "65 and up", "65 or above", "65 &older")),
    rep("65+", 4)
  )
})

test_that("period_standard() and cohort_standard() do not treat 'under N' or 'age' as age words", {
  expect_identical(cohort_standard("under 2000"), "<2000")
  expect_error(period_standard("Age 2020"), "Don't know how to interpret")
})

test_that("suffixes such as 'or earlier' include the year, prefixes such as 'before' exclude it", {
  x <- c("1900 or earlier", "1900 and earlier", "1900 or before", "1900 and before",
         "1900 or less", "1900 and under", "1900 and below", "1900 and less")
  expect_identical(cohort_standard(x), rep("<1901", length(x)))
  expect_identical(period_standard(x), rep("<1901", length(x)))
  expect_identical(cohort_standard(x, interpret_single = "upper"), rep("<1901", length(x)))
  expect_identical(period_standard(x, interpret_single = "upper"), rep("<1901", length(x)))
  y <- c("before 1900", "under 1900", "less than 1900", "<1900")
  expect_identical(cohort_standard(y), rep("<1900", length(y)))
  expect_identical(period_standard(y), rep("<1900", length(y)))
})

test_that("'N or earlier' ends at N + 1, whatever the value of interpret_single", {
  for (s in c("lower", "upper")) {
    expect_identical(period_upper("2000 or earlier", interpret_single = s), 2001)
    expect_identical(cohort_upper("2000 or earlier", interpret_single = s), 2001)
  }
})

test_that("'up to' includes the year", {
  expect_identical(cohort_standard("up to 1900"), "<1901")
  expect_identical(period_standard("up to 1900", interpret_single = "upper"), "<1901")
})

test_that("open labels do not depend on interpret_single", {
  x <- c("before 2000", "<2000", "2000 or earlier", "2000 or more",
         "2000 and over", "2000 or later", "2000 and later", "2000+", "2000-")
  expected <- c("<2000", "<2000", "<2001", "2000+",
                "2000+", "2000+", "2000+", "2000+", "2000+")
  for (s in c("lower", "upper")) {
    expect_identical(period_standard(x, interpret_single = s), expected)
    expect_identical(cohort_standard(x, interpret_single = s), expected)
  }
})

test_that("'or later' is recognized for periods and cohorts but not ages", {
  expect_identical(period_standard(c("2000 or later", "2000 & later")), c("2000+", "2000+"))
  expect_identical(cohort_standard("2000 and later"), "2000+")
  expect_error(age_standard("85 or later"), "Don't know how to interpret")
})

test_that("'after' is not recognized", {
  expect_error(period_standard("after 2000"), "Don't know how to interpret")
  expect_error(cohort_standard("after 2000"), "Don't know how to interpret")
})

test_that("labels starting with '-' are rejected", {
  expect_error(period_standard("-2000"), "negative values are not allowed")
  expect_error(cohort_lower(c("1990", "-2000")), "open on the left, use \"<2000\"")
  expect_error(age_lower("-5"), "negative values are not allowed")
  expect_warning(ans <- period_lower("-2000", interpret_fail = "warn"),
                 "negative values are not allowed")
  expect_identical(ans, NA_real_)
})

test_that("'older' and 'younger' are recognized for ages but not periods or cohorts", {
  expect_identical(age_standard(c("85 or older", "85 and older", "85 &older")), rep("85+", 3))
  expect_error(cohort_standard("1990 or older"), "Don't know how to interpret")
  expect_error(cohort_standard("1990 or younger"), "Don't know how to interpret")
  expect_error(period_standard("2000 and older"), "Don't know how to interpret")
})

test_that("decimal labels are not treated as ranges", {
  expect_error(age_standard("5.5"), "Don't know how to interpret label \"5.5\"")
  expect_error(period_standard("2020.5"), "Don't know how to interpret label \"2020.5\"")
  expect_identical(age_standard(c("5_9", "5:9", "5/9", "5--9")), rep("5-9", 4))
})
