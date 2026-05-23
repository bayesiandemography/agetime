# Create a New Set of Unique Period Labels

Create a New Set of Unique Period Labels

## Usage

``` r
period_labels(
  breaks,
  x_one = c("lower", "upper"),
  x_multi = c("include", "exclude"),
  include_total = FALSE,
  include_na = FALSE
)

period_labels_one(
  lower_first,
  lower_last,
  x_one = c("lower", "upper"),
  x_multi = c("include", "exclude"),
  include_total = FALSE,
  include_na = FALSE
)

period_labels_five(
  lower_first,
  lower_last,
  x_one = c("lower", "upper"),
  x_multi = c("include", "exclude"),
  include_total = FALSE,
  include_na = FALSE
)

period_labels_ten(
  lower_first,
  lower_last,
  x_one = c("lower", "upper"),
  x_multi = c("include", "exclude"),
  include_total = FALSE,
  include_na = FALSE
)
```

## Arguments

- breaks:

  Boundaries between periods A numeric vector.

- x_one:

  How to interpret labels in `x` that describe one-year periods. Choices
  are `"lower"` (the default) and `"upper"`.

- x_multi:

  How to interpret labels in `x` that describe multi-year periods.
  Choices are `"include"` (the default) and `"exclude"`.

- include_total:

  Whether to include a `"Total"` category.

- include_na:

  Whether to include an `NA` category.

- lower_first:

  The lower limit of the first period.

- lower_last:

  The lower limit of the last period.

## Value

A character vector.

## Examples

``` r
## 5-year periods
period_labels_five(lower_first = 2000,
                   lower_last = 2010)
#> [1] "2000-2005" "2005-2010" "2010-2015"

## single-year periods
period_labels_one(lower_first = 2000,
                  lower_last = 2010)
#>  [1] "2000" "2001" "2002" "2003" "2004" "2005" "2006" "2007" "2008" "2009"
#> [11] "2010"

## single-year periods, 'x_one' is "upper"
period_labels_one(lower_first = 2000,
                  lower_last = 2010,
                  x_one = "upper")
#>  [1] "2001" "2002" "2003" "2004" "2005" "2006" "2007" "2008" "2009" "2010"
#> [11] "2011"

## ten-year periods
period_labels_ten(lower_first = 2000,
                  lower_last = 2010)
#> [1] "2000-2010" "2010-2020"

## ten-year periods, 'x_multi' is "exclude",
period_labels_ten(lower_first = 2000,
                  lower_last = 2010,
                  x_multi = "exclude")
#> [1] "2000-2009" "2010-2019"

## include total and NA
period_labels_ten(lower_first = 2000,
                  lower_last = 2010,
                  include_total = TRUE,
                  include_na = TRUE)
#> [1] "2000-2010" "2010-2020" "Total"     NA         
```
