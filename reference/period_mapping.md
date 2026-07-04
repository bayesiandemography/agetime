# Mapping Between Period Labels

Create a mapping between period labels. A mapping depicts a relationship
between the labels of `labels` and the labels of `y`. The types of
relationship that can be mapped are:

- "labels equals y"

- "labels contains y"

- "labels is contained in y"

- "labels overlaps with y".

## Usage

``` r
period_mapping(
  labels,
  y = NULL,
  relation = c("equals", "contains", "is-contained-in", "overlaps-with"),
  format = c("tibble", "matrix"),
  interpret_single = c("lower", "upper"),
  interpret_multi = c("include", "exclude"),
  interpret_fail = c("error", "warn", "silent")
)
```

## Arguments

- labels:

  Vector of period labels.

- y:

  Vector of period labels. If no value supplied, `labels` is mapped onto
  itself.

- relation:

  Relationship between labels. Choices are `"equals"` (the default),
  `"contains"`, `"is-contained-in"`, and `"overlaps-with"`. See below
  for details and examples.

- format:

  Format of return value. Choices are `"tibble"` (the default) or
  `"matrix"`.

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
depending on `format`.

## Details

If no value for `y` is supplied, `labels` is mapped onto itself.

Tibbles produced by `period_mapping()` are sparse in that they only
include matches. Matrices produced by `period_mapping()` are dense in
that they include matches and non-matches. See the example below.

## The `relation` argument

|                     |                                               |
|---------------------|-----------------------------------------------|
| `relation`          | Endpoints of `labels` and `y`                 |
| `"equals"`          | Endpoints equal                               |
| `"contains"`        | Endpoints of `y` inside endpoints of `labels` |
| `"is-contained-in"` | Endpoints of `labels` inside endpoints of `y` |
| `"overlaps-with"`   | Endpoint of `labels` in `y`, or reverse       |

## Controlling how period labels are interpreted

If `interpret_single` is `"lower"` (the default), then labels for
single-year periods are assumed to refer to lower limits, so that
`"2025"` means `[2025,2026)`. This is the convention that data providers
typically use for calendar years.

If `interpret_single` is `"upper"`, then labels for single-year periods
are assumed to refer to upper limits, so that `"2025"` means
`[2024,2025)`. This is the convention that data providers typically use
for non-calendar years, such as 1 July to 30 June.

If `interpret_multi` is `"include"` (the default), then labels for
multi-year periods are assumed to include upper limits, so that
`"2025-2030"` means `[2025,2030)`.

If `interpret_multi` is `"exclude"`, then labels for multi-year periods
are assumed to exclude the upper limits, so that `"2025-2030"` means
`[2025,2031)`.

## See also

- [`age_mapping()`](https://bayesiandemography.github.io/agetime/reference/age_mapping.md)
  Age equivalent of `period_mapping()`

- [`cohort_mapping()`](https://bayesiandemography.github.io/agetime/reference/cohort_mapping.md)
  Cohort equivalent of `period_mapping()`

## Examples

``` r
labels <- c("2020-2025", "2030", "2025-2027")
y <- c("2025-2030", "2020-2025", "2026-2034")
period_mapping(labels = labels, y = y)
#> # A tibble: 1 × 2
#>   x         y        
#>   <chr>     <chr>    
#> 1 2020-2025 2020-2025
period_mapping(labels = labels, y = y, format = "matrix")
#>            y
#> x           2025-2030 2020-2025 2026-2034
#>   2020-2025         0         1         0
#>   2030              0         0         0
#>   2025-2027         0         0         0
period_mapping(labels = labels, y = y, relation = "contains")
#> # A tibble: 1 × 2
#>   x         y        
#>   <chr>     <chr>    
#> 1 2020-2025 2020-2025
period_mapping(labels = labels, y = y, relation = "is-contained-in")
#> # A tibble: 3 × 2
#>   x         y        
#>   <chr>     <chr>    
#> 1 2025-2027 2025-2030
#> 2 2020-2025 2020-2025
#> 3 2030      2026-2034
period_mapping(labels = labels, y = y, relation = "overlaps-with")
#> # A tibble: 4 × 2
#>   x         y        
#>   <chr>     <chr>    
#> 1 2025-2027 2025-2030
#> 2 2020-2025 2020-2025
#> 3 2030      2026-2034
#> 4 2025-2027 2026-2034

# sparse tibble vs dense matrix
labels <- c("2020-2025", "2030-2035")
y <- c("2020-2025", "2025-2030")
period_mapping(labels = labels, y = y) # one match
#> # A tibble: 1 × 2
#>   x         y        
#>   <chr>     <chr>    
#> 1 2020-2025 2020-2025
period_mapping(labels = labels, y = y, format = "matrix")
#>            y
#> x           2020-2025 2025-2030
#>   2020-2025         1         0
#>   2030-2035         0         0

# mapping 'labels' on to itself
labels <- c("2020--2025", "2020-2025", "2030")
period_mapping(labels)
#> # A tibble: 5 × 2
#>   x          y         
#>   <chr>      <chr>     
#> 1 2020--2025 2020--2025
#> 2 2020-2025  2020--2025
#> 3 2020--2025 2020-2025 
#> 4 2020-2025  2020-2025 
#> 5 2030       2030      
```
