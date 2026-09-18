# Identify Age Group Labels for Totals

Find categories representing totals in age group labels.

## Usage

``` r
age_is_total(labels, interpret_fail = c("error", "warn", "silent"))
```

## Arguments

- labels:

  Vector of age group labels.

- interpret_fail:

  Action if element of `labels` cannot be interpreted. Choices are
  `"error"` (the default), `"warn"`, and `"silent"`.

## Value

Logical vector with the same length as `labels`.

## See also

- [`period_is_total()`](https://bayesiandemography.github.io/agetime/reference/period_is_total.md)
  Period equivalent of `age_is_total()`

- [`cohort_is_total()`](https://bayesiandemography.github.io/agetime/reference/cohort_is_total.md)
  Cohort equivalent of `age_is_total()`

- [`age_is_subtotal()`](https://bayesiandemography.github.io/agetime/reference/age_is_subtotal.md)
  Identify subtotals

- [`age_is_missing()`](https://bayesiandemography.github.io/agetime/reference/age_is_missing.md)
  Identify missing age group labels

- [`age_is_open_right()`](https://bayesiandemography.github.io/agetime/reference/age_is_open_right.md)
  Identify age groups open on right

## Examples

``` r
labels <- c("0-4", "5-9", "0-64", "Total")
age_is_total(labels)
#>   0-4   5-9  0-64 Total 
#> FALSE FALSE FALSE  TRUE 
age_is_subtotal(labels)
#>   0-4   5-9  0-64 Total 
#> FALSE FALSE FALSE FALSE 

labels <- c("overall", "20-24", "Total", "100+", "ALL")
age_is_total(labels)
#> overall   20-24   Total    100+     ALL 
#>    TRUE   FALSE    TRUE   FALSE    TRUE 

## use to filter data
library(dplyr, warn.conflicts = FALSE)
df <- data.frame(
  age = c("0-4", "5-9", "0-64", "Total"),
  value = c(100, 200, 300, 400)
)
df |>
  filter(!age_is_total(age))
#>    age value
#> 1  0-4   100
#> 2  5-9   200
#> 3 0-64   300
```
