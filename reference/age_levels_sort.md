# Sort Age Group Levels

Sort the levels of `x`.

## Usage

``` r
age_levels_sort(x, decreasing = FALSE, x_fail = c("error", "warn", "silent"))
```

## Arguments

- x:

  Vector of age group labels.

- decreasing:

  Whether sort is increasing or decreasing. Default is `FALSE`.

- x_fail:

  Action if element of `x` cannot be parsed: `"error"` (the default),
  `"warn"`, or `"silent"`.

## Value

A factor, the same length as `x`.

## Details

If `x` is not a factor, and so does not have levels, convert it to a
factor before sorting the levels.

Levels are sorted on their lower limits. Upper limits are used to
resolve times. `NA`s come second-to-last and totals come last.

## Examples

``` r
x <- c("0-4", "50+", "Total", NA, "20-24")
age_levels_sort(x)
#> [1] 0-4   50+   Total <NA>  20-24
#> Levels: 0-4 20-24 50+ <NA> Total
```
