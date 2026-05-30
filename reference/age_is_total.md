# Identify Age Group Labels for Totals

Find age group labels that agetime interprets as totals.

## Usage

``` r
age_is_total(x, x_fail = c("error", "warn", "silent"))
```

## Arguments

- x:

  Vector of age group labels.

- x_fail:

  Action if element of `x` cannot be parsed: `"error"` (the default),
  `"warn"`, or `"silent"`.

## Value

Logical vector with the same length as `x`.

## See also

- [`age_is_open()`](https://bayesiandemography.github.io/agetime/reference/age_is_open.md)
  Find open age groups

- [`period_is_total()`](https://bayesiandemography.github.io/agetime/reference/period_is_total.md)
  Period equivalent of `age_is_total()`

- [`cohort_is_total()`](https://bayesiandemography.github.io/agetime/reference/cohort_is_total.md)
  Cohort equivalent of `age_is_total()`

## Examples

``` r
x <- c("20-24", "Total", "100+", "ALL")
age_is_total(x)
#> [1] FALSE  TRUE FALSE  TRUE
```
