# Limits, Widths, and Midpoints from Age Group Labels

Calculate lower limits, upper limits, widths, and midpoints of age
groups.

## Usage

``` r
age_lower(labels, interpret_fail = c("error", "warn", "silent"))

age_mid(labels, interpret_fail = c("error", "warn", "silent"))

age_upper(labels, interpret_fail = c("error", "warn", "silent"))

age_width(labels, interpret_fail = c("error", "warn", "silent"))
```

## Arguments

- labels:

  Vector of age group labels.

- interpret_fail:

  Action if element of `labels` cannot be parsed: `"error"` (the
  default), `"warn"`, or `"silent"`.

## Value

Numeric vector with the same length as `labels`.

## Details

Lower and upper limits can be used to filter on age. See below for
examples.

`age_mid()` uses the formula
`age_mid(labels) = age_lower(labels) + 0.5 * age_width(labels)`, except
for open age groups, such as `"100+"`, where it uses
`age_mid(labels) = age_lower(labels) + 0.5 * median_width` where
`median_width` is the median over closed intervals.

## See also

- [`period_lower()`](https://bayesiandemography.github.io/agetime/reference/period_lower.md)
  Period equivalent of `age_lower()`

- [`cohort_lower()`](https://bayesiandemography.github.io/agetime/reference/cohort_lower.md)
  Cohort equivalent of `age_lower()`

## Examples

``` r
labels <- c("5-9", "10-14", "100+")
age_lower(labels)
#>   5-9 10-14  100+ 
#>     5    10   100 
age_upper(labels)
#>   5-9 10-14  100+ 
#>    10    15   Inf 
age_width(labels)
#>   5-9 10-14  100+ 
#>     5     5   Inf 
age_mid(labels)
#>   5-9 10-14  100+ 
#>   7.5  12.5 102.5 

## use 'age_lower()' to filter on age
library(dplyr, warn.conflicts = FALSE)
df <- tribble(
  ~age, ~count,
  "5-9", 11,
  "10-14", 20,
  "100+", 7
)
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

## no action when 'interpret_fail' is "silent"
age_lower(c("0-4", "young people", "50plus"),
  interpret_fail = "silent"
)
#>         0-4 youngpeople         50+ 
#>           0          NA          50 
```
