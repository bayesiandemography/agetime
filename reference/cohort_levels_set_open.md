# Set Open Cohort Level

Add an open cohort level, i.e. a cohort with no lower limit. Replace
existing cohorts where necessary.

## Usage

``` r
cohort_levels_set_open(
  x,
  upper_open,
  x_one = c("lower", "upper"),
  x_multi = c("include", "exclude"),
  x_fail = c("error", "warn", "silent")
)
```

## Arguments

- x:

  Vector of cohort labels.

- upper_open:

  Upper limit of open cohort.

- x_one:

  Whether labels for one-year cohorts are based on lower or upper limit
  of period. Default is `"lower"`.

- x_multi:

  Whether labels for multi-year periods include or exclude final year of
  period. Default is `"include"`.

- x_fail:

  Action if element of `x` cannot be parsed: `"error"` (the default),
  `"warn"`, or `"silent"`.

## Value

Factor with the same length as `x`.

## See also

- [`parsing_cohort_labels()`](https://bayesiandemography.github.io/agetime/reference/parsing_cohort_labels.md)
  Details for `x_one`, `x_multi`, and `x_fail`

- [`age_levels_set_open()`](https://bayesiandemography.github.io/agetime/reference/age_levels_set_open.md)
  Set open age group levels (right-open)

## Examples

``` r
x <- c("2020-2024", "<2000", "2015")
cohort_levels_set_open(x, upper_open = 2020)
#> [1] 2020-2024 <2020     <2020    
#> Levels: <2020 2020-2024
cohort_levels_set_open(x, upper_open = 2005)
#> [1] 2020-2024 <2005     2015     
#> Levels: <2005 2015 2020-2024
cohort_levels_set_open(c("2000-2004", "2010-2014"), upper_open = 1990)
#> [1] 2000-2004 2010-2014
#> Levels: <1990 2000-2004 2010-2014
```
