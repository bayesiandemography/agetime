# Identify Cohort Labels for Totals

Find categories representing totals in cohort labels.

## Usage

``` r
cohort_is_total(
  labels,
  interpret_single = c("lower", "upper"),
  interpret_multi = c("include", "exclude"),
  interpret_fail = c("error", "warn", "silent")
)
```

## Arguments

- labels:

  Vector of cohort labels.

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

Logical vector with the same length as `labels`.

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

- [`cohort_is_open_left()`](https://bayesiandemography.github.io/agetime/reference/cohort_is_open_left.md)
  Identify cohorts open on left

- [`cohort_is_open_right()`](https://bayesiandemography.github.io/agetime/reference/cohort_is_open_left.md)
  Identify cohorts open on right

- [`age_is_total()`](https://bayesiandemography.github.io/agetime/reference/age_is_total.md)
  Age equivalent of `cohort_is_total()`

- [`period_is_total()`](https://bayesiandemography.github.io/agetime/reference/period_is_total.md)
  Period equivalent of `cohort_is_total()`

- [`cohort_is_subtotal()`](https://bayesiandemography.github.io/agetime/reference/cohort_is_subtotal.md)
  Identify subtotals

- [`cohort_is_missing()`](https://bayesiandemography.github.io/agetime/reference/cohort_is_missing.md)
  Identify missing cohort labels

## Examples

``` r
labels <- c("2020-2025", "2025-2030", "2020-2035", "Total")
cohort_is_total(labels)
#> 2020-2025 2025-2030 2020-2035     Total 
#>     FALSE     FALSE     FALSE      TRUE 
cohort_is_subtotal(labels)
#> 2020-2025 2025-2030 2020-2035     Total 
#>     FALSE     FALSE     FALSE     FALSE 

labels <- c("2020-2025", "Total", "1999", "ALL")
cohort_is_total(labels)
#> 2020-2025     Total      1999       ALL 
#>     FALSE      TRUE     FALSE      TRUE 

## use to filter data
library(dplyr, warn.conflicts = FALSE)
df <- data.frame(
  cohort = c("2020-2025", "2025-2030", "2020-2035", "Total"),
  value = c(100, 200, 300, 400)
)
df |>
  filter(!cohort_is_total(cohort))
#>      cohort value
#> 1 2020-2025   100
#> 2 2025-2030   200
#> 3 2020-2035   300
```
