# Diagnostics and Assertions for Age Groups

Check whether age group labels meet conditions. The `diagnose` functions
report on each condition, and the `assert` functions throw an error if a
condition is not met.

- `age_diagnose_values()` and `age_assert_values()` check the elements
  of `labels`.

- `age_diagnose_levels()` and `age_assert_levels()` check the levels of
  `labels`, including any unused levels. Both functions require `labels`
  to be a factor.

Conditions include:

- Not overlapping

- Not having gaps

- Not having totals or missing values

- Having, or not having, open age groups

- Having an age group that starts at zero

- Only including age groups used by an abridged life table

## Usage

``` r
age_diagnose_levels(
  labels,
  no_overlap = FALSE,
  no_gap = FALSE,
  no_total = FALSE,
  no_missing = FALSE,
  no_open_right = FALSE,
  has_open_right = FALSE,
  has_zero = FALSE,
  valid_life = FALSE,
  interpret_fail = c("error", "warn", "silent")
)

age_assert_levels(
  labels,
  no_overlap = FALSE,
  no_gap = FALSE,
  no_total = FALSE,
  no_missing = FALSE,
  no_open_right = FALSE,
  has_open_right = FALSE,
  has_zero = FALSE,
  valid_life = FALSE,
  interpret_fail = c("error", "warn", "silent")
)

age_diagnose_values(
  labels,
  no_overlap = FALSE,
  no_gap = FALSE,
  no_total = FALSE,
  no_missing = FALSE,
  no_open_right = FALSE,
  has_open_right = FALSE,
  has_zero = FALSE,
  valid_life = FALSE,
  interpret_fail = c("error", "warn", "silent")
)

age_assert_values(
  labels,
  no_overlap = FALSE,
  no_gap = FALSE,
  no_total = FALSE,
  no_missing = FALSE,
  no_open_right = FALSE,
  has_open_right = FALSE,
  has_zero = FALSE,
  valid_life = FALSE,
  interpret_fail = c("error", "warn", "silent")
)
```

## Arguments

- labels:

  Vector of age group labels.

