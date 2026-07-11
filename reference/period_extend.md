# Extend a Set of Periods

Continue an existing set of period labels.

## Usage

``` r
period_extend(
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

  Vector of period labels.

- n:

  Number of periods to add. Default is `1`.

- width:

  Width of the periods to be added.

- include_x:

  Should the return value include `labels`? Default is `TRUE`.

- interpret_single:

  How to interpret labels for single-year periods. Choices are `"lower"`
  (the default) and `"upper"`. See below for details.

- interpret_multi:

  How to interpret labels for multi-year periods. Choices are
  `"include"` (the default) and `"exclude"`. See below for details.

- interpret_fail:

  Action if element of `labels` cannot be interpreted. Choices are
  `"error"` (the default), `"warn"`, and `"silent"`.

## Value

Character vector or factor.

## Details

By default, the width of the new periods is derived from the last
element of `labels`, but a value can be specified through the `width`
arugment.

## Controlling how period labels are interpreted

If `interpret_single` is `"lower"` (the default), then labels for
single-year periods are assumed to refer to lower limits, so that
`"2025"` means `[2025,2026)`. This is the convention that data providers
typically use for calendar years.

If `interpret_single` is `"upper"`, then labels for single-year periods
are assumed to refer to upper limits, so that `"2025"` means
`[2024,2025)`. This is the convention that data providers typically use
for non-calendar years, such as 1 July to 30 June.

If `interpret_multi` is `"include"` (the default), then labels for
multi-year periods are assumed to include upper limits, so that
`"2025-2030"` means `[2025,2030)`.

If `interpret_multi` is `"exclude"`, then labels for multi-year periods
are assumed to exclude the upper limits, so that `"2025-2030"` means
`[2025,2031)`.

## See also

- [`age_extend()`](https://bayesiandemography.github.io/agetime/reference/age_extend.md)
  Age equivalent of `period_extend()`

- [`cohort_extend()`](https://bayesiandemography.github.io/agetime/reference/cohort_extend.md)
  Cohort equivalent of `period_extend()`

## Examples

``` r
labels <- c("2020-2025", "2025-2030")
period_extend(labels, n = 2)
#> [1] "2020-2025" "2025-2030" "2030-2035" "2035-2040"
period_extend(labels, n = 2, width = 10)
#> [1] "2020-2025" "2025-2030" "2030-2040" "2040-2050"
period_extend(labels, n = 2, include_x = FALSE)
#> [1] "2030-2035" "2035-2040"
```
