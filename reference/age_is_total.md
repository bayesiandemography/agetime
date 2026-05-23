# Identify Age Group Labels that Refer to Totals

Find age group labels that agetime interprets as totals.

## Usage

``` r
age_is_total(x, x_fail = c("error", "warn", "silent"))
```

## Arguments

- x:

  Vector of age group labels.

- x_fail:

  Action if meaning of label unclear. Choices are `"error"` (the
  default), `"warn"`, and `"silent"`.

## Value

A logical vector the same length as `x`.

## Examples

``` r
x <- c("20-24", "Total", "100+", "ALL")
age_is_total(x)
#> [1] FALSE  TRUE FALSE  TRUE
```
