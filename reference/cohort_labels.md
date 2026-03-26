# Create a New Set of Cohort Labels

Create a New Set of Cohort Labels

## Usage

``` r
cohort_labels(
  breaks,
  open = FALSE,
  label_one = c("lower", "upper"),
  label_multi = c("include", "exclude"),
  include_total = FALSE,
  include_na = FALSE
)

cohort_labels_one(
  lower_first,
  lower_last,
  open = FALSE,
  label_one = c("lower", "upper"),
  label_multi = c("include", "exclude"),
  include_total = FALSE,
  include_na = FALSE
)

cohort_labels_five(
  lower_first,
  lower_last,
  open = FALSE,
  label_one = c("lower", "upper"),
  label_multi = c("include", "exclude"),
  include_total = FALSE,
  include_na = FALSE
)

cohort_labels_ten(
  lower_first,
  lower_last,
  open = FALSE,
  label_one = c("lower", "upper"),
  label_multi = c("include", "exclude"),
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

- label_one:

  Whether labels for one-year cohorts are based on the lower or upper
  limit of the period. Default is `"lower"`.

- label_multi:

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

A character vector

## Examples

``` r
## 5-year cohorts
cohort_labels_five(lower_first = 2000,
                   lower_last = 2010)
#> Error in loadNamespace(x): there is no package called ‘poputils’

## 5-year cohorts, first cohort is open
cohort_labels_five(lower_first = 1960,
                   lower_last = 2020,
                   open = TRUE)
#> Error in loadNamespace(x): there is no package called ‘poputils’

## single-year cohorts
cohort_labels_one(lower_first = 2000,
                  lower_last = 2010)
#> Error in loadNamespace(x): there is no package called ‘poputils’

## single-year cohorts, 'label_one' is "upper"
cohort_labels_one(lower_first = 2000,
                  lower_last = 2010,
                  label_one = "upper")
#> Error in loadNamespace(x): there is no package called ‘poputils’

## ten-year cohorts
cohort_labels_ten(lower_first = 2000,
                  lower_last = 2010)
#> Error in loadNamespace(x): there is no package called ‘poputils’

## ten-year cohorts, 'label_multi' is "exclude",
cohort_labels_ten(lower_first = 2000,
                  lower_last = 2010,
                  label_multi = "exclude")
#> Error in loadNamespace(x): there is no package called ‘poputils’

## include total and NA
cohort_labels_ten(lower_first = 2000,
                  lower_last = 2010,
                  include_total = TRUE,
                  include_na = TRUE)
#> Error in loadNamespace(x): there is no package called ‘poputils’
```
