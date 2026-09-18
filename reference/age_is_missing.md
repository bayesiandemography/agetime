# Identify Missing Age Group Labels

Find categories representing missing, not stated, or `NA` values in age
group labels.

## Usage

``` r
age_is_missing(labels, interpret_fail = c("error", "warn", "silent"))
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

- [`period_is_missing()`](https://bayesiandemography.github.io/agetime/reference/period_is_missing.md)
  Period equivalent of `age_is_missing()`

- [`cohort_is_missing()`](https://bayesiandemography.github.io/agetime/reference/cohort_is_missing.md)
  Cohort equivalent of `age_is_missing()`

- [`age_is_total()`](https://bayesiandemography.github.io/agetime/reference/age_is_total.md)
  Identify totals for age groups

- [`age_is_open_right()`](https://bayesiandemography.github.io/agetime/reference/age_is_open_right.md)
  Identify age groups open on right

## Examples

``` r
labels <- c("0-4", NA, "not stated", "Total", "missing")
age_is_missing(labels)
#>        0-4       <NA> not stated      Total    missing 
#>      FALSE       TRUE       TRUE      FALSE       TRUE 
```
