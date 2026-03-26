# Extend a Set of Age Groups

Add `n` age groups to an existing set of labels `x`. The width of the
age groups is derived from the `width` argument, or from the width of
the last label in `x`.

## Usage

``` r
age_extend(
  x,
  n = 1L,
  width = NULL,
  include_x = TRUE,
  unknown_label = c("error", "warn", "silent")
)
```

## Arguments

- x:

  Vector of age group labels.

- n:

  The number of age groups to add. Default is `1`.

- include_x:

  Should the return value include `x`? Default is `TRUE`.

- unknown_label:

  Action if meaning of label unclear. Choices are `"error"` (the
  default), `"warn"`, and `"silent"`.

## Value

If `x` is a factor, `age_extend` returns a factor; otherwise it returns
a character vector.

## Examples

``` r
x <- c("0-4", "5-9")
age_extend(x, n = 2)
#> [1] "0-4"   "5-9"   "10-14" "15-19"
age_extend(x, n = 2, width = 10)
#> [1] "0-4"   "5-9"   "10-19" "20-29"
age_extend(x, n = 2, include_x = FALSE)
#> [1] "10-14" "15-19"
```
