# Standardize Period Labels

Convert period labels to the default agetime format for periods.

## Usage

``` r
period_standard(
  labels,
  interpret_single = c("lower", "upper"),
  interpret_multi = c("include", "exclude"),
  interpret_fail = c("error", "warn", "silent")
)
```

## Arguments

- labels:

  Vector of period labels.

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

Character vector or factor with the same length as `labels`.

## Rules for formatting output

|                 |                        |                              |
|-----------------|------------------------|------------------------------|
| *Interval type* | *Rule*                 | *Example*                    |
| single          | `[a,a+1) -> "a"`       | `[2020,2021) -> "2020"`      |
| multi           | `[a,a+n) -> "a-<a+n>"` | `[2020,2025) -> "2020-2025"` |
| open on left    | `(-Inf,a) -> "<a"`     | `(-Inf,2020) -> "<2020"`     |
| open on right   | `[a,Inf) -> "a+"`      | `[2020,Inf) -> "2020+"`      |

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

- [`age_standard()`](https://bayesiandemography.github.io/agetime/reference/age_standard.md)
  Age equivalent of `period_standard()`

- [`cohort_standard()`](https://bayesiandemography.github.io/agetime/reference/cohort_standard.md)
  Cohort equivalent of `period_standard()`

- [`period_labels()`](https://bayesiandemography.github.io/agetime/reference/period_labels.md)
  Create period labels

## Examples

``` r
labels <- c("2025to2030", "1910--1914", " 2022 ", "all")
period_standard(labels)
#> [1] "2025-2030" "1910-1914" "2022"      "Total"    
```
