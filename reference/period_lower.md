# Limits, Widths, and Midpoints from Period Labels

Calculate lower limits, upper limits, widths, and midpoints from period
labels.

## Usage

``` r
period_lower(
  labels,
  interpret_single = c("lower", "upper"),
  interpret_multi = c("include", "exclude"),
  interpret_fail = c("error", "warn", "silent")
)

period_mid(
  labels,
  interpret_single = c("lower", "upper"),
  interpret_multi = c("include", "exclude"),
  interpret_fail = c("error", "warn", "silent")
)

period_upper(
  labels,
  interpret_single = c("lower", "upper"),
  interpret_multi = c("include", "exclude"),
  interpret_fail = c("error", "warn", "silent")
)

period_width(
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

Numeric vector with the same length as `labels`.

## Details

Lower and upper limits can be used to filter on periods. See below for
examples.

`period_mid()` assigns open periods (e.g., `"2025+"`) honorary
midpoints, which are useful for plotting. These midpoints use half the
median width of the closed intervals in `labels`.

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

- [`age_lower()`](https://bayesiandemography.github.io/agetime/reference/age_lower.md)
  Age equivalent of `period_lower()`

- [`cohort_lower()`](https://bayesiandemography.github.io/agetime/reference/cohort_lower.md)
  Cohort equivalent of `period_lower()`

## Examples

``` r
labels <- c("2025-2030", "2020-2025", "2030-2035")
period_lower(labels)
#> 2025-2030 2020-2025 2030-2035 
#>      2025      2020      2030 
period_upper(labels)
#> 2025-2030 2020-2025 2030-2035 
#>      2030      2025      2035 
period_width(labels)
#> 2025-2030 2020-2025 2030-2035 
#>         5         5         5 
period_mid(labels)
#> 2025-2030 2020-2025 2030-2035 
#>    2027.5    2022.5    2032.5 

## use 'period_lower()' to filter on period
library(dplyr, warn.conflicts = FALSE)
df <- tribble(
  ~period, ~count,
  "2020-2025", 20,
  "2025-2030", 5,
  "2030-2035", 11
)
df
#> # A tibble: 3 × 2
#>   period    count
#>   <chr>     <dbl>
#> 1 2020-2025    20
#> 2 2025-2030     5
#> 3 2030-2035    11
df |> filter(period_lower(period) >= 2025)
#> # A tibble: 2 × 2
#>   period    count
#>   <chr>     <dbl>
#> 1 2025-2030     5
#> 2 2030-2035    11

## midpoint of open periods
period_mid(c("2020-2030", "2030-2040", "2040+")) # 2045
#> 2020-2030 2030-2040     2040+ 
#>      2025      2035      2045 
period_mid(c("2020-2025", "2025-2030", "2030+")) # 2032.5
#> 2020-2025 2025-2030     2030+ 
#>    2022.5    2027.5    2032.5 

## 'interpret_single' is "lower" (the default)
period_lower("2025")
#> 2025 
#> 2025 
period_upper("2025")
#> 2025 
#> 2026 
period_width("2025")
#> 2025 
#>    1 

## 'interpret_single' is "upper"
period_lower("2025", interpret_single = "upper")
#> 2025 
#> 2024 
period_upper("2025", interpret_single = "upper")
#> 2025 
#> 2025 
period_width("2025", interpret_single = "upper")
#> 2025 
#>    1 

## 'interpret_multi' is "include" (the default)
period_upper("2025-2030")
#> 2025-2030 
#>      2030 
period_width("2025-2030")
#> 2025-2030 
#>         5 

## 'interpret_multi' is "exclude"
period_upper("2025-2030", interpret_multi = "exclude")
#> 2025-2030 
#>      2031 
period_width("2025-2030", interpret_multi = "exclude")
#> 2025-2030 
#>         6 

## no action when 'interpret_fail' is "silent"
period_lower(
  labels = c("2000-2005", "long time ago"),
  interpret_fail = "silent"
)
#>     2000-2005 long time ago 
#>          2000            NA 
```
