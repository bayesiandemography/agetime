# Quick start

Multi-year age groups, periods, and cohorts are stored as character
vectors or factors with labels such as `"0-14"`, `"2020-2025"`, or
`"1980-1990"`. Working with these label vectors can be awkward.
Identifying 5-year age groups older than 60, for instance, is harder
than it should be.

**agetime** makes working with label vectors easy. **agetime** functions
know how to interpret age, period, and cohort labels, and can work
directly with label vectors. **agetime** contains functions for
validating, manipulating, and extracting information from label vectors.

**agetime** functions for age groups, periods, and cohorts follow a
common pattern. This vignette uses age groups to illustrate the pattern.

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

There are many ways of formatting age group labels.
[`age_standard()`](https://bayesiandemography.github.io/agetime/reference/age_standard.md)
converts labels to a standard format:

``` r

x <- c("5to9", "10--14", "100plus")
age_standard(x)
#> [1] "5-9"   "10-14" "100+"
```

If `x` is a factor,
[`age_standard()`](https://bayesiandemography.github.io/agetime/reference/age_standard.md)
returns a factor where the levels are also standardized.

``` r

x <- factor(c("5to9", "10--14", "100plus"))
age_standard(x)
#> [1] 5-9   10-14 100+ 
#> Levels: 10-14 100+ 5-9
```

## Create a regular series of labels

To generate labels from scratch, use the `age_labels` functions.

``` r

age_labels_five(lower_first = 0, lower_last = 20)
#> [1] "0-4"   "5-9"   "10-14" "15-19" "20+"
age_labels_life(lower_last = 60) ## life table age groups
#>  [1] "0"     "1-4"   "5-9"   "10-14" "15-19" "20-24" "25-29" "30-34" "35-39"
#> [10] "40-44" "45-49" "50-54" "55-59" "60+"
```

## Modify to new groupings

To widen or realign age groups, use an `age_modify` function.

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
  has_zero = TRUE,
  has_open = TRUE
)
#> $ok
#> [1] TRUE
#> 
#> $details
#> # A tibble: 4 × 3
#>   check      passed comment
#>   <chr>      <lgl>  <chr>  
#> 1 no_overlap TRUE   NA     
#> 2 no_gap     TRUE   NA     
#> 3 has_zero   TRUE   NA     
#> 4 has_open   TRUE   NA
```

[`age_assert()`](https://bayesiandemography.github.io/agetime/reference/age_check.md)
throws an error if a check fails.

## Create mappings

[`age_mapping()`](https://bayesiandemography.github.io/agetime/reference/age_mapping.md)
builds a mapping between sets of labels.

``` r

x <- c("10--14", "0--9")
y <- c("0-4", "5-9", "10-14")
age_mapping(x, y, relation = "contains", format = "matrix")
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
| [`age_modify()`](https://bayesiandemography.github.io/agetime/reference/age_modify.md) | [`period_modify()`](https://bayesiandemography.github.io/agetime/reference/period_modify.md) | [`cohort_modify()`](https://bayesiandemography.github.io/agetime/reference/cohort_modify.md) |

## More information

- [`?agetime`](https://bayesiandemography.github.io/agetime/reference/agetime-package.md)
  for a full list of functions grouped by task
- [`vignette("api-principles")`](https://bayesiandemography.github.io/agetime/articles/api-principles.md)
  for naming and return-type conventions
- Package website: <https://bayesiandemography.github.io/agetime/>
