# Identify Cohort Labels for Totals

Find cohort labels that agetime interprets as totals.

## Usage

``` r
cohort_is_total(
  x,
  x_one = c("lower", "upper"),
  x_multi = c("include", "exclude"),
  x_fail = c("error", "warn", "silent")
)
```

## Arguments

- x:

  Vector of cohort labels.

- x_one:

  Whether labels for one-year cohorts are based on lower or upper limit
  of period. Default is `"lower"`.

- x_multi:

  Whether labels for multi-year periods include or exclude final year of
  period. Default is `"include"`.

- x_fail:

  Action if element of `x` cannot be parsed: `"error"` (the default),
  `"warn"`, or `"silent"`.

## Value

Logical vector with the same length as `x`.

## See also

- [`parsing_cohort_labels()`](https://bayesiandemography.github.io/agetime/reference/parsing_cohort_labels.md)
  Details for `x_one`, `x_multi`, and `x_fail`

- [`cohort_is_open()`](https://bayesiandemography.github.io/agetime/reference/cohort_is_open.md)
  Find open cohorts

- [`age_is_total()`](https://bayesiandemography.github.io/agetime/reference/age_is_total.md)
  Age equivalent of `cohort_is_total()`

- [`period_is_total()`](https://bayesiandemography.github.io/agetime/reference/period_is_total.md)
  Period equivalent of `cohort_is_total()`

## Examples

``` r
x <- c("2020-2025", "Total", "1999", "ALL")
cohort_is_total(x)
#> [1] FALSE  TRUE FALSE  TRUE
```
