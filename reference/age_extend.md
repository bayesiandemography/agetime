# Extend a Set of Age Group Labels

Add new equal-width age group labels to the end of an existing set.

## Usage

``` r
age_extend(
  labels,
  n = 1L,
  width = NULL,
  include_labels = TRUE,
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

- include_labels:

  Should the return value include `labels`? Default is `TRUE`.

- interpret_fail:

  Action if element of `labels` cannot be interpreted. Choices are
  `"error"` (the default), `"warn"`, and `"silent"`.

## Value

A factor if `labels` is a factor, and a character vector otherwise. If
`labels` is a factor, the new age groups are added as levels, after the
existing levels.

## Details

The new age groups start at the highest upper limit of the age groups in
`labels`, including unused levels if `labels` is a factor. By default,
the width of the new age groups is the width of the age group with the
highest upper limit, but a value can be specified through the `width`
argument.

`labels` cannot include totals, missing values, or age groups that are
open on the right.

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
age_extend(labels, n = 2, include_labels = FALSE)
#> [1] "10-14" "15-19"
```
