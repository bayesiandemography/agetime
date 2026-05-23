# Identify Period Labels that Refer to Totals

Find period labels that agetime interprets as totals.

## Usage

``` r
period_is_total(
  x,
  x_one = c("lower", "upper"),
  x_multi = c("include", "exclude"),
  x_fail = c("error", "warn", "silent")
)
```

## Arguments

- x:

  Vector of period labels.

- x_one:

  How to interpret labels in `x` that describe one-year periods. Choices
  are `"lower"` (the default) and `"upper"`.

- x_multi:

  How to interpret labels in `x` that describe multi-year periods.
  Choices are `"include"` (the default) and `"exclude"`.

- x_fail:

  What to do if a label in `x` cannot be interpreted. Choices are
  `"error"` (the default), `"warn"`, and `"silent"`.

## Value

A logical vector the same length as `x`.

## Examples

``` r
x <- c("2020-2025", "Total", "1999", "ALL")
period_is_total(x)
#> [1] FALSE  TRUE FALSE  TRUE
```
