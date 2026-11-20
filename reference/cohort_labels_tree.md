# Create Cohort Labels for a Reporting Tree

Create labels for a reporting tree, in which records are tabulated at
different levels of detail: detailed cohorts, broader cohorts, and,
optionally, cohort not stated.

## Usage

``` r
cohort_labels_tree(
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

  Boundaries between cohorts. A numeric vector.

- nodes:

  Labels for broad cohorts. A character vector, or `NULL` (the default),
  in which case there are no broad cohorts.

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

- include_missing:

  Whether to include a `"Missing"` category, representing cohort not
  stated. Default is `TRUE`.

## Value

Character vector.

## Details

The most detailed cohorts (the leaves of the tree) are created from
`breaks`, `open_left`, and `open_right`, exactly as by
[`cohort_labels()`](https://bayesiandemography.github.io/agetime/reference/cohort_labels.md).
Broader cohorts are supplied through `nodes`, as ordinary cohort labels.
Broader cohorts can be given in any order, and can nest to any depth.
Leaves do not need to be the same distance from the root.

Labels in `nodes` are interpreted using the same rules as are used to
format the leaves, as set by `format_single` and `format_multi`. With
the default `format_multi = "at_upper"`, for instance, `"2000-2010"`
means the cohort from the start of 2000 to the start of 2010. Labels in
`nodes` are then converted into the same format as the leaves.

Each broad cohort must start and end at values in `breaks` (or be open,
if `open_left` or `open_right` is `TRUE`), so that it is a union of
detailed cohorts. It must contain at least two detailed cohorts, but not
all of them, and broad cohorts must nest: any two either do not overlap,
or one contains the other.

The root of the tree, representing records with no information on
cohort, is labelled `"Missing"`. Unlike
[`cohort_labels()`](https://bayesiandemography.github.io/agetime/reference/cohort_labels.md),
`cohort_labels_tree()` includes `"Missing"` by default, since most
reporting trees in practice have a category for cohort not stated.

Labels are returned in the same order as
[`cohort_set_order_tree()`](https://bayesiandemography.github.io/agetime/reference/cohort_set_order_tree.md):
detailed cohorts, then broad cohorts (each after the cohorts inside it),
then `"Missing"`.

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

- [`cohort_labels()`](https://bayesiandemography.github.io/agetime/reference/cohort_labels.md)
  Create labels without broad cohorts

- [`cohort_set_order_tree()`](https://bayesiandemography.github.io/agetime/reference/cohort_set_order_tree.md)
  Order existing labels as a tree

- [`cohort_diagnose_values()`](https://bayesiandemography.github.io/agetime/reference/cohort_diagnose_levels.md)
  Check labels, including with `valid_tree = TRUE`

- [`age_labels_tree()`](https://bayesiandemography.github.io/agetime/reference/age_labels_tree.md)
  Age equivalent of `cohort_labels_tree()`

- [`period_labels_tree()`](https://bayesiandemography.github.io/agetime/reference/period_labels_tree.md)
  Period equivalent of `cohort_labels_tree()`

## Examples

``` r
## year of birth: 10-year cohorts, a broad group
## for births before 1960, and not stated
cohort_labels_tree(
  breaks = seq(1940, 2000, 10),
  nodes = "<1960",
  open_left = TRUE
)
#> [1] "<1940"     "1940-1950" "1950-1960" "1960-1970" "1970-1980" "1980-1990"
#> [7] "1990-2000" "<1960"     "Missing"  
```
