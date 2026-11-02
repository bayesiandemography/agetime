# Limits, Widths, Midpoints, and Intervals from Age Group Labels

Calculate lower limits, upper limits, widths, midpoints, and intervals
from age group labels.

## Usage

``` r
age_lower(labels, interpret_fail = c("error", "warn", "silent"))

age_mid(labels, interpret_fail = c("error", "warn", "silent"))

age_upper(labels, interpret_fail = c("error", "warn", "silent"))

age_width(labels, interpret_fail = c("error", "warn", "silent"))

age_interval(labels, interpret_fail = c("error", "warn", "silent"))
```

## Arguments

- labels:

  Vector of age group labels.

- interpret_fail:

  Action if element of `labels` cannot be interpreted. Choices are
  `"error"` (the default), `"warn"`, and `"silent"`.

## Value

`age_interval()` returns a character vector, and the other functions
return a numeric vector. The result has the same length as `labels`. If
`labels` has names, the result has the same names.

## Details

Lower and upper limits can be used to filter on age. See below for
examples.

`age_mid()` assigns open age groups (e.g., `"100+"`) honorary midpoints,
which are useful for plotting. An open age group gets a midpoint half
the width of the closed age group with the highest lower limit, so that,
for instance, the midpoint of `"100+"` is `102.5` when the other age
groups are five-year groups. If `labels` has no closed age groups,
`age_mid()` throws an error.

`age_interval()` describes each age group using interval notation. For
instance, `"[5, 10)"` includes age 5 but not age 10, and `"[100, Inf)"`
has no upper limit. `age_interval()` is useful for checking how labels
are being interpreted.

## See also

- [`period_lower()`](https://bayesiandemography.github.io/agetime/reference/period_lower.md)
  Period equivalent of `age_lower()`

- [`cohort_lower()`](https://bayesiandemography.github.io/agetime/reference/cohort_lower.md)
  Cohort equivalent of `age_lower()`

## Examples

``` r
labels <- c("5-9", "10-14", "100+")
age_lower(labels)
#> [1]   5  10 100
age_upper(labels)
#> [1]  10  15 Inf
age_width(labels)
#> [1]   5   5 Inf
age_mid(labels)
#> [1]   7.5  12.5 102.5
age_interval(labels)
#> [1] "[5, 10)"    "[10, 15)"   "[100, Inf)"

## use 'age_lower()' to filter on age
library(dplyr, warn.conflicts = FALSE)
df <- tribble(
  ~age, ~count,
  "5-9", 11,
  "10-14", 20,
  "100+", 7
)
df
#> # A tibble: 3 × 2
#>   age   count
#>   <chr> <dbl>
#> 1 5-9      11
#> 2 10-14    20
#> 3 100+      7
df |> filter(age_lower(age) >= 10)
#> # A tibble: 2 × 2
#>   age   count
#>   <chr> <dbl>
#> 1 10-14    20
#> 2 100+      7

## midpoint of open intervals
age_mid(c("80-89", "90-99", "100+")) # 105
#> [1]  85  95 105
age_mid(c("90-94", "95-99", "100+")) # 102.5
#> [1]  92.5  97.5 102.5

## no action when 'interpret_fail' is "silent"
age_lower(
  labels = c("0-4", "young people", "50plus"),
  interpret_fail = "silent"
)
#> [1]  0 NA 50

## names of 'labels' are kept
pop <- c(young = "0-14", working = "15-64", old = "65+")
age_lower(pop)
#>   young working     old 
#>       0      15      65 
```
