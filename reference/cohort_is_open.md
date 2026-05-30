# Identify Cohort Labels for Open Cohorts

Find cohort labels that agetime interprets as open, ie having no lower
limit.

## Usage

``` r
cohort_is_open(
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

- [`cohort_is_total()`](https://bayesiandemography.github.io/agetime/reference/cohort_is_total.md)
  Find cohort labels for totals

- [`age_is_open()`](https://bayesiandemography.github.io/agetime/reference/age_is_open.md)
  Age equivalent of `cohort_is_open()`

## Examples

``` r
x <- c("2020", "<1900", "2040-2050", "<2022")
cohort_is_open(x)
#>      2020     <1900 2040-2050     <2022 
#>     FALSE      TRUE     FALSE      TRUE 
```
