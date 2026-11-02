# Fill in Gaps in Period Levels

Add intermediate periods. The return value is a factor, and the
intermediate periods are added as factor levels.

- `period_fill()` adds periods specified by `breaks`.

- `period_fill_one()` adds periods with width 1.

- `period_fill_five()` adds periods with width 5.

- `period_fill_ten()` adds periods with width 10.

## Usage

``` r
period_fill(
  labels,
  breaks = NULL,
  interpret_single = c("lower", "upper"),
  interpret_multi = NULL,
  interpret_fail = c("error", "warn", "silent")
)

period_fill_one(
  labels,
  interpret_single = c("lower", "upper"),
  interpret_multi = NULL,
  interpret_fail = c("error", "warn", "silent")
)

period_fill_five(
  labels,
  interpret_single = c("lower", "upper"),
  interpret_multi = NULL,
  interpret_fail = c("error", "warn", "silent")
)

period_fill_ten(
  labels,
  interpret_single = c("lower", "upper"),
  interpret_multi = NULL,
  interpret_fail = c("error", "warn", "silent")
)
```

## Arguments

- labels:

  Vector of period labels.

- breaks:

  Boundaries of newly-created periods. Boundaries for existing periods
  can be omitted.

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

- [`age_fill()`](https://bayesiandemography.github.io/agetime/reference/age_fill.md)
  Age equivalent of `period_fill()`

- [`cohort_fill()`](https://bayesiandemography.github.io/agetime/reference/cohort_fill.md)
  Cohort equivalent of `period_fill()`

## Examples

``` r
labels <- factor(c("2020-2025", "2030-2035"))
labels
#> [1] 2020-2025 2030-2035
#> Levels: 2020-2025 2030-2035
period_fill(labels) ## uses existing boundaries
#> [1] 2020-2025 2030-2035
#> Levels: 2020-2025 2025-2030 2030-2035
period_fill(labels, breaks = 2028)
#> [1] 2020-2025 2030-2035
#> Levels: 2020-2025 2025-2028 2028-2030 2030-2035
period_fill_one(labels)
#> [1] 2020-2025 2030-2035
#> Levels: 2020-2025 2025 2026 2027 2028 2029 2030-2035
period_fill_five(labels)
#> [1] 2020-2025 2030-2035
#> Levels: 2020-2025 2025-2030 2030-2035

labels <- c("2051-2061", "2021-2031")
period_fill_ten(labels)
#> [1] 2051-2061 2021-2031
#> Levels: 2021-2031 2031-2041 2041-2051 2051-2061

## levels are used by functions
## such as 'table()'
labels |>
  table()
#> labels
#> 2021-2031 2051-2061 
#>         1         1 
labels |>
  period_fill_ten() |>
  table()
#> 
#> 2021-2031 2031-2041 2041-2051 2051-2061 
#>         1         0         0         1 

## set level order after filling
labels |>
  period_fill_ten() |>
  period_set_order() |>
  table()
#> 
#> 2021-2031 2031-2041 2041-2051 2051-2061 
#>         1         0         0         1 
```
