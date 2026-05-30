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

Character vector or factor with the same length as `x`.

## See also

- [`parsing_period_labels()`](https://bayesiandemography.github.io/agetime/reference/parsing_period_labels.md)
  Details for `x_one`, `x_multi`, and `x_fail`

- [`age_standard()`](https://bayesiandemography.github.io/agetime/reference/age_standard.md)
  Age equivalent of `period_standard()`

- [`cohort_standard()`](https://bayesiandemography.github.io/agetime/reference/cohort_standard.md)
  Cohort equivalent of `period_standard()`

## Examples

``` r
x <- c("2025to2030", "1910--1914", " 2022 ")
period_standard(x)
#> [1] "2025-2030" "1910-1914" "2022"     
```
