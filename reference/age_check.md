# Check or Make Assertions About Age Groups

`age_check()` creates reports comparing age group labels against
expectations.

`age_assert()` throws an error if age group labels do not conform to
expectations.

If `labels` is a factor, then the tests are applied to the `levels`
attribute of `labels`. Otherwise the tests are applied to the elements
of `labels`.

## Usage

``` r
age_check(
  labels,
  no_overlap = FALSE,
  no_gap = FALSE,
  no_total = FALSE,
  no_na = FALSE,
  has_zero = FALSE,
  has_open = FALSE,
  valid_life = FALSE,
  interpret_fail = c("error", "warn", "silent")
)

age_assert(
  labels,
  no_overlap = FALSE,
  no_gap = FALSE,
  no_total = FALSE,
  no_na = FALSE,
  has_zero = FALSE,
  has_open = FALSE,
  valid_life = FALSE,
  interpret_fail = c("error", "warn", "silent")
)
```

## Arguments

- labels:

  Vector of age group labels.

- no_overlap:

  Check that no age groups overlap. Default is `FALSE` (don't check).

- no_gap:

  Check that all ages between the youngest and oldest age groups are
  included. Default is `FALSE` (don't check).

- no_total:

  Check that there is no "Total" label. Default is `FALSE` (don't
  check).

- no_na:

  Check that there is no `NA` label. Default is `FALSE` (don't check).

- has_zero:

  Check that at least one age group has a lower limit of zero. Default
  is `FALSE` (don't check).

- has_open:

  Check that at least one age group has no upper limit. Default is
  `FALSE` (don't check).

- valid_life:

  Check that all labels are valid for an abridged life table. Default is
  `FALSE` (don't check).

- interpret_fail:

  Action if element of `labels` cannot be interpreted. Choices are
  `"error"` (the default), `"warn"`, and `"silent"`.

## Value

- `age_check()` returns a list with a logical flag called `ok` and a
  [tibble](https://tibble.tidyverse.org/reference/tibble.html) called
  `details` with columns `check`, `passed`, and `comment`.

- `age_assert()` returns `labels` invisibly, or raises an error.

## Abridged and complete life tables

An 'abridged' life table uses age groups `"0"`, `"1-4"`, `"5-9"`,
`"10-14"`, and so on up to the oldest age group, which is open on the
right. A 'complete' life table uses single-year age groups.

## See also

- [`period_check()`](https://bayesiandemography.github.io/agetime/reference/period_check.md)
  Period equivalent of `age_check()`

- [`cohort_check()`](https://bayesiandemography.github.io/agetime/reference/cohort_check.md)
  Cohort equivalent of `age_check()`

## Examples

``` r
lab <- age_labels_life()
lab
#>  [1] "0"     "1-4"   "5-9"   "10-14" "15-19" "20-24" "25-29" "30-34" "35-39"
#> [10] "40-44" "45-49" "50-54" "55-59" "60-64" "65-69" "70-74" "75-79" "80-84"
#> [19] "85-89" "90-94" "95-99" "100+" 

## get info on everything
age_check(
  labels = lab,
  no_overlap = TRUE,
  no_gap = TRUE,
  no_total = TRUE,
  no_na = TRUE,
  has_zero = TRUE,
  has_open = TRUE,
  valid_life = TRUE
)
#> $ok
#> [1] TRUE
#> 
#> $details
#> # A tibble: 7 × 3
#>   check      passed comment
#>   <chr>      <lgl>  <chr>  
#> 1 no_overlap TRUE   NA     
#> 2 no_gap     TRUE   NA     
#> 3 no_total   TRUE   NA     
#> 4 no_na      TRUE   NA     
#> 5 has_zero   TRUE   NA     
#> 6 has_open   TRUE   NA     
#> 7 valid_life TRUE   NA     
#> 

## throw error if overlap or gap
age_assert(
  labels = lab,
  no_overlap = TRUE,
  no_gap = TRUE
)
```
