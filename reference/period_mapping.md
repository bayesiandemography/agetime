# Mapping Between Period Labels

Create a mapping between period labels. The mapping is based on one of
four types of relationship:

## Usage

``` r
period_mapping(
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

  Vector of period labels.

- y:

  Vector of period labels. If no value supplied, `x` is mapped onto
  itself.

- relation:

  Relationship between labels. The choices are `"equals"` (the default),
  `"contains"`, `"contained"`, and `"overlaps"`. See below for details
  and examples.

- return_val:

  The format of the return value. The choices are `"data.frame"` (the
  default) or `"matrix"`.

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

A data.frame or matrix

## Details

If no value for `y` is supplied, `x` is mapped onto itself.

## The `relation` argument

|  |  |
|----|----|
| `relation` | Endpoints of `x` and `y` |
| `"equals"` | `period_lower(x) == period_lower(y) & period_upper(x) == period_upper(y)` |
| `"contains"` | `period_lower(x) <= period_lower(y) & period_upper(y) <= period_upper(x)` |
| `"contained"` | `period_lower(y) <= period_lower(x) & period_upper(x) <= period_upper(y)` |
| `"overlaps"` | `(period_lower(y) <= period_lower(x) < period_upper(y))` \| `(period_lower(y) <= period_upper(x) < period_upper(y))` |

## Examples

``` r
x <- c("2020-2025", "2030", "2025-2027")
y <- c("2025-2030", "2020-2025", "2026-2034")
period_mapping(x = x, y = y)
#> # A tibble: 1 × 2
#>   x         y        
#>   <chr>     <chr>    
#> 1 2020-2025 2020-2025
period_mapping(x, return_val = "matrix")
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
period_mapping(x = x, y = y, relation = "contained")
#> # A tibble: 3 × 2
#>   x         y        
#>   <chr>     <chr>    
#> 1 2025-2027 2025-2030
#> 2 2020-2025 2020-2025
#> 3 2030      2026-2034
period_mapping(x = x, y = y, relation = "overlaps")
#> # A tibble: 4 × 2
#>   x         y        
#>   <chr>     <chr>    
#> 1 2025-2027 2025-2030
#> 2 2020-2025 2020-2025
#> 3 2030      2026-2034
#> 4 2025-2027 2026-2034
```
