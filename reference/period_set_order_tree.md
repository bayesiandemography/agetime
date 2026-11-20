# Set Order of Period Levels for a Reporting Tree

Modify the `levels` attribute of `labels` so that periods are ordered as
a reporting tree: the most detailed periods first, then broader periods,
then period not stated.

## Usage

``` r
period_set_order_tree(
  labels,
  interpret_single = c("lower", "upper"),
  interpret_multi = NULL,
  interpret_fail = c("error", "warn", "silent"),
  x_arg = rlang::caller_arg(labels),
  call = rlang::current_env()
)
```

## Arguments

- labels:

  Vector of period labels.

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

- x_arg:

  Name of `labels` to use in error and warning messages. Defaults to the
  expression supplied for `labels`. A function that calls this function
  can supply its own name, such as `"data$age"`.

- call:

  Execution environment of the function to name in error and warning
  messages. The default is this function itself. A function that calls
  this function can supply `call = rlang::current_env()`, so that
  messages name it instead.

## Value

Factor with the same length as `labels`.

## Details

In a reporting tree, periods nest: any two periods either do not
overlap, or one contains the other. Reporting trees arise, for instance,
in census tables of year of arrival, where most records have detailed
periods (`"2015-2020"`), some have only broad periods (`"<2010"`), and
some have no period at all (`"Missing"`).

Levels are ordered as follows:

1.  Leaves, that is, periods that contain no other period, ordered by
    lower limit.

2.  Broader periods, ordered so that each period comes after all periods
    inside it, and before any period entirely above it.

3.  Labels that could not be interpreted, if `interpret_fail` is
    `"warn"` or `"silent"`.

4.  Labels for missing values, as defined by
    [`period_is_missing()`](https://bayesiandemography.github.io/agetime/reference/period_is_missing.md).

Different labels that describe the same period are placed next to each
other, in the order in which they first appear. Leaves do not need to
lie at the same depth in the tree.

`period_set_order_tree()` checks only that the periods nest. It does not
check, for instance, that the leaves cover the full span. Labels for
totals, as defined by
[`period_is_total()`](https://bayesiandemography.github.io/agetime/reference/period_is_total.md),
are not part of a reporting tree, and cause an error. Some tables use
`"Total"` to mean period not stated. In such cases, recode the total to
`"Missing"` before calling `period_set_order_tree()`, for instance using
`x[period_is_total(x)] <- "Missing"`.

`period_set_order_tree()` has no effect on the values of `labels`. Only
the levels are changed.

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

- [`period_set_order()`](https://bayesiandemography.github.io/agetime/reference/period_set_order.md)
  Order periods by lower limit

- [`age_set_order_tree()`](https://bayesiandemography.github.io/agetime/reference/age_set_order_tree.md)
  Age equivalent of `period_set_order_tree()`

- [`cohort_set_order_tree()`](https://bayesiandemography.github.io/agetime/reference/cohort_set_order_tree.md)
  Cohort equivalent of `period_set_order_tree()`

## Examples

``` r
## year of arrival: detailed periods, arrival
## known only as before 2010, and not stated
labels <- c("2015-2020", "2010-2015", "<2000", "2000-2010",
            "<2010", "Missing")
period_set_order_tree(labels)
#> [1] 2015-2020 2010-2015 <2000     2000-2010 <2010     Missing  
#> Levels: <2000 2000-2010 2010-2015 2015-2020 <2010 Missing
```
