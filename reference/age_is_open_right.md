# Identify Age Groups With No Upper Limit

Find age groups that are open on the right, i.e., that have no upper
limit.

## Usage

``` r
age_is_open_right(
  labels,
  interpret_fail = c("error", "warn", "silent"),
  x_arg = rlang::caller_arg(labels),
  call = rlang::current_env()
)
```

## Arguments

- labels:

  Vector of age group labels.

- interpret_fail:

  Action if element of `labels` cannot be interpreted. Choices are
  `"error"` (the default), `"warn"`, and `"silent"`.

- x_arg:

  Name of `labels` to use in error and warning messages. Defaults to the
  expression supplied for `labels`. A function that calls this function
  can supply its own name, such as `"data$age"`.

- call:

  Execution environment of the function to name in error and warning
  messages. The default is this function itself. A function that calls
  this function can supply `call = rlang::current_env()`, so that
  messages name it instead.

## Value

Logical vector with the same length as `labels`. If `labels` has names,
the result has the same names.

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

- [`age_is_missing()`](https://bayesiandemography.github.io/agetime/reference/age_is_missing.md)
  Identify missing age group labels

- [`age_set_open_right()`](https://bayesiandemography.github.io/agetime/reference/age_set_open_right.md)
  Specify age group open on right

## Examples

``` r
labels <- c("20+", "infant", "100+", "60to79", "80 years or more")
age_is_open_right(labels)
#> [1]  TRUE FALSE  TRUE FALSE  TRUE
```
