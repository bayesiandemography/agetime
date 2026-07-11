# Fill in Gaps in Cohort Levels

Fill in gaps in levels of `labels`.

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

## Details

If `labels` is not a factor, and so does not have levels, convert it to
a factor before filling in levels.

- `cohort_fill` adds cohorts specified by `breaks`.

- `cohort_fill_one` adds cohorts with width 1.

- `cohort_fill_five` adds cohorts with width 5.

- `cohort_fill_ten` adds cohorts with width 10.

## Controlling how cohort labels are interpreted

If `interpret_single` is `"lower"` (the default), then labels for
single-year cohorts are assumed to refer to lower limits, so that
`"2025"` means `[2025,2026)`. This is the convention that data providers
typically use for calendar years.

If `interpret_single` is `"upper"`, then labels for single-year cohorts
are assumed to refer to upper limits, so that `"2025"` means
`[2024,2025)`. This is the convention that data providers typically use
for non-calendar years, such as 1 July to 30 June.

If `interpret_multi` is `"include"` (the default), then labels for
multi-year cohorts are assumed to include upper limits, so that
`"2025-2030"` means `[2025,2030)`.

If `interpret_multi` is `"exclude"`, then labels for multi-year cohorts
are assumed to exclude the upper limits so that `"2025-2030"` means
`[2025,2031)`.

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
labels |> table()
#> labels
#> 2021-2031 2051-2061 
#>         1         1 
labels |>
  cohort_fill_ten() |>
  table()
#> 
#> 2021-2031 2031-2041 2041-2051 2051-2061 
#>         1         0         0         1 

## sort after filling
labels |>
  cohort_fill_ten() |>
  cohort_sort() |>
  table()
#> 
#> 2021-2031 2031-2041 2041-2051 2051-2061 
#>         1         0         0         1 
```
