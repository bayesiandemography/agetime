# Lower Limits, Upper Limits, Widths, and Midpoints of Periods

Calculate lower limits, upper limits, widths, and midpoints for periods.

## Usage

``` r
period_lower(
  x,
  label_single = c("lower", "upper"),
  label_multi = c("include", "exclude")
)

period_upper(
  x,
  label_single = c("lower", "upper"),
  label_multi = c("include", "exclude")
)

period_width(
  x,
  label_single = c("lower", "upper"),
  label_multi = c("include", "exclude")
)

period_mid(
  x,
  label_single = c("lower", "upper"),
  label_multi = c("include", "exclude")
)
```

## Arguments

- x:

  A vector of age group labels.

- label_single:

  Whether labels for single-year periods are based on the lower or upper
  limit of the period. Default is \`"lower"\`.

- label_multi:

  Whether labels for multi-year periods include or exclude the final
  year of the period. Default is \`"include"\`.

## Value

A numeric vector with same length as \`x\`.

## Details

Lower and upper limits can be used to filter on periods. See below for
examples.

## Examples

``` r
x <- c("2025-2030", "2020-2025", "2030-2035")
period_lower(x)
#> [1] 2025 2020 2030
period_upper(x)
#> [1] 2030 2025 2035
period_width(x)
#> [1] 5 5 5
period_mid(x)
#> [1] 2027.5 2022.5 2032.5

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

## 'label_single' is "lower" (the default)
period_lower("2025")
#> [1] 2025
period_upper("2025")
#> [1] 2026
period_width("2025")
#> [1] 1

## 'label_single' is "upper"
period_lower("2025", label_single = "upper")
#> [1] 2024
period_upper("2025", label_single = "upper")
#> [1] 2025
period_width("2025", label_single = "upper")
#> [1] 1

## 'label_multi' is "include" (the default)
period_lower("2025-2029")
#> [1] 2025
period_upper("2025-2029")
#> [1] 2029
period_width("2025-2029")
#> [1] 4

## 'label_multi' is "exclude"
period_lower("2025-2029", label_multi = "exclude")
#> [1] 2025
period_upper("2025-2029", label_multi = "exclude")
#> [1] 2030
period_width("2025-2029", label_multi = "exclude")
#> [1] 5
```
