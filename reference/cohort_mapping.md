# Mapping Between Cohort Labels

Create a mapping between cohort labels. The mapping is based on one of
four types of relationship:

## Usage

``` r
cohort_mapping(
  x,
  y = NULL,
  relation = c("equals", "contains", "contained", "overlaps"),
  return_val = c("data.frame", "matrix"),
  x_one = c("lower", "upper"),
  x_multi = c("include", "exclude"),
  x_fail = c("error", "warn", "silent")
)
```

## Arguments

- x:

  Vector of cohort labels.

- y:

  Vector of cohort labels. If no value supplied, `x` is mapped onto
  itself.

- relation:

  Relationship between labels. The choices are `"equals"` (the default),
  `"contains"`, `"contained"`, and `"overlaps"`. See below for details
  and examples.

- return_val:

  The format of the return value. The choices are `"data.frame"` (the
  default) or `"matrix"`.

- x_one:

  Whether labels for one-year cohorts are based on lower or upper limit
  of period. Default is `"lower"`.

- x_multi:

  Whether labels for multi-year periods include or exclude final year of
  period. Default is `"include"`.

- x_fail:

  Action if element of `x` cannot be parsed: `"error"` (the default),
  `"warn"`, or `"silent"`.

## Value

Data frame or matrix, depending on `return_val`.

## Details

If no value for `y` is supplied, `x` is mapped onto itself.

## The `relation` argument

|  |  |
|----|----|
| `relation` | Endpoints of `x` and `y` |
| `"equals"` | `cohort_lower(x) == cohort_lower(y) & cohort_upper(x) == cohort_upper(y)` |
| `"contains"` | `cohort_lower(x) <= cohort_lower(y) & cohort_upper(y) <= cohort_upper(x)` |
| `"contained"` | `cohort_lower(y) <= cohort_lower(x) & cohort_upper(x) <= cohort_upper(y)` |
| `"overlaps"` | `(cohort_lower(y) <= cohort_lower(x) < cohort_upper(y))` \| `(cohort_lower(y) <= cohort_upper(x) < cohort_upper(y))` |

## See also

- [`parsing_cohort_labels()`](https://bayesiandemography.github.io/agetime/reference/parsing_cohort_labels.md)
  Details for `x_one`, `x_multi`, and `x_fail`

- [`age_mapping()`](https://bayesiandemography.github.io/agetime/reference/age_mapping.md)
  Age equivalent of `cohort_mapping()`

- [`period_mapping()`](https://bayesiandemography.github.io/agetime/reference/period_mapping.md)
  Period equivalent of `cohort_mapping()`

## Examples

``` r
x <- c("2020-2025", "2030", "2025-2027")
y <- c("2025-2030", "2020-2025", "2026-2034")
cohort_mapping(x = x, y = y)
#> # A tibble: 1 × 2
#>   x         y        
#>   <chr>     <chr>    
#> 1 2020-2025 2020-2025
cohort_mapping(x, return_val = "matrix")
#>            y
#> x           2020-2025 2030 2025-2027
#>   2020-2025         1    0         0
#>   2030              0    1         0
#>   2025-2027         0    0         1
cohort_mapping(x = x, y = y, relation = "contains")
#> # A tibble: 1 × 2
#>   x         y        
#>   <chr>     <chr>    
#> 1 2020-2025 2020-2025
cohort_mapping(x = x, y = y, relation = "contained")
#> # A tibble: 3 × 2
#>   x         y        
#>   <chr>     <chr>    
#> 1 2025-2027 2025-2030
#> 2 2020-2025 2020-2025
#> 3 2030      2026-2034
cohort_mapping(x = x, y = y, relation = "overlaps")
#> # A tibble: 4 × 2
#>   x         y        
#>   <chr>     <chr>    
#> 1 2025-2027 2025-2030
#> 2 2020-2025 2020-2025
#> 3 2030      2026-2034
#> 4 2025-2027 2026-2034
```
