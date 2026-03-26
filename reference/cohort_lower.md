# Lower Limits, Upper Limits, Widths, and Midpoints of Cohorts

Calculate lower limits, upper limits, widths, and midpoints for cohorts.

## Usage

``` r
cohort_lower(
  x,
  label_one = c("lower", "upper"),
  label_multi = c("include", "exclude"),
  unknown_label = c("error", "warn", "silent")
)

cohort_mid(
  x,
  label_one = c("lower", "upper"),
  label_multi = c("include", "exclude"),
  unknown_label = c("error", "warn", "silent")
)

cohort_upper(
  x,
  label_one = c("lower", "upper"),
  label_multi = c("include", "exclude"),
  unknown_label = c("error", "warn", "silent")
)

cohort_width(
  x,
  label_one = c("lower", "upper"),
  label_multi = c("include", "exclude"),
  unknown_label = c("error", "warn", "silent")
)
```

## Arguments

- x:

  A vector of cohort labels.

- label_one:

  Whether labels for one-year cohorts are based on the lower or upper
  limit of the period. Default is `"lower"`.

- label_multi:

  Whether labels for multi-year periods include or exclude the final
  year of the period. Default is `"include"`.

- unknown_label:

  Action if a label cannot be interpreted. Choices are `"error"` (the
  default), `"warn"`, and `"silent"`.

## Value

A numeric vector with same length as `x`.

## Details

Lower and upper limits can be used to filter on cohorts. See below for
examples.

## Examples

``` r
x <- c("2025-2030", "<2025", "2030-2035")
cohort_lower(x)
#> 2025-2030     <2025 2030-2035 
#>      2025      -Inf      2030 
cohort_upper(x)
#> 2025-2030     <2025 2030-2035 
#>      2030      2025      2035 
cohort_width(x)
#> 2025-2030     <2025 2030-2035 
#>         5       Inf         5 
cohort_mid(x)
#> 2025-2030     <2025 2030-2035 
#>    2027.5    2022.5    2032.5 

## use 'cohort_lower()' to filter on cohort
library(dplyr, warn.conflicts = FALSE)
df <- tribble(    ~cohort, ~count,
              "2025-2030",     20,
                  "<2025",      5,
              "2030-2035",     11 )
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

## 'label_one' is "lower" (the default)
cohort_lower("2025")
#> 2025 
#> 2025 
cohort_upper("2025")
#> 2025 
#> 2026 
cohort_width("2025")
#> 2025 
#>    1 

## 'label_one' is "upper"
cohort_lower("2025", label_one = "upper")
#> 2025 
#> 2024 
cohort_upper("2025", label_one = "upper")
#> 2025 
#> 2025 
cohort_width("2025", label_one = "upper")
#> 2025 
#>    1 

## 'label_multi' is "include" (the default)
cohort_lower("2025-2030")
#> 2025-2030 
#>      2025 
cohort_upper("2025-2030")
#> 2025-2030 
#>      2030 
cohort_width("2025-2030")
#> 2025-2030 
#>         5 

## 'label_multi' is "exclude"
cohort_lower("2025-2030", label_multi = "exclude")
#> 2025-2030 
#>      2025 
cohort_upper("2025-2030", label_multi = "exclude")
#> 2025-2030 
#>      2031 
cohort_width("2025-2030", label_multi = "exclude")
#> 2025-2030 
#>         6 

## no action when 'unknown_label' is "silent"
cohort_lower(c("2000-2005", "long time ago"),
             unknown_label = "silent")
#>   2000-2005 longtimeago 
#>        2000          NA 
```
