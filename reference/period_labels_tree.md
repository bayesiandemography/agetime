# Create Period Labels for a Reporting Tree

Create labels for a reporting tree, in which records are tabulated at
different levels of detail: detailed periods, broader periods, and,
optionally, period not stated.

## Usage

``` r
period_labels_tree(
  breaks,
  nodes = NULL,
  open_left = FALSE,
  open_right = FALSE,
  format_single = c("lower", "upper"),
  format_multi = c("at_upper", "below_upper"),
  include_missing = TRUE
)
```

## Arguments

- breaks:

  Boundaries between periods. A numeric vector.

- nodes:

  Labels for broad periods. A character vector, or `NULL` (the default),
  in which case there are no broad periods.

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

- include_missing:

  Whether to include a `"Missing"` category, representing period not
  stated. Default is `TRUE`.

## Value

Character vector.

## Details

The most detailed periods (the leaves of the tree) are created from
`breaks`, `open_left`, and `open_right`, exactly as by
[`period_labels()`](https://bayesiandemography.github.io/agetime/reference/period_labels.md).
Broader periods are supplied through `nodes`, as ordinary period labels.
Broader periods can be given in any order, and can nest to any depth.
Leaves do not need to be the same distance from the root.

Labels in `nodes` are interpreted using the same rules as are used to
format the leaves, as set by `format_single` and `format_multi`. With
the default `format_multi = "at_upper"`, for instance, `"2000-2010"`
means the period from the start of 2000 to the start of 2010. Labels in
`nodes` are then converted into the same format as the leaves.

Each broad period must start and end at values in `breaks` (or be open,
if `open_left` or `open_right` is `TRUE`), so that it is a union of
detailed periods. It must contain at least two detailed periods, but not
all of them, and broad periods must nest: any two either do not overlap,
or one contains the other.

The root of the tree, representing records with no information on
period, is labelled `"Missing"`. Unlike
[`period_labels()`](https://bayesiandemography.github.io/agetime/reference/period_labels.md),
`period_labels_tree()` includes `"Missing"` by default, since most
reporting trees in practice have a category for period not stated.

Labels are returned in the same order as
[`period_set_order_tree()`](https://bayesiandemography.github.io/agetime/reference/period_set_order_tree.md):
detailed periods, then broad periods (each after the periods inside it),
then `"Missing"`.

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

- [`period_labels()`](https://bayesiandemography.github.io/agetime/reference/period_labels.md)
  Create labels without broad periods

- [`period_set_order_tree()`](https://bayesiandemography.github.io/agetime/reference/period_set_order_tree.md)
  Order existing labels as a tree

- [`period_diagnose_values()`](https://bayesiandemography.github.io/agetime/reference/period_diagnose_levels.md)
  Check labels, including with `valid_tree = TRUE`

- [`age_labels_tree()`](https://bayesiandemography.github.io/agetime/reference/age_labels_tree.md)
  Age equivalent of `period_labels_tree()`

- [`cohort_labels_tree()`](https://bayesiandemography.github.io/agetime/reference/cohort_labels_tree.md)
  Cohort equivalent of `period_labels_tree()`

## Examples

``` r
## year of arrival: 5-year periods, a broad group
## for arrivals before 2010, and not stated
period_labels_tree(
  breaks = seq(2000, 2020, 5),
  nodes = "<2010",
  open_left = TRUE
)
#> [1] "<2000"     "2000-2005" "2005-2010" "2010-2015" "2015-2020" "<2010"    
#> [7] "Missing"  

## labels in "below_upper" format
period_labels_tree(
  breaks = seq(2000, 2020, 5),
  nodes = c("2000-2009", "2010-2019"),
  format_multi = "below_upper"
)
#> [1] "2000-2004" "2005-2009" "2010-2014" "2015-2019" "2000-2009" "2010-2019"
#> [7] "Missing"  
```
