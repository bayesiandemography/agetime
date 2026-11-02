# Diagnostics and Assertions for Cohorts

Check whether cohort labels meet conditions. The `diagnose` functions
report on each condition, and the `assert` functions throw an error if a
condition is not met.

- `cohort_diagnose_values()` and `cohort_assert_values()` check the
  elements of `labels`.

- `cohort_diagnose_levels()` and `cohort_assert_levels()` check the
  levels of `labels`, including any unused levels. Both functions
  require `labels` to be a factor.

Conditions include:

- Not overlapping

- Not having gaps

- Not having totals or missing values

- Having, or not having, open cohorts

## Usage

``` r
cohort_diagnose_levels(
  labels,
  no_overlap = FALSE,
  no_gap = FALSE,
  no_total = FALSE,
  no_missing = FALSE,
  no_open_left = FALSE,
  no_open_right = FALSE,
  has_open_left = FALSE,
  has_open_right = FALSE,
  interpret_single = c("lower", "upper"),
  interpret_multi = NULL,
  interpret_fail = c("error", "warn", "silent")
)

cohort_assert_levels(
  labels,
  no_overlap = FALSE,
  no_gap = FALSE,
  no_total = FALSE,
  no_missing = FALSE,
  no_open_left = FALSE,
  no_open_right = FALSE,
  has_open_left = FALSE,
  has_open_right = FALSE,
  interpret_single = c("lower", "upper"),
  interpret_multi = NULL,
  interpret_fail = c("error", "warn", "silent")
)

cohort_diagnose_values(
  labels,
  no_overlap = FALSE,
  no_gap = FALSE,
  no_total = FALSE,
  no_missing = FALSE,
  no_open_left = FALSE,
  no_open_right = FALSE,
  has_open_left = FALSE,
  has_open_right = FALSE,
  interpret_single = c("lower", "upper"),
  interpret_multi = NULL,
  interpret_fail = c("error", "warn", "silent")
)

cohort_assert_values(
  labels,
  no_overlap = FALSE,
  no_gap = FALSE,
  no_total = FALSE,
  no_missing = FALSE,
  no_open_left = FALSE,
  no_open_right = FALSE,
  has_open_left = FALSE,
  has_open_right = FALSE,
  interpret_single = c("lower", "upper"),
  interpret_multi = NULL,
  interpret_fail = c("error", "warn", "silent")
)
```

## Arguments

- labels:

  Vector of cohort labels.

