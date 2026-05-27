# Convert to Equal-Length Periods

Modify the periods used by `x`. The new periods must contain the old
periods, and follow a regular pattern:

- `period_modify_five` Five-year periods

- `period_modify_ten` Ten-year periods

## Usage

``` r
period_modify_five(
  x,
  offset = 0,
  x_one = c("lower", "upper"),
  x_multi = c("include", "exclude"),
  x_fail = c("error", "warn", "silent")
)

period_modify_ten(
  x,
  offset = 0,
  x_one = c("lower", "upper"),
  x_multi = c("include", "exclude"),
  x_fail = c("error", "warn", "silent")
)
```

## Arguments

- x:

  Vector of period labels.

- offset:

  Parameter controlling alignment of periods. Default is `0`.

- x_one:

  How to interpret labels in `x` that describe one-year periods. Choices
  are `"lower"` (the default) and `"upper"`.

- x_multi:

  How to interpret labels in `x` that describe multi-year periods.
  Choices are `"include"` (the default) and `"exclude"`.

- x_fail:

  Action if element of `x` cannot be parsed: `"error"` (the default),
  `"warn"`, or `"silent"`.

## Value

A factor if `x` is a factor; otherwise a character vector.

## See also

[`period_modify()`](https://bayesiandemography.github.io/agetime/reference/period_modify.md)
Convert to general periods
[`age_modify_five()`](https://bayesiandemography.github.io/agetime/reference/age_modify_five.md)
Age equivalent of `period_modify_five()`
[`age_modify_ten()`](https://bayesiandemography.github.io/agetime/reference/age_modify_five.md)
Age equivalent of `period_modify_ten()`
[`cohort_modify_five()`](https://bayesiandemography.github.io/agetime/reference/cohort_modify_five.md)
Cohort equivalent of `period_modify_five()`
[`cohort_modify_ten()`](https://bayesiandemography.github.io/agetime/reference/cohort_modify_five.md)
Cohort equivalent of `period_modify_ten()`
[`period_levels_fill()`](https://bayesiandemography.github.io/agetime/reference/period_levels_fill.md)
Add levels for intermediate periods

## Examples

``` r
x <- c("2002-2004", "1987-1989", "2000", "Total")
period_modify_five(x)
#> [1] "2000-2005" "1985-1990" "2000-2005" "Total"    
period_modify_five(x, offset = 1)
#> [1] "2001-2006" "1986-1991" "1996-2001" "Total"    
period_modify_five(x, offset = 2)
#> [1] "2002-2007" "1987-1992" "1997-2002" "Total"    
period_modify_ten(x)
#> [1] "2000-2010" "1980-1990" "2000-2010" "Total"    
period_modify_ten(x, offset = 1)
#> [1] "2001-2011" "1981-1991" "1991-2001" "Total"    
period_modify_ten(x, offset = 2)
#> [1] "2002-2012" "1982-1992" "1992-2002" "Total"    
```
