# Diagnostics and Assertions for Age Groups

`age_diagnose()` reports whether age group labels meet conditions.

`age_assert()` throws an error if conditions are not met.

Conditions include:

- Not overlapping

- Not having gaps

- Having totals, NAs, or zeros

- Having open age groups

- Valid for an abridged life table

If `labels` is a factor, `age_diagnose()` and `age_assert()` check
levels, including unused levels, rather than values. To check the values
of a factor, use `age_diagnose_values()` or `age_assert_values()`.
Checking values rather than levels is sometimes useful when working with
subsets of factors, such as when working with grouped data.

## Usage

``` r
age_diagnose(
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

age_diagnose_values(
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

age_assert_values(
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

  Check that there is no total category. Default is `FALSE` (don't
  check).

- no_na:

  Check that there is no `NA` category. Default is `FALSE` (don't
  check).

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

- `age_diagnose()` and `age_diagnose_values()` return a list with a
  logical flag called `ok` and a
  [tibble](https://tibble.tidyverse.org/reference/tibble.html) called
  `details`.

- `age_assert()` and `age_assert_values()` return `labels` invisibly, or
  raise an error.

## Abridged and complete life tables

- An abridged life table uses age groups `"0"` and `"1-4"`, followed by
  5-year age groups such as `"5-9"` and `"10-14"`.

- A complete life table uses single-year age groups such as `"0"`,
  `"1"`, and `"2"`.

- Both types of life table usually have an open age group such as
  `"85+"` or `"100+"`.

## See also

- `age_diagnose_values()` Check observed values only

- [`period_diagnose()`](https://bayesiandemography.github.io/agetime/reference/period_diagnose.md)
  Period equivalent of `age_diagnose()`

- [`cohort_diagnose()`](https://bayesiandemography.github.io/agetime/reference/cohort_diagnose.md)
  Cohort equivalent of `age_diagnose()`

## Examples

``` r
lab <- age_labels_life()
lab
#>  [1] "0"     "1-4"   "5-9"   "10-14" "15-19" "20-24" "25-29" "30-34" "35-39"
#> [10] "40-44" "45-49" "50-54" "55-59" "60-64" "65-69" "70-74" "75-79" "80-84"
#> [19] "85-89" "90-94" "95-99" "100+" 

## get info on everything
age_diagnose(
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
#>   condition      passed comment
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

## factor with unused overlapping level
fac <- factor(
  x = "0-4",
  levels = c("0-4", "3-7")
)
fac
#> [1] 0-4
#> Levels: 0-4 3-7
age_diagnose(fac, no_overlap = TRUE)
#> $ok
#> [1] FALSE
#> 
#> $details
#> # A tibble: 1 × 3
#>   condition  passed comment                                         
#>   <chr>      <lgl>  <chr>                                           
#> 1 no_overlap FALSE  Example of overlap among levels: '0-4' and '3-7'
#> 
age_diagnose_values(fac, no_overlap = TRUE)
#> $ok
#> [1] TRUE
#> 
#> $details
#> # A tibble: 1 × 3
#>   condition  passed comment
#>   <chr>      <lgl>  <chr>  
#> 1 no_overlap TRUE   NA     
#> 
```
