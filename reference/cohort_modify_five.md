# Convert to Equal-Length Cohorts

Modify the cohorts used by `x`. The new cohorts must contain the old
cohorts, and follow a regular pattern:

- `cohort_modify_five` Five-year cohorts

- `cohort_modify_ten` Ten-year cohorts

## Usage

``` r
cohort_modify_five(
  x,
  offset = 0,
  x_one = c("lower", "upper"),
  x_multi = c("include", "exclude"),
  x_fail = c("error", "warn", "silent")
)

cohort_modify_ten(
  x,
  offset = 0,
  x_one = c("lower", "upper"),
  x_multi = c("include", "exclude"),
  x_fail = c("error", "warn", "silent")
)
```

## Arguments

- x:

  A vector of cohort labels.

- offset:

  Parameter controlling alignment of cohorts. Default is `0`.

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

## See also

[`cohort_modify()`](https://bayesiandemography.github.io/agetime/reference/cohort_modify.md)
Convert to general cohorts
[`age_modify_five()`](https://bayesiandemography.github.io/agetime/reference/age_modify_five.md)
Age equivalent of `cohort_modify_five()`
[`age_modify_ten()`](https://bayesiandemography.github.io/agetime/reference/age_modify_five.md)
Age equivalent of `cohort_modify_ten()`
[`period_modify_five()`](https://bayesiandemography.github.io/agetime/reference/period_modify_five.md)
Period equivalent of `cohort_modify_five()`
[`period_modify_ten()`](https://bayesiandemography.github.io/agetime/reference/period_modify_five.md)
Period equivalent of `cohort_modify_ten()`
[`cohort_levels_fill()`](https://bayesiandemography.github.io/agetime/reference/cohort_levels_fill.md)
Add levels for intermediate cohorts

## Examples

``` r
x <- c("2002-2004", "1987-1989", "2000", "Total")
cohort_modify_five(x)
#> [1] "2000-2005" "1985-1990" "2000-2005" "Total"    
cohort_modify_five(x, offset = 1)
#> [1] "2001-2006" "1986-1991" "1996-2001" "Total"    
cohort_modify_five(x, offset = 2)
#> [1] "2002-2007" "1987-1992" "1997-2002" "Total"    
cohort_modify_ten(x)
#> [1] "2000-2010" "1980-1990" "2000-2010" "Total"    
cohort_modify_ten(x, offset = 1)
#> [1] "2001-2011" "1981-1991" "1991-2001" "Total"    
cohort_modify_ten(x, offset = 2)
#> [1] "2002-2012" "1982-1992" "1992-2002" "Total"    
```
