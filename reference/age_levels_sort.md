# Sort Age Group Levels

Sort the levels of `labels`.

## Usage

``` r
age_levels_sort(
  labels,
  decreasing = FALSE,
  interpret_fail = c("error", "warn", "silent")
)
```

## Arguments

- labels:

  Vector of age group labels.

- decreasing:

  Whether sort is increasing or decreasing. Default is `FALSE`.

- interpret_fail:

  Action if element of `labels` cannot be parsed: `"error"` (the
  default), `"warn"`, or `"silent"`.

## Value

Factor with the same length as `labels`.

## Details

If `labels` is not a factor, and so does not have levels, convert it to
a factor before sorting the levels.

Levels are sorted on their lower limits. Upper limits are used to
resolve times. `NA`s come second-to-last and totals come last.

## See also

- [`period_levels_sort()`](https://bayesiandemography.github.io/agetime/reference/period_levels_sort.md)
  Period equivalent of `age_levels_sort()`

- [`cohort_levels_sort()`](https://bayesiandemography.github.io/agetime/reference/cohort_levels_sort.md)
  Cohort equivalent of `age_levels_sort()`

## Examples

``` r
labels <- c("0-4", "50+", "Total", NA, "20-24")
age_levels_sort(labels)
#> [1] 0-4   50+   Total <NA>  20-24
#> Levels: 0-4 20-24 50+ <NA> Total
```
