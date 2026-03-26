# Check or Make Assertions About Age Groups

Collect information on age group labels (`age_check()`), or throw an
error if age group labels do not conform to expectations (`age_assert`).

## Usage

``` r
age_check(
  x,
  no_overlap = NA,
  no_gap = NA,
  no_total = NA,
  no_na = NA,
  include_zero = NA,
  include_open = NA,
  unknown_label = c("error", "warn", "silent")
)

age_assert(
  x,
  no_overlap = NA,
  no_gap = NA,
  no_total = NA,
  no_na = NA,
  include_zero = NA,
  include_open = NA,
  unknown_label = c("error", "warn", "silent")
)
```

## Arguments

- x:

  Vector of age group labels.

- no_overlap:

  No age groups overlap

- no_gap:

  The age groups span the entire range from the lower limit of the
  youngest age group to the upper limit of the oldest age group

- no_total:

  No "Total" age group

- no_na:

  No NA age group

- include_zero:

  One or more age groups have a lower limit of zero.

- include_open:

  One or more age groups has no upper limit.

- unknown_label:

  Action if meaning of label unclear. Choices are `"error"` (the
  default), `"warn"`, and `"silent"`.

## Value

- `age_check()` returns a list with components `ok` (a logical flag) and
  `details` (a data frame).

- `age_assert()` returns `x` invisibly, or throws an error.

## Examples

``` r
lab <- age_labels_labor()
#> Error in loadNamespace(x): there is no package called ‘poputils’
lab
#> Error: object 'lab' not found

## get info on everything
age_check(x = lab,
          no_overlap = TRUE,
          no_gap = TRUE,
          no_total = TRUE,
          no_na = TRUE,
          include_zero = TRUE,
          include_open = TRUE)
#> Error: object 'lab' not found

## throw error if gaps
age_assert(x = lab, no_gap = TRUE)
#> Error: object 'lab' not found

lab_gap <- lab[c(1, 3)]
#> Error: object 'lab' not found
## throw error if no gaps
age_assert(x = lab_gap, no_gap = FALSE)
#> Error: object 'lab_gap' not found
```
