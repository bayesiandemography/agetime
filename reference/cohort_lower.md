# Limits, Widths, and Midpoints from Cohort Labels

Calculate lower limits, upper limits, widths, and midpoints for cohorts.

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

## Controlling how cohort labels are interpreted

If `interpret_single` is `"lower"` (the default), then labels for
single-year cohorts are assumed to refer to lower limits, so that
`"2025"` means `[2025,2026)`. This is the convention that data providers
typically use for calendar years.

If `interpret_single` is `"upper"`, then labels for single-year cohorts
are assumed to refer to upper limits, so that `"2025"` means
`[2024,2025)`. This is the convention that data providers typically use
for non-calendar years, such as 1 July to 30 June.

If `interpret_multi` is `"include"` (the default), then labels for
multi-year cohorts are assumed to include upper limits, so that
`"2025-2030"` means `[2025,2030)`.

If `interpret_multi` is `"exclude"`, then labels for multi-year cohorts
are assumed to exclude the upper limits so that `"2025-2030"` means
`[2025,2031)`.

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
cohort_lower(c("2000-2005", "long time ago"),
  interpret_fail = "silent"
)
#>   2000-2005 longtimeago 
#>        2000          NA 
```
