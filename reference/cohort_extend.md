# Extend a Set of Cohorts

Create `n` new cohorts. The width of the new cohorts can be specified
through the `width` argument. Otherwise it is derived from the last
element of `x`.

## Usage

``` r
cohort_extend(
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

  A vector of cohort labels.

- n:

  Number of cohorts to add. Default is `1`.

- width:

  Width of the cohorts to be added.

- include_x:

  Should the return value include `x`? Default is `TRUE`.

- x_one:

  Whether labels for one-year cohorts are based on the lower or upper
  limit of the period. Default is `"lower"`.

- x_multi:

  Whether labels for multi-year periods include or exclude the final
  year of the period. Default is `"include"`.

- x_fail:

  Action if a label cannot be interpreted. Choices are `"error"` (the
  default), `"warn"`, and `"silent"`.

## Value

If `x` is a factor, then the return value is a factor; otherwise it is a
character vector.

## Examples

``` r
x <- c("2020-2025", "2025-2030")
cohort_extend(x, n = 2)
#> [1] "2020-2025" "2025-2030" "2030-2035" "2035-2040"
cohort_extend(x, n = 2, width = 10)
#> [1] "2020-2025" "2025-2030" "2030-2040" "2040-2050"
cohort_extend(x, n = 2, include_x = FALSE)
#> [1] "2030-2035" "2035-2040"
```
