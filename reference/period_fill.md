# Fill in Gaps in Period Levels

Fill in gaps in levels of `labels`.

## Usage

``` r
period_fill(
  labels,
  breaks = NULL,
  interpret_single = c("lower", "upper"),
  interpret_multi = c("include", "exclude"),
  interpret_fail = c("error", "warn", "silent")
)

period_fill_one(
  labels,
  interpret_single = c("lower", "upper"),
  interpret_multi = c("include", "exclude"),
  interpret_fail = c("error", "warn", "silent")
)

period_fill_five(
  labels,
  interpret_single = c("lower", "upper"),
  interpret_multi = c("include", "exclude"),
  interpret_fail = c("error", "warn", "silent")
)

period_fill_ten(
  labels,
  interpret_single = c("lower", "upper"),
  interpret_multi = c("include", "exclude"),
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

  How to interpret labels for single-year periods. Choices are `"lower"`
  (the default) and `"upper"`. See below for details.

- interpret_multi:

  How to interpret labels for multi-year periods. Choices are
  `"include"` (the default) and `"exclude"`. See below for details.

- interpret_fail:

  Action if element of `labels` cannot be interpreted. Choices are
  `"error"` (the default), `"warn"`, and `"silent"`.

## Value

Factor with the same length as `labels`.

## Details

If `labels` is not a factor, and so does not have levels, convert it to
a factor before filling in levels.

- `period_fill` adds periods specified by `breaks`.

- `period_fill_one` adds periods with width 1.

- `period_fill_five` adds periods with width 5.

- `period_fill_ten` adds periods with width 10.

## Controlling how period labels are interpreted

If `interpret_single` is `"lower"` (the default), then labels for
single-year periods are assumed to refer to lower limits, so that
`"2025"` means `[2025,2026)`. This is the convention that data providers
typically use for calendar years.

If `interpret_single` is `"upper"`, then labels for single-year periods
are assumed to refer to upper limits, so that `"2025"` means
`[2024,2025)`. This is the convention that data providers typically use
for non-calendar years, such as 1 July to 30 June.

If `interpret_multi` is `"include"` (the default), then labels for
multi-year periods are assumed to include upper limits, so that
`"2025-2030"` means `[2025,2030)`.

If `interpret_multi` is `"exclude"`, then labels for multi-year periods
are assumed to exclude the upper limits, so that `"2025-2030"` means
`[2025,2031)`.

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
labels |> table()
#> labels
#> 2021-2031 2051-2061 
#>         1         1 
labels |>
  period_fill_ten() |>
  table()
#> 
#> 2021-2031 2031-2041 2041-2051 2051-2061 
#>         1         0         0         1 

## sort after filling
labels |>
  period_fill_ten() |>
  period_sort() |>
  table()
#> 
#> 2021-2031 2031-2041 2041-2051 2051-2061 
#>         1         0         0         1 
```
