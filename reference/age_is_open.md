# Identify Labels that Refer to Open Age Groups

Find age group labels that agetime interprets as open, ie as having no
upper limit.

## Usage

``` r
age_is_open(x, x_fail = c("error", "warn", "silent"))
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
x <- c("20+", "infant", "100+", "60to79")
age_is_open(x)
#>   20+     0  100+ 60-79 
#>  TRUE FALSE  TRUE FALSE 
```
