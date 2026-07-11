# Convert to Specialised Age Groups

Modify the age groups used by `labels`. The new age groups must contain
the old age groups, and follow a regular pattern:

- `age_modify_five` Five-year age groups

- `age_modify_ten` Ten-year age groups

- `age_modify_life` Age groups used in 'abridged' life tables

## Usage

``` r
age_modify_five(
  labels,
  open_right = NULL,
  interpret_fail = c("error", "warn", "silent")
)

age_modify_ten(
  labels,
  open_right = NULL,
  interpret_fail = c("error", "warn", "silent")
)

age_modify_life(
  labels,
  open_right = NULL,
  interpret_fail = c("error", "warn", "silent")
)
```

## Arguments

- labels:

  Vector of age group labels.

- open_right:

  Whether the oldest age group is open on the right, i.e. has no upper
  limit. If `NULL` (the default), `open_right` is set to `TRUE` if
  `labels` has an age group that is open on the right, and to `FALSE`
  otherwise.

- interpret_fail:

  Action if element of `labels` cannot be interpreted. Choices are
  `"error"` (the default), `"warn"`, and `"silent"`.

## Value

Factor with the same length as `labels`.

## Abridged and complete life tables

- An 'abridged' life table uses age groups `"0"` and `"1-4"`, followed
  by 5-year age groups `"5-9"`, `"10-14"`, ...

- A 'complete' life table uses single-year age groups `"0"`, `"1"`,
  `"2"`, ...

- Both types of life table have an open interval such as `"85+"` or
  `"100+"`.

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

- [`age_fill()`](https://bayesiandemography.github.io/agetime/reference/age_fill.md)
  Add levels for intermediate age groups

## Examples

``` r
labels <- c("1-3", "87-89", "0", "91+", "total", "52")
age_modify_five(labels)
#> [1] 0-4   85-89 0-4   90+   Total 50-54
#> 20 Levels: 0-4 5-9 10-14 15-19 20-24 25-29 30-34 35-39 40-44 45-49 ... Total
age_modify_ten(labels)
#> [1] 0-9   80-89 0-9   90+   Total 50-59
#> Levels: 0-9 10-19 20-29 30-39 40-49 50-59 60-69 70-79 80-89 90+ Total
age_modify_life(labels)
#> [1] 1-4   85-89 0     90+   Total 50-54
#> 21 Levels: 0 1-4 5-9 10-14 15-19 20-24 25-29 30-34 35-39 40-44 45-49 ... Total
```
