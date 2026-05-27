# Sort Period Levels

Sort the levels of `x`.

## Usage

``` r
period_levels_sort(
  x,
  decreasing = FALSE,
  x_one = c("lower", "upper"),
  x_multi = c("include", "exclude"),
  x_fail = c("error", "warn", "silent")
)
```

## Arguments

- x:

  Vector of period labels.

- decreasing:

  Whether sort is increasing or decreasing. Default is `FALSE`.

- x_one:

  How to interpret labels in `x` that describe one-year periods. Choices
  are `"lower"` (the default) and `"upper"`.

- x_multi:

  How to interpret labels in `x` that describe multi-year periods.
  Choices are `"include"` (the default) and `"exclude"`.

- x_fail:

  Action if element of `x` cannot be parsed: `"error"` (the default),
  `"warn"`, or `"silent"`.

## Value

A factor, the same length as `x`.

## Details

If `x` is not a factor, and so does not have levels, convert it to a
factor first.

Levels are sorted on their lower limits. When there are ties, upper
limits are used. `NA`s come second-to-last, and totals come last.

## Examples

``` r
x <- c("2020-2025", "2050", "Total", NA, "2025-2050")
period_levels_sort(x)
#> [1] 2020-2025 2050      Total     <NA>      2025-2050
#> Levels: 2020-2025 2025-2050 2050 <NA> Total
```
