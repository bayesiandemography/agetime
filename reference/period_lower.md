# Limits, Widths, and Midpoints from Period Labels

Calculate lower limits, upper limits, widths, and midpoints for periods.

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

## Controlling how period labels are interpreted

If `interpret_single` is `"lower"` (the default), then labels for
single-year periods are assumed to refer to lower limits, so that
`"2025"` means `[2025,2026)`. This is the convention that data providers
typically use for calendar years.

If `interpret_single` is `"upper"`, then labels for single-year periods
are assumed to refer to upper limits, so that `"2025"` means
`[2024,2025)`. This is the convention that data providers typically use
for non-calendar years, such as 1 July to 30 June.

If `interpret_multi` is `"include"` (the default), then labels for
multi-year periods are assumed to include upper limits, so that
`"2025-2030"` means `[2025,2030)`.

If `interpret_multi` is `"exclude"`, then labels for multi-year periods
are assumed to exclude the upper limits, so that `"2025-2030"` means
`[2025,2031)`.

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
period_lower(c("2000-2005", "long time ago"),
  interpret_fail = "silent"
)
#>   2000-2005 longtimeago 
#>        2000          NA 
```