- no_overlap:

  Check that no age groups overlap. Different labels that describe the
  same interval, such as `"0"` and `"infant"`, count as overlapping.
  Totals and missing values, as defined by
  [`age_is_total()`](https://bayesiandemography.github.io/agetime/reference/age_is_total.md)
  and
  [`age_is_missing()`](https://bayesiandemography.github.io/agetime/reference/age_is_missing.md),
  are removed before checks for overlaps are performed. Default is
  `FALSE` (don't check).

- no_gap:

  Check that all ages between the youngest and oldest age groups are
  included. Default is `FALSE` (don't check).

- no_total:

  Check that there is no "total" category, as defined by
  [`age_is_total()`](https://bayesiandemography.github.io/agetime/reference/age_is_total.md).
  Default is `FALSE` (don't check).

- no_missing:

  Check that there is no "missing" category, as defined by
  [`age_is_missing()`](https://bayesiandemography.github.io/agetime/reference/age_is_missing.md).
  Default is `FALSE` (don't check).

- no_open_right:

  Check that no age group is open on the right (has no upper limit), as
  defined by
  [`age_is_open_right()`](https://bayesiandemography.github.io/agetime/reference/age_is_open_right.md).
  Default is `FALSE` (don't check).

- has_open_right:

  Check that at least one age group is open on the right (has no upper
  limit), as defined by
  [`age_is_open_right()`](https://bayesiandemography.github.io/agetime/reference/age_is_open_right.md).
  Default is `FALSE` (don't check).

- has_zero:

  Check that at least one age group has a lower limit of zero. Default
  is `FALSE` (don't check).

- valid_life:

  Check that all labels are valid for an abridged life table. Default is
  `FALSE` (don't check).

- interpret_fail:

  Action if element of `labels` cannot be interpreted. Choices are
  `"error"` (the default), `"warn"`, and `"silent"`.

## Value

- `age_diagnose_levels()` and `age_diagnose_values()` return a list with
  a logical flag called `ok` and a
  [tibble](https://tibble.tidyverse.org/reference/tibble.html) called
  `details`.

- `age_assert_levels()` and `age_assert_values()` return `labels`
  invisibly, or raise an error.

## Abridged and complete life tables

- An abridged life table uses age groups `"0"` and `"1-4"`, followed by
  5-year age groups such as `"5-9"` and `"10-14"`.

- A complete life table uses single-year age groups such as `"0"`,
  `"1"`, and `"2"`.

- Both types of life table usually have an open age group such as
  `"85+"` or `"100+"`.

## See also

- [`period_assert_values()`](https://bayesiandemography.github.io/agetime/reference/period_diagnose_levels.md),
  [`period_assert_levels()`](https://bayesiandemography.github.io/agetime/reference/period_diagnose_levels.md)

- [`period_diagnose_values()`](https://bayesiandemography.github.io/agetime/reference/period_diagnose_levels.md),
  [`period_diagnose_levels()`](https://bayesiandemography.github.io/agetime/reference/period_diagnose_levels.md)

- [`cohort_assert_values()`](https://bayesiandemography.github.io/agetime/reference/cohort_diagnose_levels.md),
  [`cohort_assert_levels()`](https://bayesiandemography.github.io/agetime/reference/cohort_diagnose_levels.md)

- [`cohort_diagnose_values()`](https://bayesiandemography.github.io/agetime/reference/cohort_diagnose_levels.md),
  [`cohort_diagnose_levels()`](https://bayesiandemography.github.io/agetime/reference/cohort_diagnose_levels.md)

## Examples

``` r
lab <- age_labels_life()
lab
#>  [1] "0"     "1-4"   "5-9"   "10-14" "15-19" "20-24" "25-29" "30-34" "35-39"
#> [10] "40-44" "45-49" "50-54" "55-59" "60-64" "65-69" "70-74" "75-79" "80-84"
#> [19] "85-89" "90-94" "95-99" "100+" 

## get info on everything
age_diagnose_values(
  labels = lab,
  no_overlap = TRUE,
  no_gap = TRUE,
  no_total = TRUE,
  no_missing = TRUE,
  has_open_right = TRUE,
  has_zero = TRUE,
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
#> 4 no_missing     TRUE   NA     
#> 5 has_open_right TRUE   NA     
#> 6 has_zero       TRUE   NA     
#> 7 valid_life     TRUE   NA     
#> 

## throw error if overlap or gap
age_assert_values(
  labels = lab,
  no_overlap = TRUE,
  no_gap = TRUE
)

## repeated labels count as overlapping...
df <- data.frame(
  age = c("0-4", "5-9", "0-4", "5-9"),
  sex = c("F", "F", "M", "M")
)
age_diagnose_values(df$age, no_overlap = TRUE)
#> $ok
#> [1] FALSE
#> 
#> $details
#> # A tibble: 1 × 3
#>   condition  passed comment                                                     
#>   <chr>      <lgl>  <chr>                                                       
#> 1 no_overlap FALSE  Example of overlap among values: '0-4' appears 2 times. To …
#> 

## ...so check within groups
library(dplyr, warn.conflicts = FALSE)
df |>
  group_by(sex) |>
  mutate(age = age_assert_values(age, no_overlap = TRUE))
#> # A tibble: 4 × 2
#> # Groups:   sex [2]
#>   age   sex  
#>   <chr> <chr>
#> 1 0-4   F    
#> 2 5-9   F    
#> 3 0-4   M    
#> 4 5-9   M    

## factor with unused level
fac <- factor(
  x = "0-4",
  levels = c("0-4", "3-7")
)
fac
#> [1] 0-4
#> Levels: 0-4 3-7
age_diagnose_levels(fac, no_overlap = TRUE)
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
