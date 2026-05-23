# Extend a Set of Age Groups

Create `n` new age groups. The width of the new age groups can be
specified through the `width` argument. Otherwise it is derived from the
last element of `x`.

## Usage

``` r
age_extend(
  x,
  n = 1L,
  width = NULL,
  include_x = TRUE,
  x_fail = c("error", "warn", "silent")
)
```

## Arguments

- x:

  Vector of age group labels.

- n:

  Number of age groups to add. Default is `1`.

- width:

  Width of the age groups to be added.

- include_x:

  Should the return value include `x`? Default is `TRUE`.

- x_fail:

  Action if meaning of label unclear. Choices are `"error"` (the
  default), `"warn"`, and `"silent"`.

## Value

If `x` is a factor, then the return value is a factor; otherwise it is a
character vector.

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
