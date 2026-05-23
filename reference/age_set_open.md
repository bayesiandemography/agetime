# Define Open Age Group

Set an open age group, i.e. an age group with no upper limit. Replace
existing age groups where necessary.

## Usage

``` r
age_set_open(x, open, x_fail = c("error", "warn", "silent"))
```

## Arguments

- x:

  Vector of age group labels.

- open:

  Lower limit of open age group.

- x_fail:

  Action if meaning of label unclear. Choices are `"error"` (the
  default), `"warn"`, and `"silent"`.

## Value

If `x` is a factor, then the return value is a factor; otherwise it is a
character vector.

## Examples

``` r
x <- c("20-24", "80-84", "100+")
age_set_open(x, open = 80)
#> [1] "20-24" "80+"   "80+"  
age_set_open(x, open = 50)
#> [1] "20-24" "50+"   "50+"  
```
