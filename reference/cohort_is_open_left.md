# Identify Cohorts With No Lower Limit or No Upper Limit

Find cohorts that are open on the left or right.

## Usage

``` r
cohort_is_open_left(
  labels,
  interpret_single = c("lower", "upper"),
  interpret_multi = NULL,
  interpret_fail = c("error", "warn", "silent")
)

cohort_is_open_right(
  labels,
  interpret_single = c("lower", "upper"),
  interpret_multi = NULL,
  interpret_fail = c("error", "warn", "silent")
)
```

## Arguments

- labels:

  Vector of cohort labels.

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

Logical vector with the same length as `labels`. If `labels` has names,
the result has the same names.

## Details

- `cohort_is_open_left()` finds cohorts open on the left (has no lower
  limit).

- `cohort_is_open_right()` finds cohorts open on the right (has no upper
  limit).

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

- [`age_is_open_right()`](https://bayesiandemography.github.io/agetime/reference/age_is_open_right.md)
  Identify age groups open on right

- [`period_is_open_left()`](https://bayesiandemography.github.io/agetime/reference/period_is_open_left.md)
  Identify periods open on left

- [`period_is_open_right()`](https://bayesiandemography.github.io/agetime/reference/period_is_open_left.md)
  Identify periods open on right

- [`cohort_is_total()`](https://bayesiandemography.github.io/agetime/reference/cohort_is_total.md)
  Identify cohort totals

- [`cohort_is_missing()`](https://bayesiandemography.github.io/agetime/reference/cohort_is_missing.md)
  Identify missing cohort labels

- [`cohort_set_open_left()`](https://bayesiandemography.github.io/agetime/reference/cohort_set_open_left.md)
  Specify cohort open on left

- [`cohort_set_open_right()`](https://bayesiandemography.github.io/agetime/reference/cohort_set_open_left.md)
  Specify cohort open on right

## Examples

``` r
labels <- c("2020", "<1900", "2040-2050", "1900 or less", "2030+")
cohort_is_open_left(labels)
#> [1] FALSE  TRUE FALSE  TRUE FALSE
cohort_is_open_right(labels)
#> [1] FALSE FALSE FALSE FALSE  TRUE
```
