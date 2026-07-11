# Extend a Set of Cohorts

Continue an existing set of cohort labels.

## Usage

``` r
cohort_extend(
  labels,
  n = 1L,
  width = NULL,
  include_x = TRUE,
  interpret_single = c("lower", "upper"),
  interpret_multi = c("include", "exclude"),
  interpret_fail = c("error", "warn", "silent")
)
```

## Arguments

- labels:

  Vector of cohort labels.

- n:

  Number of cohorts to add. Default is `1`.

- width:

  Width of the cohorts to be added.

- include_x:

  Should the return value include `labels`? Default is `TRUE`.

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

Character vector or factor.

## Details

By default, the width of the new cohorts is derived from the last
element of `labels`, but a value can be specified through the `width`
arugment.

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

- [`age_extend()`](https://bayesiandemography.github.io/agetime/reference/age_extend.md)
  Age equivalent of `cohort_extend()`

- [`period_extend()`](https://bayesiandemography.github.io/agetime/reference/period_extend.md)
  Period equivalent of `cohort_extend()`

## Examples

``` r
labels <- c("2020-2025", "2025-2030")
cohort_extend(labels, n = 2)
#> [1] "2020-2025" "2025-2030" "2030-2035" "2035-2040"
cohort_extend(labels, n = 2, width = 10)
#> [1] "2020-2025" "2025-2030" "2030-2040" "2040-2050"
cohort_extend(labels, n = 2, include_x = FALSE)
#> [1] "2030-2035" "2035-2040"
```
