# Convert Age Group Labels to Specific New Format

Convert Age Group Labels to Specific New Format

## Usage

``` r
age_to_one(
  x,
  lower_first = NULL,
  lower_last = NULL,
  open = TRUE,
  include_total = NULL,
  include_na = NULL,
  unknown_label = c("error", "warn", "silent")
)

age_to_five(
  x,
  lower_first = NULL,
  lower_last = NULL,
  open = TRUE,
  include_total = NULL,
  include_na = NULL,
  unknown_label = c("error", "warn", "silent")
)

age_to_ten(
  x,
  lower_first = NULL,
  lower_last = NULL,
  open = TRUE,
  include_total = NULL,
  include_na = NULL,
  unknown_label = c("error", "warn", "silent")
)

age_to_life(
  x,
  lower_last = NULL,
  include_total = NULL,
  include_na = NULL,
  unknown_label = c("error", "warn", "silent")
)

age_to_labor(
  x,
  age_work = 20,
  age_retire = 65,
  include_total = NULL,
  include_na = NULL,
  unknown_label = c("error", "warn", "silent")
)
```

## Arguments

- lower_first:

  Integer or NULL

- lower_last:

  Integer or NULL

## Value

A factor the same length as `x`.

## Examples

``` r
x <- factor(c("1-4", "87-89", "50-54"))
age_to_five(x)
#> [1] 0-4   85-89 50-54
#> 19 Levels: 0-4 5-9 10-14 15-19 20-24 25-29 30-34 35-39 40-44 45-49 ... 90+
age_to_life(x)
#> [1] 1-4   85-89 50-54
#> 20 Levels: 0 1-4 5-9 10-14 15-19 20-24 25-29 30-34 35-39 40-44 45-49 ... 90+
age_to_ten(x)
#> [1] 0-9   80-89 50-59
#> Levels: 0-9 10-19 20-29 30-39 40-49 50-59 60-69 70-79 80-89 90+
age_to_ten(x, open = FALSE)
#> [1] 0-9   80-89 50-59
#> Levels: 0-9 10-19 20-29 30-39 40-49 50-59 60-69 70-79 80-89 90-99

x <- factor(c("0-9", "70+", "22"))
age_to_labor(x)
#> Error in loadNamespace(x): there is no package called ‘poputils’
age_to_labor(x,
             age_work = 20,
             age_retire = 67)
#> Error in loadNamespace(x): there is no package called ‘poputils’

x <- c(NA, 1, 10, "Total")
age_to_five(x)
#> [1] <NA>  0-4   10+   Total
#> Levels: 0-4 5-9 10+ Total <NA>
```
