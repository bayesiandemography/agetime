# Quick start

Working with age group, period, and cohort labels can be awkward and
error-prone. The `agetime` package makes it easier.

## Infer intervals from labels

Given a vector of age group labels, extract lower limits, upper limits,
midpoints, and widths:

``` r

library(agetime)

x <- c("0", "1-4", "5-9", "10+")
age_lower(x)
#> [1]  0  1  5 10
age_upper(x)
#> [1]   1   5  10 Inf
age_mid(x)
#> [1]  0.5  3.0  7.5 12.5
age_width(x)
#> [1]   1   4   5 Inf
```

Use the lower limit to filter rows:

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

## Find special labels

`agetime` knows about totals and open intervals.

``` r

df <- tibble(
  period = c("<2000", "2000-2010", "2010-2015", "Total"),
  count  = c(5, 2, 6, 13)
)

df |>
  filter(!period_is_total(period))
#> # A tibble: 3 × 2
#>   period    count
#>   <chr>     <dbl>
#> 1 <2000         5
#> 2 2000-2010     2
#> 3 2010-2015     6

df |>
  filter(period_is_open_right(period))
#> # A tibble: 0 × 2
#> # ℹ 2 variables: period <chr>, count <dbl>
```

## Standardize messy labels

[`age_standard()`](https://bayesiandemography.github.io/agetime/reference/age_standard.md)
converts labels to a standard format:

``` r

x <- c("5to9", "10--14", "100plus")
age_standard(x)
#> [1] "5-9"   "10-14" "100+"
```

## Create a regular series of labels

The `cohort_labels` functions generate labels from scratch.

``` r

cohort_labels_five(lower_first = 2000, lower_last = 2015)
#> [1] "2000-2005" "2005-2010" "2010-2015" "2015-2020"
```

## Manipulate levels

Use the `age_coarsen` functions to convert to wider age groups.

``` r

x <- c("0-4", "5-9", "10-14", "50-54")
age_coarsen(x, breaks = c(0, 15, 55))
#> [1] 0-14  0-14  0-14  15-54
#> Levels: 0-14 15-54
age_coarsen_five(x)
#> [1] 0-4   5-9   10-14 50-54
#> Levels: 0-4 5-9 10-14 50-54
```

Use the `age_fill` functions to add intermediate levels:

``` r

x |>
  age_coarsen_five() |>
  age_fill_five()
#> [1] 0-4   5-9   10-14 50-54
#> Levels: 0-4 5-9 10-14 15-19 20-24 25-29 30-34 35-39 40-44 45-49 50-54
```

## Check and assert

Check whether period labels conform to expectations:

``` r

lab <- period_labels_five(
  lower_first = 2000,
  lower_last = 2020
)
period_diagnose_values(
  lab,
  no_overlap = TRUE,
  no_gap = TRUE,
  no_open_right = TRUE
)
#> $ok
#> [1] TRUE
#> 
#> $details
#> # A tibble: 3 × 3
#>   condition     passed comment
#>   <chr>         <lgl>  <chr>  
#> 1 no_overlap    TRUE   NA     
#> 2 no_gap        TRUE   NA     
#> 3 no_open_right TRUE   NA
```

[`period_assert_values()`](https://bayesiandemography.github.io/agetime/reference/period_diagnose_levels.md)
throws an error if a check fails.
[`period_diagnose_levels()`](https://bayesiandemography.github.io/agetime/reference/period_diagnose_levels.md)
and
[`period_assert_levels()`](https://bayesiandemography.github.io/agetime/reference/period_diagnose_levels.md)
check the levels of a factor, including unused levels.

## Create mappings

[`age_mapping()`](https://bayesiandemography.github.io/agetime/reference/age_mapping.md)
builds a mapping between sets of labels.

``` r

labels_x <- c("10--14", "0--9")
labels_y <- c("0-4", "5-9", "10-14")
age_mapping(
  labels_x,
  labels_y,
  relation = "contains",
  format = "matrix"
)
#>         y
#> x        0-4 5-9 10-14
#>   10--14   0   0     1
#>   0--9     1   1     0
```

## Age, period, and cohort

Most functions have age, period, and cohort equivalents. For instance:

| Age | Period | Cohort |
|----|----|----|
| [`age_lower()`](https://bayesiandemography.github.io/agetime/reference/age_lower.md) | [`period_lower()`](https://bayesiandemography.github.io/agetime/reference/period_lower.md) | [`cohort_lower()`](https://bayesiandemography.github.io/agetime/reference/cohort_lower.md) |
| [`age_standard()`](https://bayesiandemography.github.io/agetime/reference/age_standard.md) | [`period_standard()`](https://bayesiandemography.github.io/agetime/reference/period_standard.md) | [`cohort_standard()`](https://bayesiandemography.github.io/agetime/reference/cohort_standard.md) |
| [`age_labels_five()`](https://bayesiandemography.github.io/agetime/reference/age_labels.md) | [`period_labels_five()`](https://bayesiandemography.github.io/agetime/reference/period_labels.md) | [`cohort_labels_five()`](https://bayesiandemography.github.io/agetime/reference/cohort_labels.md) |
| [`age_coarsen()`](https://bayesiandemography.github.io/agetime/reference/age_coarsen.md) | [`period_coarsen()`](https://bayesiandemography.github.io/agetime/reference/period_coarsen.md) | [`cohort_coarsen()`](https://bayesiandemography.github.io/agetime/reference/cohort_coarsen.md) |

## Function tasks

`agetime` functions fall into five groups:

| Task | Examples (`age`/`period`/`cohort` omitted) | Return value |
|----|----|----|
| Extract limits or identify special labels | `_lower()`, `_upper()`, `_mid()`, `_width()`, `_is_total()` | Numeric or logical |
| Create a new series, or reformat existing labels | `_interval()`, `_labels_five()`, `_standard()`, `_extend()` | Character, or same type as `labels` |
| Recode values and set factor levels | `_coarsen()`, `_fill()`, `_set_open_right()`, `_set_order()` | Factor |
| Validate labels | `_diagnose_values()`, `_assert_values()` | Diagnostics, or `labels` |
| Relate two sets of labels | `_mapping()` | Tibble or matrix |

## More information

- [`?agetime`](https://bayesiandemography.github.io/agetime/reference/agetime-package.md)
  for a full list of functions
- [Cookbook](https://bayesiandemography.github.io/agetime/articles/cookbook.md)
  for suggestions for performing common label-related tasks
- [Troubleshooting](https://bayesiandemography.github.io/agetime/articles/troubleshooting.md)
  for solutions to common problems
- Package website: <https://bayesiandemography.github.io/agetime/>
