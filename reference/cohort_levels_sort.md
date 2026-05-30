# Sort Cohort Levels

Sort the levels of `x`.

## Usage

``` r
cohort_levels_sort(
  x,
  decreasing = FALSE,
  x_one = c("lower", "upper"),
  x_multi = c("include", "exclude"),
  x_fail = c("error", "warn", "silent")
)
```

## Arguments

- x:

  Vector of cohort labels.

- decreasing:

  Whether sort is increasing or decreasing. Default is `FALSE`.

- x_one:

  Whether labels for one-year cohorts are based on lower or upper limit
  of period. Default is `"lower"`.

- x_multi:

  Whether labels for multi-year periods include or exclude final year of
  period. Default is `"include"`.

- x_fail:

  Action if element of `x` cannot be parsed: `"error"` (the default),
  `"warn"`, or `"silent"`.

## Value

Factor with the same length as `x`.

## Details

If `x` is not a factor, and so does not have levels, convert it to a
factor first.

Levels are sorted on their lower limits. When there are ties, upper
limits are used. `NA`s come second-to-last, and totals come last.

## See also

- [`parsing_cohort_labels()`](https://bayesiandemography.github.io/agetime/reference/parsing_cohort_labels.md)
  Details for `x_one`, `x_multi`, and `x_fail`

- [`age_levels_sort()`](https://bayesiandemography.github.io/agetime/reference/age_levels_sort.md)
  Age equivalent of `cohort_levels_sort()`

- [`period_levels_sort()`](https://bayesiandemography.github.io/agetime/reference/period_levels_sort.md)
  Period equivalent of `cohort_levels_sort()`

## Examples

``` r
x <- c("2020-2025", "<1990", "Total", NA, "2025-2050")
cohort_levels_sort(x)
#> [1] 2020-2025 <1990     Total     <NA>      2025-2050
#> Levels: <1990 2020-2025 2025-2050 <NA> Total
```
