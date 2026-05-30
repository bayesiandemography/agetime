# Check or Make Assertions About Cohorts

Collect information on cohort labels (`cohort_check()`), or throw an
error if cohort labels do not conform to expectations (`cohort_assert`).

## Usage

``` r
cohort_check(
  x,
  no_overlap = NA,
  no_gap = NA,
  no_total = NA,
  no_na = NA,
  include_open = NA,
  x_one = c("lower", "upper"),
  x_multi = c("include", "exclude"),
  x_fail = c("error", "warn", "silent")
)

cohort_assert(
  x,
  no_overlap = NA,
  no_gap = NA,
  no_total = NA,
  no_na = NA,
  include_open = NA,
  x_one = c("lower", "upper"),
  x_multi = c("include", "exclude"),
  x_fail = c("error", "warn", "silent")
)
```

## Arguments

- x:

  A vector of cohort labels.

- no_overlap:

  No cohorts overlap

- no_gap:

  The cohorts span the entire range from the lower limit of the earliest
  cohort to the upper limit of the latest cohort

- no_total:

  No "Total" label

- no_na:

  No NA label

- include_open:

  One or more cohorts has no lower limit.

- x_one:

  Whether labels for one-year cohorts are based on the lower or upper
  limit of the period. Default is `"lower"`.

- x_multi:

  Whether labels for multi-year periods include or exclude the final
  year of the period. Default is `"include"`.

- x_fail:

  Action if element of `x` cannot be parsed: `"error"` (the default),
  `"warn"`, or `"silent"`.

## Value

- `cohort_check()` returns a list with components `ok` (a logical flag)
  and `details` (a data frame).

- `cohort_assert()` returns `x` invisibly, or throws an error.

When `length(x) == 0`, checks on overlap, gaps, totals, and NA are
vacuously satisfied (`observed = TRUE`). Checks that require at least
one interval (`include_open`) fail (`observed = FALSE`).

## Examples

``` r
lab <- cohort_labels_five(lower_first = 2020,
                          lower_last = 2030)
lab
#> [1] "2020-2025" "2025-2030" "2030-2035"

## get info on everything
cohort_check(x = lab,
             no_overlap = TRUE,
             no_gap = TRUE,
             no_total = TRUE,
             no_na = TRUE,
             include_open = TRUE)
#> $ok
#> [1] FALSE
#> 
#> $details
#> # A tibble: 5 × 4
#>   check        asserted observed comment                      
#>   <chr>        <lgl>    <lgl>    <chr>                        
#> 1 no_overlap   TRUE     TRUE     Passed                       
#> 2 no_gap       TRUE     TRUE     Passed                       
#> 3 no_total     TRUE     TRUE     Passed                       
#> 4 no_na        TRUE     TRUE     Passed                       
#> 5 include_open TRUE     FALSE    Highest interval: '2030-2035'
#> 

## throw error if gaps
cohort_assert(x = lab, no_gap = TRUE)

lab_gap <- lab[c(1, 3)]
## throw error if no gaps
cohort_assert(lab_gap, no_gap = FALSE)
```
