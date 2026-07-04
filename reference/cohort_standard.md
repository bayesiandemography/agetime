# Standardize Cohort Labels

Convert cohort labels to the default agetime format.

## Usage

``` r
cohort_standard(
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

Character vector or factor with the same length as `labels`.

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

- [`cohort_labels()`](https://bayesiandemography.github.io/agetime/reference/cohort_labels.md)
  Default agetime format

- [`age_standard()`](https://bayesiandemography.github.io/agetime/reference/age_standard.md)
  Age equivalent of `cohort_standard()`

- [`period_standard()`](https://bayesiandemography.github.io/agetime/reference/period_standard.md)
  Period equivalent of `cohort_standard()`

## Examples

``` r
labels <- c("2025to2030", "1910--1914", " < 2022 ")
cohort_standard(labels)
#> [1] "2025-2030" "1910-1914" "<2022"    
```
