# Quick start

Working with age group, period, and cohort labels is often awkward and
error-prone. The `agetime` package makes it easier. This vignette
introduces some of the basic functions. The vignette focuses on age
group labels, but equivalent functions also exist for period and cohort
labels.

## Infer intervals from labels

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
  filter(age_is_open_right(age))
#> # A tibble: 1 × 2
#>   age   count
#>   <chr> <dbl>
#> 1 65+       6
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

The `age_labels` functions generate labels from scratch.

``` r

age_labels_five(lower_first = 0, lower_last = 20)
#> [1] "0-4"   "5-9"   "10-14" "15-19" "20+"
age_labels_life(lower_last = 60) ## life table age groups
#>  [1] "0"     "1-4"   "5-9"   "10-14" "15-19" "20-24" "25-29" "30-34" "35-39"
#> [10] "40-44" "45-49" "50-54" "55-59" "60+"
```

## Manipulate levels

Use the `age_coarsen` functions to convert to wider age groups.

``` r

x <- c("0-4", "5-9", "10-14", "50-54")
age_coarsen(x, breaks = c(0, 15, 55))
#> [1] 0-14  0-14  0-14  15-54
#> Levels: 0-14 15-54
age_coarsen_five(x)
#> [1] "0-4"   "5-9"   "10-14" "50-54"
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

Check whether age labels conform to expectations:

``` r

lab <- age_labels_five(
  lower_first = 0,
  lower_last = 85,
  open_right = TRUE
)
age_diagnose(
  lab,
  no_overlap = TRUE,
  no_gap = TRUE,
  has_zero = TRUE,
  has_open_right = TRUE
)
#> $ok
#> [1] TRUE
#> 
#> $details
#> # A tibble: 4 × 3
#>   condition      passed comment
#>   <chr>          <lgl>  <chr>  
#> 1 no_overlap     TRUE   NA     
#> 2 no_gap         TRUE   NA     
#> 3 has_zero       TRUE   NA     
#> 4 has_open_right TRUE   NA
```

[`age_assert()`](https://bayesiandemography.github.io/agetime/reference/age_diagnose.md)
throws an error if a check fails.

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

## Period and cohort

Age group functions have period and cohort equivalents. For instance:

| Age | Period | Cohort |
|----|----|----|
| [`age_lower()`](https://bayesiandemography.github.io/agetime/reference/age_lower.md) | [`period_lower()`](https://bayesiandemography.github.io/agetime/reference/period_lower.md) | [`cohort_lower()`](https://bayesiandemography.github.io/agetime/reference/cohort_lower.md) |
| [`age_standard()`](https://bayesiandemography.github.io/agetime/reference/age_standard.md) | [`period_standard()`](https://bayesiandemography.github.io/agetime/reference/period_standard.md) | [`cohort_standard()`](https://bayesiandemography.github.io/agetime/reference/cohort_standard.md) |
| [`age_labels_five()`](https://bayesiandemography.github.io/agetime/reference/age_labels.md) | [`period_labels_five()`](https://bayesiandemography.github.io/agetime/reference/period_labels.md) | [`cohort_labels_five()`](https://bayesiandemography.github.io/agetime/reference/cohort_labels.md) |
| [`age_coarsen()`](https://bayesiandemography.github.io/agetime/reference/age_coarsen.md) | [`period_coarsen()`](https://bayesiandemography.github.io/agetime/reference/period_coarsen.md) | [`cohort_coarsen()`](https://bayesiandemography.github.io/agetime/reference/cohort_coarsen.md) |

## Function tasks

`agetime` functions fall into five groups, defined by their tasks:

| Task | Examples | Return value |
|----|----|----|
| Extract limits or identify special labels | [`age_lower()`](https://bayesiandemography.github.io/agetime/reference/age_lower.md), [`age_upper()`](https://bayesiandemography.github.io/agetime/reference/age_lower.md), [`age_mid()`](https://bayesiandemography.github.io/agetime/reference/age_lower.md), [`age_width()`](https://bayesiandemography.github.io/agetime/reference/age_lower.md), [`age_is_total()`](https://bayesiandemography.github.io/agetime/reference/age_is_total.md) | Numeric or logical |
| Create a new series, or reformat existing labels | [`age_labels_five()`](https://bayesiandemography.github.io/agetime/reference/age_labels.md), [`age_standard()`](https://bayesiandemography.github.io/agetime/reference/age_standard.md), [`age_extend()`](https://bayesiandemography.github.io/agetime/reference/age_extend.md) | Character, or same type as `labels` |
| Recode values and set factor levels | [`age_coarsen()`](https://bayesiandemography.github.io/agetime/reference/age_coarsen.md), [`age_fill()`](https://bayesiandemography.github.io/agetime/reference/age_fill.md), [`age_set_open_right()`](https://bayesiandemography.github.io/agetime/reference/age_set_open_right.md), [`age_set_order()`](https://bayesiandemography.github.io/agetime/reference/age_set_order.md) | Factor |
| Validate labels | [`age_diagnose()`](https://bayesiandemography.github.io/agetime/reference/age_diagnose.md), [`age_assert()`](https://bayesiandemography.github.io/agetime/reference/age_diagnose.md) | Diagnostics, or `labels` |
| Relate two sets of labels | [`age_mapping()`](https://bayesiandemography.github.io/agetime/reference/age_mapping.md) | Tibble or matrix |

## More information

- [`?agetime`](https://bayesiandemography.github.io/agetime/reference/agetime-package.md)
  for a full list of functions
- [`vignette("cookbook")`](https://bayesiandemography.github.io/agetime/articles/cookbook.md)
  for suggestions for performing common label-related tasks
- [`vignette("api-principles")`](https://bayesiandemography.github.io/agetime/articles/api-principles.md)
  for an AI-written summary of principles underlying the interface for
  the package
- Package website: <https://bayesiandemography.github.io/agetime/>
