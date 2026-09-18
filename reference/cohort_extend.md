# Extend a Set of Cohort Labels

Add new equal-width cohort labels to the end of an existing set.

## Usage

``` r
cohort_extend(
  labels,
  n = 1L,
  width = NULL,
  include_x = TRUE,
  interpret_single = c("lower", "upper"),
  interpret_multi = c("include", "exclude"),
  interpret_fail = c("error", "warn", "silent")
)
```

## Arguments

- labels:

  Vector of cohort labels.

- n:

  Number of cohorts to add. Default is `1`.

- width:

  Width of the cohorts to be added.

- include_x:

  Should the return value include `labels`? Default is `TRUE`.

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

Character vector or factor.

## Details

By default, the width of the new cohorts is derived from the last
element of `labels`, but a value can be specified through the `width`
argument.

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

- [`age_extend()`](https://bayesiandemography.github.io/agetime/reference/age_extend.md)
  Age equivalent of `cohort_extend()`

- [`period_extend()`](https://bayesiandemography.github.io/agetime/reference/period_extend.md)
  Period equivalent of `cohort_extend()`

## Examples

``` r
labels <- c("2020-2025", "2025-2030")
cohort_extend(labels, n = 2)
#> [1] "2020-2025" "2025-2030" "2030-2035" "2035-2040"
cohort_extend(labels, n = 2, width = 10)
#> [1] "2020-2025" "2025-2030" "2030-2040" "2040-2050"
cohort_extend(labels, n = 2, include_x = FALSE)
#> [1] "2030-2035" "2035-2040"
```
