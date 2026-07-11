# Identify Age Group Labels for Totals

Find "total" categories in age group labels.

## Usage

``` r
age_is_total(labels, interpret_fail = c("error", "warn", "silent"))
```

## Arguments

- labels:

  Vector of age group labels.

- interpret_fail:

  Action if element of `labels` cannot be interpreted. Choices are
  `"error"` (the default), `"warn"`, and `"silent"`.

## Value

Logical vector with the same length as `labels`.

## See also

- [`period_is_total()`](https://bayesiandemography.github.io/agetime/reference/period_is_total.md)
  Period equivalent of `age_is_total()`

- [`cohort_is_total()`](https://bayesiandemography.github.io/agetime/reference/cohort_is_total.md)
  Cohort equivalent of `age_is_total()`

- [`age_is_open_right()`](https://bayesiandemography.github.io/agetime/reference/age_is_open_right.md)
  Identify age groups open on right

## Examples

``` r
labels <- c("overall", "20-24", "Total", "100+", "ALL")
age_is_total(labels)
#> overall   20-24   Total    100+     ALL 
#>    TRUE   FALSE    TRUE   FALSE    TRUE 
```
