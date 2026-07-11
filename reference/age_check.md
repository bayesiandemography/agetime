# Check or Make Assertions About Age Groups

`age_check()` reports on whether age group labels meet conditions such
as not overlapping.

`age_assert()` throws an error if conditions are not met.

## Usage

``` r
age_check(
  labels,
  no_overlap = FALSE,
  no_gap = FALSE,
  no_total = FALSE,
  no_na = FALSE,
  has_zero = FALSE,
  has_open_right = FALSE,
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
  has_open_right = FALSE,
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

- has_open_right:

  Check that at least one age group is open on the right (has no upper
  limit). Default is `FALSE` (don't check).

- valid_life:

  Check that all labels are valid for an abridged life table. Default is
  `FALSE` (don't check).

- interpret_fail:

  Action if element of `labels` cannot be interpreted. Choices are
  `"error"` (the default), `"warn"`, and `"silent"`.

## Value

- `age_check()` returns a list with a logical flag called `ok` and a
  [tibble](https://tibble.tidyverse.org/reference/tibble.html) called
  `details`.

- `age_assert()` returns `labels` invisibly, or raises an error.

## Abridged and complete life tables

- An 'abridged' life table uses age groups `"0"` and `"1-4"`, followed
  by 5-year age groups `"5-9"`, `"10-14"`, ...

- A 'complete' life table uses single-year age groups `"0"`, `"1"`,
  `"2"`, ...

- Both types of life table have an open interval such as `"85+"` or
  `"100+"`.

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
  has_open_right = TRUE,
  valid_life = TRUE
)
#> $ok
#> [1] TRUE
#> 
#> $details
#> # A tibble: 7 × 3
#>   check          passed comment
#>   <chr>          <lgl>  <chr>  
#> 1 no_overlap     TRUE   NA     
#> 2 no_gap         TRUE   NA     
#> 3 no_total       TRUE   NA     
#> 4 no_na          TRUE   NA     
#> 5 has_zero       TRUE   NA     
#> 6 has_open_right TRUE   NA     
#> 7 valid_life     TRUE   NA     
#> 

## throw error if overlap or gap
age_assert(
  labels = lab,
  no_overlap = TRUE,
  no_gap = TRUE
)
```
