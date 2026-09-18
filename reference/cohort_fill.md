# Fill in Gaps in Cohort Levels

Add intermediate cohorts.

The return value is a factor, and the intermediate cohorts are added as
factor levels.

- `cohort_fill()` adds cohorts specified by `breaks`.

- `cohort_fill_one()` adds cohorts with width 1.

- `cohort_fill_five()` adds cohorts with width 5.

- `cohort_fill_ten()` adds cohorts with width 10.

## Usage

``` r
cohort_fill(
  labels,
  breaks = NULL,
  interpret_single = c("lower", "upper"),
  interpret_multi = c("include", "exclude"),
  interpret_fail = c("error", "warn", "silent")
)

cohort_fill_one(
  labels,
  interpret_single = c("lower", "upper"),
  interpret_multi = c("include", "exclude"),
  interpret_fail = c("error", "warn", "silent")
)

cohort_fill_five(
  labels,
  interpret_single = c("lower", "upper"),
  interpret_multi = c("include", "exclude"),
  interpret_fail = c("error", "warn", "silent")
)

cohort_fill_ten(
  labels,
  interpret_single = c("lower", "upper"),
  interpret_multi = c("include", "exclude"),
  interpret_fail = c("error", "warn", "silent")
)
```

## Arguments

- labels:

  Vector of cohort labels.

- breaks:

  Boundaries of newly-created cohorts. Boundaries for existing cohorts
  can be omitted.

- interpret_single:

  How to interpret labels for single-year cohorts. Choices are `"lower"`
  (the default) and `"upper"`. See below for details.

- interpret_multi:

  How to interpret labels for multi-year cohorts. Choices are
  `"include"` (the default) and `"exclude"`. See below for details.

- interpret_fail:

  Action if element of `labels` cannot be interpreted. Choices are
  `"error"` (the default), `"warn"`, and `"silent"`.

## Value

Factor with the same length as `labels`.

## Rules for interpreting inputs

Single-year cohorts:

|                    |                  |                         |
|--------------------|------------------|-------------------------|
| `interpret_single` | *Rule*           | *Example*               |
| `"lower"`          | `"a" -> [a,a+1)` | `"2020" -> [2020,2021)` |
| `"upper"`          | `"a" -> [a-1,a)` | `"2020" -> [2019,2020)` |

Data providers typically use the "lower" convention for calendar years
(1 January to 31 December), and the "upper" convention for non-calendar
years (e.g., 1 July to 30 June).

Multi-year cohorts:

|                   |                          |                              |
|-------------------|--------------------------|------------------------------|
| `interpret_multi` | *Rule*                   | *Example*                    |
| `"include"`       | `"a-<a+n>" -> [a,a+n)`   | `"2020-2025" -> [2020,2025)` |
| `"exclude"`       | `"a-<a+n-1>" -> [a,a+n)` | `"2020-2024" -> [2020,2025)` |

A two-value label cannot describe a one-year cohort. With
`interpret_multi = "include"`, `"2010-2011"` would be `[2010, 2011)` and
`"2010-2010"` would be empty; both are rejected. Use `"2010"`, or
`"2010-2012"` for two years. With `interpret_multi = "exclude"`,
`"2010-2011"` is two years `[2010, 2012)` and is accepted.

## See also

- [`age_fill()`](https://bayesiandemography.github.io/agetime/reference/age_fill.md)
  Age equivalent of `cohort_fill()`

- [`period_fill()`](https://bayesiandemography.github.io/agetime/reference/period_fill.md)
  Period equivalent of `cohort_fill()`

## Examples

``` r
labels <- factor(c("2020-2025", "2030-2035"))
labels
#> [1] 2020-2025 2030-2035
#> Levels: 2020-2025 2030-2035
cohort_fill(labels) ## uses existing boundaries
#> [1] 2020-2025 2030-2035
#> Levels: 2020-2025 2025-2030 2030-2035
cohort_fill(labels, breaks = 2028)
#> [1] 2020-2025 2030-2035
#> Levels: 2020-2025 2025-2028 2028-2030 2030-2035
cohort_fill_one(labels)
#> [1] 2020-2025 2030-2035
#> Levels: 2020-2025 2025 2026 2027 2028 2029 2030-2035
cohort_fill_five(labels)
#> [1] 2020-2025 2030-2035
#> Levels: 2020-2025 2025-2030 2030-2035

labels <- c("2051-2061", "2021-2031")
cohort_fill_ten(labels)
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
  cohort_fill_ten() |>
  table()
#> 
#> 2021-2031 2031-2041 2041-2051 2051-2061 
#>         1         0         0         1 

## set level order after filling
labels |>
  cohort_fill_ten() |>
  cohort_set_order() |>
  table()
#> 
#> 2021-2031 2031-2041 2041-2051 2051-2061 
#>         1         0         0         1 
```
