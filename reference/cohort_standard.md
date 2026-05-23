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

  A vector of cohort labels.

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

A modified version of `x`.

## Examples

``` r
x <- c("2025to2030", "1910--1914", " < 2022 ")
cohort_standard(x)
#> [1] "2025-2030" "1910-1914" "<2022"    
```
