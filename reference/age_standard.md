# Standardize Age Group Labels

Convert age group labels to the default agetime format.

## Usage

``` r
age_standard(labels, interpret_fail = c("error", "warn", "silent"))
```

## Arguments

- labels:

  Vector of age group labels.

- interpret_fail:

  Action if element of `labels` cannot be parsed: `"error"` (the
  default), `"warn"`, or `"silent"`.

## Value

Character vector or factor with the same length as `labels`.

## See also

- [`period_standard()`](https://bayesiandemography.github.io/agetime/reference/period_standard.md)
  Period equivalent of `age_standard()`

- [`cohort_standard()`](https://bayesiandemography.github.io/agetime/reference/cohort_standard.md)
  Cohort equivalent of `age_standard()`

## Examples

``` r
labels <- c("5to9", "10--14", "100plus")
age_standard(labels)
#> [1] "5-9"   "10-14" "100+" 

## factor input: factor in, factor out
age_standard(factor(c("5to9", "10--14")))
#> [1] 5-9   10-14
#> Levels: 10-14 5-9
```
