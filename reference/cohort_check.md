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
  label_one = c("lower", "upper"),
  label_multi = c("include", "exclude"),
  unknown_label = c("error", "warn", "silent")
)

cohort_assert(
  x,
  no_overlap = NA,
  no_gap = NA,
  no_total = NA,
  no_na = NA,
  include_open = NA,
  label_one = c("lower", "upper"),
  label_multi = c("include", "exclude"),
  unknown_label = c("error", "warn", "silent")
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

- label_one:

  Whether labels for one-year cohorts are based on the lower or upper
  limit of the period. Default is `"lower"`.

- label_multi:

  Whether labels for multi-year periods include or exclude the final
  year of the period. Default is `"include"`.

- unknown_label:

  Action if a label cannot be interpreted. Choices are `"error"` (the
  default), `"warn"`, and `"silent"`.

## Value

- `cohort_check()` returns a list with components `ok` (a logical flag)
  and `details` (a data frame).

- `cohort_assert()` returns `x` invisibly, or throws an error.

## Examples

``` r
lab <- cohort_labels_five(lower_first = 2020,
                          lower_last = 2030)
#> Error in loadNamespace(x): there is no package called ‘poputils’
lab
#> Error: object 'lab' not found

## get info on everything
cohort_check(x = lab,
             no_overlap = TRUE,
             no_gap = TRUE,
             no_total = TRUE,
             no_na = TRUE,
             include_open = TRUE)
#> Error: object 'lab' not found

## throw error if gaps
cohort_assert(x = lab, no_gap = TRUE)
#> Error: object 'lab' not found

lab_gap <- lab[c(1, 3)]
#> Error: object 'lab' not found
## throw error if no gaps
cohort_assert(lab_gap, no_gap = FALSE)
#> Error: object 'lab_gap' not found
```
