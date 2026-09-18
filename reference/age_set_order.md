# Set Order of Age Group Levels

Modify the `levels` attribute of `labels` so that age groups are ordered
by their lower limits.

## Usage

``` r
age_set_order(
  labels,
  decreasing = FALSE,
  interpret_fail = c("error", "warn", "silent")
)
```

## Arguments

- labels:

  Vector of age group labels.

- decreasing:

  Whether order is increasing or decreasing. Default is `FALSE`.

- interpret_fail:

  Action if element of `labels` cannot be interpreted. Choices are
  `"error"` (the default), `"warn"`, and `"silent"`.

## Value

Factor with the same length as `labels`.

## Details

`age_set_order()` fixes a common problem with age group labels, where
levels are ordered alphabetically rather than numerically, so that, for
instance, `"10-14"` comes before `"5-9"`. Calling `age_set_order()` on
age group labels makes the labels behave sensibly with functions such as
[`sort()`](https://rdrr.io/r/base/sort.html),
[`order()`](https://rdrr.io/r/base/order.html), and
[`arrange()`](https://dplyr.tidyverse.org/reference/arrange.html).

If `labels` is not a factor, and so does not have levels, it is
converted to a factor before the ordering is performed.

`age_set_order()` has no effect on the values of `labels`. Only the
levels are changed.

When two age groups have the same lower limit, the age group with the
smallest upper limit comes first. Labels for missing values come
second-to-last in the ordering, and totals come last.

## See also

- [`period_set_order()`](https://bayesiandemography.github.io/agetime/reference/period_set_order.md)
  Period equivalent of `age_set_order()`

- [`cohort_set_order()`](https://bayesiandemography.github.io/agetime/reference/cohort_set_order.md)
  Cohort equivalent of `age_set_order()`

## Examples

``` r
labels <- c("0-4", "50+", "Total", NA, "20-24")
age_set_order(labels)
#> [1] 0-4   50+   Total <NA>  20-24
#> Levels: 0-4 20-24 50+ <NA> Total
```
