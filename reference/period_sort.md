# Sort Period Levels

Sort the levels of `labels`.

## Usage

``` r
period_sort(
  labels,
  decreasing = FALSE,
  interpret_single = c("lower", "upper"),
  interpret_multi = c("include", "exclude"),
  interpret_fail = c("error", "warn", "silent")
)
```

## Arguments

- labels:

  Vector of period labels.

- decreasing:

  Whether sort is increasing or decreasing. Default is `FALSE`.

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

Factor with the same length as `labels`.

## Details

If `labels` is not a factor, and so does not have levels, convert it to
a factor first.

Levels are sorted on their lower limits. When there are ties, upper
limits are used. `NA`s come second-to-last, and totals come last.

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

- [`age_sort()`](https://bayesiandemography.github.io/agetime/reference/age_sort.md)
  Age equivalent of `period_sort()`

- [`cohort_sort()`](https://bayesiandemography.github.io/agetime/reference/cohort_sort.md)
  Cohort equivalent of `period_sort()`

## Examples

``` r
labels <- c("2020-2025", "2050", "Total", NA, "2025-2050")
period_sort(labels)
#> [1] 2020-2025 2050      Total     <NA>      2025-2050
#> Levels: 2020-2025 2025-2050 2050 <NA> Total
```
