# Set Open Cohort Level

Add an open cohort level, i.e. a cohort with no lower limit. Replace
existing cohorts where necessary.

## Usage

``` r
cohort_levels_set_open(
  labels,
  upper_open,
  interpret_single = c("lower", "upper"),
  interpret_multi = c("include", "exclude"),
  interpret_fail = c("error", "warn", "silent")
)
```

## Arguments

- labels:

  Vector of cohort labels.

- upper_open:

  Upper limit of open cohort.

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

- [`age_levels_set_open()`](https://bayesiandemography.github.io/agetime/reference/age_levels_set_open.md)
  Set open age group levels (right-open)

## Examples

``` r
labels <- c("2020-2024", "<2000", "2015")
cohort_levels_set_open(labels, upper_open = 2020)
#> [1] 2020-2024 <2020     <2020    
#> Levels: <2020 2020-2024
cohort_levels_set_open(labels, upper_open = 2005)
#> [1] 2020-2024 <2005     2015     
#> Levels: <2005 2015 2020-2024
cohort_levels_set_open(c("2000-2004", "2010-2014"), upper_open = 1990)
#> [1] 2000-2004 2010-2014
#> Levels: <1990 2000-2004 2010-2014
```
