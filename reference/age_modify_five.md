# Convert to Specialised Age Groups

Modify the age groups used by `labels`. The new age groups must contain
the old age groups, and follow a regular pattern:

- `age_modify_five` Five-year age groups

- `age_modify_ten` Ten-year age groups

- `age_modify_life` Age groups used in 'abridged' life tables

## Usage

``` r
age_modify_five(labels, interpret_fail = c("error", "warn", "silent"))

age_modify_ten(labels, interpret_fail = c("error", "warn", "silent"))

age_modify_life(labels, interpret_fail = c("error", "warn", "silent"))
```

## Arguments

- labels:

  Vector of age group labels.

- interpret_fail:

  Action if element of `labels` cannot be parsed: `"error"` (the
  default), `"warn"`, or `"silent"`.

## Value

Character vector or factor with the same length as `labels`.

## See also

- [`age_modify()`](https://bayesiandemography.github.io/agetime/reference/age_modify.md)
  Convert to general age groups

- [`period_modify_five()`](https://bayesiandemography.github.io/agetime/reference/period_modify_five.md)
  Period equivalent of `age_modify_five()`

- [`period_modify_ten()`](https://bayesiandemography.github.io/agetime/reference/period_modify_five.md)
  Period equivalent of `age_modify_ten()`

- [`cohort_modify_five()`](https://bayesiandemography.github.io/agetime/reference/cohort_modify_five.md)
  Cohort equivalent of `age_modify_five()`

- [`cohort_modify_ten()`](https://bayesiandemography.github.io/agetime/reference/cohort_modify_five.md)
  Cohort equivalent of `age_modify_ten()`

- [`age_levels_fill()`](https://bayesiandemography.github.io/agetime/reference/age_levels_fill.md)
  Add levels for intermediate age groups

## Examples

``` r
labels <- c("1-3", "87-89", "0", "91+", "total", "52")
age_modify_five(labels)
#> [1] "0-4"   "85-89" "0-4"   "90+"   "Total" "50-54"
age_modify_ten(labels)
#> [1] "0-9"   "80-89" "0-9"   "90+"   "Total" "50-59"
age_modify_life(labels)
#> [1] "1-4"   "85-89" "0"     "90+"   "Total" "50-54"
```
