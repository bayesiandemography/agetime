# Limits, Widths, Midpoints, and Intervals from Cohort Labels

Calculate lower limits, upper limits, widths, midpoints, and intervals
from cohort labels.

## Usage

``` r
cohort_lower(
  labels,
  interpret_single = c("lower", "upper"),
  interpret_multi = NULL,
  interpret_fail = c("error", "warn", "silent")
)

cohort_mid(
  labels,
  interpret_single = c("lower", "upper"),
  interpret_multi = NULL,
  interpret_fail = c("error", "warn", "silent")
)

cohort_upper(
  labels,
  interpret_single = c("lower", "upper"),
  interpret_multi = NULL,
  interpret_fail = c("error", "warn", "silent")
)

cohort_width(
  labels,
  interpret_single = c("lower", "upper"),
  interpret_multi = NULL,
  interpret_fail = c("error", "warn", "silent")
)

cohort_interval(
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

`cohort_interval()` returns a character vector, and the other functions
return a numeric vector. The result has the same length as `labels`. If
`labels` has names, the result has the same names.

## Details

Lower and upper limits can be used to filter on cohorts. See below for
examples.

`cohort_mid()` assigns open cohorts (e.g., `"<2000"`) honorary
midpoints, which are useful for plotting. An interval that is open on
the right gets a midpoint half the width of the closed cohort with the
highest lower limit, and an interval that is open on the left gets a
midpoint half the width of the closed cohort with the lowest upper
limit.

`cohort_interval()` describes each cohort using interval notation. For
instance, `"[2020, 2025)"` includes 2020 but not 2025, and
`"(-Inf, 2000)"` has no lower limit. `cohort_interval()` is useful for
checking how labels are being interpreted.

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

- [`age_lower()`](https://bayesiandemography.github.io/agetime/reference/age_lower.md)
  Age equivalent of `cohort_lower()`

- [`age_upper()`](https://bayesiandemography.github.io/agetime/reference/age_lower.md)
  Age equivalent of `cohort_upper()`

- [`age_mid()`](https://bayesiandemography.github.io/agetime/reference/age_lower.md)
  Age equivalent of `cohort_mid()`

- [`age_width()`](https://bayesiandemography.github.io/agetime/reference/age_lower.md)
  Age equivalent of `cohort_width()`

- [`age_interval()`](https://bayesiandemography.github.io/agetime/reference/age_lower.md)
  Age equivalent of `cohort_interval()`

- [`period_lower()`](https://bayesiandemography.github.io/agetime/reference/period_lower.md)
  Period equivalent of `cohort_lower()`

- [`period_upper()`](https://bayesiandemography.github.io/agetime/reference/period_lower.md)
  Period equivalent of `cohort_upper()`

- [`period_mid()`](https://bayesiandemography.github.io/agetime/reference/period_lower.md)
  Period equivalent of `cohort_mid()`

- [`period_width()`](https://bayesiandemography.github.io/agetime/reference/period_lower.md)
  Period equivalent of `cohort_width()`

- [`period_interval()`](https://bayesiandemography.github.io/agetime/reference/period_lower.md)
  Period equivalent of `cohort_interval()`

## Examples

``` r
labels <- c("2025-2030", "<2025", "2030-2035")
cohort_lower(labels)
#> [1] 2025 -Inf 2030
cohort_upper(labels)
#> [1] 2030 2025 2035
cohort_width(labels)
#> [1]   5 Inf   5
cohort_mid(labels)
#> [1] 2027.5 2022.5 2032.5
cohort_interval(labels)
#> [1] "[2025, 2030)" "(-Inf, 2025)" "[2030, 2035)"
library(dplyr, warn.conflicts = FALSE)
df <- tribble(
  ~cohort, ~count,
  "2025-2030", 20,
  "<2025", 5,
  "2030-2035", 11
)
df
#> # A tibble: 3 × 2
#>   cohort    count
#>   <chr>     <dbl>
#> 1 2025-2030    20
#> 2 <2025         5
#> 3 2030-2035    11
df |> filter(cohort_lower(cohort) >= 2025)
#> # A tibble: 2 × 2
#>   cohort    count
#>   <chr>     <dbl>
#> 1 2025-2030    20
#> 2 2030-2035    11

## midpoint of open cohorts
cohort_mid(c("<2000", "2000-2010", "2010-2020")) # 1995
#> [1] 1995 2005 2015
cohort_mid(c("<2000", "2000-2005", "2005-2010")) # 1997.5
#> [1] 1997.5 2002.5 2007.5

## 'interpret_single' is "lower" (the default)
cohort_lower("2025")
#> [1] 2025
cohort_upper("2025")
#> [1] 2026
cohort_width("2025")
#> [1] 1
cohort_interval("2025")
#> [1] "[2025, 2026)"

## 'interpret_single' is "upper"
cohort_lower("2025", interpret_single = "upper")
#> [1] 2024
cohort_upper("2025", interpret_single = "upper")
#> [1] 2025
cohort_width("2025", interpret_single = "upper")
#> [1] 1
cohort_interval("2025", interpret_single = "upper")
#> [1] "[2024, 2025)"

## 'interpret_multi' is "at_upper"
## (the default, NULL, behaves like "at_upper")
cohort_upper("2025-2030")
#> [1] 2030
cohort_width("2025-2030")
#> [1] 5
cohort_interval("2025-2030")
#> [1] "[2025, 2030)"

## 'interpret_multi' is "below_upper"
cohort_upper("2025-2030", interpret_multi = "below_upper")
#> [1] 2031
cohort_width("2025-2030", interpret_multi = "below_upper")
#> [1] 6
cohort_interval("2025-2030", interpret_multi = "below_upper")
#> [1] "[2025, 2031)"

## no action when 'interpret_fail' is "silent"
cohort_lower(
  labels = c("2000-2005", "long time ago"),
  interpret_fail = "silent"
)
#> [1] 2000   NA

## names of 'labels' are kept
cohorts <- c(parents = "1960-1970", children = "1990-2000")
cohort_lower(cohorts)
#>  parents children 
#>     1960     1990 
```
