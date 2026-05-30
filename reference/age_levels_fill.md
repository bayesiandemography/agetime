# Fill in Gaps in Age Group Levels

Fill in gaps in the levels of `x`.

## Usage

``` r
age_levels_fill(x, breaks = NULL, x_fail = c("error", "warn", "silent"))

age_levels_fill_one(x, x_fail = c("error", "warn", "silent"))

age_levels_fill_five(x, x_fail = c("error", "warn", "silent"))

age_levels_fill_ten(x, x_fail = c("error", "warn", "silent"))

age_levels_fill_life(x, x_fail = c("error", "warn", "silent"))
```

## Arguments

- x:

  Vector of age group labels.

- breaks:

  Boundaries of the the newly-created age groups. (Boundaries supplied
  by existing age groups can be omitted.)

- x_fail:

  Action if element of `x` cannot be parsed: `"error"` (the default),
  `"warn"`, or `"silent"`.

## Value

A factor, the same length as `x`.

When `length(x) == 0` and there are no levels to fill, returns an empty
factor. If `breaks` is supplied to `age_levels_fill()`, levels are built
from `breaks`. When `length(x) == 0` but `x` is a factor with levels,
[`levels()`](https://rdrr.io/r/base/levels.html) are still filled in.
The `ordered` attribute is preserved when `x` is an ordered factor.

## Details

If `x` is not a factor, and so does not have levels, convert it to a
factor before filling in the levels.

- `age_levels_fill` adds the age groups specified by `breaks`.

- `age_levels_fill_one` adds age groups with width 1.

- `age_levels_fill_five` adds age groups with width 5.

- `age_levels_fill_ten` adds age groups with width 10.

- `age_levels_fill_life` adds age groups used by a life table.

## Examples

``` r
x <- factor(c("0-4", "20-24"))
x
#> [1] 0-4   20-24
#> Levels: 0-4 20-24
age_levels_fill(x) ## uses existing boundaries
#> [1] 0-4  5-19
#> Levels: 0-4 5-19 20-24
age_levels_fill(x, breaks = c(8, 12))
#> [1] 0-4 5-7
#> Levels: 0-4 5-7 8-11 12-19 20-24
age_levels_fill_one(x)
#> [1] 0-4 5  
#> Levels: 0-4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20-24
age_levels_fill_five(x)
#> [1] 0-4 5-9
#> Levels: 0-4 5-9 10-14 15-19 20-24

x <- c("25-29", "0-4")
age_levels_fill_ten(x)
#> [1] 25-29 0-4  
#> Levels: 25-29 0-4 5-14 15-24

x <- c("60+", "0")
age_levels_fill_life(x)
#> [1] 60+ 0  
#> 14 Levels: 60+ 0 1-4 5-9 10-14 15-19 20-24 25-29 30-34 35-39 40-44 ... 55-59

## levels are used by functions
## such as 'table()'
x <- c("30-39", "0-9")
x |> table()
#> x
#>   0-9 30-39 
#>     1     1 
x |>
  age_levels_fill() |>
  table()
#> 
#> 30-39   0-9 10-29 
#>     1     1     0 

## sort after filling
x |>
  age_levels_fill() |>
  age_levels_sort() |>
  table()
#> 
#>   0-9 10-29 30-39 
#>     1     1     0 
```
