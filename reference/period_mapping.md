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
  relation = c("equals", "contains", "is_contained_in", "overlaps_with"),
  format = c("tibble", "matrix"),
  name_x = "x",
  name_y = "y",
  interpret_single = c("lower", "upper"),
  interpret_multi = NULL,
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
  `"contains"`, `"is_contained_in"`, and `"overlaps_with"`. See below
  for details and examples.

- format:

  Format of return value. Choices are `"tibble"` (the default) or
  `"matrix"`.

- name_x, name_y:

  Names for the two sides of the mapping in the return value. Defaults
  are `"x"` and `"y"`. Applied to tibble columns and to matrix dimnames.

- interpret_single:

  How to interpret a label for a single year, such as `"2020"`. Choices
  are `"lower"` (the default) and `"upper"`. See below for details.

- interpret_multi:

  How to interpret a label that refers to multiple years, such as
  `"2020-2025"`. Choices are `NULL` (the default), `"at_upper"`, and
  `"below_upper"`. See below for details.

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
| `"is_contained_in"` | Endpoints of `labels_x` inside endpoints of `labels_y` |
| `"overlaps_with"` | Endpoint of `labels_x` in `labels_y`, or reverse |

## Rules for interpreting inputs

**Single-year**

Labels for single-year periods sometimes refer to the lower limits of
periods, and sometimes refer to upper limits. For instance, the label
`"2020"` is sometimes used to refer to the period that starts at
midnight on 1 January 2020 and ends at midnight on 1 January 2021, and
is sometimes used to refer to the period that starts at midnight on 1
July 2019 and ends at midnight on 1 July 2020.

The `interpret_single` argument can be used to distinguish between the
two conventions:

|                    |                  |                         |
|--------------------|------------------|-------------------------|
| `interpret_single` | *Rule*           | *Example*               |
| `"lower"`          | `"a" -> [a,a+1)` | `"2020" -> [2020,2021)` |
| `"upper"`          | `"a" -> [a-1,a)` | `"2020" -> [2019,2020)` |

**Multi-year**

In labels for multi-year periods, the second number is sometimes the
upper limit of the period, and sometimes the upper limit minus 1. For
instance, the period that starts at midnight on 1 January 2020 and ends
at midnight on 1 January 2025 is sometimes labelled `"2020-2025"` and is
sometimes labelled `"2020-2024"`.

The `interpret_multi` argument can be used to distinguish between the
two conventions:

|                   |                    |                              |
|-------------------|--------------------|------------------------------|
| `interpret_multi` | *Rule*             | *Example*                    |
| `"at_upper"`      | `"a-b" -> [a,b)`   | `"2020-2025" -> [2020,2025)` |
| `"below_upper"`   | `"a-b" -> [a,b+1)` | `"2020-2024" -> [2020,2025)` |

If `interpret_multi` is `NULL` (the default), then multi-year labels are
interpreted using the `"at_upper"` convention. If, however, the
`"at_upper"` convention leads to intervals with widths 4, 9, 14, ...,
then agetime emits a message. Supplying an explicit value for
`interpret_multi` silences this message.

**Open**

A period that is open on the left has no lower limit, and a period that
is open on the right has no upper limit. Labels for open periods are not
affected by `interpret_single` or `interpret_multi`.

Some examples of open periods:

|                                                |               |
|------------------------------------------------|---------------|
| *Label*                                        | *Interval*    |
| `"<2000"`, `"before 2000"`, `"under 2000"`     | `(-Inf,2000)` |
| `"2000 or earlier"`, `"up to 2000"`            | `(-Inf,2001)` |
| `"2000+"`, `"2000 or more"`, `"2000 or later"` | `[2000,Inf)`  |

Labels starting with `"-"`, such as `"-2000"`, are not accepted.

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
period_mapping(labels_x = x, labels_y = y, relation = "is_contained_in")
#> # A tibble: 3 × 2
#>   x         y        
#>   <chr>     <chr>    
#> 1 2025-2027 2025-2030
#> 2 2020-2025 2020-2025
#> 3 2030      2026-2034
period_mapping(labels_x = x, labels_y = y, relation = "overlaps_with")
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
