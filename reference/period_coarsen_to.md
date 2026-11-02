# Coarsen Periods to a Target Classification

Recode period labels so they match a second set of labels.

## Usage

``` r
period_coarsen_to(
  labels,
  to,
  interpret_single = c("lower", "upper"),
  interpret_multi = NULL,
  interpret_fail = c("error", "warn", "silent")
)
```

## Arguments

- labels:

  Vector of period labels.

- to:

  Vector of period labels giving the target classification.

- interpret_single:

  How to interpret a label for a single year, such as `"2020"`. Choices
  are `"lower"` (the default) and `"upper"`. See below for details.

- interpret_multi:

  How to interpret a label that refers to multiple years, such as
  `"2020-2025"`. Choices are `NULL` (the default), `"at_upper"`, and
  `"below_upper"`. See below for details.

- interpret_fail:

  Action if an element of `labels` or `to` cannot be interpreted.
  Choices are `"error"` (the default), `"warn"`, and `"silent"`.

## Value

Factor with the same length as `labels`.

## Details

Every interval in `labels` must lie in exactly one interval in `to`.
Intervals in `to` must not overlap. Gaps in `to` are allowed, provided
that no intervals in `labels` fall within them.

If `labels` is a factor, its levels are modified along with its
elements.

Levels of the return value come from `to`. If `to` is a factor, the
levels are the levels of `to`, in the same order, including levels that
do not appear in `to`. Otherwise, the levels are the unique values of
`to`, in the order in which they first appear.

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

- [`period_coarsen()`](https://bayesiandemography.github.io/agetime/reference/period_coarsen.md)
  Coarsen using break points

- [`period_mapping()`](https://bayesiandemography.github.io/agetime/reference/period_mapping.md)
  Inspect the relationship between two sets of labels

- [`period_labels()`](https://bayesiandemography.github.io/agetime/reference/period_labels.md)
  Create period labels

- [`period_standard()`](https://bayesiandemography.github.io/agetime/reference/period_standard.md)
  Clean existing labels

- [`age_coarsen_to()`](https://bayesiandemography.github.io/agetime/reference/age_coarsen_to.md)
  Age equivalent of `period_coarsen_to()`

- [`cohort_coarsen_to()`](https://bayesiandemography.github.io/agetime/reference/cohort_coarsen_to.md)
  Cohort equivalent of `period_coarsen_to()`

## Examples

``` r
labels <- c("2020", "2021", "2025")
to <- c("2020-2025", "2025-2030")
period_coarsen_to(labels, to)
#> [1] 2020-2025 2020-2025 2025-2030
#> Levels: 2020-2025 2025-2030

## unused labels in `to` are kept as levels
period_coarsen_to(c("2020", "2021"), to)
#> [1] 2020-2025 2020-2025
#> Levels: 2020-2025 2025-2030
```
