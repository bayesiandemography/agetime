# Mapping Between Age Group Labels

Create a mapping between age group labels. A mapping depicts a
relationship between the labels of `labels` and the labels of `y`. The
types of relationship that can be mapped are:

- "labels equals y"

- "labels contains y"

- "labels is contained in y"

- "labels overlaps with y".

## Usage

``` r
age_mapping(
  labels,
  y = NULL,
  relation = c("equals", "contains", "is-contained-in", "overlaps-with"),
  format = c("tibble", "matrix"),
  interpret_fail = c("error", "warn", "silent")
)
```

## Arguments

- labels:

  Vector of age group labels.

- y:

  Vector of age group labels. If no value supplied, `labels` is mapped
  onto itself.

- relation:

  Relationship between labels. Choices are `"equals"` (the default),
  `"contains"`, `"is-contained-in"`, and `"overlaps-with"`. See below
  for details and examples.

- format:

  Format of return value. Choices are `"tibble"` (the default) or
  `"matrix"`.

- interpret_fail:

  Action if element of `labels` cannot be interpreted. Choices are
  `"error"` (the default), `"warn"`, and `"silent"`.

## Value

[Tibble](https://tibble.tidyverse.org/reference/tibble.html) or matrix,
depending on `format`.

## Details

If no value for `y` is supplied, `labels` is mapped onto itself.

Tibbles produced by `age_mapping()` are sparse in that they only include
matches. Matrices produced by `age_mapping()` are dense in that they
include matches and non-matches. See the example below.

## The `relation` argument

|                     |                                               |
|---------------------|-----------------------------------------------|
| `relation`          | Endpoints of `labels` and `y`                 |
| `"equals"`          | Endpoints equal                               |
| `"contains"`        | Endpoints of `y` inside endpoints of `labels` |
| `"is-contained-in"` | Endpoints of `labels` inside endpoints of `y` |
| `"overlaps-with"`   | Endpoint of `labels` in `y`, or reverse       |

## See also

- [`period_mapping()`](https://bayesiandemography.github.io/agetime/reference/period_mapping.md)
  Period equivalent of `age_mapping()`

- [`cohort_mapping()`](https://bayesiandemography.github.io/agetime/reference/cohort_mapping.md)
  Cohort equivalent of `age_mapping()`

## Examples

``` r
labels <- c("0-4", "10", "5-7")
y <- c("5-9", "0-4", "6-14")
age_mapping(labels = labels, y = y)
#> # A tibble: 1 × 2
#>   x     y    
#>   <chr> <chr>
#> 1 0-4   0-4  
age_mapping(labels = labels, format = "matrix")
#>      y
#> x     0-4 10 5-7
#>   0-4   1  0   0
#>   10    0  1   0
#>   5-7   0  0   1
age_mapping(labels = labels, y = y, relation = "contains")
#> # A tibble: 1 × 2
#>   x     y    
#>   <chr> <chr>
#> 1 0-4   0-4  
age_mapping(labels = labels, y = y, relation = "is-contained-in")
#> # A tibble: 3 × 2
#>   x     y    
#>   <chr> <chr>
#> 1 5-7   5-9  
#> 2 0-4   0-4  
#> 3 10    6-14 
age_mapping(labels = labels, y = y, relation = "overlaps-with")
#> # A tibble: 4 × 2
#>   x     y    
#>   <chr> <chr>
#> 1 5-7   5-9  
#> 2 0-4   0-4  
#> 3 10    6-14 
#> 4 5-7   6-14 

# sparse tibble vs dense matrix
labels <- c("0-4", "10-14")
y <- c("0-4", "5-9")
age_mapping(labels = labels, y = y) # one match
#> # A tibble: 1 × 2
#>   x     y    
#>   <chr> <chr>
#> 1 0-4   0-4  
age_mapping(labels = labels, y = y, format = "matrix")
#>        y
#> x       0-4 5-9
#>   0-4     1   0
#>   10-14   0   0

# mapping 'labels' on to itself
labels <- c("0--4", "0-4", "5+")
age_mapping(labels)
#> # A tibble: 5 × 2
#>   x     y    
#>   <chr> <chr>
#> 1 0--4  0--4 
#> 2 0-4   0--4 
#> 3 0--4  0-4  
#> 4 0-4   0-4  
#> 5 5+    5+   
```
