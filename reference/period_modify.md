# Convert to New Periods

Modify the periods used by `x`. The the new periods must contain the old
ones.

## Usage

``` r
period_modify(
  x,
  breaks,
  x_one = c("lower", "upper"),
  x_multi = c("include", "exclude"),
  x_fail = c("error", "warn", "silent")
)
```

## Arguments

- x:

  Vector of period labels.

- breaks:

  Boundaries between periods. A numeric vector.

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

A vector the same length as `x` with modified labels.

If `x` is a character vector, returns a character vector. When
`length(x) == 0`, returns `character(0)`.

If `x` is a factor, returns a factor with the same length and `ordered`
attribute as `x`. Element values are mapped to the new periods and
[`levels()`](https://rdrr.io/r/base/levels.html) is the full label set
defined by `breaks`. When `length(x) == 0`, `levels(x)` are still
modified.

## See also

- [`period_modify_five()`](https://bayesiandemography.github.io/agetime/reference/period_modify_five.md)
  Convert to 5-year periods

- [`period_modify_ten()`](https://bayesiandemography.github.io/agetime/reference/period_modify_five.md)
  Convert to 10-year periods

- [`age_modify()`](https://bayesiandemography.github.io/agetime/reference/age_modify.md)
  Age group equivalent of `period_modify()`

- [`cohort_modify()`](https://bayesiandemography.github.io/agetime/reference/cohort_modify.md)
  Cohort equivalent of `period_modify()`

## Examples

``` r
x <- c("2001-2004", "1987-1989", "2000", "2005-2010")
period_modify(x, breaks = c(1970, 2000, 2005, 2015))
#> [1] "2000-2005" "1970-2000" "2000-2005" "2005-2015"
```
