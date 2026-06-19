# Mapping Between Age Group Labels

Create a mapping between age group labels. A mapping depicts a
relationship between the labels of `x` and the labels of `y`. The types
of relationship that can be mapped are:

- "x equals y"

- "x contains y"

- "x is contained in y"

- "x overlaps with y".

## Usage

``` r
age_mapping(
  x,
  y = NULL,
  relation = c("equals", "contains", "is-contained-in", "overlaps-with"),
  format = c("tibble", "matrix"),
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

  Relationship between labels. Choices are `"equals"` (the default),
  `"contains"`, `"is-contained-in"`, and `"overlaps-with"`. See below
  for details and examples.

- format:

  Format of return value. Choices are `"tibble"` (the default) or
  `"matrix"`.

- x_fail:

  Action if element of `x` cannot be parsed: `"error"` (the default),
  `"warn"`, or `"silent"`.

## Value

[Tibble](https://tibble.tidyverse.org/reference/tibble.html) or matrix,
depending on `format`.

## Details

If no value for `y` is supplied, `x` is mapped onto itself.

Tibbles produced by `age_mapping()` are sparse in that they only include
matches. Matrices produced by `age_mapping()` are dense in that they
include matches and non-matches. See the example below.

## The `relation` argument

|                     |                                                  |
|---------------------|--------------------------------------------------|
| `relation`          | Endpoints of `x` and `y`                         |
| `"equals"`          | Endpoints equal                                  |
| `"contains"`        | Endpoints of `y` inside endpoints of `x`         |
| `"is-contained-in"` | Endpoints of `x` inside endpoints of `y`         |
| `"overlaps-with"`   | Endpoint of `x` in `y` or endpoint of `y` in `x` |

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
age_mapping(x = x, format = "matrix")
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
age_mapping(x = x, y = y, relation = "is-contained-in")
#> # A tibble: 3 × 2
#>   x     y    
#>   <chr> <chr>
#> 1 5-7   5-9  
#> 2 0-4   0-4  
#> 3 10    6-14 
age_mapping(x = x, y = y, relation = "overlaps-with")
#> # A tibble: 4 × 2
#>   x     y    
#>   <chr> <chr>
#> 1 5-7   5-9  
#> 2 0-4   0-4  
#> 3 10    6-14 
#> 4 5-7   6-14 

# sparse tibble vs dense matrix
x <- c("0-4", "10-14")
y <- c("0-4", "5-9")
age_mapping(x = x, y = y) # one match
#> # A tibble: 1 × 2
#>   x     y    
#>   <chr> <chr>
#> 1 0-4   0-4  
age_mapping(x = x, y = y, format = "matrix") # 1 match, 3 non-matches
#>        y
#> x       0-4 5-9
#>   0-4     1   0
#>   10-14   0   0

# mapping 'x' on to itself
x <- c("0--4", "0-4", "5+")
age_mapping(x)
#> # A tibble: 5 × 2
#>   x     y    
#>   <chr> <chr>
#> 1 0--4  0--4 
#> 2 0-4   0--4 
#> 3 0--4  0-4  
#> 4 0-4   0-4  
#> 5 5+    5+   
```
