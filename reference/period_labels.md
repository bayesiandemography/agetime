# Create a New Set of Period Labels

Create a New Set of Period Labels

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

  Whether labels for one-year periods are based on the lower or upper
  limit of the period. Default is `"lower"`.

- label_multi:

  Whether labels for multi-year periods include or exclude the final
  year of the period. Default is `"include"`.

- include_total:

  Whether to include a `"Total"` category.

- include_na:

  Whether to include an `NA` category.

- lower_first:

  The lower limit of the first period.

- lower_last:

  The lower limit of the last period.

## Value

A character vector

## Examples

``` r
## 5-year periods
period_labels_five(lower_first = 2000,
                   lower_last = 2010)
#> Error in loadNamespace(x): there is no package called ‘poputils’

## single-year periods
period_labels_one(lower_first = 2000,
                  lower_last = 2010)
#> Error in loadNamespace(x): there is no package called ‘poputils’

## single-year periods, 'label_one' is "upper"
period_labels_one(lower_first = 2000,
                  lower_last = 2010,
                  label_one = "upper")
#> Error in loadNamespace(x): there is no package called ‘poputils’

## ten-year periods
period_labels_ten(lower_first = 2000,
                  lower_last = 2010)
#> Error in loadNamespace(x): there is no package called ‘poputils’

## ten-year periods, 'label_multi' is "exclude",
period_labels_ten(lower_first = 2000,
                  lower_last = 2010,
                  label_multi = "exclude")
#> Error in loadNamespace(x): there is no package called ‘poputils’

## include total and NA
period_labels_ten(lower_first = 2000,
                  lower_last = 2010,
                  include_total = TRUE,
                  include_na = TRUE)
#> Error in loadNamespace(x): there is no package called ‘poputils’
```
