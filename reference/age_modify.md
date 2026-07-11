# Convert to New Age Groups

Modify the age groups used by `labels`. The the new age groups must
contain the old ones.

## Usage

``` r
age_modify(
  labels,
  breaks,
  open_right = NULL,
  interpret_fail = c("error", "warn", "silent")
)
```

## Arguments

- labels:

  Vector of age group labels.

- breaks:

  Boundaries between age groups. A numeric vector.

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

## See also

- [`age_modify_five()`](https://bayesiandemography.github.io/agetime/reference/age_modify_five.md)
  Convert to 5-year age groups

- [`age_modify_ten()`](https://bayesiandemography.github.io/agetime/reference/age_modify_five.md)
  Convert to 10-year age groups

- [`age_modify_life()`](https://bayesiandemography.github.io/agetime/reference/age_modify_five.md)
  Convert to life table age groups

- [`period_modify()`](https://bayesiandemography.github.io/agetime/reference/period_modify.md)
  Period equivalent of `age_modify()`

- [`cohort_modify()`](https://bayesiandemography.github.io/agetime/reference/cohort_modify.md)
  Cohort equivalent of `age_modify()`

## Examples

``` r
labels <- c("10-14", "16", "22-23")
age_modify(labels, breaks = c(10, 15, 25))
#> [1] 10-14 15-24 15-24
#> Levels: 10-14 15-24

## open_right inferred from labels
labels_no_open <- c("1-4", "87-89", "0", "50-54")
age_modify(labels_no_open, breaks = c(0, 10, 40, 90))
#> [1] 0-9   40-89 0-9   40-89
#> Levels: 0-9 10-39 40-89
labels_has_open <- c("1-4", "87+", "0", "50-54")
age_modify(labels_has_open, breaks = c(0, 10, 40, 90))
#> Error in check_m_contains(m_contains = m_contains, label_type = label_type): label "87+" cannot each lie in exactly one new age group.
#> ℹ Make sure that every old age group lies in exactly one new age group?

## open_right specified
age_modify(
  labels_no_open,
  breaks = c(0, 10, 40, 90),
  open_right = TRUE
)
#> [1] 0-9   40-89 0-9   40-89
#> Levels: 0-9 10-39 40-89 90+
```
