# Extend a Set of Periods

Add new periods at the end of `x`.

## Usage

``` r
period_extend(
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

  Vector of period labels.

- n:

  Number of periods to add. Default is `1`.

- width:

  Width of the periods to be added.

- include_x:

  Should the return value include `x`? Default is `TRUE`.

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

A factor if `x` is a factor; otherwise a character vector.

When `length(x) == 0`, throws an error (there is no interval to extend
from). If `width` is `NULL`, the error suggests supplying `width`
explicitly.

## Details

By default, the width of the new periods is derived from the last
element of `x`, but a value can be specified through the `width`
arugment.

## See also

- [`age_extend()`](https://bayesiandemography.github.io/agetime/reference/age_extend.md)
  Age equivalent of `period_extend()`

- [`cohort_extend()`](https://bayesiandemography.github.io/agetime/reference/cohort_extend.md)
  Cohort equivalent of `period_extend()`

## Examples

``` r
x <- c("2020-2025", "2025-2030")
period_extend(x, n = 2)
#> [1] "2020-2025" "2025-2030" "2030-2035" "2035-2040"
period_extend(x, n = 2, width = 10)
#> [1] "2020-2025" "2025-2030" "2030-2040" "2040-2050"
period_extend(x, n = 2, include_x = FALSE)
#> [1] "2030-2035" "2035-2040"
```
