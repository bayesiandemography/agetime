# agetime

[![](reference/figures/sticker/agetime_sticker.png)](https://github.com/bayesiandemography/bage)

Work with labels for age groups, periods, and cohorts.

## Installation

``` r

devtools::install_github("bayesiandemography/agetime")
```

## Example

``` r

library(agetime)
library(dplyr, warn.conflicts = FALSE)

df <- tribble(   ~age,  ~count,
               "0-14",     100,
               "100+",      40,
              "15-65",     200 )
df 
#> # A tibble: 3 × 2
#>   age   count
#>   <chr> <dbl>
#> 1 0-14    100
#> 2 100+     40
#> 3 15-65   200

df |>
  mutate(age_width = age_width(age))
#> # A tibble: 3 × 3
#>   age   count age_width
#>   <chr> <dbl>     <dbl>
#> 1 0-14    100        15
#> 2 100+     40       Inf
#> 3 15-65   200        51

df |>
  filter(age_lower(age) >= 15)
#> # A tibble: 2 × 2
#>   age   count
#>   <chr> <dbl>
#> 1 100+     40
#> 2 15-65   200
```
