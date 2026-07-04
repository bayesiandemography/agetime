# Convert to New Periods

Modify the periods used by `labels`. The the new periods must contain
the old ones.

## Usage

``` r
period_modify(
  labels,
  breaks,
  interpret_single = c("lower", "upper"),
  interpret_multi = c("include", "exclude"),
  interpret_fail = c("error", "warn", "silent")
)
```

## Arguments

- labels:

  Vector of period labels.

- breaks:

  Boundaries between periods. A numeric vector.

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

- [`period_modify_five()`](https://bayesiandemography.github.io/agetime/reference/period_modify_five.md)
  Convert to 5-year periods

- [`period_modify_ten()`](https://bayesiandemography.github.io/agetime/reference/period_modify_five.md)
  Convert to 10-year periods

- [`age_modify()`](https://bayesiandemography.github.io/agetime/reference/age_modify.md)
  Age group equivalent of `period_modify()`

- [`cohort_modify()`](https://bayesiandemography.github.io/agetime/reference/cohort_modify.md)
  Cohort equivalent of `period_modify()`

## Examples

``` r
labels <- c("2001-2004", "1987-1989", "2000", "2005-2010")
period_modify(labels, breaks = c(1970, 2000, 2005, 2015))
#> [1] "2000-2005" "1970-2000" "2000-2005" "2005-2015"
```
