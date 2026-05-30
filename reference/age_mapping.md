# Mapping Between Age Group Labels

Create a mapping between age group labels. The mapping is based on one
of four types of relationship:

## Usage

``` r
age_mapping(
  x,
  y = NULL,
  relation = c("equals", "contains", "contained", "overlaps"),
  return_val = c("data.frame", "matrix"),
  x_fail = c("error", "warn", "silent")
)
```

## Arguments

- x:

  Vector of age group labels.

- y:

  Vector of age group labels. If no value supplied, `x` is mapped onto
  itself.

- relation:

  Relationship between labels. The choices are `"equals"` (the default),
  `"contains"`, `"contained"`, and `"overlaps"`. See below for details
  and examples.

- return_val:

  The format of the return value. The choices are `"data.frame"` (the
  default) or `"matrix"`.

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
| `"equals"` | `age_lower(x) == age_lower(y) & age_upper(x) == age_upper(y)` |
| `"contains"` | `age_lower(x) <= age_lower(y) & age_upper(y) <= age_upper(x)` |
| `"contained"` | `age_lower(y) <= age_lower(x) & age_upper(x) <= age_upper(y)` |
| `"overlaps"` | `(age_lower(y) <= age_lower(x) < age_upper(y))` \| `(age_lower(y) <= age_upper(x) < age_upper(y))` |

## See also

- [`period_mapping()`](https://bayesiandemography.github.io/agetime/reference/period_mapping.md)
  Period equivalent of `age_mapping()`

- [`cohort_mapping()`](https://bayesiandemography.github.io/agetime/reference/cohort_mapping.md)
  Cohort equivalent of `age_mapping()`

## Examples

``` r
x <- c("0-4", "10", "5-7")
y <- c("5-9", "0-4", "6-14")
age_mapping(x = x, y = y)
#> # A tibble: 1 × 2
#>   x     y    
#>   <chr> <chr>
#> 1 0-4   0-4  
age_mapping(x, return_val = "matrix")
#>      y
#> x     0-4 10 5-7
#>   0-4   1  0   0
#>   10    0  1   0
#>   5-7   0  0   1
age_mapping(x = x, y = y, relation = "contains")
#> # A tibble: 1 × 2
#>   x     y    
#>   <chr> <chr>
#> 1 0-4   0-4  
age_mapping(x = x, y = y, relation = "contained")
#> # A tibble: 3 × 2
#>   x     y    
#>   <chr> <chr>
#> 1 5-7   5-9  
#> 2 0-4   0-4  
#> 3 10    6-14 
age_mapping(x = x, y = y, relation = "overlaps")
#> # A tibble: 4 × 2
#>   x     y    
#>   <chr> <chr>
#> 1 5-7   5-9  
#> 2 0-4   0-4  
#> 3 10    6-14 
#> 4 5-7   6-14 
```
