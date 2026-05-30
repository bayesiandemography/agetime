# Standardize Age Group Labels

Convert age group labels to a 'standard' format.

## Usage

``` r
age_standard(x, x_fail = c("error", "warn", "silent"))
```

## Arguments

- x:

  Vector of age group labels.

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
x <- c("5to9", "10--14", "100plus")
age_standard(x)
#> [1] "5-9"   "10-14" "100+" 

## factor input: factor in, factor out
age_standard(factor(c("5to9", "10--14")))
#> [1] 5-9   10-14
#> Levels: 10-14 5-9
```
