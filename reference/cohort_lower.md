# Lower Limits, Upper Limits, Widths, and Midpoints of Cohorts

Calculate lower limits, upper limits, widths, and midpoints for cohorts.

## Usage

``` r
cohort_lower(
  x,
  x_one = c("lower", "upper"),
  x_multi = c("include", "exclude"),
  x_fail = c("error", "warn", "silent")
)

cohort_mid(
  x,
  x_one = c("lower", "upper"),
  x_multi = c("include", "exclude"),
  x_fail = c("error", "warn", "silent")
)

cohort_upper(
  x,
  x_one = c("lower", "upper"),
  x_multi = c("include", "exclude"),
  x_fail = c("error", "warn", "silent")
)

cohort_width(
  x,
  x_one = c("lower", "upper"),
  x_multi = c("include", "exclude"),
  x_fail = c("error", "warn", "silent")
)
```

## Arguments

- x:

  Vector of cohort labels.

- x_one:

  Whether labels for one-year cohorts are based on lower or upper limit
  of period. Default is `"lower"`.

- x_multi:

  Whether labels for multi-year periods include or exclude final year of
  period. Default is `"include"`.

- x_fail:

  Action if element of `x` cannot be parsed: `"error"` (the default),
  `"warn"`, or `"silent"`.

## Value

Numeric vector with the same length as `x`.

## Details

Lower and upper limits can be used to filter on cohorts. See below for
examples.

## See also

- [`parsing_cohort_labels()`](https://bayesiandemography.github.io/agetime/reference/parsing_cohort_labels.md)
  Details for `x_one`, `x_multi`, and `x_fail`

- [`age_lower()`](https://bayesiandemography.github.io/agetime/reference/age_lower.md)
  Age equivalent of `cohort_lower()`

- [`period_lower()`](https://bayesiandemography.github.io/agetime/reference/period_lower.md)
  Period equivalent of `cohort_lower()`

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

## 'x_one' is "lower" (the default)
cohort_lower("2025")
#> 2025 
#> 2025 
cohort_upper("2025")
#> 2025 
#> 2026 
cohort_width("2025")
#> 2025 
#>    1 

## 'x_one' is "upper"
cohort_lower("2025", x_one = "upper")
#> 2025 
#> 2024 
cohort_upper("2025", x_one = "upper")
#> 2025 
#> 2025 
cohort_width("2025", x_one = "upper")
#> 2025 
#>    1 

## 'x_multi' is "include" (the default)
cohort_upper("2025-2030")
#> 2025-2030 
#>      2030 
cohort_width("2025-2030")
#> 2025-2030 
#>         5 

## 'x_multi' is "exclude"
cohort_upper("2025-2030", x_multi = "exclude")
#> 2025-2030 
#>      2031 
cohort_width("2025-2030", x_multi = "exclude")
#> 2025-2030 
#>         6 

## no action when 'x_fail' is "silent"
cohort_lower(c("2000-2005", "long time ago"),
             x_fail = "silent")
#>   2000-2005 longtimeago 
#>        2000          NA 
```
