# Fill in Gaps in Age Group Levels

Fill in gaps in levels of `labels`.

## Usage

``` r
age_fill(labels, breaks = NULL, interpret_fail = c("error", "warn", "silent"))

age_fill_one(labels, interpret_fail = c("error", "warn", "silent"))

age_fill_five(labels, interpret_fail = c("error", "warn", "silent"))

age_fill_ten(labels, interpret_fail = c("error", "warn", "silent"))

age_fill_life(labels, interpret_fail = c("error", "warn", "silent"))
```

## Arguments

- labels:

  Vector of age group labels.

- breaks:

  Boundaries of newly-created age groups. Boundaries for existing age
  groups can be omitted.

- interpret_fail:

  Action if element of `labels` cannot be interpreted. Choices are
  `"error"` (the default), `"warn"`, and `"silent"`.

## Value

Factor with the same length as `labels`.

## Details

If `labels` is not a factor, and so does not have levels, convert it to
a factor before filling in levels.

- `age_fill` adds age groups specified by `breaks`.

- `age_fill_one` adds age groups with width 1.

- `age_fill_five` adds age groups with width 5.

- `age_fill_ten` adds age groups with width 10.

- `age_fill_life` adds age groups used by an abridged life table.

## Abridged and complete life tables

- An 'abridged' life table uses age groups `"0"` and `"1-4"`, followed
  by 5-year age groups `"5-9"`, `"10-14"`, ...

- A 'complete' life table uses single-year age groups `"0"`, `"1"`,
  `"2"`, ...

- Both types of life table have an open interval such as `"85+"` or
  `"100+"`.

## See also

- [`period_fill()`](https://bayesiandemography.github.io/agetime/reference/period_fill.md)
  Period equivalent of `age_fill()`

- [`cohort_fill()`](https://bayesiandemography.github.io/agetime/reference/cohort_fill.md)
  Cohort equivalent of `age_fill()`

## Examples

``` r
labels <- factor(c("0-4", "20-24"))
labels
#> [1] 0-4   20-24
#> Levels: 0-4 20-24
age_fill(labels) ## uses existing boundaries
#> [1] 0-4   20-24
#> Levels: 0-4 5-19 20-24
age_fill(labels, breaks = c(8, 12))
#> [1] 0-4   20-24
#> Levels: 0-4 5-7 8-11 12-19 20-24
age_fill_one(labels)
#> [1] 0-4   20-24
#> Levels: 0-4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20-24
age_fill_five(labels)
#> [1] 0-4   20-24
#> Levels: 0-4 5-9 10-14 15-19 20-24

labels <- c("25-29", "0-4")
age_fill_ten(labels)
#> [1] 25-29 0-4  
#> Levels: 0-4 5-14 15-24 25-29

labels <- c("60+", "0")
age_fill_life(labels)
#> [1] 60+ 0  
#> 14 Levels: 0 1-4 5-9 10-14 15-19 20-24 25-29 30-34 35-39 40-44 45-49 ... 60+

## levels are used by functions
## such as 'table()'
labels <- c("30-39", "0-9")
labels |> table()
#> labels
#>   0-9 30-39 
#>     1     1 
labels |>
  age_fill() |>
  table()
#> 
#>   0-9 10-29 30-39 
#>     1     0     1 

## sort after filling
labels |>
  age_fill() |>
  age_sort() |>
  table()
#> 
#>   0-9 10-29 30-39 
#>     1     0     1 
```
