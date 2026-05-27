# Convert to New Cohorts

Modify the cohorts used by `x`. The the new cohorts must contain the old
ones.

## Usage

``` r
cohort_modify(
  x,
  breaks,
  open = FALSE,
  x_one = c("lower", "upper"),
  x_multi = c("include", "exclude"),
  x_fail = c("error", "warn", "silent")
)
```

## Arguments

- x:

  A vector of cohort labels.

- breaks:

  Boundaries between cohorts. A numeric vector.

- open:

  Whether the first cohort is "open", i.e. has no lower limit. Default
  is `FALSE`.

- x_one:

  Whether labels for one-year cohorts are based on the lower or upper
  limit of the period. Default is `"lower"`.

- x_multi:

  Whether labels for multi-year periods include or exclude the final
  year of the period. Default is `"include"`.

- x_fail:

  Action if element of `x` cannot be parsed: `"error"` (the default),
  `"warn"`, or `"silent"`.

## Value

If `x` is a factor, then the return value is a factor; otherwise it is a
character vector.

## See also

- [`cohort_modify_five()`](https://bayesiandemography.github.io/agetime/reference/cohort_modify_five.md)
  Convert to 5-year cohorts

- [`cohort_modify_ten()`](https://bayesiandemography.github.io/agetime/reference/cohort_modify_five.md)
  Convert to 10-year cohorts

- [`age_modify()`](https://bayesiandemography.github.io/agetime/reference/age_modify.md)
  Age group equivalent of `cohort_modify()`

- [`period_modify()`](https://bayesiandemography.github.io/agetime/reference/period_modify.md)
  Period equivalent of `cohort_modify()`

## Examples

``` r
x <- c("2001-2004", "1987-1989", "2000", "2005-2010")
cohort_modify(x, breaks = c(1970, 2000, 2005, 2015))
#> [1] "2000-2005" "1970-2000" "2000-2005" "2005-2015"
cohort_modify(x, breaks = c(1970, 2000, 2005, 2015), open = TRUE)
#> [1] "2000-2005" "1970-2000" "2000-2005" "2005-2015"
```
