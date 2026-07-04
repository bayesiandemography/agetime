# Check or Make Assertions About Age Groups

Collect information on age group labels (`age_check()`), or throw an
error if age group labels do not conform to expectations (`age_assert`).

## Usage

``` r
age_check(
  labels,
  no_overlap = NA,
  no_gap = NA,
  no_total = NA,
  no_na = NA,
  include_zero = NA,
  include_open = NA,
  valid_life = NA,
  interpret_fail = c("error", "warn", "silent")
)

age_assert(
  labels,
  no_overlap = NA,
  no_gap = NA,
  no_total = NA,
  no_na = NA,
  include_zero = NA,
  include_open = NA,
  valid_life = NA,
  interpret_fail = c("error", "warn", "silent")
)
```

## Arguments

- labels:

  Vector of age group labels.

- no_overlap:

  No age groups overlap.

- no_gap:

  Age groups span entire range from lower limit of youngest age group to
  upper limit of oldest age group.

- no_total:

  No "Total" age group.

- no_na:

  No NA age group.

- include_zero:

  One or more age groups have a lower limit of zero.

- include_open:

  One or more age groups has no upper limit.

- valid_life:

  All labels valid for (abridged) life table.

- interpret_fail:

  Action if element of `labels` cannot be parsed: `"error"` (the
  default), `"warn"`, or `"silent"`.

## Value

For `age_check()`, a list with logical `ok` and data frame `details`;
for `age_assert()`, `labels` invisibly or an error.

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
  include_zero = TRUE,
  include_open = TRUE,
  valid_life = TRUE
)
#> $ok
#> [1] TRUE
#> 
#> $details
#> # A tibble: 7 × 4
#>   check        asserted observed comment
#>   <chr>        <lgl>    <lgl>    <chr>  
#> 1 no_overlap   TRUE     TRUE     Passed 
#> 2 no_gap       TRUE     TRUE     Passed 
#> 3 no_total     TRUE     TRUE     Passed 
#> 4 no_na        TRUE     TRUE     Passed 
#> 5 include_zero TRUE     TRUE     Passed 
#> 6 include_open TRUE     TRUE     Passed 
#> 7 valid_life   TRUE     TRUE     Passed 
#> 

## throw error if gaps
age_assert(labels = lab, no_gap = TRUE)

lab_gap <- lab[c(1, 3)]
## throw error if no gaps
age_assert(labels = lab_gap, no_gap = FALSE)
```
