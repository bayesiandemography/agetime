# Define Open Cohort

Set an open cohort, i.e. a cohort with no lower limit. Replace existing
cohorts where necessary.

## Usage

``` r
cohort_set_open(
  x,
  open,
  x_one = c("lower", "upper"),
  x_multi = c("include", "exclude"),
  x_fail = c("error", "warn", "silent")
)
```

## Arguments

- x:

  A vector of cohort labels.

- open:

  Upper limit of open cohort.

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

A factor if `x` is a factor; otherwise a character vector.

If no labels qualify for the open group (including when `x` is
`character(0)` or a factor with no levels), `x` is returned unchanged.
When `x` is a factor with levels but no element values, qualifying
levels are still relabelled.

## Examples

``` r
x <- c("2020-2024", "<2000", "2015")
cohort_set_open(x, open = 2020)
#> [1] "2020+" "<2000" "2015" 
cohort_set_open(x, open = 2005)
#> [1] "2005+" "<2000" "2005+"
```
