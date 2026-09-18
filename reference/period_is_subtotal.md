# Identify Period Labels for Subtotals

Find categories representing subtotals in period labels.

## Usage

``` r
period_is_subtotal(
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

A subtotal is a label representing the same interval as two or more
smaller intervals in the same set. For example, in
`c("2020-2025", "2025-2030", "2030-2035", "2020-2030", "Total")`,
`"2020-2030"` is a subtotal because it represents the same interval as
`"2020-2025"` and `"2025-2030"`.

Subtotals are distinct from grand total labels such as `"Total"` or
`"All"`, which are identified by
[`period_is_total()`](https://bayesiandemography.github.io/agetime/reference/period_is_total.md).

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

- [`age_is_subtotal()`](https://bayesiandemography.github.io/agetime/reference/age_is_subtotal.md)
  Age equivalent of `period_is_subtotal()`

- [`cohort_is_subtotal()`](https://bayesiandemography.github.io/agetime/reference/cohort_is_subtotal.md)
  Cohort equivalent of `period_is_subtotal()`

- [`period_is_total()`](https://bayesiandemography.github.io/agetime/reference/period_is_total.md)
  Identify grand totals

- [`period_is_missing()`](https://bayesiandemography.github.io/agetime/reference/period_is_missing.md)
  Identify missing period labels

- [`period_is_open_left()`](https://bayesiandemography.github.io/agetime/reference/period_is_open_left.md)
  Identify periods open on left

- [`period_is_open_right()`](https://bayesiandemography.github.io/agetime/reference/period_is_open_left.md)
  Identify periods open on right

## Examples

``` r
labels <- c(
  period_labels_five(lower_first = 2000, lower_last = 2035),
  "2000-2015",
  "2015-2040",
  "Total"
)
period_is_subtotal(labels)
#> 2000-2005 2005-2010 2010-2015 2015-2020 2020-2025 2025-2030 2030-2035 2035-2040 
#>     FALSE     FALSE     FALSE     FALSE     FALSE     FALSE     FALSE     FALSE 
#> 2000-2015 2015-2040     Total 
#>      TRUE      TRUE     FALSE 
period_is_total(labels)
#> 2000-2005 2005-2010 2010-2015 2015-2020 2020-2025 2025-2030 2030-2035 2035-2040 
#>     FALSE     FALSE     FALSE     FALSE     FALSE     FALSE     FALSE     FALSE 
#> 2000-2015 2015-2040     Total 
#>     FALSE     FALSE      TRUE 

## subtotals must fully cover range
labels_no_2020_2025 <- setdiff(labels, "2020-2025")
period_is_subtotal(labels_no_2020_2025) ## "2015-2040" not subtotal
#> 2000-2005 2005-2010 2010-2015 2015-2020 2025-2030 2030-2035 2035-2040 2000-2015 
#>     FALSE     FALSE     FALSE     FALSE     FALSE     FALSE     FALSE      TRUE 
#> 2015-2040     Total 
#>     FALSE     FALSE 

## subtotals can overlap
labels_2000_2040 <- c(labels, "2000-2040")
period_is_subtotal(labels_2000_2040)
#> 2000-2005 2005-2010 2010-2015 2015-2020 2020-2025 2025-2030 2030-2035 2035-2040 
#>     FALSE     FALSE     FALSE     FALSE     FALSE     FALSE     FALSE     FALSE 
#> 2000-2015 2015-2040     Total 2000-2040 
#>      TRUE      TRUE     FALSE      TRUE 

## use to filter data
library(dplyr, warn.conflicts = FALSE)
df <- data.frame(
  period = c("2020-2025", "2025-2030", "2030-2035", "2020-2035"),
  value = c(100, 200, 300, 400)
)
df |>
  filter(!period_is_subtotal(period))
#>      period value
#> 1 2020-2025   100
#> 2 2025-2030   200
#> 3 2030-2035   300
```
