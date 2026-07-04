# Create New Period Labels

Create a new set of period labels.

## Usage

``` r
period_labels(
  breaks,
  format_single = c("lower", "upper"),
  format_multi = c("include", "exclude"),
  include_total = FALSE,
  include_na = FALSE
)

period_labels_one(
  lower_first,
  lower_last,
  format_single = c("lower", "upper"),
  format_multi = c("include", "exclude"),
  include_total = FALSE,
  include_na = FALSE
)

period_labels_five(
  lower_first,
  lower_last,
  format_single = c("lower", "upper"),
  format_multi = c("include", "exclude"),
  include_total = FALSE,
  include_na = FALSE
)

period_labels_ten(
  lower_first,
  lower_last,
  format_single = c("lower", "upper"),
  format_multi = c("include", "exclude"),
  include_total = FALSE,
  include_na = FALSE
)
```

## Arguments

- breaks:

  Boundaries between periods. A numeric vector.

- format_single:

  How to format label for single-year period. Choices are `"lower"` (the
  default) and `"upper"`. See below for details.

- format_multi:

  How to format label for multi-year period. Choices are `"include"`
  (the default) and `"exclude"`. See below for details.

- include_total:

  Whether to include a `"Total"` category. Default is `FALSE`.

- include_na:

  Whether to include an `NA` category. Default is `FALSE`.

- lower_first:

  Lower limit of first period. Non-negative number.

- lower_last:

  Lower limit of last period. Non-negative number.

## Value

Character vector.

## Controlling the formatting of period labels

`format_single` controls whether the label for a single-year periods is
based on the lower or upper limit. For instance, the period
`[2025,2026)` has label `"2025"` if `format_single` is `"lower"` and
`"2026"` if `format_single` is `"upper"`.

`format_multi` controls whether the label for a multi-year period
includes the upper limit. For instance, the period `[2025,2030)` has
label `"2025-2035"` if `format_multi` is `"include"` and `"2025-2029"`
if `format_multi` is `"exclude"`.

## See also

- [`age_labels()`](https://bayesiandemography.github.io/agetime/reference/age_labels.md)
  Age equivalent of `period_labels()`

- [`cohort_labels()`](https://bayesiandemography.github.io/agetime/reference/cohort_labels.md)
  Cohort equivalent of `period_labels()`

## Examples

``` r
## 5-year periods
period_labels_five(
  lower_first = 2000,
  lower_last = 2015
)
#> [1] "2000-2005" "2005-2010" "2010-2015" "2015-2020"

## single-year periods
period_labels_one(
  lower_first = 2000,
  lower_last = 2004
)
#> [1] "2000" "2001" "2002" "2003" "2004"

## single-year periods, 'format_single' is "upper"
period_labels_one(
  lower_first = 2000,
  lower_last = 2004,
  format_single = "upper"
)
#> [1] "2001" "2002" "2003" "2004" "2005"

## ten-year periods
period_labels_ten(
  lower_first = 2001,
  lower_last = 2021
)
#> [1] "2001-2011" "2011-2021" "2021-2031"

## ten-year periods, 'format_multi' is "exclude",
period_labels_ten(
  lower_first = 2000,
  lower_last = 2010,
  format_multi = "exclude"
)
#> [1] "2000-2009" "2010-2019"

## include total and NA
period_labels_ten(
  lower_first = 2000,
  lower_last = 2010,
  include_total = TRUE,
  include_na = TRUE
)
#> [1] "2000-2010" "2010-2020" "Total"     NA         
```
