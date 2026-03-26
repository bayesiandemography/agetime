# Extend a Set of Periods

Add `n` periods to an existing set of labels `x`. The width of the
periods is derived from the `width` argument, or from the width of the
last label in `x`.

## Usage

``` r
period_extend(
  x,
  n = 1L,
  width = NULL,
  include_x = TRUE,
  label_one = c("lower", "upper"),
  label_multi = c("include", "exclude"),
  unknown_label = c("error", "warn", "silent")
)
```

## Arguments

- x:

  A vector of period labels.

- n:

  The number of periods to add. Default is `1`.

- include_x:

  Should the return value include `x`? Default is `TRUE`.

- label_one:

  Whether labels for one-year periods are based on the lower or upper
  limit of the period. Default is `"lower"`.

- label_multi:

  Whether labels for multi-year periods include or exclude the final
  year of the period. Default is `"include"`.

- unknown_label:

  Action if a label cannot be interpreted. Choices are `"error"` (the
  default), `"warn"`, and `"silent"`.

## Value

If `x` is a factor, `period_extend` returns a factor; otherwise it
returns a character vector.

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
