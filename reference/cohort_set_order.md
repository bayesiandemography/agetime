# Set Order of Cohort Levels

Modify the `levels` attribute of `labels` so that cohorts are ordered by
their lower limits.

## Usage

``` r
cohort_set_order(
  labels,
  decreasing = FALSE,
  interpret_single = c("lower", "upper"),
  interpret_multi = c("include", "exclude"),
  interpret_fail = c("error", "warn", "silent")
)
```

## Arguments

- labels:

  Vector of cohort labels.

- decreasing:

  Whether order is increasing or decreasing. Default is `FALSE`.

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

## Details

If `labels` is not a factor, and so does not have levels, it is
converted to a factor before the ordering is performed.

`cohort_set_order()` has no effect on the values of `labels`. Only the
levels are changed.

When two cohorts have the same lower limit, the cohort with the smallest
upper limit comes first. Labels for missing values come second-to-last
in the ordering, and totals come last.

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

- [`age_set_order()`](https://bayesiandemography.github.io/agetime/reference/age_set_order.md)
  Age equivalent of `cohort_set_order()`

- [`period_set_order()`](https://bayesiandemography.github.io/agetime/reference/period_set_order.md)
  Period equivalent of `cohort_set_order()`

## Examples

``` r
labels <- c("2020-2025", "<1990", "Total", NA, "2025-2050")
cohort_set_order(labels)
#> [1] 2020-2025 <1990     Total     <NA>      2025-2050
#> Levels: <1990 2020-2025 2025-2050 <NA> Total
```
