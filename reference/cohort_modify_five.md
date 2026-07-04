# Convert to Equal-Length Cohorts

Modify the cohorts used by `labels`. The new cohorts must contain the
old cohorts, and follow a regular pattern:

- `cohort_modify_five` Five-year cohorts

- `cohort_modify_ten` Ten-year cohorts

## Usage

``` r
cohort_modify_five(
  labels,
  offset = 0,
  interpret_single = c("lower", "upper"),
  interpret_multi = c("include", "exclude"),
  interpret_fail = c("error", "warn", "silent")
)

cohort_modify_ten(
  labels,
  offset = 0,
  interpret_single = c("lower", "upper"),
  interpret_multi = c("include", "exclude"),
  interpret_fail = c("error", "warn", "silent")
)
```

## Arguments

- labels:

  Vector of cohort labels.

- offset:

  Parameter controlling alignment of cohorts. Default is `0`.

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

Character vector or factor with the same length as `labels`.

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

- [`cohort_modify()`](https://bayesiandemography.github.io/agetime/reference/cohort_modify.md)
  Convert to general cohorts

- [`age_modify_five()`](https://bayesiandemography.github.io/agetime/reference/age_modify_five.md)
  Age equivalent of `cohort_modify_five()`

- [`age_modify_ten()`](https://bayesiandemography.github.io/agetime/reference/age_modify_five.md)
  Age equivalent of `cohort_modify_ten()`

- [`period_modify_five()`](https://bayesiandemography.github.io/agetime/reference/period_modify_five.md)
  Period equivalent of `cohort_modify_five()`

- [`period_modify_ten()`](https://bayesiandemography.github.io/agetime/reference/period_modify_five.md)
  Period equivalent of `cohort_modify_ten()`

- [`cohort_levels_fill()`](https://bayesiandemography.github.io/agetime/reference/cohort_levels_fill.md)
  Add levels for intermediate cohorts

## Examples

``` r
labels <- c("2002-2004", "1987-1989", "2000", "Total")
cohort_modify_five(labels)
#> [1] "2000-2005" "1985-1990" "2000-2005" "Total"    
cohort_modify_five(labels, offset = 1)
#> [1] "2001-2006" "1986-1991" "1996-2001" "Total"    
cohort_modify_five(labels, offset = 2)
#> [1] "2002-2007" "1987-1992" "1997-2002" "Total"    
cohort_modify_ten(labels)
#> [1] "2000-2010" "1980-1990" "2000-2010" "Total"    
cohort_modify_ten(labels, offset = 1)
#> [1] "2001-2011" "1981-1991" "1991-2001" "Total"    
cohort_modify_ten(labels, offset = 2)
#> [1] "2002-2012" "1982-1992" "1992-2002" "Total"    
```
