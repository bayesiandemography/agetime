# Identify Age Group Labels for Subtotals

Find categories representing subtotals in age group labels.

## Usage

``` r
age_is_subtotal(labels, interpret_fail = c("error", "warn", "silent"))
```

## Arguments

- labels:

  Vector of age group labels.

- interpret_fail:

  Action if element of `labels` cannot be interpreted. Choices are
  `"error"` (the default), `"warn"`, and `"silent"`.

## Value

Logical vector with the same length as `labels`.

## Details

A subtotal is a label representing the same interval as two or more
smaller intervals in the same set. For example, in
`c("0-4", "5-9", "10-14", "0-9", "Total")`, `"0-9"` is a subtotal
because it represents the same interval as `"0-4"` and `"5-9"`.

Subtotals are distinct from grand total labels such as `"Total"` or
`"All"`, which are identified by
[`age_is_total()`](https://bayesiandemography.github.io/agetime/reference/age_is_total.md).

## See also

- [`period_is_subtotal()`](https://bayesiandemography.github.io/agetime/reference/period_is_subtotal.md)
  Period equivalent of `age_is_subtotal()`

- [`cohort_is_subtotal()`](https://bayesiandemography.github.io/agetime/reference/cohort_is_subtotal.md)
  Cohort equivalent of `age_is_subtotal()`

- [`age_is_total()`](https://bayesiandemography.github.io/agetime/reference/age_is_total.md)
  Identify grand totals

- [`age_is_missing()`](https://bayesiandemography.github.io/agetime/reference/age_is_missing.md)
  Identify missing age group labels

- [`age_is_open_right()`](https://bayesiandemography.github.io/agetime/reference/age_is_open_right.md)
  Identify age groups open on right

## Examples

``` r
labels <- c(
  age_labels_five(),
  "0-14",
  "15-64",
  "65+",
  "Total"
)
age_is_subtotal(labels)
#>   0-4   5-9 10-14 15-19 20-24 25-29 30-34 35-39 40-44 45-49 50-54 55-59 60-64 
#> FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE 
#> 65-69 70-74 75-79 80-84 85-89 90-94 95-99  100+  0-14 15-64   65+ Total 
#> FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE  TRUE  TRUE  TRUE FALSE 
age_is_total(labels)
#>   0-4   5-9 10-14 15-19 20-24 25-29 30-34 35-39 40-44 45-49 50-54 55-59 60-64 
#> FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE 
#> 65-69 70-74 75-79 80-84 85-89 90-94 95-99  100+  0-14 15-64   65+ Total 
#> FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE  TRUE 

## overlapping alternative groupings still count
age_is_subtotal(c("90+", "90", "91+", "95+", "90-94"))
#>   90+    90   91+   95+ 90-94 
#>  TRUE FALSE FALSE FALSE FALSE 

## subtotals must fully cover range
labels_no_20_24 <- setdiff(labels, "20-24")
age_is_subtotal(labels_no_20_24) ## "15-64" not subtotal
#>   0-4   5-9 10-14 15-19 25-29 30-34 35-39 40-44 45-49 50-54 55-59 60-64 65-69 
#> FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE 
#> 70-74 75-79 80-84 85-89 90-94 95-99  100+  0-14 15-64   65+ Total 
#> FALSE FALSE FALSE FALSE FALSE FALSE FALSE  TRUE FALSE  TRUE FALSE 

## subtotals can overlap
labels_064 <- c(labels, "0-64")
age_is_subtotal(labels_064)
#>   0-4   5-9 10-14 15-19 20-24 25-29 30-34 35-39 40-44 45-49 50-54 55-59 60-64 
#> FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE 
#> 65-69 70-74 75-79 80-84 85-89 90-94 95-99  100+  0-14 15-64   65+ Total  0-64 
#> FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE  TRUE  TRUE  TRUE FALSE  TRUE 

## use to filter data
library(dplyr, warn.conflicts = FALSE)
df <- data.frame(
  age = c("0-4", "5-9", "10-14", "0-14"),
  value = c(100, 200, 300, 400)
)
df |>
  filter(!age_is_subtotal(age))
#>     age value
#> 1   0-4   100
#> 2   5-9   200
#> 3 10-14   300
```
