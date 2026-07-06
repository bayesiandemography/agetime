# Identify Age Labels for Open Age Groups

Find open age groups, i.e., age groups with no upper limit.

## Usage

``` r
age_is_open(labels, interpret_fail = c("error", "warn", "silent"))
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

- [`age_is_total()`](https://bayesiandemography.github.io/agetime/reference/age_is_total.md)
  Find age labels for totals

- [`cohort_is_open()`](https://bayesiandemography.github.io/agetime/reference/cohort_is_open.md)
  Cohort equivalent of `age_is_open()`

## Examples

``` r
labels <- c("20+", "infant", "100+", "60to79")
age_is_open(labels)
#>    20+ infant   100+ 60to79 
#>   TRUE  FALSE   TRUE  FALSE 
```
