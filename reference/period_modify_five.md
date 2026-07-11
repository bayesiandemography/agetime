# Convert to Equal-Length Periods

Modify the periods used by `labels`. The new periods must contain the
old periods, and follow a regular pattern:

- `period_modify_five` Five-year periods

- `period_modify_ten` Ten-year periods

## Usage

``` r
period_modify_five(
  labels,
  offset = 0,
  open_left = NULL,
  open_right = NULL,
  interpret_single = c("lower", "upper"),
  interpret_multi = c("include", "exclude"),
  interpret_fail = c("error", "warn", "silent")
)

period_modify_ten(
  labels,
  offset = 0,
  open_left = NULL,
  open_right = NULL,
  interpret_single = c("lower", "upper"),
  interpret_multi = c("include", "exclude"),
  interpret_fail = c("error", "warn", "silent")
)
```

## Arguments

- labels:

  Vector of period labels.

- offset:

  Parameter controlling alignment of periods. Default is `0`.

- open_left:

  Whether the first period is open on the left, i.e. has no lower limit.
  Default is `NULL`, which infers from `labels`: `TRUE` when any label
  is open on the left, otherwise `FALSE`. Use `TRUE` or `FALSE` to add
  or suppress an open left level regardless of `labels`.

- open_right:

  Whether the last period is open on the right, i.e. has no upper limit.
  Default is `NULL`, which infers from `labels`: `TRUE` when any label
  is open on the right, otherwise `FALSE`. Use `TRUE` or `FALSE` to add
  or suppress an open right level regardless of `labels`.

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

- [`period_modify()`](https://bayesiandemography.github.io/agetime/reference/period_modify.md)
  Convert to general periods

- [`age_modify_five()`](https://bayesiandemography.github.io/agetime/reference/age_modify_five.md)
  Age equivalent of `period_modify_five()`

- [`age_modify_ten()`](https://bayesiandemography.github.io/agetime/reference/age_modify_five.md)
  Age equivalent of `period_modify_ten()`

- [`cohort_modify_five()`](https://bayesiandemography.github.io/agetime/reference/cohort_modify_five.md)
  Cohort equivalent of `period_modify_five()`

- [`cohort_modify_ten()`](https://bayesiandemography.github.io/agetime/reference/cohort_modify_five.md)
  Cohort equivalent of `period_modify_ten()`

- [`period_fill()`](https://bayesiandemography.github.io/agetime/reference/period_fill.md)
  Add levels for intermediate periods

## Examples

``` r
labels <- c("2002-2004", "1987-1989", "2000", "Total")
period_modify_five(labels)
#> [1] 2000-2005 1985-1990 2000-2005 Total    
#> Levels: 1985-1990 1990-1995 1995-2000 2000-2005 Total
period_modify_five(labels, offset = 1)
#> [1] 2001-2006 1986-1991 1996-2001 Total    
#> Levels: 1986-1991 1991-1996 1996-2001 2001-2006 Total
period_modify_five(labels, offset = 2)
#> [1] 2002-2007 1987-1992 1997-2002 Total    
#> Levels: 1987-1992 1992-1997 1997-2002 2002-2007 Total
period_modify_ten(labels)
#> [1] 2000-2010 1980-1990 2000-2010 Total    
#> Levels: 1980-1990 1990-2000 2000-2010 Total
period_modify_ten(labels, offset = 1)
#> [1] 2001-2011 1981-1991 1991-2001 Total    
#> Levels: 1981-1991 1991-2001 2001-2011 Total
period_modify_ten(labels, offset = 2)
#> [1] 2002-2012 1982-1992 1992-2002 Total    
#> Levels: 1982-1992 1992-2002 2002-2012 Total
```
