# Diagnostics and Assertions for Cohorts

`cohort_diagnose()` reports whether cohort labels meet conditions.

`cohort_assert()` throws an error if conditions are not met.

Conditions include:

- Not overlapping

- Not having gaps

- Having totals or NAs

- Having open cohorts

If `labels` is a factor, `cohort_diagnose()` and `cohort_assert()` check
levels, including unused levels, rather than values. To check the values
of a factor, use `cohort_diagnose_values()` or `cohort_assert_values()`.
Checking values rather than levels is sometimes useful when working with
subsets of factors, such as when working with grouped data.

## Usage

``` r
cohort_diagnose(
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

cohort_assert(
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

cohort_diagnose_values(
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

cohort_assert_values(
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

  Vector of cohort labels.

- no_overlap:

  Check that no cohorts overlap. Default is `FALSE` (don't check).

- no_gap:

  Check that all cohorts between the earliest and latest cohort are
  included. Default is `FALSE` (don't check).

- no_total:

  Check that there is no total category. Default is `FALSE` (don't
  check).

- no_na:

  Check that there is no `NA` category. Default is `FALSE` (don't
  check).

- has_open_left:

  Check that at least one cohort is open on the left (has no lower
  limit). Default is `FALSE` (don't check).

- has_open_right:

  Check that at least one cohort is open on the right (has no upper
  limit). Default is `FALSE` (don't check).

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

- `cohort_diagnose()` and `cohort_diagnose_values()` return a list with
  a logical flag called `ok` and a
  [tibble](https://tibble.tidyverse.org/reference/tibble.html) called
  `details`.

- `cohort_assert()` and `cohort_assert_values()` return `labels`
  invisibly, or raise an error.

## Rules for interpreting inputs

Single-year cohorts:

|                    |                  |                         |
|--------------------|------------------|-------------------------|
| `interpret_single` | *Rule*           | *Example*               |
| `"lower"`          | `"a" -> [a,a+1)` | `"2020" -> [2020,2021)` |
| `"upper"`          | `"a" -> [a-1,a)` | `"2020" -> [2019,2020)` |

Data providers typically use the "lower" convention for calendar years
(1 January to 31 December), and the "upper" convention for non-calendar
years (e.g., 1 July to 30 June).

Multi-year cohorts:

|                   |                          |                              |
|-------------------|--------------------------|------------------------------|
| `interpret_multi` | *Rule*                   | *Example*                    |
| `"include"`       | `"a-<a+n>" -> [a,a+n)`   | `"2020-2025" -> [2020,2025)` |
| `"exclude"`       | `"a-<a+n-1>" -> [a,a+n)` | `"2020-2024" -> [2020,2025)` |

A two-value label cannot describe a one-year cohort. With
`interpret_multi = "include"`, `"2010-2011"` would be `[2010, 2011)` and
`"2010-2010"` would be empty; both are rejected. Use `"2010"`, or
`"2010-2012"` for two years. With `interpret_multi = "exclude"`,
`"2010-2011"` is two years `[2010, 2012)` and is accepted.

## See also

- `cohort_diagnose_values()` Check observed values only

- [`age_diagnose()`](https://bayesiandemography.github.io/agetime/reference/age_diagnose.md)
  Age equivalent of `cohort_diagnose()`

- [`period_diagnose()`](https://bayesiandemography.github.io/agetime/reference/period_diagnose.md)
  Period equivalent of `cohort_diagnose()`

## Examples

``` r
lab <- cohort_labels_five(
  lower_first = 2020,
  lower_last = 2030
)
lab
#> [1] "2020-2025" "2025-2030" "2030-2035"

## get info on everything
cohort_diagnose(
  labels = lab,
  no_overlap = TRUE,
  no_gap = TRUE,
  no_total = TRUE,
  no_na = TRUE,
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
#> 4 no_na          TRUE   NA                                        
#> 5 has_open_left  FALSE  Lowest interval among levels: '2020-2025' 
#> 6 has_open_right FALSE  Highest interval among levels: '2030-2035'
#> 

## throw error if overlap or gap
cohort_assert(
  labels = lab,
  no_overlap = TRUE,
  no_gap = TRUE
)

## factor with unused levels
fac <- factor(
  x = "2020-2025",
  levels = c("2020-2025", "2030-2035")
)
fac
#> [1] 2020-2025
#> Levels: 2020-2025 2030-2035
cohort_diagnose(fac, no_gap = TRUE)
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
