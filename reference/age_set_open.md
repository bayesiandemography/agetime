# Define Open Age Group

Set an open age group, i.e. an age group with no upper limit. Replace
existing age groups where necessary.

## Usage

``` r
age_set_open(x, open, x_fail = c("error", "warn", "silent"))
```

## Arguments

- x:

  Vector of age group labels.

- open:

  Lower limit of open age group.

- x_fail:

  Action if element of `x` cannot be parsed: `"error"` (the default),
  `"warn"`, or `"silent"`.

## Value

Character vector or factor with the same length as `x`.

## See also

- [`cohort_set_open()`](https://bayesiandemography.github.io/agetime/reference/cohort_set_open.md)
  Cohort equivalent of `age_set_open()`

## Examples

``` r
x <- c("20-24", "80-84", "100+")
age_set_open(x, open = 80)
#> [1] "20-24" "80+"   "80+"  
age_set_open(x, open = 50)
#> [1] "20-24" "50+"   "50+"  
```
