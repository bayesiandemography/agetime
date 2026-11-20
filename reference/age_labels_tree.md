# Create Age Group Labels for a Reporting Tree

Create labels for a reporting tree, in which records are tabulated at
different levels of detail: detailed age groups, broader age groups,
and, optionally, age not stated.

## Usage

``` r
age_labels_tree(
  breaks,
  nodes = NULL,
  open_right = TRUE,
  include_missing = TRUE
)
```

## Arguments

- breaks:

  Boundaries between age groups. A numeric vector.

- nodes:

  Labels for broad age groups. A character vector, or `NULL` (the
  default), in which case there are no broad age groups.

- open_right:

  Whether the oldest age group is open on the right, i.e. has no upper
  limit. Default is `TRUE`.

- include_missing:

  Whether to include a `"Missing"` category, representing age not
  stated. Default is `TRUE`.

## Value

Character vector.

## Details

The most detailed age groups (the leaves of the tree) are created from
`breaks` and `open_right`, exactly as by
[`age_labels()`](https://bayesiandemography.github.io/agetime/reference/age_labels.md).
Broader age groups are supplied through `nodes`, as ordinary age group
labels such as `"0-14"` or `"65+"`. Broader age groups can be given in
any order, and can nest to any depth: for instance,
`nodes = c("0-14", "15+", "15-64", "65+")` describes a tree where
`"15+"` is divided into `"15-64"` and `"65+"`, each of which is divided
into detailed age groups. Leaves do not need to be the same distance
from the root.

Each broad age group must start and end at values in `breaks` (or be
open, if `open_right` is `TRUE`), so that it is a union of detailed age
groups. It must contain at least two detailed age groups, but not all of
them, and broad age groups must nest: any two either do not overlap, or
one contains the other. Labels in `nodes` are converted to the standard
format used by
[`age_standard()`](https://bayesiandemography.github.io/agetime/reference/age_standard.md),
so that, for instance, `"Under 15"` becomes `"0-14"`.

The root of the tree, representing records with no information on age,
is labelled `"Missing"`. Unlike
[`age_labels()`](https://bayesiandemography.github.io/agetime/reference/age_labels.md),
`age_labels_tree()` includes `"Missing"` by default, since most
reporting trees in practice have a category for age not stated.

Labels are returned in the same order as
[`age_set_order_tree()`](https://bayesiandemography.github.io/agetime/reference/age_set_order_tree.md):
detailed age groups, then broad age groups (each after the age groups
inside it), then `"Missing"`.

## See also

- [`age_labels()`](https://bayesiandemography.github.io/agetime/reference/age_labels.md)
  Create labels without broad age groups

- [`age_set_order_tree()`](https://bayesiandemography.github.io/agetime/reference/age_set_order_tree.md)
  Order existing labels as a tree

- [`age_diagnose_values()`](https://bayesiandemography.github.io/agetime/reference/age_diagnose_levels.md)
  Check labels, including with `valid_tree = TRUE`

- [`period_labels_tree()`](https://bayesiandemography.github.io/agetime/reference/period_labels_tree.md)
  Period equivalent of `age_labels_tree()`

- [`cohort_labels_tree()`](https://bayesiandemography.github.io/agetime/reference/cohort_labels_tree.md)
  Cohort equivalent of `age_labels_tree()`

## Examples

``` r
## census with 5-year and 10-year age groups,
## age reported only as under or over 15,
## and age not stated
age_labels_tree(
  breaks = c(0, 5, 10, 15, seq(20, 70, 10)),
  nodes = c("0-14", "15+")
)
#>  [1] "0-4"     "5-9"     "10-14"   "15-19"   "20-29"   "30-39"   "40-49"  
#>  [8] "50-59"   "60-69"   "70+"     "0-14"    "15+"     "Missing"

## three levels, with leaves at different depths
age_labels_tree(
  breaks = seq(0, 85, 5),
  nodes = c("0-14", "15+", "15-64", "65+")
)
#>  [1] "0-4"     "5-9"     "10-14"   "15-19"   "20-24"   "25-29"   "30-34"  
#>  [8] "35-39"   "40-44"   "45-49"   "50-54"   "55-59"   "60-64"   "65-69"  
#> [15] "70-74"   "75-79"   "80-84"   "85+"     "0-14"    "15-64"   "65+"    
#> [22] "15+"     "Missing"

## no broad age groups, no "Missing"
age_labels_tree(
  breaks = seq(0, 20, 5),
  include_missing = FALSE
)
#> [1] "0-4"   "5-9"   "10-14" "15-19" "20+"  
```
