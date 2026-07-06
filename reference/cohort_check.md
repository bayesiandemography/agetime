# Check or Make Assertions About Cohorts

`cohort_check()` creates reports comparing cohort labels against
expectations.

`cohort_assert()` throws an error if cohort labels do not conform to
expectations.

If `labels` is a factor, then the tests are applied to the `levels`
attribute of `labels`. Otherwise the tests are applied to the elements
of `labels`.

## Usage

``` r
cohort_check(
  labels,
  no_overlap = FALSE,
  no_gap = FALSE,
  no_total = FALSE,
  no_na = FALSE,
  has_open = FALSE,
  interpret_single = c("lower", "upper"),
  interpret_multi = c("include", "exclude"),
  interpret_fail = c("error", "warn", "silent")
)

cohort_assert(
  labels,
  no_overlap = FALSE,
  no_gap = FALSE,
  no_total = FALSE,
  no_na = FALSE,
  has_open = FALSE,
  interpret_single = c("lower", "upper"),
  interpret_multi = c("include", "exclude"),
  interpret_fail = c("error", "warn", "silent")
)
```

## Arguments

- labels:

  Vector of cohort labels.

- no_overlap:

  Check that no cohorts overlap. Default is `FALSE` (don't check).

- no_gap:

  Check that all cohorts between the earliest and latest cohort are
  included. Default is `FALSE` (don't check).

- no_total:

  Check that there is no "Total" label. Default is `FALSE` (don't
  check).

- no_na:

  Check that there is no `NA` label. Default is `FALSE` (don't check).

- has_open:

  Check that at least one cohort has no lower limit. Default is `FALSE`
  (don't check).

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

- `cohort_check()` returns a list with a logical flag called `ok` and a
  [tibble](https://tibble.tidyverse.org/reference/tibble.html) called
  `details` with columns `check`, `passed`, and `comment`.

- `cohort_assert()` returns `labels` invisibly, or raises an error.

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
  has_open = TRUE
)
#> $ok
#> [1] FALSE
#> 
#> $details
#> # A tibble: 5 × 3
#>   check      passed comment                      
#>   <chr>      <lgl>  <chr>                        
#> 1 no_overlap TRUE   NA                           
#> 2 no_gap     TRUE   NA                           
#> 3 no_total   TRUE   NA                           
#> 4 no_na      TRUE   NA                           
#> 5 has_open   FALSE  Highest interval: '2030-2035'
#> 

## throw error if overlap or gap
cohort_assert(
  labels = lab,
  no_overlap = TRUE,
  no_gap = TRUE
)
```
