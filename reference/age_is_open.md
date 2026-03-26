# Identify Labels that Refer to Open Age Groups

Return a logical vector the same length as `x` with `TRUE` for labels
that agetime interprets as open age groups, and `FALSE` otherwise. An
open age group is one with no upper limit, eg `"100+"`.

## Usage

``` r
age_is_open(x, unknown_label = c("error", "warn", "silent"))
```

## Arguments

- x:

  Vector of age group labels.

- unknown_label:

  Action if meaning of label unclear. Choices are `"error"` (the
  default), `"warn"`, and `"silent"`.

## Value

`TRUE` or `FALSE`

## Examples

``` r
x <- c("20+", "infant", "100+", "60to79")
age_is_open(x)
#>   20+     0  100+ 60-79 
#>  TRUE FALSE  TRUE FALSE 
```
