# Create New Period Labels

Create a new set of period labels.

## Usage

``` r
period_labels(
  breaks,
  open_left = FALSE,
  open_right = FALSE,
  format_single = c("lower", "upper"),
  format_multi = c("include", "exclude"),
  include_total = FALSE,
  include_na = FALSE
)

period_labels_one(
  lower_first,
  lower_last,
  open_left = FALSE,
  open_right = FALSE,
  format_single = c("lower", "upper"),
  format_multi = c("include", "exclude"),
  include_total = FALSE,
  include_na = FALSE
)

period_labels_five(
  lower_first,
  lower_last,
  open_left = FALSE,
  open_right = FALSE,
  format_single = c("lower", "upper"),
  format_multi = c("include", "exclude"),
  include_total = FALSE,
  include_na = FALSE
)

period_labels_ten(
  lower_first,
  lower_last,
  open_left = FALSE,
  open_right = FALSE,
  format_single = c("lower", "upper"),
  format_multi = c("include", "exclude"),
  include_total = FALSE,
  include_na = FALSE
)
```

## Arguments

- breaks:

  Boundaries between periods. A numeric vector.

- open_left:

  Whether first period is open on the left, i.e. has no lower limit.
  Default is `FALSE`.

- open_right:

  Whether last period is open on the right, i.e. has no upper limit.
  Default is `FALSE`.

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

## Rules for formatting output

**Single-year periods**

|                 |                      |                         |
|-----------------|----------------------|-------------------------|
| `format_single` | *Rule*               | *Example*               |
| `"lower"`       | `[a,a+1) -> "a"`     | `[2020,2021) -> "2020"` |
| `"upper"`       | `[a,a+1) -> "<a+1>"` | `[2020,2021) -> "2021"` |

**Multi-year periods**

|                |                          |                              |
|----------------|--------------------------|------------------------------|
| `format_multi` | *Rule*                   | *Example*                    |
| `"include"`    | `[a,a+n) -> "a-<a+n>"`   | `[2020,2025) -> "2020-2025"` |
| `"exclude"`    | `[a,a+n) -> "a-<a+n-1>"` | `[2020,2025) -> "2020-2024"` |

**Open periods**

|                 |                    |                          |
|-----------------|--------------------|--------------------------|
| *Interval type* | *Rule*             | *Example*                |
| open on left    | `(-Inf,a) -> "<a"` | `(-Inf,2020) -> "<2020"` |
| open on right   | `[a,Inf) -> "a+"`  | `[2020,Inf) -> "2020+"`  |

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
