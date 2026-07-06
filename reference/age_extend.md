# Extend a Set of Age Groups

Add new age groups at the end of `labels`.

## Usage

``` r
age_extend(
  labels,
  n = 1L,
  width = NULL,
  include_x = TRUE,
  interpret_fail = c("error", "warn", "silent")
)
```

## Arguments

- labels:

  Vector of age group labels.

- n:

  Number of age groups to add. Default is `1`.

- width:

  Width of the age groups to be added.

- include_x:

  Should the return value include `labels`? Default is `TRUE`.

- interpret_fail:

  Action if element of `labels` cannot be interpreted. Choices are
  `"error"` (the default), `"warn"`, and `"silent"`.

## Value

Character vector or factor. Length is `n`, or `length(labels) + n` when
`include_x` is `TRUE`.

## Details

By default, the width of the new age groups is derived from the last
element of `labels`, but a value can be specified through the `width`
arugment.

## See also

- [`period_extend()`](https://bayesiandemography.github.io/agetime/reference/period_extend.md)
  Period equivalent of `age_extend()`

- [`cohort_extend()`](https://bayesiandemography.github.io/agetime/reference/cohort_extend.md)
  Cohort equivalent of `age_extend()`

## Examples

``` r
labels <- c("0-4", "5-9")
age_extend(labels, n = 2)
#> [1] "0-4"   "5-9"   "10-14" "15-19"
age_extend(labels, n = 2, width = 10)
#> [1] "0-4"   "5-9"   "10-19" "20-29"
age_extend(labels, n = 2, include_x = FALSE)
#> [1] "10-14" "15-19"
```
