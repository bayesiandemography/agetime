# Specify Open Cohort

Define a factor level representing an open cohort. Replace existing
cohorts where necessary.

- `cohort_set_open_left()` defines a cohort with no lower limit.

- `cohort_set_open_right()` defines a cohort with no upper limit.

## Usage

``` r
cohort_set_open_left(
  labels,
  at,
  interpret_single = c("lower", "upper"),
  interpret_multi = c("include", "exclude"),
  interpret_fail = c("error", "warn", "silent")
)

cohort_set_open_right(
  labels,
  at,
  interpret_single = c("lower", "upper"),
  interpret_multi = c("include", "exclude"),
  interpret_fail = c("error", "warn", "silent")
)
```

## Arguments

- labels:

  Vector of cohort labels.

- at:

  Point at which intervals become open, e.g. `2020` in `<2020` or `2030`
  in `2030+`.

- interpret_single:

  How to interpret labels for single-year cohorts. Choices are `"lower"`
  (the default) and `"upper"`. See below for details.

- interpret_multi:

  How to interpret labels for multi-year cohorts. Choices are
  `"include"` (the default) and `"exclude"`. See below for details.

- interpret_fail:

  Action if element of `labels` cannot be interpreted. Choices are
  `"error"` (the default), `"warn"`, and `"silent"`.

## Value

Factor with the same length as `labels`.

## Rules for interpreting inputs

Single-year cohorts:

|                    |                  |                         |
|--------------------|------------------|-------------------------|
| `interpret_single` | *Rule*           | *Example*               |
| `"lower"`          | `"a" -> [a,a+1)` | `"2020" -> [2020,2021)` |
| `"upper"`          | `"a" -> [a-1,a)` | `"2020" -> [2019,2020)` |

Data providers typically use the "lower" convention for calendar years
(1 January to 31 December), and the "upper" convention for non-calendar
years (e.g., 1 July to 30 June).

Multi-year cohorts:

|                   |                          |                              |
|-------------------|--------------------------|------------------------------|
| `interpret_multi` | *Rule*                   | *Example*                    |
| `"include"`       | `"a-<a+n>" -> [a,a+n)`   | `"2020-2025" -> [2020,2025)` |
| `"exclude"`       | `"a-<a+n-1>" -> [a,a+n)` | `"2020-2024" -> [2020,2025)` |

A two-value label cannot describe a one-year cohort. With
`interpret_multi = "include"`, `"2010-2011"` would be `[2010, 2011)` and
`"2010-2010"` would be empty; both are rejected. Use `"2010"`, or
`"2010-2012"` for two years. With `interpret_multi = "exclude"`,
`"2010-2011"` is two years `[2010, 2012)` and is accepted.

## See also

- [`age_set_open_right()`](https://bayesiandemography.github.io/agetime/reference/age_set_open_right.md)
  Specify age group open on right

- [`period_set_open_left()`](https://bayesiandemography.github.io/agetime/reference/period_set_open_left.md)
  Specify period open on left

- [`period_set_open_right()`](https://bayesiandemography.github.io/agetime/reference/period_set_open_left.md)
  Specify period open on right

- [`cohort_is_open_left()`](https://bayesiandemography.github.io/agetime/reference/cohort_is_open_left.md)
  Identify cohorts open on left

- [`cohort_is_open_right()`](https://bayesiandemography.github.io/agetime/reference/cohort_is_open_left.md)
  Identify cohorts open on right

## Examples

``` r
labels <- c("2020-2024", "<2000", "2015")
cohort_set_open_left(labels, at = 2020)
#> [1] 2020-2024 <2020     <2020    
#> Levels: <2020 2020-2024
cohort_set_open_left(labels, at = 2005)
#> [1] 2020-2024 <2005     2015     
#> Levels: <2005 2015 2020-2024
cohort_set_open_left(c("2000-2004", "2010-2014"), at = 1990)
#> [1] 2000-2004 2010-2014
#> Levels: <1990 2000-2004 2010-2014

labels <- c("2020-2024", "2025-2029", "2030")
cohort_set_open_right(labels, at = 2030)
#> [1] 2020-2024 2025-2029 2030+    
#> Levels: 2020-2024 2025-2029 2030+
```
