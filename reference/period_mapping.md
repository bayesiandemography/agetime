# Mapping Between Period Labels

Create a mapping depicting the relationship between `labels_x` and
`labels_y`. The types of relationship that can be mapped are:

- "`labels_x` equals `labels_y`"

- "`labels_x` contains `labels_y`"

- "`labels_x` is contained in `labels_y`"

- "`labels_x` overlaps with `labels_y`".

## Usage

``` r
period_mapping(
  labels_x,
  labels_y = NULL,
  relation = c("equals", "contains", "is-contained-in", "overlaps-with"),
  format = c("tibble", "matrix"),
  name_x = "x",
  name_y = "y",
  interpret_single = c("lower", "upper"),
  interpret_multi = c("include", "exclude"),
  interpret_fail = c("error", "warn", "silent")
)
```

## Arguments

- labels_x:

  Vector of period labels.

- labels_y:

  Vector of period labels or `NULL`.

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

- interpret_single:

  How to interpret labels for single-year periods. Choices are `"lower"`
  (the default) and `"upper"`. See below for details.

- interpret_multi:

  How to interpret labels for multi-year periods. Choices are
  `"include"` (the default) and `"exclude"`. See below for details.

- interpret_fail:

  Action if element of `labels` cannot be interpreted. Choices are
  `"error"` (the default), `"warn"`, and `"silent"`.

## Value

[Tibble](https://tibble.tidyverse.org/reference/tibble.html) or matrix,
depending on the value of `format`.

## Details

If no value for `labels_y` is supplied, `labels_x` is mapped onto
itself.

Tibbles produced by `period_mapping()` are sparse in that they only
include matches. Matrices produced by `period_mapping()` are dense in
that they include matches and non-matches. See the example below.

## The `relation` argument

|  |  |
|----|----|
| `relation` | Endpoints of `labels_x` and `labels_y` |
| `"equals"` | Endpoints equal |
| `"contains"` | Endpoints of `labels_y` inside endpoints of `labels_x` |
| `"is-contained-in"` | Endpoints of `labels_x` inside endpoints of `labels_y` |
| `"overlaps-with"` | Endpoint of `labels_x` in `labels_y`, or reverse |

## Rules for interpreting inputs

Single-year periods:

|                    |                  |                         |
|--------------------|------------------|-------------------------|
| `interpret_single` | *Rule*           | *Example*               |
| `"lower"`          | `"a" -> [a,a+1)` | `"2020" -> [2020,2021)` |
| `"upper"`          | `"a" -> [a-1,a)` | `"2020" -> [2019,2020)` |

Data providers typically use the "lower" convention for calendar years
(1 January to 31 December), and the "upper" convention for non-calendar
years (e.g., 1 July to 30 June).

Multi-year periods:

|                   |                          |                              |
|-------------------|--------------------------|------------------------------|
| `interpret_multi` | *Rule*                   | *Example*                    |
| `"include"`       | `"a-<a+n>" -> [a,a+n)`   | `"2020-2025" -> [2020,2025)` |
| `"exclude"`       | `"a-<a+n-1>" -> [a,a+n)` | `"2020-2024" -> [2020,2025)` |

A two-value label cannot describe a one-year period. With
`interpret_multi = "include"`, `"2010-2011"` would be `[2010, 2011)` and
`"2010-2010"` would be empty; both are rejected. Use `"2010"`, or
`"2010-2012"` for two years. With `interpret_multi = "exclude"`,
`"2010-2011"` is two years `[2010, 2012)` and is accepted.

## See also

- [`period_coarsen_to()`](https://bayesiandemography.github.io/agetime/reference/period_coarsen_to.md)
  Recode labels into another classification

- [`age_mapping()`](https://bayesiandemography.github.io/agetime/reference/age_mapping.md)
  Age equivalent of `period_mapping()`

- [`cohort_mapping()`](https://bayesiandemography.github.io/agetime/reference/cohort_mapping.md)
  Cohort equivalent of `period_mapping()`

## Examples

``` r
x <- c("2020-2025", "2030", "2025-2027")
y <- c("2025-2030", "2020-2025", "2026-2034")
period_mapping(labels_x = x, labels_y = y)
#> # A tibble: 1 × 2
#>   x         y        
#>   <chr>     <chr>    
#> 1 2020-2025 2020-2025
period_mapping(labels_x = x, labels_y = y, format = "matrix")
#>            y
#> x           2025-2030 2020-2025 2026-2034
#>   2020-2025         0         1         0
#>   2030              0         0         0
#>   2025-2027         0         0         0
period_mapping(labels_x = x, labels_y = y, relation = "contains")
#> # A tibble: 1 × 2
#>   x         y        
#>   <chr>     <chr>    
#> 1 2020-2025 2020-2025
period_mapping(labels_x = x, labels_y = y, relation = "is-contained-in")
#> # A tibble: 3 × 2
#>   x         y        
#>   <chr>     <chr>    
#> 1 2025-2027 2025-2030
#> 2 2020-2025 2020-2025
#> 3 2030      2026-2034
period_mapping(labels_x = x, labels_y = y, relation = "overlaps-with")
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
period_mapping(labels_x = x, labels_y = y) # one match
#> # A tibble: 1 × 2
#>   x         y        
#>   <chr>     <chr>    
#> 1 2020-2025 2020-2025
period_mapping(labels_x = x, labels_y = y, format = "matrix")
#>            y
#> x           2020-2025 2025-2030
#>   2020-2025         1         0
#>   2030-2035         0         0

# map labels_x onto itself
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
