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

  Action if element of `x` cannot be parsed: `"error"` (the default),
  `"warn"`, or `"silent"`.

## Value

A vector the same length as `x` with standardized labels.

If `x` is a character vector, returns a character vector. If `x` is a
factor, returns a factor with the same length and `ordered` attribute as
`x`. Element values and `levels(x)` are standardized; level order is
unchanged except where two or more levels collapse to the same string
after standardization (the first occurrence in `levels(x)` is kept).
When `length(x) == 0`, returns `character(0)` for character input; for
factors, standardized `levels(x)` are still applied.

With `x_fail = "silent"`, labels that cannot be parsed are mapped to
`NA` (including in [`levels()`](https://rdrr.io/r/base/levels.html) for
factors).

## Examples

``` r
x <- c("2025to2030", "1910--1914", " 2022 ")
period_standard(x)
#> [1] "2025-2030" "1910-1914" "2022"     
```
