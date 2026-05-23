# Extend a Set of Periods

Create `n` new periods. The width of the new periods can be specified
through the `width` argument. Otherwise it is derived from the last
element of `x`.

## Usage

``` r
period_extend(
  x,
  n = 1L,
  width = NULL,
  include_x = TRUE,
  x_one = c("lower", "upper"),
  x_multi = c("include", "exclude"),
  x_fail = c("error", "warn", "silent")
)
```

## Arguments

- x:

  Vector of period labels.

- n:

  Number of periods to add. Default is `1`.

- width:

  Width of the periods to be added.

- include_x:

  Should the return value include `x`? Default is `TRUE`.

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

If `x` is a factor, then the return value is a factor; otherwise it is a
character vector.

## Examples

``` r
x <- c("2020-2025", "2025-2030")
period_extend(x, n = 2)
#> [1] "2020-2025" "2025-2030" "2030-2035" "2035-2040"
period_extend(x, n = 2, width = 10)
#> [1] "2020-2025" "2025-2030" "2030-2040" "2040-2050"
period_extend(x, n = 2, include_x = FALSE)
#> [1] "2030-2035" "2035-2040"
```
