# Identify Open Cohorts

Find cohorts that are open on the left or right.

## Usage

``` r
cohort_is_open_left(
  labels,
  interpret_single = c("lower", "upper"),
  interpret_multi = c("include", "exclude"),
  interpret_fail = c("error", "warn", "silent")
)

cohort_is_open_right(
  labels,
  interpret_single = c("lower", "upper"),
  interpret_multi = c("include", "exclude"),
  interpret_fail = c("error", "warn", "silent")
)
```

## Arguments

- labels:

  Vector of cohort labels.

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

Logical vector with the same length as `labels`.

## Details

- `cohort_is_open_left()` finds cohorts open on the left (has no lower
  limit).

- `cohort_is_open_right()` finds cohorts open on the right (has no upper
  limit).

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

- [`age_is_open_right()`](https://bayesiandemography.github.io/agetime/reference/age_is_open_right.md)
  Identify age groups open on right

- [`period_is_open_left()`](https://bayesiandemography.github.io/agetime/reference/period_is_open_left.md)
  Identify periods open on left

- [`period_is_open_right()`](https://bayesiandemography.github.io/agetime/reference/period_is_open_left.md)
  Identify periods open on right

- [`cohort_is_total()`](https://bayesiandemography.github.io/agetime/reference/cohort_is_total.md)
  Identify cohort totals

- [`cohort_set_open_left()`](https://bayesiandemography.github.io/agetime/reference/cohort_set_open_left.md)
  Specify cohort open on left

- [`cohort_set_open_right()`](https://bayesiandemography.github.io/agetime/reference/cohort_set_open_left.md)
  Specify cohort open on right

## Examples

``` r
labels <- c("2020", "<1900", "2040-2050", "1900 or less", "2030+")
cohort_is_open_left(labels)
#> Error in FUN(X[[i]], ...): Don't know how to interpret label "1900orless".
cohort_is_open_right(labels)
#> Error in FUN(X[[i]], ...): Don't know how to interpret label "1900orless".
```
