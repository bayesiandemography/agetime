# Set Order of Age Group Levels for a Reporting Tree

Modify the `levels` attribute of `labels` so that age groups are ordered
as a reporting tree: the most detailed age groups first, then broader
age groups, then age not stated.

## Usage

``` r
age_set_order_tree(
  labels,
  interpret_fail = c("error", "warn", "silent"),
  x_arg = rlang::caller_arg(labels),
  call = rlang::current_env()
)
```

## Arguments

- labels:

  Vector of age group labels.

- interpret_fail:

  Action if element of `labels` cannot be interpreted. Choices are
  `"error"` (the default), `"warn"`, and `"silent"`.

- x_arg:

  Name of `labels` to use in error and warning messages. Defaults to the
  expression supplied for `labels`. A function that calls this function
  can supply its own name, such as `"data$age"`.

- call:

  Execution environment of the function to name in error and warning
  messages. The default is this function itself. A function that calls
  this function can supply `call = rlang::current_env()`, so that
  messages name it instead.

## Value

Factor with the same length as `labels`.

## Details

In a reporting tree, age groups nest: any two age groups either do not
overlap, or one contains the other. Reporting trees arise, for instance,
in census tables where most records have detailed ages (`"0-4"`,
`"5-9"`, ...), some have only broad ages (`"0-14"`, `"15+"`), and some
have no age at all (`"Missing"`).

Levels are ordered as follows:

1.  Leaves, that is, age groups that contain no other age group, ordered
    by lower limit.

2.  Broader age groups, ordered so that each age group comes after all
    age groups inside it, and before any age group entirely above it.
    For instance, `"15-64"`, `"65+"`, and `"15+"` are ordered `"15-64"`,
    `"65+"`, `"15+"`.

3.  Labels that could not be interpreted, if `interpret_fail` is
    `"warn"` or `"silent"`.

4.  Labels for missing values, as defined by
    [`age_is_missing()`](https://bayesiandemography.github.io/agetime/reference/age_is_missing.md).

Different labels that describe the same age group, such as `"0-4"` and
`"Under 5"`, are placed next to each other, in the order in which they
first appear.

Leaves do not need to lie at the same depth in the tree. For instance, a
tree can have a broad group `"65+"` and no broad groups at younger ages,
so that `"0-4"` sits directly below the root while `"70-74"` sits below
`"65+"`.

`age_set_order_tree()` checks only that the age groups nest. It does not
check, for instance, that the leaves cover all ages. Labels for totals,
as defined by
[`age_is_total()`](https://bayesiandemography.github.io/agetime/reference/age_is_total.md),
are not part of a reporting tree, and cause an error. Some tables use
`"Total"` to mean age not stated. In such cases, recode the total to
`"Missing"` before calling `age_set_order_tree()`, for instance using
`age[age_is_total(age)] <- "Missing"`.

If `labels` is not a factor, and so does not have levels, it is
converted to a factor before the ordering is performed.
`age_set_order_tree()` has no effect on the values of `labels`. Only the
levels are changed.

## See also

- [`age_set_order()`](https://bayesiandemography.github.io/agetime/reference/age_set_order.md)
  Order age groups by lower limit

- [`age_is_missing()`](https://bayesiandemography.github.io/agetime/reference/age_is_missing.md)
  Identify labels for missing values

- [`period_set_order_tree()`](https://bayesiandemography.github.io/agetime/reference/period_set_order_tree.md)
  Period equivalent of `age_set_order_tree()`

- [`cohort_set_order_tree()`](https://bayesiandemography.github.io/agetime/reference/cohort_set_order_tree.md)
  Cohort equivalent of `age_set_order_tree()`

## Examples

``` r
labels <- c("Missing", "15+", "0-14", "70+", "60-69", "50-59",
            "40-49", "30-39", "20-29", "15-19", "10-14", "5-9", "0-4")
age_set_order_tree(labels)
#>  [1] Missing 15+     0-14    70+     60-69   50-59   40-49   30-39   20-29  
#> [10] 15-19   10-14   5-9     0-4    
#> 13 Levels: 0-4 5-9 10-14 15-19 20-29 30-39 40-49 50-59 60-69 70+ 0-14 ... Missing

## three levels, with leaves at different depths
labels <- c(age_labels_five(lower_last = 85),
            "0-14", "15+", "15-64", "65+", "Missing")
levels(age_set_order_tree(labels))
#>  [1] "0-4"     "5-9"     "10-14"   "15-19"   "20-24"   "25-29"   "30-34"  
#>  [8] "35-39"   "40-44"   "45-49"   "50-54"   "55-59"   "60-64"   "65-69"  
#> [15] "70-74"   "75-79"   "80-84"   "85+"     "0-14"    "15-64"   "65+"    
#> [22] "15+"     "Missing"
```
