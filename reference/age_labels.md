# Create a New Set of Age Labels

Create a New Set of Age Labels

## Usage

``` r
age_labels(breaks, open = TRUE, include_total = FALSE, include_na = FALSE)

age_labels_one(
  lower_first = 0,
  lower_last = 100,
  open = TRUE,
  include_total = FALSE,
  include_na = FALSE
)

age_labels_five(
  lower_first = 0,
  lower_last = 100,
  open = TRUE,
  include_total = FALSE,
  include_na = FALSE
)

age_labels_ten(
  lower_first = 0,
  lower_last = 100,
  open = TRUE,
  include_total = FALSE,
  include_na = FALSE
)

age_labels_life(lower_last = 100, include_total = FALSE, include_na = FALSE)

age_labels_labor(
  age_work = 20,
  age_retire = 65,
  include_total = FALSE,
  include_na = FALSE
)
```

## Arguments

- breaks:

  Boundaries between age groups. A numeric vector.

- open:

  Whether the oldest age group is "open", i.e. has no upper limit.
  Default is `TRUE`.

- include_total:

  Whether to include a `"Total"` category.

- include_na:

  Whether to include an `NA` category.

- lower_first:

  The lower limit of the youngest age group.

- lower_last:

  The lower limit of the last age group.

## Value

A character vector

## Examples

``` r
## default 5-year age groups
age_labels_five()
#> Error in loadNamespace(x): there is no package called ‘poputils’

## open age group is 80+
age_labels_five(lower_last = 80)
#> Error in loadNamespace(x): there is no package called ‘poputils’

## reproductive ages: 5-year
age_labels_five(lower_first = 15,
                lower_last = 45,
                open = FALSE)
#> Error in loadNamespace(x): there is no package called ‘poputils’

## reproductive ages: 1-year
age_labels_one(lower_first = 15,
               lower_last = 49,
               open = FALSE)
#> Error in loadNamespace(x): there is no package called ‘poputils’

## include total and NA
age_labels_five(lower_last = 20,
                include_total = TRUE,
                include_na = TRUE)
#> Error in loadNamespace(x): there is no package called ‘poputils’

## arbitrary age groups
age_labels(breaks = c(0, 5, 10, 14, 18),
           open = FALSE)
#> [1] "0-4"   "5-9"   "10-13" "14-17"

## life table age groups with
## open age group of 75+
age_labels_life(lower_last = 75)
#> Error in loadNamespace(x): there is no package called ‘poputils’

## labor force age groups
age_labels_labor()
#> Error in loadNamespace(x): there is no package called ‘poputils’
age_labels_labor(age_retire = 67)
#> Error in loadNamespace(x): there is no package called ‘poputils’
```
