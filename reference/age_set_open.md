# Define the Oldest Age Group

### TODO - WEAKEN REQUIREMENT THAT

### lower_last IS AN EXISTING

### 'lower'.

## Usage

``` r
age_set_open(x, lower_last, unknown_label = c("error", "warn", "silent"))
```

## Arguments

- x:

  Vector of age group labels.

- lower_last:

  Lower limit of an existing age group in `x`.

- unknown_label:

  Action if meaning of label unclear. Choices are `"error"` (the
  default), `"warn"`, and `"silent"`.

## Value

Modified version of `x`.

## Details

If the oldest age group in `x` was not previously open, then calling
`age_set_open()` on `x` makes it open.

## Examples

``` r
x <- c("20-24", "80-84", "100+")
age_set_open(x, lower_last = 80)
#> Error in loadNamespace(x): there is no package called ‘poputils’
age_set_open(x, lower_last = 20)
#> Error in loadNamespace(x): there is no package called ‘poputils’

## 'x' does not have open age group
x <- c("20-24", "80-84", "100")
age_set_open(x, 100)
#> Error in loadNamespace(x): there is no package called ‘poputils’
age_set_open(x, 80)
#> Error in loadNamespace(x): there is no package called ‘poputils’
```
