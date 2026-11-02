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

Logical vector with the same length as `labels`. If `labels` has names,
the result has the same names.

## Details

A subtotal is a label whose interval can be divided into the intervals
of two or more other labels in the same set. For example, in
`c("0-4", "5-9", "10-14", "0-9", "Total")`, `"0-9"` is a subtotal
because it represents the same interval as `"0-4"` and `"5-9"`.

Subtotals are distinct from grand total labels such as `"Total"` or
`"All"`, which are identified by
[`age_is_total()`](https://bayesiandemography.github.io/agetime/reference/age_is_total.md).

If `labels` is a factor, unused levels are ignored.

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
#>  [1] FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE
#> [13] FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE  TRUE  TRUE  TRUE
#> [25] FALSE
age_is_total(labels)
#>  [1] FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE
#> [13] FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE
#> [25]  TRUE

## overlapping alternative groupings still count
age_is_subtotal(c("90+", "90", "91+", "95+", "90-94"))
#> [1]  TRUE FALSE FALSE FALSE FALSE

## subtotals must fully cover range
labels_no_20_24 <- setdiff(labels, "20-24")
age_is_subtotal(labels_no_20_24) ## "15-64" not subtotal
#>  [1] FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE
#> [13] FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE  TRUE FALSE  TRUE FALSE

## subtotals can overlap
labels_064 <- c(labels, "0-64")
age_is_subtotal(labels_064)
#>  [1] FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE
#> [13] FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE  TRUE  TRUE  TRUE
#> [25] FALSE  TRUE

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
