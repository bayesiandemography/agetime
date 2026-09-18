# Coarsen Periods to a Target Classification

Recode period labels so they match a second set of labels.

## Usage

``` r
period_coarsen_to(
  labels,
  to,
  interpret_single = c("lower", "upper"),
  interpret_multi = c("include", "exclude"),
  interpret_fail = c("error", "warn", "silent")
)
```

## Arguments

- labels:

  Vector of period labels.

- to:

  Vector of period labels giving the target classification.

- interpret_single:

  How to interpret labels for single-year periods. Choices are `"lower"`
  (the default) and `"upper"`. See below for details.

- interpret_multi:

  How to interpret labels for multi-year periods. Choices are
  `"include"` (the default) and `"exclude"`. See below for details.

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

## Rules for interpreting inputs

Single-year periods:

|                    |                  |                         |
|--------------------|------------------|-------------------------|
| `interpret_single` | *Rule*           | *Example*               |
| `"lower"`          | `"a" -> [a,a+1)` | `"2020" -> [2020,2021)` |
| `"upper"`          | `"a" -> [a-1,a)` | `"2020" -> [2019,2020)` |

Data providers typically use the "lower" convention for calendar years
(1 January to 31 December), and the "upper" convention for non-calendar
years (e.g., 1 July to 30 June).

Multi-year periods:

|                   |                          |                              |
|-------------------|--------------------------|------------------------------|
| `interpret_multi` | *Rule*                   | *Example*                    |
| `"include"`       | `"a-<a+n>" -> [a,a+n)`   | `"2020-2025" -> [2020,2025)` |
| `"exclude"`       | `"a-<a+n-1>" -> [a,a+n)` | `"2020-2024" -> [2020,2025)` |

A two-value label cannot describe a one-year period. With
`interpret_multi = "include"`, `"2010-2011"` would be `[2010, 2011)` and
`"2010-2010"` would be empty; both are rejected. Use `"2010"`, or
`"2010-2012"` for two years. With `interpret_multi = "exclude"`,
`"2010-2011"` is two years `[2010, 2012)` and is accepted.

## See also

- [`period_coarsen()`](https://bayesiandemography.github.io/agetime/reference/period_coarsen.md)
  Coarsen using break points

- [`period_mapping()`](https://bayesiandemography.github.io/agetime/reference/period_mapping.md)
  Inspect the relationship between two sets of labels

- [`age_coarsen_to()`](https://bayesiandemography.github.io/agetime/reference/age_coarsen_to.md)
  Age equivalent of `period_coarsen_to()`

- [`cohort_coarsen_to()`](https://bayesiandemography.github.io/agetime/reference/cohort_coarsen_to.md)
  Cohort equivalent of `period_coarsen_to()`

## Examples

``` r
labels <- c("2020", "2021", "2025")
to <- c("2020-2025", "2025-2030")
period_coarsen_to(labels, to)
#> [1] 2020-2025 2020-2025 2025-2030
#> Levels: 2020-2025 2025-2030

## unused labels in `to` are kept as levels
period_coarsen_to(c("2020", "2021"), to)
#> [1] 2020-2025 2020-2025
#> Levels: 2020-2025 2025-2030
```
