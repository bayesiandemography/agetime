# Convert to New Cohorts

Modify the cohorts used by `labels`. The the new cohorts must contain
the old ones.

## Usage

``` r
cohort_modify(
  labels,
  breaks,
  open_left = NULL,
  open_right = NULL,
  interpret_single = c("lower", "upper"),
  interpret_multi = c("include", "exclude"),
  interpret_fail = c("error", "warn", "silent")
)
```

## Arguments

- labels:

  Vector of cohort labels.

- breaks:

  Boundaries between cohorts. A numeric vector.

- open_left:

  Whether the first cohort is open on the left, i.e. has no lower limit.
  Default is `NULL`, which infers from `labels`: `TRUE` when any label
  is open on the left, otherwise `FALSE`. Use `TRUE` or `FALSE` to add
  or suppress an open left level regardless of `labels`.

- open_right:

  Whether the last cohort is open on the right, i.e. has no upper limit.
  Default is `NULL`, which infers from `labels`: `TRUE` when any label
  is open on the right, otherwise `FALSE`. Use `TRUE` or `FALSE` to add
  or suppress an open right level regardless of `labels`.

- interpret_single:

  How to interpret labels for single-year cohorts. Choices are `"lower"`
  (the default) and `"upper"`. See below for details.

- interpret_multi:

  How to interpret labels for multi-year cohorts. Choices are
  `"include"` (the default) and `"exclude"`. See below for details.

- interpret_fail:

  Action if element of `labels` cannot be interpreted. Choices are
  `"error"` (the default), `"warn"`, and `"silent"`.

## Value

Factor with the same length as `labels`.

## Controlling how cohort labels are interpreted

If `interpret_single` is `"lower"` (the default), then labels for
single-year cohorts are assumed to refer to lower limits, so that
`"2025"` means `[2025,2026)`. This is the convention that data providers
typically use for calendar years.

If `interpret_single` is `"upper"`, then labels for single-year cohorts
are assumed to refer to upper limits, so that `"2025"` means
`[2024,2025)`. This is the convention that data providers typically use
for non-calendar years, such as 1 July to 30 June.

If `interpret_multi` is `"include"` (the default), then labels for
multi-year cohorts are assumed to include upper limits, so that
`"2025-2030"` means `[2025,2030)`.

If `interpret_multi` is `"exclude"`, then labels for multi-year cohorts
are assumed to exclude the upper limits so that `"2025-2030"` means
`[2025,2031)`.

## See also

- [`cohort_modify_five()`](https://bayesiandemography.github.io/agetime/reference/cohort_modify_five.md)
  Convert to 5-year cohorts

- [`cohort_modify_ten()`](https://bayesiandemography.github.io/agetime/reference/cohort_modify_five.md)
  Convert to 10-year cohorts

- [`age_modify()`](https://bayesiandemography.github.io/agetime/reference/age_modify.md)
  Age group equivalent of `cohort_modify()`

- [`period_modify()`](https://bayesiandemography.github.io/agetime/reference/period_modify.md)
  Period equivalent of `cohort_modify()`

## Examples

``` r
labels <- c("2001-2004", "1987-1989", "2000", "2005-2010")
cohort_modify(labels, breaks = c(1970, 2000, 2005, 2015))
#> [1] 2000-2005 1970-2000 2000-2005 2005-2015
#> Levels: 1970-2000 2000-2005 2005-2015
cohort_modify(labels, breaks = c(1970, 2000, 2005, 2015), open_left = TRUE)
#> [1] 2000-2005 1970-2000 2000-2005 2005-2015
#> Levels: <1970 1970-2000 2000-2005 2005-2015
```
