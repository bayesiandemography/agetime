# Fill in Gaps in Period Levels

Fill in gaps in levels of `x`.

## Usage

``` r
period_levels_fill(
  x,
  breaks = NULL,
  x_one = c("lower", "upper"),
  x_multi = c("include", "exclude"),
  x_fail = c("error", "warn", "silent")
)

period_levels_fill_one(
  x,
  x_one = c("lower", "upper"),
  x_multi = c("include", "exclude"),
  x_fail = c("error", "warn", "silent")
)

period_levels_fill_five(
  x,
  x_one = c("lower", "upper"),
  x_multi = c("include", "exclude"),
  x_fail = c("error", "warn", "silent")
)

period_levels_fill_ten(
  x,
  x_one = c("lower", "upper"),
  x_multi = c("include", "exclude"),
  x_fail = c("error", "warn", "silent")
)
```

## Arguments

- x:

  Vector of period labels.

- breaks:

  Boundaries of newly-created periods. Boundaries for existing periods
  can be omitted.

- x_one:

  How to interpret labels in `x` that describe one-year periods. Choices
  are `"lower"` (the default) and `"upper"`.

- x_multi:

  How to interpret labels in `x` that describe multi-year periods.
  Choices are `"include"` (the default) and `"exclude"`.

- x_fail:

  Action if element of `x` cannot be parsed: `"error"` (the default),
  `"warn"`, or `"silent"`.

## Value

Factor with the same length as `x`.

## Details

If `x` is not a factor, and so does not have levels, convert it to a
factor before filling in levels.

- `period_levels_fill` adds periods specified by `breaks`.

- `period_levels_fill_one` adds periods with width 1.

- `period_levels_fill_five` adds periods with width 5.

- `period_levels_fill_ten` adds periods with width 10.

## See also

- [`parsing_period_labels()`](https://bayesiandemography.github.io/agetime/reference/parsing_period_labels.md)
  Details for `x_one`, `x_multi`, and `x_fail`

- [`age_levels_fill()`](https://bayesiandemography.github.io/agetime/reference/age_levels_fill.md)
  Age equivalent of `period_levels_fill()`

- [`cohort_levels_fill()`](https://bayesiandemography.github.io/agetime/reference/cohort_levels_fill.md)
  Cohort equivalent of `period_levels_fill()`

## Examples

``` r
x <- factor(c("2020-2025", "2030-2035"))
x
#> [1] 2020-2025 2030-2035
#> Levels: 2020-2025 2030-2035
period_levels_fill(x) ## uses existing boundaries
#> [1] 2020-2025 2030-2035
#> Levels: 2020-2025 2025-2030 2030-2035
period_levels_fill(x, breaks = 2028)
#> [1] 2020-2025 2030-2035
#> Levels: 2020-2025 2025-2028 2028-2030 2030-2035
period_levels_fill_one(x)
#> [1] 2020-2025 2030-2035
#> Levels: 2020-2025 2025 2026 2027 2028 2029 2030-2035
period_levels_fill_five(x)
#> [1] 2020-2025 2030-2035
#> Levels: 2020-2025 2025-2030 2030-2035

x <- c("2051-2061", "2021-2031")
period_levels_fill_ten(x)
#> [1] 2051-2061 2021-2031
#> Levels: 2021-2031 2031-2041 2041-2051 2051-2061

## levels are used by functions
## such as 'table()'
x |> table()
#> x
#> 2021-2031 2051-2061 
#>         1         1 
x |>
  period_levels_fill_ten() |>
  table()
#> 
#> 2021-2031 2031-2041 2041-2051 2051-2061 
#>         1         0         0         1 

## sort after filling
x |>
  period_levels_fill_ten() |>
  period_levels_sort() |>
  table()
#> 
#> 2021-2031 2031-2041 2041-2051 2051-2061 
#>         1         0         0         1 
```
