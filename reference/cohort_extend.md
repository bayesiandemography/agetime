# Extend a Set of Cohorts

Add new cohorts at the end of `x`.

## Usage

``` r
cohort_extend(
  x,
  n = 1L,
  width = NULL,
  include_x = TRUE,
  x_one = c("lower", "upper"),
  x_multi = c("include", "exclude"),
  x_fail = c("error", "warn", "silent")
)
```

## Arguments

- x:

  A vector of cohort labels.

- n:

  Number of cohorts to add. Default is `1`.

- width:

  Width of the cohorts to be added.

- include_x:

  Should the return value include `x`? Default is `TRUE`.

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

A factor if `x` is a factor; otherwise a character vector.

## Details

By default, the width of the new cohorts is derived from the last
element of `x`, but a value can be specified through the `width`
arugment.

## See also

- [`age_extend()`](https://bayesiandemography.github.io/agetime/reference/age_extend.md)
  Age equivalent of `cohort_extend()`

- [`period_extend()`](https://bayesiandemography.github.io/agetime/reference/period_extend.md)
  Period equivalent of `cohort_extend()`

## Examples

``` r
x <- c("2020-2025", "2025-2030")
cohort_extend(x, n = 2)
#> [1] "2020-2025" "2025-2030" "2030-2035" "2035-2040"
cohort_extend(x, n = 2, width = 10)
#> [1] "2020-2025" "2025-2030" "2030-2040" "2040-2050"
cohort_extend(x, n = 2, include_x = FALSE)
#> [1] "2030-2035" "2035-2040"
```
