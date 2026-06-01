# Mapping Between Period Labels

Create a mapping between period labels. A mapping depicts a relationship
between the labels of `x` and the labels of `y`. The types of
relationship that can be mapped are:

- "x equals y"

- "x contains y"

- "x is contained in y"

- "x overlaps with y".

## Usage

``` r
period_mapping(
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

  Vector of period labels.

- y:

  Vector of period labels. If no value supplied, `x` is mapped onto
  itself.

- relation:

  Relationship between labels. Choices are `"equals"` (the default),
  `"contains"`, `"is-contained-in"`, and `"overlaps-with"`. See below
  for details and examples.

- format:

  Format of return value. Choices are `"tibble"` (the default) or
  `"matrix"`.

- x_one:

  How to interpret labels in `x` that describe one-year periods. Choices
  are `"lower"` (the default) and `"upper"`.

- x_multi:

  How to interpret labels in `x` that describe multi-year periods.
  Choices are `"include"` (the default) and `"exclude"`.

- x_fail:

  Action if element of `x` cannot be parsed: `"error"` (the default),
  `"warn"`, or `"silent"`.

## Value

[Tibble](https://tibble.tidyverse.org/reference/tibble.html) or matrix,
depending on `format`.

## Details

If no value for `y` is supplied, `x` is mapped onto itself.

Tibbles produced by `period_mapping()` are sparse, while matrices are
dense. See the example below.

## The `relation` argument

|  |  |
|----|----|
| `relation` | Endpoints of `x` and `y` |
| `"equals"` | `period_lower(x) == period_lower(y) & period_upper(x) == period_upper(y)` |
| `"contains"` | `period_lower(x) <= period_lower(y) & period_upper(y) <= period_upper(x)` |
| `"is-contained-in"` | `period_lower(y) <= period_lower(x) & period_upper(x) <= period_upper(y)` |
| `"overlaps-with"` | `(period_lower(y) <= period_lower(x) < period_upper(y))` \| `(period_lower(y) <= period_upper(x) < period_upper(y))` |

## See also

- [`parsing_period_labels()`](https://bayesiandemography.github.io/agetime/reference/parsing_period_labels.md)
  Details for `x_one`, `x_multi`, and `x_fail`

- [`age_mapping()`](https://bayesiandemography.github.io/agetime/reference/age_mapping.md)
  Age equivalent of `period_mapping()`

- [`cohort_mapping()`](https://bayesiandemography.github.io/agetime/reference/cohort_mapping.md)
  Cohort equivalent of `period_mapping()`

## Examples

``` r
x <- c("2020-2025", "2030", "2025-2027")
y <- c("2025-2030", "2020-2025", "2026-2034")
period_mapping(x = x, y = y)
#> # A tibble: 1 × 2
#>   x         y        
#>   <chr>     <chr>    
#> 1 2020-2025 2020-2025
period_mapping(x, format = "matrix")
#>            y
#> x           2020-2025 2030 2025-2027
#>   2020-2025         1    0         0
#>   2030              0    1         0
#>   2025-2027         0    0         1
period_mapping(x = x, y = y, relation = "contains")
#> # A tibble: 1 × 2
#>   x         y        
#>   <chr>     <chr>    
#> 1 2020-2025 2020-2025
period_mapping(x = x, y = y, relation = "is-contained-in")
#> # A tibble: 3 × 2
#>   x         y        
#>   <chr>     <chr>    
#> 1 2025-2027 2025-2030
#> 2 2020-2025 2020-2025
#> 3 2030      2026-2034
period_mapping(x = x, y = y, relation = "overlaps-with")
#> # A tibble: 4 × 2
#>   x         y        
#>   <chr>     <chr>    
#> 1 2025-2027 2025-2030
#> 2 2020-2025 2020-2025
#> 3 2030      2026-2034
#> 4 2025-2027 2026-2034

# sparse tibble vs dense matrix
x <- c("2020-2025", "2030-2035")
y <- c("2020-2025", "2025-2030")
period_mapping(x = x, y = y) # one match
#> # A tibble: 1 × 2
#>   x         y        
#>   <chr>     <chr>    
#> 1 2020-2025 2020-2025
period_mapping(x = x, y = y, format = "matrix") # one match and three non-matches
#>            y
#> x           2020-2025 2025-2030
#>   2020-2025         1         0
#>   2030-2035         0         0

# mapping 'x' on to itself
x <- c("2020--2025", "2020-2025", "2030")
period_mapping(x)
#> # A tibble: 5 × 2
#>   x          y         
#>   <chr>      <chr>     
#> 1 2020--2025 2020--2025
#> 2 2020-2025  2020--2025
#> 3 2020--2025 2020-2025 
#> 4 2020-2025  2020-2025 
#> 5 2030       2030      
```
