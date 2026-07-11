# Specify Open Age Group

Add a factor level representing an age group that is open on the right
(has no upper limit). Replace existing age groups where necessary.

## Usage

``` r
age_set_open_right(labels, at, interpret_fail = c("error", "warn", "silent"))
```

## Arguments

- labels:

  Vector of age group labels.

- at:

  Point at which intervals become open, e.g. `80` in `80+`.

- interpret_fail:

  Action if element of `labels` cannot be interpreted. Choices are
  `"error"` (the default), `"warn"`, and `"silent"`.

## Value

Factor with the same length as `labels`.

## See also

- [`cohort_set_open_left()`](https://bayesiandemography.github.io/agetime/reference/cohort_set_open_left.md)
  Specify cohort open on left

- [`cohort_set_open_right()`](https://bayesiandemography.github.io/agetime/reference/cohort_set_open_left.md)
  Specify cohort open on right

- [`period_set_open_left()`](https://bayesiandemography.github.io/agetime/reference/period_set_open_left.md)
  Specify period open on left

- [`period_set_open_right()`](https://bayesiandemography.github.io/agetime/reference/period_set_open_left.md)
  Specify period open on right

- [`cohort_is_open_left()`](https://bayesiandemography.github.io/agetime/reference/cohort_is_open_left.md)
  Identify cohorts open on left

- [`cohort_is_open_right()`](https://bayesiandemography.github.io/agetime/reference/cohort_is_open_left.md)
  Identify cohorts open on right

- [`period_is_open_left()`](https://bayesiandemography.github.io/agetime/reference/period_is_open_left.md)
  Identify periods open on left

- [`period_is_open_right()`](https://bayesiandemography.github.io/agetime/reference/period_is_open_left.md)
  Identify periods open on right

- [`age_is_open_right()`](https://bayesiandemography.github.io/agetime/reference/age_is_open_right.md)
  Identify age groups open on right

## Examples

``` r
labels <- c("20-24", "80-84", "100+")
age_set_open_right(labels, at = 80)
#> [1] 20-24 80+   80+  
#> Levels: 20-24 80+
age_set_open_right(labels, at = 50)
#> [1] 20-24 50+   50+  
#> Levels: 20-24 50+
age_set_open_right(c("0-4", "60-64"), at = 70)
#> [1] 0-4   60-64
#> Levels: 0-4 60-64 70+
```
