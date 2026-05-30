# Standardize Cohort Labels

Convert cohort labels to a 'standard' format.

## Usage

``` r
cohort_standard(
  x,
  x_one = c("lower", "upper"),
  x_multi = c("include", "exclude"),
  x_fail = c("error", "warn", "silent")
)
```

## Arguments

- x:

  Vector of cohort labels.

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

Character vector or factor with the same length as `x`.

## See also

- [`parsing_cohort_labels()`](https://bayesiandemography.github.io/agetime/reference/parsing_cohort_labels.md)
  Details for `x_one`, `x_multi`, and `x_fail`

- [`age_standard()`](https://bayesiandemography.github.io/agetime/reference/age_standard.md)
  Age equivalent of `cohort_standard()`

- [`period_standard()`](https://bayesiandemography.github.io/agetime/reference/period_standard.md)
  Period equivalent of `cohort_standard()`

## Examples

``` r
x <- c("2025to2030", "1910--1914", " < 2022 ")
cohort_standard(x)
#> [1] "2025-2030" "1910-1914" "<2022"    
```
