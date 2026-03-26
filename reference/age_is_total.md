# Identify Labels that Refer to Totals

Return a logical vector the same length as `x` with `TRUE` for labels
that agetime interprets as totals, and `FALSE` otherwise.

## Usage

``` r
age_is_total(x, unknown_label = c("error", "warn", "silent"))
```

## Arguments

- x:

  Vector of age group labels.

- unknown_label:

  Action if meaning of label unclear. Choices are `"error"` (the
  default), `"warn"`, and `"silent"`.

## Value

A logical vector

## Examples

``` r
x <- c("20-24", "Total", "100+", "ALL")
age_is_total(x)
#> [1] FALSE  TRUE FALSE  TRUE
```
