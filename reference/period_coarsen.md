# Coarsen Periods

Define new periods that contain existing periods.

## Usage

``` r
period_coarsen(
  labels,
  breaks,
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

- breaks:

  Boundaries between periods. A numeric vector.

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

Factor with the same length as `labels`.

## Details

The new periods cannot split existing periods, and are typically wider
than the existing periods.

If `labels` is a factor, its levels are modified along with its
elements.

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
  Coarsen to an existing set of labels

- [`period_coarsen_five()`](https://bayesiandemography.github.io/agetime/reference/period_coarsen_five.md)
  Coarsen to 5-year periods

- [`period_coarsen_ten()`](https://bayesiandemography.github.io/agetime/reference/period_coarsen_five.md)
  Coarsen to 10-year periods

- [`age_coarsen()`](https://bayesiandemography.github.io/agetime/reference/age_coarsen.md)
  Age group equivalent of `period_coarsen()`

- [`cohort_coarsen()`](https://bayesiandemography.github.io/agetime/reference/cohort_coarsen.md)
  Cohort equivalent of `period_coarsen()`

## Examples

``` r
labels <- c("2001-2004", "1987-1989", "2000", "2005-2010")
period_coarsen(labels, breaks = c(1970, 2000, 2005, 2015))
#> [1] 2000-2005 1970-2000 2000-2005 2005-2015
#> Levels: 1970-2000 2000-2005 2005-2015

## let inclusion of open period depend on labels
labels_closed <- c("2001-2004", "2005-2010")
period_coarsen(labels_closed, breaks = c(2000, 2010, 2020))
#> [1] 2000-2010 2000-2010
#> Levels: 2000-2010 2010-2020
labels_open <- c("<1970", "2001-2004", "2020+")
period_coarsen(labels_open, breaks = c(1970, 2000, 2010, 2020))
#> [1] <1970     2000-2010 2020+    
#> Levels: <1970 1970-2000 2000-2010 2010-2020 2020+

## insist on an open period
period_coarsen(
  labels_closed,
  breaks = c(2000, 2010, 2020),
  open_right = TRUE
)
#> [1] 2000-2010 2000-2010
#> Levels: 2000-2010 2010-2020 2020+
```
