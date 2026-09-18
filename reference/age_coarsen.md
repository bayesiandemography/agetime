# Coarsen Age Groups

Define new age groups that contain existing age groups.

## Usage

``` r
age_coarsen(
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

  Whether to include an age group that is open on the right. Optional.
  See below for details.

- interpret_fail:

  Action if element of `labels` cannot be interpreted. Choices are
  `"error"` (the default), `"warn"`, and `"silent"`.

## Value

Factor with the same length as `labels`.

## Details

The new age groups cannot split existing age groups, and are typically
wider than the existing age groups.

If `labels` is a factor, its levels are modified along with its
elements.

## The `open_right` argument

An age group is open on the right if it has no upper limit, e.g.
`"100+"`.

By default, the return value has an open age group if and only if
`labels` does. The full range of options is:

|                  |                            |                                |
|------------------|----------------------------|--------------------------------|
| `open_right`     | `labels` has open on right | Return value has open on right |
| `NULL` (default) | Yes                        | Yes                            |
| `NULL` (default) | No                         | No                             |
| `TRUE`           | Yes                        | Yes                            |
| `TRUE`           | No                         | Yes                            |
| `FALSE`          | Yes                        | *Error*                        |
| `FALSE`          | No                         | No                             |

## See also

- [`age_coarsen_to()`](https://bayesiandemography.github.io/agetime/reference/age_coarsen_to.md)
  Coarsen to an existing set of labels

- [`age_coarsen_five()`](https://bayesiandemography.github.io/agetime/reference/age_coarsen_five.md)
  Coarsen to 5-year age groups

- [`age_coarsen_ten()`](https://bayesiandemography.github.io/agetime/reference/age_coarsen_five.md)
  Coarsen to 10-year age groups

- [`age_coarsen_life()`](https://bayesiandemography.github.io/agetime/reference/age_coarsen_five.md)
  Coarsen to life table age groups

- [`period_coarsen()`](https://bayesiandemography.github.io/agetime/reference/period_coarsen.md)
  Period equivalent of `age_coarsen()`

- [`cohort_coarsen()`](https://bayesiandemography.github.io/agetime/reference/cohort_coarsen.md)
  Cohort equivalent of `age_coarsen()`

## Examples

``` r
labels <- c("10-14", "16", "22-23")
age_coarsen(labels, breaks = c(10, 15, 25))
#> [1] 10-14 15-24 15-24
#> Levels: 10-14 15-24

## let inclusion of open age group depend on labels
labels_no_open <- c("1-4", "87-89", "0", "50-54")
age_coarsen(labels_no_open, breaks = c(0, 10, 40, 90))
#> [1] 0-9   40-89 0-9   40-89
#> Levels: 0-9 10-39 40-89
labels_has_open <- c("1-4", "87+", "0", "50-54")
age_coarsen(labels_has_open, breaks = c(0, 10, 40, 87))
#> [1] 0-9   87+   0-9   40-86
#> Levels: 0-9 10-39 40-86 87+

## insist on an open age group
age_coarsen(
  labels_no_open,
  breaks = c(0, 10, 40, 90),
  open_right = TRUE
)
#> [1] 0-9   40-89 0-9   40-89
#> Levels: 0-9 10-39 40-89 90+
```
