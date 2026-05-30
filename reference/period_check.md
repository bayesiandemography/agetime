# Check or Make Assertions About Periods

Collect information on period labels (`period_check()`), or throw an
error if period labels do not conform to expectations (`period_assert`).

## Usage

``` r
period_check(
  x,
  no_overlap = NA,
  no_gap = NA,
  no_total = NA,
  no_na = NA,
  x_one = c("lower", "upper"),
  x_multi = c("include", "exclude"),
  x_fail = c("error", "warn", "silent")
)

period_assert(
  x,
  no_overlap = NA,
  no_gap = NA,
  no_total = NA,
  no_na = NA,
  x_one = c("lower", "upper"),
  x_multi = c("include", "exclude"),
  x_fail = c("error", "warn", "silent")
)
```

## Arguments

- x:

  Vector of period labels.

- no_overlap:

  No periods overlap.

- no_gap:

  The periods span the entire range from the lower limit of the earliest
  period to the upper limit of the latest period.

- no_total:

  No "Total" label.

- no_na:

  No NA label.

- x_one:

  How to interpret labels in `x` that describe one-year periods. Choices
  are `"lower"` (the default) and `"upper"`.

- x_multi:

  How to interpret labels in `x` that describe multi-year periods.
  Choices are `"include"` (the default) and `"exclude"`.

- x_fail:

  Action if element of `x` cannot be parsed: `"error"` (the default),
  `"warn"`, or `"silent"`.

## Value

For `period_check()`, a list with logical `ok` and data frame `details`;
for `period_assert()`, `x` invisibly or an error.

## See also

- [`parsing_period_labels()`](https://bayesiandemography.github.io/agetime/reference/parsing_period_labels.md)
  Details for `x_one`, `x_multi`, and `x_fail`

- [`age_check()`](https://bayesiandemography.github.io/agetime/reference/age_check.md)
  Age equivalent of `period_check()`

- [`cohort_check()`](https://bayesiandemography.github.io/agetime/reference/cohort_check.md)
  Cohort equivalent of `period_check()`

## Examples

``` r
lab <- period_labels_five(lower_first = 2020,
                          lower_last = 2030)
lab
#> [1] "2020-2025" "2025-2030" "2030-2035"

## get info on everything
period_check(x = lab,
             no_overlap = TRUE,
             no_gap = TRUE,
             no_total = TRUE,
             no_na = TRUE)
#> $ok
#> [1] TRUE
#> 
#> $details
#> # A tibble: 4 × 4
#>   check      asserted observed comment
#>   <chr>      <lgl>    <lgl>    <chr>  
#> 1 no_overlap TRUE     TRUE     Passed 
#> 2 no_gap     TRUE     TRUE     Passed 
#> 3 no_total   TRUE     TRUE     Passed 
#> 4 no_na      TRUE     TRUE     Passed 
#> 

## throw error if gaps
period_assert(x = lab, no_gap = TRUE)

lab_gap <- lab[c(1, 3)]
## throw error if no gaps
period_assert(lab_gap, no_gap = FALSE)
```
