# Identify Open Age Groups

Find age groups that are open on the right, i.e., that have no upper
limit.

## Usage

``` r
age_is_open_right(labels, interpret_fail = c("error", "warn", "silent"))
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

- [`cohort_is_open_left()`](https://bayesiandemography.github.io/agetime/reference/cohort_is_open_left.md)
  Identify cohorts open on left

- [`cohort_is_open_right()`](https://bayesiandemography.github.io/agetime/reference/cohort_is_open_left.md)
  Identify cohorts open on right

- [`period_is_open_left()`](https://bayesiandemography.github.io/agetime/reference/period_is_open_left.md)
  Identify periods open on left

- [`period_is_open_right()`](https://bayesiandemography.github.io/agetime/reference/period_is_open_left.md)
  Identify periods open on right

- [`age_is_total()`](https://bayesiandemography.github.io/agetime/reference/age_is_total.md)
  Identify totals for age groups

- [`age_set_open_right()`](https://bayesiandemography.github.io/agetime/reference/age_set_open_right.md)
  Specify age group open on right

## Examples

``` r
labels <- c("20+", "infant", "100+", "60to79", "80 years or more")
age_is_open_right(labels)
#>              20+           infant             100+           60to79 
#>             TRUE            FALSE             TRUE            FALSE 
#> 80 years or more 
#>             TRUE 
```
