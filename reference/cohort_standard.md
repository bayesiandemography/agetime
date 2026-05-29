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

  Action if element of `x` cannot be parsed: `"error"` (the default),
  `"warn"`, or `"silent"`.

## Value

A vector the same length as `x` with standardized labels.

If `x` is a character vector, returns a character vector. If `x` is a
factor, returns a factor with the same length and `ordered` attribute as
`x`. Element values and `levels(x)` are standardized; level order is
unchanged except where two or more levels collapse to the same string
after standardization (the first occurrence in `levels(x)` is kept).
When `length(x) == 0`, standardized `levels(x)` are still applied.

With `x_fail = "silent"`, labels that cannot be parsed are mapped to
`NA` (including in [`levels()`](https://rdrr.io/r/base/levels.html) for
factors).

## Examples

``` r
x <- c("2025to2030", "1910--1914", " < 2022 ")
cohort_standard(x)
#> [1] "2025-2030" "1910-1914" "<2022"    
```
