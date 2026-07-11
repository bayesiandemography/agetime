# Check or Make Assertions About Periods

`period_check()` reports on whether period labels meet conditions such
as not overlapping.

`period_assert()` throws an error if conditions are not met.

## Usage

``` r
period_check(
  labels,
  no_overlap = FALSE,
  no_gap = FALSE,
  no_total = FALSE,
  no_na = FALSE,
  has_open_left = FALSE,
  has_open_right = FALSE,
  interpret_single = c("lower", "upper"),
  interpret_multi = c("include", "exclude"),
  interpret_fail = c("error", "warn", "silent")
)

period_assert(
  labels,
  no_overlap = FALSE,
  no_gap = FALSE,
  no_total = FALSE,
  no_na = FALSE,
  has_open_left = FALSE,
  has_open_right = FALSE,
  interpret_single = c("lower", "upper"),
  interpret_multi = c("include", "exclude"),
  interpret_fail = c("error", "warn", "silent")
)
```

## Arguments

- labels:

  Vector of period labels.

- no_overlap:

  Check that no periods overlap. Default is `FALSE` (don't check).

- no_gap:

  Check that all periods between the earliest and latest periods are
  included. Default is `FALSE` (don't check).

- no_total:

  Check that there is no "Total" label. Default is `FALSE` (don't
  check).

- no_na:

  Check that there is no `NA` label. Default is `FALSE` (don't check).

- has_open_left:

  Check that at least one period is open on the left (has no lower
  limit). Default is `FALSE` (don't check).

- has_open_right:

  Check that at least one period is open on the right (has no upper
  limit). Default is `FALSE` (don't check).

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

- `period_check()` returns a list with a logical flag called `ok` and a
  [tibble](https://tibble.tidyverse.org/reference/tibble.html) called
  `details`.

- `period_assert()` returns `labels` invisibly, or raises an error.

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
#> # A tibble: 4 × 3
#>   check      passed comment
#>   <chr>      <lgl>  <chr>  
#> 1 no_overlap TRUE   NA     
#> 2 no_gap     TRUE   NA     
#> 3 no_total   TRUE   NA     
#> 4 no_na      TRUE   NA     
#> 

## throw error if overlap or gap
period_assert(
  labels = lab,
  no_overlap = TRUE,
  no_gap = TRUE
)
```
