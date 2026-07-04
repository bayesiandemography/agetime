# Identify Age Group Labels for Totals

Find age group labels that agetime interprets as totals.

## Usage

``` r
age_is_total(labels, interpret_fail = c("error", "warn", "silent"))
```

## Arguments

- labels:

  Vector of age group labels.

- interpret_fail:

  Action if element of `labels` cannot be parsed: `"error"` (the
  default), `"warn"`, or `"silent"`.

## Value

Logical vector with the same length as `labels`.

## See also

- [`age_is_open()`](https://bayesiandemography.github.io/agetime/reference/age_is_open.md)
  Find open age groups

- [`period_is_total()`](https://bayesiandemography.github.io/agetime/reference/period_is_total.md)
  Period equivalent of `age_is_total()`

- [`cohort_is_total()`](https://bayesiandemography.github.io/agetime/reference/cohort_is_total.md)
  Cohort equivalent of `age_is_total()`

## Examples

``` r
labels <- c("20-24", "Total", "100+", "ALL")
age_is_total(labels)
#> [1] FALSE  TRUE FALSE  TRUE
```
