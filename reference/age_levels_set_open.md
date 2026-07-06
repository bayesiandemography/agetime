# Set Open Age Group Level

Add an open age group level, i.e. an age group with no upper limit.
Replace existing age groups where necessary.

## Usage

``` r
age_levels_set_open(
  labels,
  lower_open,
  interpret_fail = c("error", "warn", "silent")
)
```

## Arguments

- labels:

  Vector of age group labels.

- lower_open:

  Lower limit of open age group.

- interpret_fail:

  Action if element of `labels` cannot be interpreted. Choices are
  `"error"` (the default), `"warn"`, and `"silent"`.

## Value

Factor with the same length as `labels`.

## See also

- [`cohort_levels_set_open()`](https://bayesiandemography.github.io/agetime/reference/cohort_levels_set_open.md)
  Set open cohort levels (left-open)

## Examples

``` r
labels <- c("20-24", "80-84", "100+")
age_levels_set_open(labels, lower_open = 80)
#> [1] 20-24 80+   80+  
#> Levels: 20-24 80+
age_levels_set_open(labels, lower_open = 50)
#> [1] 20-24 50+   50+  
#> Levels: 20-24 50+
age_levels_set_open(c("0-4", "60-64"), lower_open = 70)
#> [1] 0-4   60-64
#> Levels: 0-4 60-64 70+
```
