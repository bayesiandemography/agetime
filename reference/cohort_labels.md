# Create a New Set of Unique Cohort Labels

Create a New Set of Unique Cohort Labels

## Usage

``` r
cohort_labels(
  breaks,
  open = FALSE,
  x_one = c("lower", "upper"),
  x_multi = c("include", "exclude"),
  include_total = FALSE,
  include_na = FALSE
)

cohort_labels_one(
  lower_first,
  lower_last,
  open = FALSE,
  x_one = c("lower", "upper"),
  x_multi = c("include", "exclude"),
  include_total = FALSE,
  include_na = FALSE
)

cohort_labels_five(
  lower_first,
  lower_last,
  open = FALSE,
  x_one = c("lower", "upper"),
  x_multi = c("include", "exclude"),
  include_total = FALSE,
  include_na = FALSE
)

cohort_labels_ten(
  lower_first,
  lower_last,
  open = FALSE,
  x_one = c("lower", "upper"),
  x_multi = c("include", "exclude"),
  include_total = FALSE,
  include_na = FALSE
)
```

## Arguments

- breaks:

  Boundaries between cohorts A numeric vector.

- open:

  Whether the first cohort is "open", i.e. has no lower limit. Default
  is `FALSE`.

- x_one:

  Whether labels for one-year cohorts are based on the lower or upper
  limit of the period. Default is `"lower"`.

- x_multi:

  Whether labels for multi-year periods include or exclude the final
  year of the period. Default is `"include"`.

- include_total:

  Whether to include a `"Total"` category.

- include_na:

  Whether to include an `NA` category.

- lower_first:

  The lower limit of the first cohort.

- lower_last:

  The lower limit of the last cohort.

## Value

A character vector.

## Examples

``` r
## 5-year cohorts
cohort_labels_five(lower_first = 2000,
                   lower_last = 2010)
#> [1] "2000-2005" "2005-2010" "2010-2015"

## 5-year cohorts, first cohort is open
cohort_labels_five(lower_first = 1960,
                   lower_last = 2020,
                   open = TRUE)
#>  [1] "<1960"     "1960-1965" "1965-1970" "1970-1975" "1975-1980" "1980-1985"
#>  [7] "1985-1990" "1990-1995" "1995-2000" "2000-2005" "2005-2010" "2010-2015"
#> [13] "2015-2020" "2020-2025"

## single-year cohorts
cohort_labels_one(lower_first = 2000,
                  lower_last = 2010)
#>  [1] "2000" "2001" "2002" "2003" "2004" "2005" "2006" "2007" "2008" "2009"
#> [11] "2010"

## single-year cohorts, 'x_one' is "upper"
cohort_labels_one(lower_first = 2000,
                  lower_last = 2010,
                  x_one = "upper")
#>  [1] "2001" "2002" "2003" "2004" "2005" "2006" "2007" "2008" "2009" "2010"
#> [11] "2011"

## ten-year cohorts
cohort_labels_ten(lower_first = 2000,
                  lower_last = 2010)
#> [1] "2000-2010" "2010-2020"

## ten-year cohorts, 'x_multi' is "exclude",
cohort_labels_ten(lower_first = 2000,
                  lower_last = 2010,
                  x_multi = "exclude")
#> [1] "2000-2009" "2010-2019"

## include total and NA
cohort_labels_ten(lower_first = 2000,
                  lower_last = 2010,
                  include_total = TRUE,
                  include_na = TRUE)
#> [1] "2000-2010" "2010-2020" "Total"     NA         
```
