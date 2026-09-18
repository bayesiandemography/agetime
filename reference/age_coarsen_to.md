# Coarsen Age Groups to a Target Classification

Recode age group labels so they match a second set of labels.

## Usage

``` r
age_coarsen_to(labels, to, interpret_fail = c("error", "warn", "silent"))
```

## Arguments

- labels:

  Vector of age group labels.

- to:

  Vector of age group labels giving the target classification.

- interpret_fail:

  Action if an element of `labels` or `to` cannot be interpreted.
  Choices are `"error"` (the default), `"warn"`, and `"silent"`.

## Value

Factor with the same length as `labels`.

## Details

Every interval in `labels` must lie in exactly one interval in `to`.
Intervals in `to` must not overlap. Gaps in `to` are allowed, provided
that no intervals in `labels` fall within them.

If `labels` is a factor, its levels are modified along with its
elements. The return value is always a factor. Levels are the unique
labels in `to`, including unused labels.

## See also

- [`age_coarsen()`](https://bayesiandemography.github.io/agetime/reference/age_coarsen.md)
  Coarsen using break points

- [`age_mapping()`](https://bayesiandemography.github.io/agetime/reference/age_mapping.md)
  Inspect the relationship between two sets of labels

- [`period_coarsen_to()`](https://bayesiandemography.github.io/agetime/reference/period_coarsen_to.md)
  Period equivalent of `age_coarsen_to()`

- [`cohort_coarsen_to()`](https://bayesiandemography.github.io/agetime/reference/cohort_coarsen_to.md)
  Cohort equivalent of `age_coarsen_to()`

## Examples

``` r
labels <- c("0", "1", "5", "10", "11")
to <- c("0-4", "5-9", "10-14")
age_coarsen_to(labels, to)
#> [1] 0-4   0-4   5-9   10-14 10-14
#> Levels: 0-4 5-9 10-14

## unused labels in `to` are kept as levels
age_coarsen_to(c("0", "1"), to)
#> [1] 0-4 0-4
#> Levels: 0-4 5-9 10-14
```
