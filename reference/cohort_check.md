# Check or Make Assertions About Cohorts

Collect information on cohort labels (`cohort_check()`), or throw an
error if cohort labels do not conform to expectations (`cohort_assert`).

## Usage

``` r
cohort_check(
  labels,
  no_overlap = NA,
  no_gap = NA,
  no_total = NA,
  no_na = NA,
  include_open = NA,
  interpret_single = c("lower", "upper"),
  interpret_multi = c("include", "exclude"),
  interpret_fail = c("error", "warn", "silent")
)

cohort_assert(
  labels,
  no_overlap = NA,
  no_gap = NA,
  no_total = NA,
  no_na = NA,
  include_open = NA,
  interpret_single = c("lower", "upper"),
  interpret_multi = c("include", "exclude"),
  interpret_fail = c("error", "warn", "silent")
)
```

## Arguments

- labels:

  Vector of cohort labels.

- no_overlap:

  No cohorts overlap.

- no_gap:

  The cohorts span the entire range from the lower limit of the earliest
  cohort to the upper limit of the latest cohort.

- no_total:

  No "Total" label.

- no_na:

  No NA label.

- include_open:

  One or more cohorts has no lower limit.

- interpret_single:

  How to interpret labels for single-year cohorts. Choices are `"lower"`
  (the default) and `"upper"`. See below for details.

- interpret_multi:

  How to interpret labels for multi-year cohorts. Choices are
  `"include"` (the default) and `"exclude"`. See below for details.

- interpret_fail:

  Action if element of `labels` cannot be interpreted. Choices are
  `"error"` (the default), `"warn"`, and `"silent"`.

## Value

For `cohort_check()`, a list with logical `ok` and data frame `details`;
for `cohort_assert()`, `labels` invisibly or an error.

## Controlling how cohort labels are interpreted

If `interpret_single` is `"lower"` (the default), then labels for
single-year cohorts are assumed to refer to lower limits, so that
`"2025"` means `[2025,2026)`. This is the convention that data providers
typically use for calendar years.

If `interpret_single` is `"upper"`, then labels for single-year cohorts
are assumed to refer to upper limits, so that `"2025"` means
`[2024,2025)`. This is the convention that data providers typically use
for non-calendar years, such as 1 July to 30 June.

If `interpret_multi` is `"include"` (the default), then labels for
multi-year cohorts are assumed to include upper limits, so that
`"2025-2030"` means `[2025,2030)`.

If `interpret_multi` is `"exclude"`, then labels for multi-year cohorts
are assumed to exclude the upper limits so that `"2025-2030"` means
`[2025,2031)`.

## See also

- [`age_check()`](https://bayesiandemography.github.io/agetime/reference/age_check.md)
  Age equivalent of `cohort_check()`

- [`period_check()`](https://bayesiandemography.github.io/agetime/reference/period_check.md)
  Period equivalent of `cohort_check()`

## Examples

``` r
lab <- cohort_labels_five(
  lower_first = 2020,
  lower_last = 2030
)
lab
#> [1] "2020-2025" "2025-2030" "2030-2035"

## get info on everything
cohort_check(
  labels = lab,
  no_overlap = TRUE,
  no_gap = TRUE,
  no_total = TRUE,
  no_na = TRUE,
  include_open = TRUE
)
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
cohort_assert(labels = lab, no_gap = TRUE)

lab_gap <- lab[c(1, 3)]
## throw error if no gaps
cohort_assert(lab_gap, no_gap = FALSE)
```
