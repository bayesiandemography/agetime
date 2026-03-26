# Check or Make Assertions About Periods

Collect information on period labels (`period_check()`), or throw an
error if period labels do not conform to expectations (`period_assert`).

## Usage

``` r
period_check(
  x,
  no_overlap = NA,
  no_gap = NA,
  no_total = NA,
  no_na = NA,
  label_one = c("lower", "upper"),
  label_multi = c("include", "exclude"),
  unknown_label = c("error", "warn", "silent")
)

period_assert(
  x,
  no_overlap = NA,
  no_gap = NA,
  no_total = NA,
  no_na = NA,
  label_one = c("lower", "upper"),
  label_multi = c("include", "exclude"),
  unknown_label = c("error", "warn", "silent")
)
```

## Arguments

- x:

  A vector of period labels.

- no_overlap:

  No periods overlap

- no_gap:

  The periods span the entire range from the lower limit of the earliest
  period to the upper limit of the latest period

- no_total:

  No "Total" label

- no_na:

  No NA label

- label_one:

  Whether labels for one-year periods are based on the lower or upper
  limit of the period. Default is `"lower"`.

- label_multi:

  Whether labels for multi-year periods include or exclude the final
  year of the period. Default is `"include"`.

- unknown_label:

  Action if a label cannot be interpreted. Choices are `"error"` (the
  default), `"warn"`, and `"silent"`.

## Value

- `period_check()` returns a list with components `ok` (a logical flag)
  and `details` (a data frame).

- `period_assert()` returns `x` invisibly, or throws an error.

## Examples

``` r
lab <- period_labels_five(lower_first = 2020,
                          lower_last = 2030)
#> Error in loadNamespace(x): there is no package called ‘poputils’
lab
#> Error: object 'lab' not found

## get info on everything
period_check(x = lab,
             no_overlap = TRUE,
             no_gap = TRUE,
             no_total = TRUE,
             no_na = TRUE)
#> Error: object 'lab' not found

## throw error if gaps
period_assert(x = lab, no_gap = TRUE)
#> Error: object 'lab' not found

lab_gap <- lab[c(1, 3)]
#> Error: object 'lab' not found
## throw error if no gaps
period_assert(lab_gap, no_gap = FALSE)
#> Error: object 'lab_gap' not found
```
