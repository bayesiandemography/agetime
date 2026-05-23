# Standardize Period Labels

Convert period labels to a 'standard' format.

## Usage

``` r
period_standard(
  x,
  x_one = c("lower", "upper"),
  x_multi = c("include", "exclude"),
  x_fail = c("error", "warn", "silent")
)
```

## Arguments

- x:

  Vector of period labels.

- x_one:

  How to interpret labels in `x` that describe one-year periods. Choices
  are `"lower"` (the default) and `"upper"`.

- x_multi:

  How to interpret labels in `x` that describe multi-year periods.
  Choices are `"include"` (the default) and `"exclude"`.

- x_fail:

  What to do if a label in `x` cannot be interpreted. Choices are
  `"error"` (the default), `"warn"`, and `"silent"`.

## Value

A modified version of `x`.

## Examples

``` r
x <- c("2025to2030", "1910--1914", " 2022 ")
period_standard(x)
#> [1] "2025-2030" "1910-1914" "2022"     
```
