# Extend a Set of Age Groups

Add new age groups at the end of `x`.

## Usage

``` r
age_extend(
  x,
  n = 1L,
  width = NULL,
  include_x = TRUE,
  x_fail = c("error", "warn", "silent")
)
```

## Arguments

- x:

  Vector of age group labels.

- n:

  Number of age groups to add. Default is `1`.

- width:

  Width of the age groups to be added.

- include_x:

  Should the return value include `x`? Default is `TRUE`.

- x_fail:

  Action if element of `x` cannot be parsed: `"error"` (the default),
  `"warn"`, or `"silent"`.

## Value

Character vector or factor. Length is `n`, or `length(x) + n` when
`include_x` is `TRUE`.

## Details

By default, the width of the new age groups is derived from the last
element of `x`, but a value can be specified through the `width`
arugment.

## See also

- [`period_extend()`](https://bayesiandemography.github.io/agetime/reference/period_extend.md)
  Period equivalent of `age_extend()`

- [`cohort_extend()`](https://bayesiandemography.github.io/agetime/reference/cohort_extend.md)
  Cohort equivalent of `age_extend()`

## Examples

``` r
x <- c("0-4", "5-9")
age_extend(x, n = 2)
#> [1] "0-4"   "5-9"   "10-14" "15-19"
age_extend(x, n = 2, width = 10)
#> [1] "0-4"   "5-9"   "10-19" "20-29"
age_extend(x, n = 2, include_x = FALSE)
#> [1] "10-14" "15-19"
```
