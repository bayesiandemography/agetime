# Fill in Gaps in Cohort Levels

Fill in gaps in the levels of `x`.

## Usage

``` r
cohort_levels_fill(
  x,
  breaks = NULL,
  x_one = c("lower", "upper"),
  x_multi = c("include", "exclude"),
  x_fail = c("error", "warn", "silent")
)

cohort_levels_fill_one(
  x,
  x_one = c("lower", "upper"),
  x_multi = c("include", "exclude"),
  x_fail = c("error", "warn", "silent")
)

cohort_levels_fill_five(
  x,
  x_one = c("lower", "upper"),
  x_multi = c("include", "exclude"),
  x_fail = c("error", "warn", "silent")
)

cohort_levels_fill_ten(
  x,
  x_one = c("lower", "upper"),
  x_multi = c("include", "exclude"),
  x_fail = c("error", "warn", "silent")
)
```

## Arguments

- x:

  A vector of cohort labels.

- breaks:

  Boundaries of the the newly-created cohorts. (Boundaries supplied by
  existing cohorts can be omitted.)

- x_one:

  Whether labels for one-year cohorts are based on the lower or upper
  limit of the period. Default is `"lower"`.

- x_multi:

  Whether labels for multi-year periods include or exclude the final
  year of the period. Default is `"include"`.

- x_fail:

  Action if element of `x` cannot be parsed: `"error"` (the default),
  `"warn"`, or `"silent"`.

## Value

A factor, the same length as `x`.

## Details

If `x` is not a factor, and so does not have levels, convert it to a
factor before filling in the levels.

- `cohort_levels_fill` adds the cohorts specified by `breaks`.

- `cohort_levels_fill_one` adds cohorts with width 1.

- `cohort_levels_fill_five` adds cohorts with width 5.

- `cohort_levels_fill_ten` adds cohorts with width 10.

## Examples

``` r
x <- factor(c("2020-2025", "2030-2035"))
x
#> [1] 2020-2025 2030-2035
#> Levels: 2020-2025 2030-2035
cohort_levels_fill(x) ## uses existing boundaries
#> [1] 2020-2025 2025-2030
#> Levels: 2020-2025 2025-2030 2030-2035
cohort_levels_fill(x, breaks = 2028)
#> [1] 2020-2025 2025-2028
#> Levels: 2020-2025 2025-2028 2028-2030 2030-2035
cohort_levels_fill_one(x)
#> [1] 2020-2025 2025     
#> Levels: 2020-2025 2025 2026 2027 2028 2029 2030-2035
cohort_levels_fill_five(x)
#> [1] 2020-2025 2025-2030
#> Levels: 2020-2025 2025-2030 2030-2035

x <- c("2051-2061", "2021-2031")
cohort_levels_fill_ten(x)
#> [1] 2051-2061 2021-2031
#> Levels: 2051-2061 2021-2031 2031-2041 2041-2051

## levels are used by functions
## such as 'table()'
x |> table()
#> x
#> 2021-2031 2051-2061 
#>         1         1 
x |>
  cohort_levels_fill_ten() |>
  table()
#> 
#> 2051-2061 2021-2031 2031-2041 2041-2051 
#>         1         1         0         0 

## sort after filling
x |>
  cohort_levels_fill_ten() |>
  cohort_levels_sort() |>
  table()
#> 
#> 2021-2031 2031-2041 2041-2051 2051-2061 
#>         1         0         0         1 
```
