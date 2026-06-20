# Create New Period Labels

Create a new set of period labels.

## Usage

``` r
period_labels(
  breaks,
  label_one = c("lower", "upper"),
  label_multi = c("include", "exclude"),
  include_total = FALSE,
  include_na = FALSE
)

period_labels_one(
  lower_first,
  lower_last,
  label_one = c("lower", "upper"),
  label_multi = c("include", "exclude"),
  include_total = FALSE,
  include_na = FALSE
)

period_labels_five(
  lower_first,
  lower_last,
  label_one = c("lower", "upper"),
  label_multi = c("include", "exclude"),
  include_total = FALSE,
  include_na = FALSE
)

period_labels_ten(
  lower_first,
  lower_last,
  label_one = c("lower", "upper"),
  label_multi = c("include", "exclude"),
  include_total = FALSE,
  include_na = FALSE
)
```

## Arguments

- breaks:

  Boundaries between periods A numeric vector.

- label_one:

  Rule for one-year labels: `"lower"` or `"upper"`.

- label_multi:

  Rule for multi-year labels: `"include"` or `"exclude"`.

- include_total:

  Whether to include a `"Total"` category.

- include_na:

  Whether to include an `NA` category.

- lower_first:

  Lower limit of first period.

- lower_last:

  Lower limit of last period.

## Value

Character vector. Length depends on the function arguments.

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
  lower_last = 2010
)
#> [1] "2000-2005" "2005-2010" "2010-2015"

## single-year periods
period_labels_one(
  lower_first = 2000,
  lower_last = 2010
)
#>  [1] "2000" "2001" "2002" "2003" "2004" "2005" "2006" "2007" "2008" "2009"
#> [11] "2010"

## single-year periods, 'label_one' is "upper"
period_labels_one(
  lower_first = 2000,
  lower_last = 2010,
  label_one = "upper"
)
#>  [1] "2001" "2002" "2003" "2004" "2005" "2006" "2007" "2008" "2009" "2010"
#> [11] "2011"

## ten-year periods
period_labels_ten(
  lower_first = 2000,
  lower_last = 2010
)
#> [1] "2000-2010" "2010-2020"

## ten-year periods, 'label_multi' is "exclude",
period_labels_ten(
  lower_first = 2000,
  lower_last = 2010,
  label_multi = "exclude"
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
