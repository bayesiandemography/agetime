# Limits, Widths, Midpoints, and Intervals from Period Labels

Calculate lower limits, upper limits, widths, midpoints, and intervals
from period labels.

## Usage

``` r
period_lower(
  labels,
  interpret_single = c("lower", "upper"),
  interpret_multi = NULL,
  interpret_fail = c("error", "warn", "silent")
)

period_mid(
  labels,
  interpret_single = c("lower", "upper"),
  interpret_multi = NULL,
  interpret_fail = c("error", "warn", "silent")
)

period_upper(
  labels,
  interpret_single = c("lower", "upper"),
  interpret_multi = NULL,
  interpret_fail = c("error", "warn", "silent")
)

period_width(
  labels,
  interpret_single = c("lower", "upper"),
  interpret_multi = NULL,
  interpret_fail = c("error", "warn", "silent")
)

period_interval(
  labels,
  interpret_single = c("lower", "upper"),
  interpret_multi = NULL,
  interpret_fail = c("error", "warn", "silent")
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

## Value

`period_interval()` returns a character vector, and the other functions
return a numeric vector. The result has the same length as `labels`. If
`labels` has names, the result has the same names.

## Details

Lower and upper limits can be used to filter on periods. See below for
examples.

`period_mid()` assigns open periods (e.g., `"2025+"`) honorary
midpoints, which are useful for plotting. An interval that is open on
the right gets a midpoint half the width of the closed period with the
highest lower limit, and an interval that is open on the left gets a
midpoint half the width of the closed period with the lowest upper
limit.

`period_interval()` describes each period using interval notation. For
instance, `"[2020, 2025)"` includes 2020 but not 2025, and
`"(-Inf, 2000)"` has no lower limit. `period_interval()` is useful for
checking how labels are being interpreted.

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

- [`age_lower()`](https://bayesiandemography.github.io/agetime/reference/age_lower.md)
  Age equivalent of `period_lower()`

- [`age_upper()`](https://bayesiandemography.github.io/agetime/reference/age_lower.md)
  Age equivalent of `period_upper()`

- [`age_mid()`](https://bayesiandemography.github.io/agetime/reference/age_lower.md)
  Age equivalent of `period_mid()`

- [`age_width()`](https://bayesiandemography.github.io/agetime/reference/age_lower.md)
  Age equivalent of `period_width()`

- [`age_interval()`](https://bayesiandemography.github.io/agetime/reference/age_lower.md)
  Age equivalent of `period_interval()`

- [`cohort_lower()`](https://bayesiandemography.github.io/agetime/reference/cohort_lower.md)
  Cohort equivalent of `period_lower()`

- [`cohort_upper()`](https://bayesiandemography.github.io/agetime/reference/cohort_lower.md)
  Cohort equivalent of `period_upper()`

- [`cohort_mid()`](https://bayesiandemography.github.io/agetime/reference/cohort_lower.md)
  Cohort equivalent of `period_mid()`

- [`cohort_width()`](https://bayesiandemography.github.io/agetime/reference/cohort_lower.md)
  Cohort equivalent of `period_width()`

- [`cohort_interval()`](https://bayesiandemography.github.io/agetime/reference/cohort_lower.md)
  Cohort equivalent of `period_interval()`

## Examples

``` r
labels <- c("2025-2030", "2020-2025", "2030-2035")
period_lower(labels)
#> [1] 2025 2020 2030
period_upper(labels)
#> [1] 2030 2025 2035
period_width(labels)
#> [1] 5 5 5
period_mid(labels)
#> [1] 2027.5 2022.5 2032.5
period_interval(labels)
#> [1] "[2025, 2030)" "[2020, 2025)" "[2030, 2035)"

## use 'period_lower()' to filter on period
library(dplyr, warn.conflicts = FALSE)
df <- tribble(
  ~period, ~count,
  "2020-2025", 20,
  "2025-2030", 5,
  "2030-2035", 11
)
df
#> # A tibble: 3 × 2
#>   period    count
#>   <chr>     <dbl>
#> 1 2020-2025    20
#> 2 2025-2030     5
#> 3 2030-2035    11
df |> filter(period_lower(period) >= 2025)
#> # A tibble: 2 × 2
#>   period    count
#>   <chr>     <dbl>
#> 1 2025-2030     5
#> 2 2030-2035    11

## midpoint of open periods
period_mid(c("2020-2030", "2030-2040", "2040+")) # 2045
#> [1] 2025 2035 2045
period_mid(c("2020-2025", "2025-2030", "2030+")) # 2032.5
#> [1] 2022.5 2027.5 2032.5

## 'interpret_single' is "lower" (the default)
period_lower("2025")
#> [1] 2025
period_upper("2025")
#> [1] 2026
period_width("2025")
#> [1] 1
period_interval("2025")
#> [1] "[2025, 2026)"

## 'interpret_single' is "upper"
period_lower("2025", interpret_single = "upper")
#> [1] 2024
period_upper("2025", interpret_single = "upper")
#> [1] 2025
period_width("2025", interpret_single = "upper")
#> [1] 1
period_interval("2025", interpret_single = "upper")
#> [1] "[2024, 2025)"

## 'interpret_multi' is "at_upper"
## (the default, NULL, behaves like "at_upper")
period_upper("2025-2030")
#> [1] 2030
period_width("2025-2030")
#> [1] 5
period_interval("2025-2030")
#> [1] "[2025, 2030)"

## 'interpret_multi' is "below_upper"
period_upper("2025-2030", interpret_multi = "below_upper")
#> [1] 2031
period_width("2025-2030", interpret_multi = "below_upper")
#> [1] 6
period_interval("2025-2030", interpret_multi = "below_upper")
#> [1] "[2025, 2031)"

## no action when 'interpret_fail' is "silent"
period_lower(
  labels = c("2000-2005", "long time ago"),
  interpret_fail = "silent"
)
#> [1] 2000   NA

## names of 'labels' are kept
periods <- c(base = "2020", forecast = "2025-2030")
period_lower(periods)
#>     base forecast 
#>     2020     2025 
```
