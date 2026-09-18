# Coarsen to Specialised Age Groups

Define new age groups that contain existing age groups and that follow a
regular pattern:

- `age_coarsen_five()` Five-year age groups

- `age_coarsen_ten()` Ten-year age groups

- `age_coarsen_life()` Age groups used in abridged life tables

## Usage

``` r
age_coarsen_five(
  labels,
  open_right = NULL,
  interpret_fail = c("error", "warn", "silent")
)

age_coarsen_ten(
  labels,
  open_right = NULL,
  interpret_fail = c("error", "warn", "silent")
)

age_coarsen_life(
  labels,
  open_right = NULL,
  interpret_fail = c("error", "warn", "silent")
)
```

## Arguments

- labels:

  Vector of age group labels.

- open_right:

  Whether to include an age group that is open on the right. Optional.
  See below for details.

- interpret_fail:

  Action if element of `labels` cannot be interpreted. Choices are
  `"error"` (the default), `"warn"`, and `"silent"`.

## Value

Character vector or factor with the same length as `labels`.

## Details

The new age groups cannot split existing age groups.

If `labels` is a factor, its levels are modified along with its
elements.

## Abridged and complete life tables

- An abridged life table uses age groups `"0"` and `"1-4"`, followed by
  5-year age groups such as `"5-9"` and `"10-14"`.

- A complete life table uses single-year age groups such as `"0"`,
  `"1"`, and `"2"`.

- Both types of life table usually have an open age group such as
  `"85+"` or `"100+"`.

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

- [`age_coarsen()`](https://bayesiandemography.github.io/agetime/reference/age_coarsen.md)
  Coarsen to general age groups

- [`age_coarsen_to()`](https://bayesiandemography.github.io/agetime/reference/age_coarsen_to.md)
  Coarsen to an existing set of labels

- [`period_coarsen_five()`](https://bayesiandemography.github.io/agetime/reference/period_coarsen_five.md)
  Period equivalent of `age_coarsen_five()`

- [`period_coarsen_ten()`](https://bayesiandemography.github.io/agetime/reference/period_coarsen_five.md)
  Period equivalent of `age_coarsen_ten()`

- [`cohort_coarsen_five()`](https://bayesiandemography.github.io/agetime/reference/cohort_coarsen_five.md)
  Cohort equivalent of `age_coarsen_five()`

- [`cohort_coarsen_ten()`](https://bayesiandemography.github.io/agetime/reference/cohort_coarsen_five.md)
  Cohort equivalent of `age_coarsen_ten()`

- [`age_fill()`](https://bayesiandemography.github.io/agetime/reference/age_fill.md)
  Add levels for intermediate age groups

## Examples

``` r
labels <- c("1-3", "16-19", "0", "31+", "total", "22")
age_coarsen_five(labels)
#> [1] "0-4"   "15-19" "0-4"   "30+"   "Total" "20-24"
age_coarsen_ten(labels)
#> [1] "0-9"   "10-19" "0-9"   "30+"   "Total" "20-29"
age_coarsen_life(labels)
#> [1] "1-4"   "15-19" "0"     "30+"   "Total" "20-24"

labels_no_open <- c("1-3", "16-19", "0", "total", "22")
age_coarsen_five(labels_no_open)
#> [1] "0-4"   "15-19" "0-4"   "Total" "20-24"
age_coarsen_five(labels_no_open, open_right = TRUE)
#> [1] "0-4"   "15-19" "0-4"   "Total" "20+"  
```
