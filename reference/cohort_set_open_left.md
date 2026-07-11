# Specify Open Cohort

Add a factor level representing an open cohort. Replace existing cohorts
where necessary.

## Usage

``` r
cohort_set_open_left(
  labels,
  at,
  interpret_single = c("lower", "upper"),
  interpret_multi = c("include", "exclude"),
  interpret_fail = c("error", "warn", "silent")
)

cohort_set_open_right(
  labels,
  at,
  interpret_single = c("lower", "upper"),
  interpret_multi = c("include", "exclude"),
  interpret_fail = c("error", "warn", "silent")
)
```

## Arguments

- labels:

  Vector of cohort labels.

- at:

  Point at which intervals become open, e.g. `2020` in `<2020` or `2030`
  in `2030+`.

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

## Details

- `cohort_set_open_left()` adds a cohort open on the left (has no lower
  limit).

- `cohort_set_open_right()` adds a cohort open on the right (has no
  upper limit).

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

- [`age_set_open_right()`](https://bayesiandemography.github.io/agetime/reference/age_set_open_right.md)
  Specify age group open on right

- [`period_set_open_left()`](https://bayesiandemography.github.io/agetime/reference/period_set_open_left.md)
  Specify period open on left

- [`period_set_open_right()`](https://bayesiandemography.github.io/agetime/reference/period_set_open_left.md)
  Specify period open on right

- [`cohort_is_open_left()`](https://bayesiandemography.github.io/agetime/reference/cohort_is_open_left.md)
  Identify cohorts open on left

- [`cohort_is_open_right()`](https://bayesiandemography.github.io/agetime/reference/cohort_is_open_left.md)
  Identify cohorts open on right

- [`period_is_open_left()`](https://bayesiandemography.github.io/agetime/reference/period_is_open_left.md)
  Identify periods open on left

- [`period_is_open_right()`](https://bayesiandemography.github.io/agetime/reference/period_is_open_left.md)
  Identify periods open on right

- [`age_is_open_right()`](https://bayesiandemography.github.io/agetime/reference/age_is_open_right.md)
  Identify age groups open on right

## Examples

``` r
labels <- c("2020-2024", "<2000", "2015")
cohort_set_open_left(labels, at = 2020)
#> [1] 2020-2024 <2020     <2020    
#> Levels: <2020 2020-2024
cohort_set_open_left(labels, at = 2005)
#> [1] 2020-2024 <2005     2015     
#> Levels: <2005 2015 2020-2024
cohort_set_open_left(c("2000-2004", "2010-2014"), at = 1990)
#> [1] 2000-2004 2010-2014
#> Levels: <1990 2000-2004 2010-2014

labels <- c("2020-2024", "2025-2029", "2030")
cohort_set_open_right(labels, at = 2030)
#> [1] 2020-2024 2025-2029 2030+    
#> Levels: 2020-2024 2025-2029 2030+
```
