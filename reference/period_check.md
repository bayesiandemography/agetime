# Check or Make Assertions About Periods

Collect information on period labels (`period_check()`), or throw an
error if period labels do not conform to expectations (`period_assert`).

## Usage

``` r
period_check(
  labels,
  no_overlap = NA,
  no_gap = NA,
  no_total = NA,
  no_na = NA,
  interpret_single = c("lower", "upper"),
  interpret_multi = c("include", "exclude"),
  interpret_fail = c("error", "warn", "silent")
)

period_assert(
  labels,
  no_overlap = NA,
  no_gap = NA,
  no_total = NA,
  no_na = NA,
  interpret_single = c("lower", "upper"),
  interpret_multi = c("include", "exclude"),
  interpret_fail = c("error", "warn", "silent")
)
```

## Arguments

- labels:

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

- interpret_single:

  How to interpret labels for single-year periods. Choices are `"lower"`
  (the default) and `"upper"`. See below for details.

- interpret_multi:

  How to interpret labels for multi-year periods. Choices are
  `"include"` (the default) and `"exclude"`. See below for details.

- interpret_fail:

  Action if element of `labels` cannot be interpreted. Choices are
  `"error"` (the default), `"warn"`, and `"silent"`.

## Value

For `period_check()`, a list with logical `ok` and data frame `details`;
for `period_assert()`, `labels` invisibly or an error.

## Controlling how period labels are interpreted

If `interpret_single` is `"lower"` (the default), then labels for
single-year periods are assumed to refer to lower limits, so that
`"2025"` means `[2025,2026)`. This is the convention that data providers
typically use for calendar years.

If `interpret_single` is `"upper"`, then labels for single-year periods
are assumed to refer to upper limits, so that `"2025"` means
`[2024,2025)`. This is the convention that data providers typically use
for non-calendar years, such as 1 July to 30 June.

If `interpret_multi` is `"include"` (the default), then labels for
multi-year periods are assumed to include upper limits, so that
`"2025-2030"` means `[2025,2030)`.

If `interpret_multi` is `"exclude"`, then labels for multi-year periods
are assumed to exclude the upper limits, so that `"2025-2030"` means
`[2025,2031)`.

## See also

- [`age_check()`](https://bayesiandemography.github.io/agetime/reference/age_check.md)
  Age equivalent of `period_check()`

- [`cohort_check()`](https://bayesiandemography.github.io/agetime/reference/cohort_check.md)
  Cohort equivalent of `period_check()`

## Examples

``` r
lab <- period_labels_five(
  lower_first = 2020,
  lower_last = 2030
)
lab
#> [1] "2020-2025" "2025-2030" "2030-2035"

## get info on everything
period_check(
  labels = lab,
  no_overlap = TRUE,
  no_gap = TRUE,
  no_total = TRUE,
  no_na = TRUE
)
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
period_assert(labels = lab, no_gap = TRUE)

lab_gap <- lab[c(1, 3)]
## throw error if no gaps
period_assert(lab_gap, no_gap = FALSE)
```
