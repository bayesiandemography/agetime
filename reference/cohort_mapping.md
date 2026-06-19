# Mapping Between Cohort Labels

Create a mapping between cohort labels. A mapping depicts a relationship
between the labels of `x` and the labels of `y`. The types of
relationship that can be mapped are:

- "x equals y"

- "x contains y"

- "x is contained in y"

- "x overlaps with y".

## Usage

``` r
cohort_mapping(
  x,
  y = NULL,
  relation = c("equals", "contains", "is-contained-in", "overlaps-with"),
  format = c("tibble", "matrix"),
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

  Relationship between labels. Choices are `"equals"` (the default),
  `"contains"`, `"is-contained-in"`, and `"overlaps-with"`. See below
  for details and examples.

- format:

  Format of return value. Choices are `"tibble"` (the default) or
  `"matrix"`.

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

[Tibble](https://tibble.tidyverse.org/reference/tibble.html) or matrix,
depending on `format`.

## Details

If no value for `y` is supplied, `x` is mapped onto itself.

Tibbles produced by `cohort_mapping()` are sparse in that they only
include matches. Matrices produced by `cohort_mapping()` are dense in
that they include matches and non-matches. See the example below.

## The `relation` argument

|                     |                                                  |
|---------------------|--------------------------------------------------|
| `relation`          | Endpoints of `x` and `y`                         |
| `"equals"`          | Endpoints equal                                  |
| `"contains"`        | Endpoints of `y` inside endpoints of `x`         |
| `"is-contained-in"` | Endpoints of `x` inside endpoints of `y`         |
| `"overlaps-with"`   | Endpoint of `x` in `y` or endpoint of `y` in `x` |

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
cohort_mapping(x = x, y = y, format = "matrix")
#>            y
#> x           2025-2030 2020-2025 2026-2034
#>   2020-2025         0         1         0
#>   2030              0         0         0
#>   2025-2027         0         0         0
cohort_mapping(x = x, y = y, relation = "contains")
#> # A tibble: 1 × 2
#>   x         y        
#>   <chr>     <chr>    
#> 1 2020-2025 2020-2025
cohort_mapping(x = x, y = y, relation = "is-contained-in")
#> # A tibble: 3 × 2
#>   x         y        
#>   <chr>     <chr>    
#> 1 2025-2027 2025-2030
#> 2 2020-2025 2020-2025
#> 3 2030      2026-2034
cohort_mapping(x = x, y = y, relation = "overlaps-with")
#> # A tibble: 4 × 2
#>   x         y        
#>   <chr>     <chr>    
#> 1 2025-2027 2025-2030
#> 2 2020-2025 2020-2025
#> 3 2030      2026-2034
#> 4 2025-2027 2026-2034

# sparse tibble vs dense matrix
x <- c("2020-2025", "2030-2035")
y <- c("2020-2025", "<2025")
cohort_mapping(x = x, y = y) # one match
#> # A tibble: 1 × 2
#>   x         y        
#>   <chr>     <chr>    
#> 1 2020-2025 2020-2025
cohort_mapping(x = x, y = y, format = "matrix") # 1 match and 3 non-matches
#>            y
#> x           2020-2025 <2025
#>   2020-2025         1     0
#>   2030-2035         0     0

# mapping 'x' on to itself
x <- c("2020--2025", "2020-2025", "<2030")
cohort_mapping(x)
#> # A tibble: 5 × 2
#>   x          y         
#>   <chr>      <chr>     
#> 1 2020--2025 2020--2025
#> 2 2020-2025  2020--2025
#> 3 2020--2025 2020-2025 
#> 4 2020-2025  2020-2025 
#> 5 <2030      <2030     
```
