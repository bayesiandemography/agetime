# Lower Limits, Upper Limits, Widths and Midpoints of Age Groups

Calculate lower limits, upper limits, widths and midpoints for age
groups.

## Usage

``` r
age_lower(x, x_fail = c("error", "warn", "silent"))

age_mid(x, x_fail = c("error", "warn", "silent"))

age_upper(x, x_fail = c("error", "warn", "silent"))

age_width(x, x_fail = c("error", "warn", "silent"))
```

## Arguments

- x:

  Vector of age group labels.

- x_fail:

  Action if element of `x` cannot be parsed: `"error"` (the default),
  `"warn"`, or `"silent"`.

## Value

Numeric vector with same length as `x`.

When `length(x) == 0`, returns `numeric(0)`.

## Details

Lower and upper limits can be used filter on age. See below for
examples.

`age_mid()` uses the formula `age_lower(x) + 0.5 * age_width(x)`, except
for open age groups, such as `"100+"`, where it uses
`age_lower(x) + 0.5 * median_width` where `median_width` is the median
over closed intervals.

## Examples

``` r
x <- c("5-9", "10-14", "100+")
age_lower(x)
#>   5-9 10-14  100+ 
#>     5    10   100 
age_upper(x)
#>   5-9 10-14  100+ 
#>    10    15   Inf 
age_width(x)
#>   5-9 10-14  100+ 
#>     5     5   Inf 
age_mid(x)
#>   5-9 10-14  100+ 
#>   7.5  12.5 102.5 

## use 'age_lower()' to filter on age
library(dplyr, warn.conflicts = FALSE)
df <- tribble(   ~age, ~count,
                "5-9",     11,
              "10-14",     20,
               "100+",      7 )       
df
#> # A tibble: 3 × 2
#>   age   count
#>   <chr> <dbl>
#> 1 5-9      11
#> 2 10-14    20
#> 3 100+      7
df |> filter(age_lower(age) >= 10)
#> # A tibble: 2 × 2
#>   age   count
#>   <chr> <dbl>
#> 1 10-14    20
#> 2 100+      7

## no action when 'x_fail' is "silent"
age_lower(c("0-4", "young people", "50plus"),
          x_fail = "silent")
#>         0-4 youngpeople         50+ 
#>           0          NA          50 
```
