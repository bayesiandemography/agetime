# Quick start

Datasets often use **character labels** such as `"0-14"`, `"2020-2025"`,
or `"100+"` for age groups, periods, and cohorts. **agetime** infers the
numeric intervals underlying the labels, and provides tools for
filtering, recoding, and validating the intervals.

This vignette introduces the main ideas using age labels. Equivalent
functions exist for periods and cohorts.

## Read intervals from labels

Given a vector of age group labels, extract lower limits, upper limits,
midpoints, and widths:

``` r

library(agetime)

x <- c("0", "1-4", "5-9", "10+")
age_lower(x)
#>   0 1-4 5-9 10+ 
#>   0   1   5  10
age_upper(x)
#>   0 1-4 5-9 10+ 
#>   1   5  10 Inf
age_mid(x)
#>    0  1-4  5-9  10+ 
#>  0.5  3.0  7.5 12.0
age_width(x)
#>   0 1-4 5-9 10+ 
#>   1   4   5 Inf
```

Use the lower limit to **filter** data:

``` r

library(dplyr, warn.conflicts = FALSE)

df <- tibble(
  age   = c("0-14", "15-64", "65+"),
  count = c(100, 200, 50)
)

df |>
  filter(age_lower(age) >= 15)
#> # A tibble: 2 × 2
#>   age   count
#>   <chr> <dbl>
#> 1 15-64   200
#> 2 65+      50
```

[`age_mid()`](https://bayesiandemography.github.io/agetime/reference/age_lower.md)
is useful for plotting.

## Find special labels

**agetime** understands open intervals and totals.

``` r

df <- tibble(
  age   = c("15-64", "0-14", "65+", "All"),
  count = c(5, 2, 6, 13)
)

df |>
  filter(!age_is_total(age))
#> # A tibble: 3 × 2
#>   age   count
#>   <chr> <dbl>
#> 1 15-64     5
#> 2 0-14      2
#> 3 65+       6

df |>
  filter(age_is_open(age))
#> # A tibble: 1 × 2
#>   age   count
#>   <chr> <dbl>
#> 1 65+       6
```

## Standardize messy labels

There are many conventions for age group labels.
[`age_standard()`](https://bayesiandemography.github.io/agetime/reference/age_standard.md)
converts labels to a standard form:

``` r

x <- c("5to9", "10--14", "100plus")
age_standard(x)
#> [1] "5-9"   "10-14" "100+"
```

If `x` is a factor,
[`age_standard()`](https://bayesiandemography.github.io/agetime/reference/age_standard.md)
returns a factor where the levels are also standardized.

## Create a regular series of labels

To generate labels from scratch, use the `age_labels` functions.

``` r

age_labels_five(lower_first = 0, lower_last = 20)
#> [1] "0-4"   "5-9"   "10-14" "15-19" "20+"
age_labels_life()
#>  [1] "0"     "1-4"   "5-9"   "10-14" "15-19" "20-24" "25-29" "30-34" "35-39"
#> [10] "40-44" "45-49" "50-54" "55-59" "60-64" "65-69" "70-74" "75-79" "80-84"
#> [19] "85-89" "90-94" "95-99" "100+"
```

## Modify to new groupings

To **widen** or **realign** age groups, use the `age_modify` functions.

``` r

x <- c("0-4", "5-9", "10-14", "50-54")
age_modify(x, breaks = c(0, 15, 55))
#> [1] "0-14"  "0-14"  "0-14"  "15-54"
age_modify_five(x)
#> [1] "0-4"   "5-9"   "10-14" "50-54"
```

[`age_levels_fill()`](https://bayesiandemography.github.io/agetime/reference/age_levels_fill.md)
adds missing age groups to factor levels, and
[`age_levels_sort()`](https://bayesiandemography.github.io/agetime/reference/age_levels_sort.md)
sorts levels.

## Check and assert

Check whether age labels conform to expectations:

``` r

lab <- age_labels_five(lower_first = 0, lower_last = 85, open = TRUE)
age_check(lab,
          no_overlap = TRUE,
          no_gap = TRUE,
          include_zero = TRUE,
          include_open = TRUE)
#> $ok
#> [1] TRUE
#> 
#> $details
#> # A tibble: 4 × 4
#>   check        asserted observed comment
#>   <chr>        <lgl>    <lgl>    <chr>  
#> 1 no_overlap   TRUE     TRUE     Passed 
#> 2 no_gap       TRUE     TRUE     Passed 
#> 3 include_zero TRUE     TRUE     Passed 
#> 4 include_open TRUE     TRUE     Passed
```

With
[`age_assert()`](https://bayesiandemography.github.io/agetime/reference/age_check.md),
failed checks throw an error.

## Map between label sets

[`age_mapping()`](https://bayesiandemography.github.io/agetime/reference/age_mapping.md)
builds a mapping between sets of labels.

By default,
[`age_mapping()`](https://bayesiandemography.github.io/agetime/reference/age_mapping.md)
looks for intervals that are identical.

``` r

x <- c("10--14", "0--9")
y <- c("0-4", "5-9", "10-14")
age_mapping(x, y, return_val = "matrix")
#>         y
#> x        0-4 5-9 10-14
#>   10--14   0   0     1
#>   0--9     0   0     0
```

But it can look for other types of relationships.

``` r

x <- c("10--14", "0--9")
y <- c("0-4", "5-9", "10-14")
age_mapping(x, y, relation = "contains", return_val = "matrix")
#>         y
#> x        0-4 5-9 10-14
#>   10--14   0   0     1
#>   0--9     1   1     0
```

## Period and cohort

Functions for periods and cohorts work the same way as functions for age
groups.  
For instance:

| Task | Age | Period | Cohort |
|----|----|----|----|
| Lower limit | [`age_lower()`](https://bayesiandemography.github.io/agetime/reference/age_lower.md) | [`period_lower()`](https://bayesiandemography.github.io/agetime/reference/period_lower.md) | [`cohort_lower()`](https://bayesiandemography.github.io/agetime/reference/cohort_lower.md) |
| Standardize | [`age_standard()`](https://bayesiandemography.github.io/agetime/reference/age_standard.md) | [`period_standard()`](https://bayesiandemography.github.io/agetime/reference/period_standard.md) | [`cohort_standard()`](https://bayesiandemography.github.io/agetime/reference/cohort_standard.md) |
| Five-year labels | [`age_labels_five()`](https://bayesiandemography.github.io/agetime/reference/age_labels.md) | [`period_labels_five()`](https://bayesiandemography.github.io/agetime/reference/period_labels.md) | [`cohort_labels_five()`](https://bayesiandemography.github.io/agetime/reference/cohort_labels.md) |
| Modify | [`age_modify()`](https://bayesiandemography.github.io/agetime/reference/age_modify.md) | [`period_modify()`](https://bayesiandemography.github.io/agetime/reference/period_modify.md) | [`cohort_modify()`](https://bayesiandemography.github.io/agetime/reference/cohort_modify.md) |

## Learn more

- [`?agetime`](https://bayesiandemography.github.io/agetime/reference/agetime-package.md)
  for a full list of functions grouped by task
- Package website: <https://bayesiandemography.github.io/agetime/>
