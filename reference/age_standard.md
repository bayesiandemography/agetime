# Standardize Age Group Labels

Standardize Age Group Labels

## Usage

``` r
age_standard(x, unknown_label = c("error", "warn", "silent"))
```

## Arguments

- x:

  Vector of age group labels.

- unknown_label:

  Action if meaning of label unclear. Choices are `"error"` (the
  default), `"warn"`, and `"silent"`.

## Value

A character vector same the length as `x`.

## Examples

``` r
x <- c("5to9", "10--14", "100plus")
age_standard(x)
#> [1] "5-9"   "10-14" "100+" 
```
