# Lower Limits, Upper Limits, Widths, and Midpoints of Periods

Calculate lower limits, upper limits, widths, and midpoints for periods.

## Usage

``` r
period_lower(
  x,
  x_one = c("lower", "upper"),
  x_multi = c("include", "exclude"),
  x_fail = c("error", "warn", "silent")
)

period_mid(
  x,
  x_one = c("lower", "upper"),
  x_multi = c("include", "exclude"),
  x_fail = c("error", "warn", "silent")
)

period_upper(
  x,
  x_one = c("lower", "upper"),
  x_multi = c("include", "exclude"),
  x_fail = c("error", "warn", "silent")
)

period_width(
  x,
  x_one = c("lower", "upper"),
  x_multi = c("include", "exclude"),
  x_fail = c("error", "warn", "silent")
)
```

## Arguments

- x:

  Vector of period labels.

- x_one:

  How to interpret labels in `x` that describe one-year periods. Choices
  are `"lower"` (the default) and `"upper"`.

- x_multi:

  How to interpret labels in `x` that describe multi-year periods.
  Choices are `"include"` (the default) and `"exclude"`.

- x_fail:

  Action if element of `x` cannot be parsed: `"error"` (the default),
  `"warn"`, or `"silent"`.

## Value

Numeric vector with the same length as `x`.

## Details

Lower and upper limits can be used to filter on periods. See below for
examples.

## See also

- [`parsing_period_labels()`](https://bayesiandemography.github.io/agetime/reference/parsing_period_labels.md)
  Details for `x_one`, `x_multi`, and `x_fail`

- [`age_lower()`](https://bayesiandemography.github.io/agetime/reference/age_lower.md)
  Age equivalent of `period_lower()`

- [`cohort_lower()`](https://bayesiandemography.github.io/agetime/reference/cohort_lower.md)
  Cohort equivalent of `period_lower()`

## Examples

``` r
x <- c("2025-2030", "2020-2025", "2030-2035")
period_lower(x)
#> 2025-2030 2020-2025 2030-2035 
#>      2025      2020      2030 
period_upper(x)
#> 2025-2030 2020-2025 2030-2035 
#>      2030      2025      2035 
period_width(x)
#> 2025-2030 2020-2025 2030-2035 
#>         5         5         5 
period_mid(x)
#> 2025-2030 2020-2025 2030-2035 
#>    2027.5    2022.5    2032.5 

## use 'period_lower()' to filter on period
library(dplyr, warn.conflicts = FALSE)
df <- tribble(    ~period, ~count,
              "2020-2025",     20,
              "2025-2030",      5,
              "2030-2035",     11 )
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

## 'x_one' is "lower" (the default)
period_lower("2025")
#> 2025 
#> 2025 
period_upper("2025")
#> 2025 
#> 2026 
period_width("2025")
#> 2025 
#>    1 

## 'x_one' is "upper"
period_lower("2025", x_one = "upper")
#> 2025 
#> 2024 
period_upper("2025", x_one = "upper")
#> 2025 
#> 2025 
period_width("2025", x_one = "upper")
#> 2025 
#>    1 

## 'x_multi' is "include" (the default)
period_upper("2025-2030")
#> 2025-2030 
#>      2030 
period_width("2025-2030")
#> 2025-2030 
#>         5 

## 'x_multi' is "exclude"
period_upper("2025-2030", x_multi = "exclude")
#> 2025-2030 
#>      2031 
period_width("2025-2030", x_multi = "exclude")
#> 2025-2030 
#>         6 

## no action when 'x_fail' is "silent"
period_lower(c("2000-2005", "long time ago"),
             x_fail = "silent")
#>   2000-2005 longtimeago 
#>        2000          NA 
```
