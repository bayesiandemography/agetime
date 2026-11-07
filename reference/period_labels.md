# Create New Period Labels

Create a new set of period labels.

## Usage

``` r
period_labels(
  breaks,
  open_left = FALSE,
  open_right = FALSE,
  format_single = c("lower", "upper"),
  format_multi = c("at_upper", "below_upper"),
  include_total = FALSE,
  include_missing = FALSE
)

period_labels_one(
  lower_first,
  lower_last,
  open_left = FALSE,
  open_right = FALSE,
  format_single = c("lower", "upper"),
  format_multi = c("at_upper", "below_upper"),
  include_total = FALSE,
  include_missing = FALSE
)

period_labels_five(
  lower_first,
  lower_last,
  open_left = FALSE,
  open_right = FALSE,
  format_single = c("lower", "upper"),
  format_multi = c("at_upper", "below_upper"),
  include_total = FALSE,
  include_missing = FALSE
)

period_labels_ten(
  lower_first,
  lower_last,
  open_left = FALSE,
  open_right = FALSE,
  format_single = c("lower", "upper"),
  format_multi = c("at_upper", "below_upper"),
  include_total = FALSE,
  include_missing = FALSE
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

  How to format the second number in a label for a multi-year period.
  With `"at_upper"` (the default), the second number is the upper limit
  of the period. With `"below_upper"`, the second number is one year
  below the upper limit. See below for details.

- include_total:

  Whether to include a `"Total"` category. Default is `FALSE`.

- include_missing:

  Whether to include a `"Missing"` category. Default is `FALSE`.

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

|                 |                      |                              |
|-----------------|----------------------|------------------------------|
| `format_multi`  | *Rule*               | *Example*                    |
| `"at_upper"`    | `[a,b) -> "a-b"`     | `[2020,2025) -> "2020-2025"` |
| `"below_upper"` | `[a,b) -> "a-<b-1>"` | `[2020,2025) -> "2020-2024"` |

**Open periods**

|                 |                    |                          |
|-----------------|--------------------|--------------------------|
| *Interval type* | *Rule*             | *Example*                |
| open on left    | `(-Inf,a) -> "<a"` | `(-Inf,2020) -> "<2020"` |
| open on right   | `[a,Inf) -> "a+"`  | `[2020,Inf) -> "2020+"`  |

## See also

- [`period_standard()`](https://bayesiandemography.github.io/agetime/reference/period_standard.md)
  Clean existing labels

- [`period_coarsen_to()`](https://bayesiandemography.github.io/agetime/reference/period_coarsen_to.md)
  Map labels onto an existing set of labels

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

## ten-year periods, 'format_multi' is "below_upper",
period_labels_ten(
  lower_first = 2000,
  lower_last = 2010,
  format_multi = "below_upper"
)
#> [1] "2000-2009" "2010-2019"

## include total and missing
period_labels_ten(
  lower_first = 2000,
  lower_last = 2010,
  include_total = TRUE,
  include_missing = TRUE
)
#> [1] "2000-2010" "2010-2020" "Missing"   "Total"    
```
