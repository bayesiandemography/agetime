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

A modified version of `x`.

## Examples

``` r
x <- c("5to9", "10--14", "100plus")
age_standard(x)
#> [1] "5-9"   "10-14" "100+" 
```
