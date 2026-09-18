# Mapping Between Age Group Labels

Create a mapping depicting the relationship between `labels_x` and
`labels_y`. The types of relationship that can be mapped are:

- "`labels_x` equals `labels_y`"

- "`labels_x` contains `labels_y`"

- "`labels_x` is contained in `labels_y`"

- "`labels_x` overlaps with `labels_y`".

## Usage

``` r
age_mapping(
  labels_x,
  labels_y = NULL,
  relation = c("equals", "contains", "is-contained-in", "overlaps-with"),
  format = c("tibble", "matrix"),
  name_x = "x",
  name_y = "y",
  interpret_fail = c("error", "warn", "silent")
)
```

## Arguments

- labels_x:

  Vector of age group labels.

- labels_y:

  Vector of age group labels or `NULL`.

- relation:

  Relationship between labels. Choices are `"equals"` (the default),
  `"contains"`, `"is-contained-in"`, and `"overlaps-with"`. See below
  for details and examples.

- format:

  Format of return value. Choices are `"tibble"` (the default) or
  `"matrix"`.

- name_x, name_y:

  Names for the two sides of the mapping in the return value. Defaults
  are `"x"` and `"y"`. Applied to tibble columns and to matrix dimnames.

- interpret_fail:

  Action if element of `labels` cannot be interpreted. Choices are
  `"error"` (the default), `"warn"`, and `"silent"`.

## Value

[Tibble](https://tibble.tidyverse.org/reference/tibble.html) or matrix,
depending on the value of `format`.

## Details

If no value for `labels_y` is supplied, `labels_x` is mapped onto
itself.

Tibbles produced by `age_mapping()` are sparse in that they only include
matches. Matrices produced by `age_mapping()` are dense in that they
include matches and non-matches. See the example below.

## The `relation` argument

|  |  |
|----|----|
| `relation` | Endpoints of `labels_x` and `labels_y` |
| `"equals"` | Endpoints equal |
| `"contains"` | Endpoints of `labels_y` inside endpoints of `labels_x` |
| `"is-contained-in"` | Endpoints of `labels_x` inside endpoints of `labels_y` |
| `"overlaps-with"` | Endpoint of `labels_x` in `labels_y`, or reverse |

## See also

- [`age_coarsen_to()`](https://bayesiandemography.github.io/agetime/reference/age_coarsen_to.md)
  Recode labels into another classification

- [`period_mapping()`](https://bayesiandemography.github.io/agetime/reference/period_mapping.md)
  Period equivalent of `age_mapping()`

- [`cohort_mapping()`](https://bayesiandemography.github.io/agetime/reference/cohort_mapping.md)
  Cohort equivalent of `age_mapping()`

## Examples

``` r
x <- c("0-4", "10", "5-7")
y <- c("5-9", "0-4", "6-14")
age_mapping(labels_x = x, labels_y = y)
#> # A tibble: 1 × 2
#>   x     y    
#>   <chr> <chr>
#> 1 0-4   0-4  
age_mapping(labels_x = x, labels_y = y, format = "matrix")
#>      y
#> x     5-9 0-4 6-14
#>   0-4   0   1    0
#>   10    0   0    0
#>   5-7   0   0    0
age_mapping(labels_x = x, labels_y = y, relation = "contains")
#> # A tibble: 1 × 2
#>   x     y    
#>   <chr> <chr>
#> 1 0-4   0-4  
age_mapping(labels_x = x, labels_y = y, relation = "is-contained-in")
#> # A tibble: 3 × 2
#>   x     y    
#>   <chr> <chr>
#> 1 5-7   5-9  
#> 2 0-4   0-4  
#> 3 10    6-14 
age_mapping(labels_x = x, labels_y = y, relation = "overlaps-with")
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
age_mapping(labels_x = x, labels_y = y) # one match
#> # A tibble: 1 × 2
#>   x     y    
#>   <chr> <chr>
#> 1 0-4   0-4  
age_mapping(labels_x = x, labels_y = y, format = "matrix")
#>        y
#> x       0-4 5-9
#>   0-4     1   0
#>   10-14   0   0

# map labels_x onto itself
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
