# Standardize Age Group Labels

Convert age group labels to the default agetime format for age.

## Usage

``` r
age_standard(
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

Character vector or factor with the same length as `labels`.

## Rules for formatting output

|                 |                          |                      |
|-----------------|--------------------------|----------------------|
| *Interval type* | *Rule*                   | *Example*            |
| single          | `[a,a+1) -> "a"`         | `[10,11) -> "10"`    |
| multi           | `[a,a+n) -> "a-<a+n-1>"` | `[10,15) -> "10-14"` |
| open on right   | `[a,Inf) -> "a+"`        | `[85,Inf) -> "85+"`  |

## See also

- [`period_standard()`](https://bayesiandemography.github.io/agetime/reference/period_standard.md)
  Period equivalent of `age_standard()`

- [`cohort_standard()`](https://bayesiandemography.github.io/agetime/reference/cohort_standard.md)
  Cohort equivalent of `age_standard()`

- [`age_labels()`](https://bayesiandemography.github.io/agetime/reference/age_labels.md)
  Create age group labels

- [`age_coarsen_to()`](https://bayesiandemography.github.io/agetime/reference/age_coarsen_to.md)
  Map labels onto an existing set of labels

## Examples

``` r
labels <- c("Under 5", "5to9", "10--14", "100plus", "all")
age_standard(labels)
#> [1] "0-4"   "5-9"   "10-14" "100+"  "Total"
```
