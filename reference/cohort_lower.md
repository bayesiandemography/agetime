# Limits, Widths, and Midpoints from Cohort Labels

Calculate lower limits, upper limits, widths, and midpoints from cohort
labels.

## Usage

``` r
cohort_lower(
  labels,
  interpret_single = c("lower", "upper"),
  interpret_multi = c("include", "exclude"),
  interpret_fail = c("error", "warn", "silent")
)

cohort_mid(
  labels,
  interpret_single = c("lower", "upper"),
  interpret_multi = c("include", "exclude"),
  interpret_fail = c("error", "warn", "silent")
)

cohort_upper(
  labels,
  interpret_single = c("lower", "upper"),
  interpret_multi = c("include", "exclude"),
  interpret_fail = c("error", "warn", "silent")
)

cohort_width(
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

Numeric vector with the same length as `labels`.

## Details

Lower and upper limits can be used to filter on cohorts. See below for
examples.

`cohort_mid()` assigns open cohorts (e.g., `"<2000"`) honorary
midpoints, which are useful for plotting. These midpoints use half the
median width of the closed intervals in `labels`.

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

## Examples

``` r
labels <- c("2025-2030", "<2025", "2030-2035")
cohort_lower(labels) # [2025, 2030)
#> 2025-2030     <2025 2030-2035 
#>      2025      -Inf      2030 
cohort_upper(labels) # [2024, 2030)
#> 2025-2030     <2025 2030-2035 
#>      2030      2025      2035 
cohort_width(labels) # 5
#> 2025-2030     <2025 2030-2035 
#>         5       Inf         5 
cohort_mid(labels) # 2027.5
#> 2025-2030     <2025 2030-2035 
#>    2027.5    2022.5    2032.5 
library(dplyr, warn.conflicts = FALSE)
df <- tribble(
  ~cohort, ~count,
  "2025-2030", 20,
  "<2025", 5,
  "2030-2035", 11
)
df
#> # A tibble: 3 × 2
#>   cohort    count
#>   <chr>     <dbl>
#> 1 2025-2030    20
#> 2 <2025         5
#> 3 2030-2035    11
df |> filter(cohort_lower(cohort) >= 2025)
#> # A tibble: 2 × 2
#>   cohort    count
#>   <chr>     <dbl>
#> 1 2025-2030    20
#> 2 2030-2035    11

## midpoint of open cohorts
cohort_mid(c("<2000", "2000-2010", "2010-2020")) # 1995
#>     <2000 2000-2010 2010-2020 
#>      1995      2005      2015 
cohort_mid(c("<2000", "2000-2005", "2005-2010")) # 1997.5
#>     <2000 2000-2005 2005-2010 
#>    1997.5    2002.5    2007.5 

## 'interpret_single' is "lower" (the default)
cohort_lower("2025")
#> 2025 
#> 2025 
cohort_upper("2025")
#> 2025 
#> 2026 
cohort_width("2025")
#> 2025 
#>    1 

## 'interpret_single' is "upper"
cohort_lower("2025", interpret_single = "upper")
#> 2025 
#> 2024 
cohort_upper("2025", interpret_single = "upper")
#> 2025 
#> 2025 
cohort_width("2025", interpret_single = "upper")
#> 2025 
#>    1 

## 'interpret_multi' is "include" (the default)
cohort_upper("2025-2030")
#> 2025-2030 
#>      2030 
cohort_width("2025-2030")
#> 2025-2030 
#>         5 

## 'interpret_multi' is "exclude"
cohort_upper("2025-2030", interpret_multi = "exclude")
#> 2025-2030 
#>      2031 
cohort_width("2025-2030", interpret_multi = "exclude")
#> 2025-2030 
#>         6 

## no action when 'interpret_fail' is "silent"
cohort_lower(
  labels = c("2000-2005", "long time ago"),
  interpret_fail = "silent"
)
#>     2000-2005 long time ago 
#>          2000            NA 
```
