# Identify Periods With No Lower Limit or No Upper Limit

Find periods that are open on the left or right.

## Usage

``` r
period_is_open_left(
  labels,
  interpret_single = c("lower", "upper"),
  interpret_multi = c("include", "exclude"),
  interpret_fail = c("error", "warn", "silent")
)

period_is_open_right(
  labels,
  interpret_single = c("lower", "upper"),
  interpret_multi = c("include", "exclude"),
  interpret_fail = c("error", "warn", "silent")
)
```

## Arguments

- labels:

  Vector of period labels.

- interpret_single:

  How to interpret labels for single-year periods. Choices are `"lower"`
  (the default) and `"upper"`. See below for details.

- interpret_multi:

  How to interpret labels for multi-year periods. Choices are
  `"include"` (the default) and `"exclude"`. See below for details.

- interpret_fail:

  Action if element of `labels` cannot be interpreted. Choices are
  `"error"` (the default), `"warn"`, and `"silent"`.

## Value

Logical vector with the same length as `labels`.

## Details

- `period_is_open_left()` finds periods open on the left (has no lower
  limit).

- `period_is_open_right()` finds periods open on the right (has no upper
  limit).

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

- [`age_is_open_right()`](https://bayesiandemography.github.io/agetime/reference/age_is_open_right.md)
  Identify age groups open on right

- [`cohort_is_open_left()`](https://bayesiandemography.github.io/agetime/reference/cohort_is_open_left.md)
  Identify cohorts open on left

- [`cohort_is_open_right()`](https://bayesiandemography.github.io/agetime/reference/cohort_is_open_left.md)
  Identify cohorts open on right

- [`period_is_total()`](https://bayesiandemography.github.io/agetime/reference/period_is_total.md)
  Identify period totals

- [`period_is_missing()`](https://bayesiandemography.github.io/agetime/reference/period_is_missing.md)
  Identify missing period labels

- [`period_set_open_left()`](https://bayesiandemography.github.io/agetime/reference/period_set_open_left.md)
  Specify period open on left

- [`period_set_open_right()`](https://bayesiandemography.github.io/agetime/reference/period_set_open_left.md)
  Specify period open on right

## Examples

``` r
labels <- c("2020", "<1900", "2020-2030", "2000 or more", "2030+")
period_is_open_left(labels)
#>         2020        <1900    2020-2030 2000 or more        2030+ 
#>        FALSE         TRUE        FALSE        FALSE        FALSE 
period_is_open_right(labels)
#>         2020        <1900    2020-2030 2000 or more        2030+ 
#>        FALSE        FALSE        FALSE         TRUE         TRUE 
```
