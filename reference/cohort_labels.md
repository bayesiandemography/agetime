# Create New Cohort Labels

Create a new set of cohort labels.

## Usage

``` r
cohort_labels(
  breaks,
  open_left = FALSE,
  open_right = FALSE,
  format_single = c("lower", "upper"),
  format_multi = c("at_upper", "below_upper"),
  include_total = FALSE,
  include_missing = FALSE
)

cohort_labels_one(
  lower_first,
  lower_last,
  open_left = FALSE,
  open_right = FALSE,
  format_single = c("lower", "upper"),
  format_multi = c("at_upper", "below_upper"),
  include_total = FALSE,
  include_missing = FALSE
)

cohort_labels_five(
  lower_first,
  lower_last,
  open_left = FALSE,
  open_right = FALSE,
  format_single = c("lower", "upper"),
  format_multi = c("at_upper", "below_upper"),
  include_total = FALSE,
  include_missing = FALSE
)

cohort_labels_ten(
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

  Boundaries between cohorts. A numeric vector.

- open_left:

  Whether first cohort is open on the left, i.e. has no lower limit.
  Default is `FALSE`.

- open_right:

  Whether last cohort is open on the right, i.e. has no upper limit.
  Default is `FALSE`.

- format_single:

  How to format label for single-year cohort. Choices are `"lower"` (the
  default) and `"upper"`. See below for details.

- format_multi:

  How to format the second number in a label for a multi-year cohort.
  With `"at_upper"` (the default), the second number is the upper limit
  of the cohort. With `"below_upper"`, the second number is one year
  below the upper limit. See below for details.

- include_total:

  Whether to include a `"Total"` category. Default is `FALSE`.

- include_missing:

  Whether to include a `"Missing"` category. Default is `FALSE`.

- lower_first:

  Lower limit of first cohort. Non-negative number.

- lower_last:

  Lower limit of last cohort. Non-negative number.

## Value

Character vector.

## Rules for formatting output

**Single-year cohorts**

|                 |                      |                         |
|-----------------|----------------------|-------------------------|
| `format_single` | *Rule*               | *Example*               |
| `"lower"`       | `[a,a+1) -> "a"`     | `[2020,2021) -> "2020"` |
| `"upper"`       | `[a,a+1) -> "<a+1>"` | `[2020,2021) -> "2021"` |

**Multi-year cohorts**

|                 |                      |                              |
|-----------------|----------------------|------------------------------|
| `format_multi`  | *Rule*               | *Example*                    |
| `"at_upper"`    | `[a,b) -> "a-b"`     | `[2020,2025) -> "2020-2025"` |
| `"below_upper"` | `[a,b) -> "a-<b-1>"` | `[2020,2025) -> "2020-2024"` |

**Open cohorts**

|                 |                    |                          |
|-----------------|--------------------|--------------------------|
| *Interval type* | *Rule*             | *Example*                |
| open on left    | `(-Inf,a) -> "<a"` | `(-Inf,2020) -> "<2020"` |
| open on right   | `[a,Inf) -> "a+"`  | `[2020,Inf) -> "2020+"`  |

## See also

- [`cohort_standard()`](https://bayesiandemography.github.io/agetime/reference/cohort_standard.md)
  Clean existing labels

- [`cohort_coarsen_to()`](https://bayesiandemography.github.io/agetime/reference/cohort_coarsen_to.md)
  Map labels onto an existing set of labels

- [`age_labels()`](https://bayesiandemography.github.io/agetime/reference/age_labels.md)
  Age equivalent of `cohort_labels()`

- [`period_labels()`](https://bayesiandemography.github.io/agetime/reference/period_labels.md)
  Period equivalent of `cohort_labels()`

## Examples

``` r
## 5-year cohorts
cohort_labels_five(
  lower_first = 2000,
  lower_last = 2010
)
#> [1] "2000-2005" "2005-2010" "2010-2015"

## 5-year cohorts, first cohort is open
cohort_labels_five(
  lower_first = 1960,
  lower_last = 2020,
  open_left = TRUE
)
#>  [1] "<1960"     "1960-1965" "1965-1970" "1970-1975" "1975-1980" "1980-1985"
#>  [7] "1985-1990" "1990-1995" "1995-2000" "2000-2005" "2005-2010" "2010-2015"
#> [13] "2015-2020" "2020-2025"

## single-year cohorts
cohort_labels_one(
  lower_first = 2000,
  lower_last = 2010
)
#>  [1] "2000" "2001" "2002" "2003" "2004" "2005" "2006" "2007" "2008" "2009"
#> [11] "2010"

## single-year cohorts, 'format_single' is "upper"
cohort_labels_one(
  lower_first = 2000,
  lower_last = 2010,
  format_single = "upper"
)
#>  [1] "2001" "2002" "2003" "2004" "2005" "2006" "2007" "2008" "2009" "2010"
#> [11] "2011"

## ten-year cohorts
cohort_labels_ten(
  lower_first = 2000,
  lower_last = 2010
)
#> [1] "2000-2010" "2010-2020"

## ten-year cohorts, 'format_multi' is "below_upper",
cohort_labels_ten(
  lower_first = 2000,
  lower_last = 2010,
  format_multi = "below_upper"
)
#> [1] "2000-2009" "2010-2019"

## include total and missing
cohort_labels_ten(
  lower_first = 2000,
  lower_last = 2010,
  include_total = TRUE,
  include_missing = TRUE
)
#> [1] "2000-2010" "2010-2020" "Missing"   "Total"    
```
