# Coarsen to Periods with Equal Widths

Coarsen the periods defined by `labels`. The new periods must contain
the old periods, and (except for open periods) all have the same width.

- `period_coarsen_five()` Five-year periods

- `period_coarsen_ten()` Ten-year periods

## Usage

``` r
period_coarsen_five(
  labels,
  offset = 0,
  open_left = NULL,
  open_right = NULL,
  interpret_single = c("lower", "upper"),
  interpret_multi = c("include", "exclude"),
  interpret_fail = c("error", "warn", "silent")
)

period_coarsen_ten(
  labels,
  offset = 0,
  open_left = NULL,
  open_right = NULL,
  interpret_single = c("lower", "upper"),
  interpret_multi = c("include", "exclude"),
  interpret_fail = c("error", "warn", "silent")
)
```

## Arguments

- labels:

  Vector of period labels.

- offset:

  Parameter controlling alignment of periods. Default is `0`.

- open_left:

  Whether to include a period that is open on the left. Optional. See
  below for details.

- open_right:

  Whether to include a period that is open on the right. Optional. See
  below for details.

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

Character vector or factor with the same length as `labels`.

## Details

The new periods cannot split existing periods, and are typically wider
than the existing periods.

If `labels` is a factor, its levels are modified along with its
elements.

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

## The `open_left` argument

A period is open on the left if it has no lower limit, e.g. `"<2000"`.

By default, the return value has a period that is open on the left if
and only if `labels` does. The full range of options is:

|                  |                           |                               |
|------------------|---------------------------|-------------------------------|
| `open_left`      | `labels` has open on left | Return value has open on left |
| `NULL` (default) | Yes                       | Yes                           |
| `NULL` (default) | No                        | No                            |
| `TRUE`           | Yes                       | Yes                           |
| `TRUE`           | No                        | Yes                           |
| `FALSE`          | Yes                       | *Error*                       |
| `FALSE`          | No                        | No                            |

## The `open_right` argument

A period is open on the right if it has no upper limit, e.g. `"2000+"`.

By default, the return value has a period that is open on the right if
and only if `labels` does. The full range of options is:

|                  |                            |                                |
|------------------|----------------------------|--------------------------------|
| `open_right`     | `labels` has open on right | Return value has open on right |
| `NULL` (default) | Yes                        | Yes                            |
| `NULL` (default) | No                         | No                             |
| `TRUE`           | Yes                        | Yes                            |
| `TRUE`           | No                         | Yes                            |
| `FALSE`          | Yes                        | *Error*                        |
| `FALSE`          | No                         | No                             |

## See also

- [`period_coarsen()`](https://bayesiandemography.github.io/agetime/reference/period_coarsen.md)
  Coarsen to general periods

- [`period_coarsen_to()`](https://bayesiandemography.github.io/agetime/reference/period_coarsen_to.md)
  Coarsen to an existing set of labels

- [`age_coarsen_five()`](https://bayesiandemography.github.io/agetime/reference/age_coarsen_five.md)
  Age equivalent of `period_coarsen_five()`

- [`age_coarsen_ten()`](https://bayesiandemography.github.io/agetime/reference/age_coarsen_five.md)
  Age equivalent of `period_coarsen_ten()`

- [`cohort_coarsen_five()`](https://bayesiandemography.github.io/agetime/reference/cohort_coarsen_five.md)
  Cohort equivalent of `period_coarsen_five()`

- [`cohort_coarsen_ten()`](https://bayesiandemography.github.io/agetime/reference/cohort_coarsen_five.md)
  Cohort equivalent of `period_coarsen_ten()`

- [`period_fill()`](https://bayesiandemography.github.io/agetime/reference/period_fill.md)
  Add levels for intermediate periods

## Examples

``` r
labels <- c("2002-2004", "1987-1989", "2000", "Total")
period_coarsen_five(labels)
#> [1] "2000-2005" "1985-1990" "2000-2005" "Total"    
period_coarsen_ten(labels)
#> [1] "2000-2010" "1980-1990" "2000-2010" "Total"    

## align to different boundaries
period_coarsen_five(labels, offset = 2)
#> [1] "2002-2007" "1987-1992" "1997-2002" "Total"    

## let inclusion of open period depend on labels
period_coarsen_five(c("<2020", "2020-2024"))
#> [1] "<2020"     "2020-2025"

## insist on an open period
period_coarsen_five(c("2010", "2020-2025"), open_right = TRUE)
#> [1] "2010-2015" "2020+"    
```
