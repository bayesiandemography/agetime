# Identify Age Labels for Open Age Groups

Find age group labels that agetime interprets as open, ie having no
upper limit.

## Usage

``` r
age_is_open(x, x_fail = c("error", "warn", "silent"))
```

## Arguments

- x:

  Vector of age group labels.

- x_fail:

  Action if element of `x` cannot be parsed: `"error"` (the default),
  `"warn"`, or `"silent"`.

## Value

Logical vector the same length as `x`.

When `length(x) == 0`, returns `logical(0)`.

## See also

[`age_is_total()`](https://bayesiandemography.github.io/agetime/reference/age_is_total.md)
Find age labels for totals
[`cohort_is_open()`](https://bayesiandemography.github.io/agetime/reference/cohort_is_open.md)
Cohort equivalent of `age_is_open()`

## Examples

``` r
x <- c("20+", "infant", "100+", "60to79")
age_is_open(x)
#>   20+     0  100+ 60-79 
#>  TRUE FALSE  TRUE FALSE 
```
