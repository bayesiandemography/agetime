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

  A vector of cohort labels.

- decreasing:

  Whether sort is increasing or decreasing. Default is `FALSE`.

- x_one:

  Whether labels for one-year cohorts are based on the lower or upper
  limit of the period. Default is `"lower"`.

- x_multi:

  Whether labels for multi-year periods include or exclude the final
  year of the period. Default is `"include"`.

- x_fail:

  Action if a label cannot be interpreted. Choices are `"error"` (the
  default), `"warn"`, and `"silent"`.

## Value

A factor, the same length as `x`.

## Details

If `x` is not a factor, and so does not have levels, convert it to a
factor first.

Levels are sorted on their lower limits. When there are ties, upper
limits are used. `NA`s come second-to-last, and totals come last.

## Examples

``` r
x <- c("2020-2025", "<1990", "Total", NA, "2025-2050")
cohort_levels_sort(x)
#> [1] 2020-2025 <1990     Total     <NA>      2025-2050
#> Levels: <1990 2020-2025 2025-2050 <NA> Total
```
