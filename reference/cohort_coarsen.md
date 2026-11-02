# Coarsen Cohorts

Define new cohorts that contain existing cohorts.

## Usage

``` r
cohort_coarsen(
  labels,
  breaks,
  open_left = NULL,
  open_right = NULL,
  interpret_single = c("lower", "upper"),
  interpret_multi = NULL,
  interpret_fail = c("error", "warn", "silent")
)
```

## Arguments

- labels:

  Vector of cohort labels.

- breaks:

  Boundaries between cohorts. A numeric vector.

- open_left:

  Whether to include a cohort that is open on the left. Optional. See
  below for details.

- open_right:

  Whether to include a cohort that is open on the right. Optional. See
  below for details.

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

Factor with the same length as `labels`.

## Details

The new cohorts cannot split existing cohorts, and are typically wider
than the existing cohorts.

If `labels` is a factor, its levels are modified along with its
elements.

## The `open_left` argument

A cohort is open on the left if it has no lower limit, e.g. `"<2000"`.

By default, the return value has a cohort that is open on the left if
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

A cohort is open on the right if it has no upper limit, e.g. `"2000+"`.

By default, the return value has a cohort that is open on the right if
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

**Single-year**

Labels for single-year cohorts sometimes refer to the lower limits of
cohorts, and sometimes refer to upper limits. For instance, the label
`"2020"` is sometimes used to refer to the cohort that starts at
midnight on 1 January 2020 and ends at midnight on 1 January 2021, and
is sometimes used to refer to the cohort that starts at midnight on 1
July 2019 and ends at midnight on 1 July 2020.

The `interpret_single` argument can be used to distinguish between the
two conventions:

|                    |                  |                         |
|--------------------|------------------|-------------------------|
| `interpret_single` | *Rule*           | *Example*               |
| `"lower"`          | `"a" -> [a,a+1)` | `"2020" -> [2020,2021)` |
| `"upper"`          | `"a" -> [a-1,a)` | `"2020" -> [2019,2020)` |

**Multi-year**

In labels for multi-year cohorts, the second number is sometimes the
upper limit of the cohort, and sometimes the upper limit minus 1. For
instance, the cohort that starts at midnight on 1 January 2020 and ends
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

A cohort that is open on the left has no lower limit, and a cohort that
is open on the right has no upper limit. Labels for open cohorts are not
affected by `interpret_single` or `interpret_multi`.

Some examples of open cohorts:

|                                                |               |
|------------------------------------------------|---------------|
| *Label*                                        | *Interval*    |
| `"<2000"`, `"before 2000"`, `"under 2000"`     | `(-Inf,2000)` |
| `"2000 or earlier"`, `"up to 2000"`            | `(-Inf,2001)` |
| `"2000+"`, `"2000 or more"`, `"2000 or later"` | `[2000,Inf)`  |

Labels starting with `"-"`, such as `"-2000"`, are not accepted.

## See also

- [`cohort_coarsen_to()`](https://bayesiandemography.github.io/agetime/reference/cohort_coarsen_to.md)
  Coarsen to an existing set of labels

- [`cohort_coarsen_five()`](https://bayesiandemography.github.io/agetime/reference/cohort_coarsen_five.md)
  Coarsen to 5-year cohorts

- [`cohort_coarsen_ten()`](https://bayesiandemography.github.io/agetime/reference/cohort_coarsen_five.md)
  Coarsen to 10-year cohorts

- [`age_coarsen()`](https://bayesiandemography.github.io/agetime/reference/age_coarsen.md)
  Age group equivalent of `cohort_coarsen()`

- [`period_coarsen()`](https://bayesiandemography.github.io/agetime/reference/period_coarsen.md)
  Period equivalent of `cohort_coarsen()`

## Examples

``` r
labels <- c("2001-2004", "1987-1989", "2000", "2005-2010")
cohort_coarsen(labels, breaks = c(1970, 2000, 2005, 2015))
#> [1] 2000-2005 1970-2000 2000-2005 2005-2015
#> Levels: 1970-2000 2000-2005 2005-2015

## let inclusion of open cohort depend on labels
labels_closed <- c("2001-2004", "2005-2010")
cohort_coarsen(labels_closed, breaks = c(2000, 2010, 2020))
#> [1] 2000-2010 2000-2010
#> Levels: 2000-2010 2010-2020
labels_open <- c("<1970", "2001-2004", "2020+")
cohort_coarsen(labels_open, breaks = c(1970, 2000, 2010, 2020))
#> [1] <1970     2000-2010 2020+    
#> Levels: <1970 1970-2000 2000-2010 2010-2020 2020+

## insist on an open cohort
cohort_coarsen(
  labels_closed,
  breaks = c(2000, 2010, 2020),
  open_right = TRUE
)
#> [1] 2000-2010 2000-2010
#> Levels: 2000-2010 2010-2020 2020+
```
