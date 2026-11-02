# Coarsen Cohorts to a Target Classification

Recode cohort labels so they match a second set of labels.

## Usage

``` r
cohort_coarsen_to(
  labels,
  to,
  interpret_single = c("lower", "upper"),
  interpret_multi = NULL,
  interpret_fail = c("error", "warn", "silent")
)
```

## Arguments

- labels:

  Vector of cohort labels.

- to:

  Vector of cohort labels giving the target classification.

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

- [`cohort_coarsen()`](https://bayesiandemography.github.io/agetime/reference/cohort_coarsen.md)
  Coarsen using break points

- [`cohort_mapping()`](https://bayesiandemography.github.io/agetime/reference/cohort_mapping.md)
  Inspect the relationship between two sets of labels

- [`cohort_labels()`](https://bayesiandemography.github.io/agetime/reference/cohort_labels.md)
  Create cohort labels

- [`cohort_standard()`](https://bayesiandemography.github.io/agetime/reference/cohort_standard.md)
  Clean existing labels

- [`age_coarsen_to()`](https://bayesiandemography.github.io/agetime/reference/age_coarsen_to.md)
  Age equivalent of `cohort_coarsen_to()`

- [`period_coarsen_to()`](https://bayesiandemography.github.io/agetime/reference/period_coarsen_to.md)
  Period equivalent of `cohort_coarsen_to()`

## Examples

``` r
labels <- c("2020", "2021", "2025")
to <- c("2020-2025", "2025-2030")
cohort_coarsen_to(labels, to)
#> [1] 2020-2025 2020-2025 2025-2030
#> Levels: 2020-2025 2025-2030

## unused labels in `to` are kept as levels
cohort_coarsen_to(c("2020", "2021"), to)
#> [1] 2020-2025 2020-2025
#> Levels: 2020-2025 2025-2030
```