- no_overlap:

  Check that no cohorts overlap. Different labels that describe the same
  interval, such as `"<2000"` and `"before 2000"`, count as overlapping.
  Totals and missing values, as defined by
  [`cohort_is_total()`](https://bayesiandemography.github.io/agetime/reference/cohort_is_total.md)
  and
  [`cohort_is_missing()`](https://bayesiandemography.github.io/agetime/reference/cohort_is_missing.md),
  are removed before checks for overlaps are performed. Default is
  `FALSE` (don't check).

- no_gap:

  Check that all cohorts between the earliest and latest cohort are
  included. Default is `FALSE` (don't check).

- no_total:

  Check that there is no "total" category, as defined by
  [`cohort_is_total()`](https://bayesiandemography.github.io/agetime/reference/cohort_is_total.md).
  Default is `FALSE` (don't check).

- no_missing:

  Check that there is no "missing" category, as defined by
  [`cohort_is_missing()`](https://bayesiandemography.github.io/agetime/reference/cohort_is_missing.md).
  Default is `FALSE` (don't check).

- no_open_left:

  Check that no cohort is open on the left (has no lower limit), as
  defined by
  [`cohort_is_open_left()`](https://bayesiandemography.github.io/agetime/reference/cohort_is_open_left.md).
  Default is `FALSE` (don't check).

- no_open_right:

  Check that no cohort is open on the right (has no upper limit), as
  defined by
  [`cohort_is_open_right()`](https://bayesiandemography.github.io/agetime/reference/cohort_is_open_left.md).
  Default is `FALSE` (don't check).

- has_open_left:

  Check that at least one cohort is open on the left (has no lower
  limit), as defined by
  [`cohort_is_open_left()`](https://bayesiandemography.github.io/agetime/reference/cohort_is_open_left.md).
  Default is `FALSE` (don't check).

- has_open_right:

  Check that at least one cohort is open on the right (has no upper
  limit), as defined by
  [`cohort_is_open_right()`](https://bayesiandemography.github.io/agetime/reference/cohort_is_open_left.md).
  Default is `FALSE` (don't check).

- interpret_single:

  How to interpret a label for a single year, such as `"2020"`. Choices
  are `"lower"` (the default) and `"upper"`. See below for details.

- interpret_multi:

  How to interpret a label that refers to multiple years, such as
  `"2020-2025"`. Choices are `NULL` (the default), `"at_upper"`, and
  `"below_upper"`. See below for details.

- interpret_fail:

  Action if element of `labels` cannot be interpreted. Choices are
  `"error"` (the default), `"warn"`, and `"silent"`.

## Value

- `cohort_diagnose_levels()` and `cohort_diagnose_values()` return a
  list with a logical flag called `ok` and a
  [tibble](https://tibble.tidyverse.org/reference/tibble.html) called
  `details`.

- `cohort_assert_levels()` and `cohort_assert_values()` return `labels`
  invisibly, or raise an error.

## Rules for interpreting inputs

**Single-year**

Labels for single-year cohorts sometimes refer to the lower limits of
cohorts, and sometimes refer to upper limits. For instance, the label
`"2020"` is sometimes used to refer to the cohort that starts at
midnight on 1 January 2020 and ends at midnight on 1 January 2021, and
is sometimes used to refer to the cohort that starts at midnight on 1
July 2019 and ends at midnight on 1 July 2020.

The `interpret_single` argument can be used to distinguish between the
two conventions:

|                    |                  |                         |
|--------------------|------------------|-------------------------|
| `interpret_single` | *Rule*           | *Example*               |
| `"lower"`          | `"a" -> [a,a+1)` | `"2020" -> [2020,2021)` |
| `"upper"`          | `"a" -> [a-1,a)` | `"2020" -> [2019,2020)` |

**Multi-year**

In labels for multi-year cohorts, the second number is sometimes the
upper limit of the cohort, and sometimes the upper limit minus 1. For
instance, the cohort that starts at midnight on 1 January 2020 and ends
at midnight on 1 January 2025 is sometimes labelled `"2020-2025"` and is
sometimes labelled `"2020-2024"`.

The `interpret_multi` argument can be used to distinguish between the
two conventions:

|                   |                    |                              |
|-------------------|--------------------|------------------------------|
| `interpret_multi` | *Rule*             | *Example*                    |
| `"at_upper"`      | `"a-b" -> [a,b)`   | `"2020-2025" -> [2020,2025)` |
| `"below_upper"`   | `"a-b" -> [a,b+1)` | `"2020-2024" -> [2020,2025)` |

If `interpret_multi` is `NULL` (the default), then multi-year labels are
interpreted using the `"at_upper"` convention. If, however, the
`"at_upper"` convention leads to intervals with widths 4, 9, 14, ...,
then agetime emits a message. Supplying an explicit value for
`interpret_multi` silences this message.

**Open**

A cohort that is open on the left has no lower limit, and a cohort that
is open on the right has no upper limit. Labels for open cohorts are not
affected by `interpret_single` or `interpret_multi`.

Some examples of open cohorts:

|                                                |               |
|------------------------------------------------|---------------|
| *Label*                                        | *Interval*    |
| `"<2000"`, `"before 2000"`, `"under 2000"`     | `(-Inf,2000)` |
| `"2000 or earlier"`, `"up to 2000"`            | `(-Inf,2001)` |
| `"2000+"`, `"2000 or more"`, `"2000 or later"` | `[2000,Inf)`  |

Labels starting with `"-"`, such as `"-2000"`, are not accepted.

## See also

- [`age_assert_values()`](https://bayesiandemography.github.io/agetime/reference/age_diagnose_levels.md),
  [`age_assert_levels()`](https://bayesiandemography.github.io/agetime/reference/age_diagnose_levels.md)

- [`age_diagnose_values()`](https://bayesiandemography.github.io/agetime/reference/age_diagnose_levels.md),
  [`age_diagnose_levels()`](https://bayesiandemography.github.io/agetime/reference/age_diagnose_levels.md)

- [`period_assert_values()`](https://bayesiandemography.github.io/agetime/reference/period_diagnose_levels.md),
  [`period_assert_levels()`](https://bayesiandemography.github.io/agetime/reference/period_diagnose_levels.md)

- [`period_diagnose_values()`](https://bayesiandemography.github.io/agetime/reference/period_diagnose_levels.md),
  [`period_diagnose_levels()`](https://bayesiandemography.github.io/agetime/reference/period_diagnose_levels.md)

## Examples

``` r
lab <- cohort_labels_five(
  lower_first = 2020,
  lower_last = 2030
)
lab
#> [1] "2020-2025" "2025-2030" "2030-2035"

## get info on everything
cohort_diagnose_values(
  labels = lab,
  no_overlap = TRUE,
  no_gap = TRUE,
  no_total = TRUE,
  no_missing = TRUE,
  has_open_left = TRUE,
  has_open_right = TRUE
)
#> $ok
#> [1] FALSE
#> 
#> $details
#> # A tibble: 6 × 3
#>   condition      passed comment                                   
#>   <chr>          <lgl>  <chr>                                     
#> 1 no_overlap     TRUE   NA                                        
#> 2 no_gap         TRUE   NA                                        
#> 3 no_total       TRUE   NA                                        
#> 4 no_missing     TRUE   NA                                        
#> 5 has_open_left  FALSE  Lowest interval among values: '2020-2025' 
#> 6 has_open_right FALSE  Highest interval among values: '2030-2035'
#> 

## throw error if overlap or gap
cohort_assert_values(
  labels = lab,
  no_overlap = TRUE,
  no_gap = TRUE
)

## repeated labels count as overlapping...
df <- data.frame(
  cohort = c("2020-2025", "2025-2030", "2020-2025", "2025-2030"),
  sex = c("F", "F", "M", "M")
)
cohort_diagnose_values(df$cohort, no_overlap = TRUE)
#> $ok
#> [1] FALSE
#> 
#> $details
#> # A tibble: 1 × 3
#>   condition  passed comment                                                     
#>   <chr>      <lgl>  <chr>                                                       
#> 1 no_overlap FALSE  Example of overlap among values: '2020-2025' appears 2 time…
#> 

## ...so check within groups
library(dplyr, warn.conflicts = FALSE)
df |>
  group_by(sex) |>
  mutate(cohort = cohort_assert_values(cohort, no_overlap = TRUE))
#> # A tibble: 4 × 2
#> # Groups:   sex [2]
#>   cohort    sex  
#>   <chr>     <chr>
#> 1 2020-2025 F    
#> 2 2025-2030 F    
#> 3 2020-2025 M    
#> 4 2025-2030 M    

## factor with unused level
fac <- factor(
  x = "2020-2025",
  levels = c("2020-2025", "2030-2035")
)
fac
#> [1] 2020-2025
#> Levels: 2020-2025 2030-2035
cohort_diagnose_levels(fac, no_gap = TRUE)
#> $ok
#> [1] FALSE
#> 
#> $details
#> # A tibble: 1 × 3
#>   condition passed comment                                    
#>   <chr>     <lgl>  <chr>                                      
#> 1 no_gap    FALSE  Example: gap among levels below '2030-2035'
#> 
cohort_diagnose_values(fac, no_gap = TRUE)
#> $ok
#> [1] TRUE
#> 
#> $details
#> # A tibble: 1 × 3
#>   condition passed comment
#>   <chr>     <lgl>  <chr>  
#> 1 no_gap    TRUE   NA     
#> 
```
