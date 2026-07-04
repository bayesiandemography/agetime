# Create New Cohort Labels

Create a new set of cohort labels.

## Usage

``` r
cohort_labels(
  breaks,
  open = FALSE,
  format_single = c("lower", "upper"),
  format_multi = c("include", "exclude"),
  include_total = FALSE,
  include_na = FALSE
)

cohort_labels_one(
  lower_first,
  lower_last,
  open = FALSE,
  format_single = c("lower", "upper"),
  format_multi = c("include", "exclude"),
  include_total = FALSE,
  include_na = FALSE
)

cohort_labels_five(
  lower_first,
  lower_last,
  open = FALSE,
  format_single = c("lower", "upper"),
  format_multi = c("include", "exclude"),
  include_total = FALSE,
  include_na = FALSE
)

cohort_labels_ten(
  lower_first,
  lower_last,
  open = FALSE,
  format_single = c("lower", "upper"),
  format_multi = c("include", "exclude"),
  include_total = FALSE,
  include_na = FALSE
)
```

## Arguments

- breaks:

  Boundaries between cohorts A numeric vector.

- open:

  Whether first cohort is "open", i.e. has no lower limit. Default is
  `FALSE`.

- format_single:

  How to format label for single-year cohort. Choices are `"lower"` (the
  default) and `"upper"`. See below for details.

- format_multi:

  How to format label for multi-year cohort. Choices are `"include"`
  (the default) and `"exclude"`. See below for details.

- include_total:

  Whether to include a `"Total"` category. Default is `FALSE`.

- include_na:

  Whether to include an `NA` category. Default is `FALSE`.

- lower_first:

  Lower limit of first cohort. Non-negative number.

- lower_last:

  Lower limit of last cohort. Non-negative number.

## Value

Character vector.

## Controlling the formatting of cohort labels

`format_single` controls whether the label for a single-year cohorts is
based on the lower or upper limit. For instance, the cohort
`[2025,2026)` has label `"2025"` if `format_single` is `"lower"` and
`"2026"` if `format_single` is `"upper"`.

`format_multi` controls whether the label for a multi-year cohort
includes the upper limit. For instance, the cohort `[2025,2030)` has
label `"2025-2035"` if `format_multi` is `"include"` and `"2025-2029"`
if `format_multi` is `"exclude"`.

## See also

- [`age_labels()`](https://bayesiandemography.github.io/agetime/reference/age_labels.md)
  Age equivalent of `cohort_labels()`

- [`period_labels()`](https://bayesiandemography.github.io/agetime/reference/period_labels.md)
  Period equivalent of `cohort_labels()`

## Examples

``` r
## 5-year cohorts
cohort_labels_five(
  lower_first = 2000,
  lower_last = 2010
)
#> [1] "2000-2005" "2005-2010" "2010-2015"

## 5-year cohorts, first cohort is open
cohort_labels_five(
  lower_first = 1960,
  lower_last = 2020,
  open = TRUE
)
#>  [1] "<1960"     "1960-1965" "1965-1970" "1970-1975" "1975-1980" "1980-1985"
#>  [7] "1985-1990" "1990-1995" "1995-2000" "2000-2005" "2005-2010" "2010-2015"
#> [13] "2015-2020" "2020-2025"

## single-year cohorts
cohort_labels_one(
  lower_first = 2000,
  lower_last = 2010
)
#>  [1] "2000" "2001" "2002" "2003" "2004" "2005" "2006" "2007" "2008" "2009"
#> [11] "2010"

## single-year cohorts, 'format_single' is "upper"
cohort_labels_one(
  lower_first = 2000,
  lower_last = 2010,
  format_single = "upper"
)
#>  [1] "2001" "2002" "2003" "2004" "2005" "2006" "2007" "2008" "2009" "2010"
#> [11] "2011"

## ten-year cohorts
cohort_labels_ten(
  lower_first = 2000,
  lower_last = 2010
)
#> [1] "2000-2010" "2010-2020"

## ten-year cohorts, 'format_multi' is "exclude",
cohort_labels_ten(
  lower_first = 2000,
  lower_last = 2010,
  format_multi = "exclude"
)
#> [1] "2000-2009" "2010-2019"

## include total and NA
cohort_labels_ten(
  lower_first = 2000,
  lower_last = 2010,
  include_total = TRUE,
  include_na = TRUE
)
#> [1] "2000-2010" "2010-2020" "Total"     NA         
```
