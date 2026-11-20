# Diagnostics and Assertions for Periods

Check whether period labels meet conditions. The `diagnose` functions
report on each condition, and the `assert` functions throw an error if a
condition is not met.

- `period_diagnose_values()` and `period_assert_values()` check the
  elements of `labels`.

- `period_diagnose_levels()` and `period_assert_levels()` check the
  levels of `labels`, including any unused levels. Both functions
  require `labels` to be a factor.

Conditions include:

- Not overlapping

- Not having gaps

- Having, or not having, totals, subtotals, or missing values

- Having, or not having, open periods

## Usage

``` r
period_diagnose_levels(
  labels,
  no_overlap = FALSE,
  no_gap = FALSE,
  no_total = FALSE,
  no_subtotal = FALSE,
  no_missing = FALSE,
  no_open_left = FALSE,
  no_open_right = FALSE,
  has_total = FALSE,
  has_subtotal = FALSE,
  has_missing = FALSE,
  has_open_left = FALSE,
  has_open_right = FALSE,
  valid_tree = FALSE,
  interpret_single = c("lower", "upper"),
  interpret_multi = NULL,
  interpret_fail = c("error", "warn", "silent"),
  x_arg = rlang::caller_arg(labels)
)

period_assert_levels(
  labels,
  no_overlap = FALSE,
  no_gap = FALSE,
  no_total = FALSE,
  no_subtotal = FALSE,
  no_missing = FALSE,
  no_open_left = FALSE,
  no_open_right = FALSE,
  has_total = FALSE,
  has_subtotal = FALSE,
  has_missing = FALSE,
  has_open_left = FALSE,
  has_open_right = FALSE,
  valid_tree = FALSE,
  interpret_single = c("lower", "upper"),
  interpret_multi = NULL,
  interpret_fail = c("error", "warn", "silent"),
  x_arg = rlang::caller_arg(labels),
  call = rlang::current_env()
)

period_diagnose_values(
  labels,
  no_overlap = FALSE,
  no_gap = FALSE,
  no_total = FALSE,
  no_subtotal = FALSE,
  no_missing = FALSE,
  no_open_left = FALSE,
  no_open_right = FALSE,
  has_total = FALSE,
  has_subtotal = FALSE,
  has_missing = FALSE,
  has_open_left = FALSE,
  has_open_right = FALSE,
  valid_tree = FALSE,
  interpret_single = c("lower", "upper"),
  interpret_multi = NULL,
  interpret_fail = c("error", "warn", "silent"),
  x_arg = rlang::caller_arg(labels)
)

period_assert_values(
  labels,
  no_overlap = FALSE,
  no_gap = FALSE,
  no_total = FALSE,
  no_subtotal = FALSE,
  no_missing = FALSE,
  no_open_left = FALSE,
  no_open_right = FALSE,
  has_total = FALSE,
  has_subtotal = FALSE,
  has_missing = FALSE,
  has_open_left = FALSE,
  has_open_right = FALSE,
  valid_tree = FALSE,
  interpret_single = c("lower", "upper"),
  interpret_multi = NULL,
  interpret_fail = c("error", "warn", "silent"),
  x_arg = rlang::caller_arg(labels),
  call = rlang::current_env()
)
```

## Arguments

- labels:

  Vector of period labels.

- no_overlap:

  Check that no periods overlap. Different labels that describe the same
  interval, such as `"2020-2025"` and `"2020 to 2025"`, count as
  overlapping. Totals and missing values, as defined by
  [`period_is_total()`](https://bayesiandemography.github.io/agetime/reference/period_is_total.md)
  and
  [`period_is_missing()`](https://bayesiandemography.github.io/agetime/reference/period_is_missing.md),
  are removed before checks for overlaps are performed. Default is
  `FALSE` (don't check).

- no_gap:

  Check that all periods between the earliest and latest periods are
  included. Default is `FALSE` (don't check).

- no_total:

  Check that there is no "total" category, as defined by
  [`period_is_total()`](https://bayesiandemography.github.io/agetime/reference/period_is_total.md).
  Default is `FALSE` (don't check).

- no_subtotal:

  Check that there are no subtotals, as defined by
  [`period_is_subtotal()`](https://bayesiandemography.github.io/agetime/reference/period_is_subtotal.md).
  Subtotals are distinct from grand totals checked by `no_total`.
  Default is `FALSE` (don't check).

- no_missing:

  Check that there is no "missing" category, as defined by
  [`period_is_missing()`](https://bayesiandemography.github.io/agetime/reference/period_is_missing.md).
  Default is `FALSE` (don't check).

- no_open_left:

  Check that no period is open on the left (has no lower limit), as
  defined by
  [`period_is_open_left()`](https://bayesiandemography.github.io/agetime/reference/period_is_open_left.md).
  Default is `FALSE` (don't check).

- no_open_right:

  Check that no period is open on the right (has no upper limit), as
  defined by
  [`period_is_open_right()`](https://bayesiandemography.github.io/agetime/reference/period_is_open_left.md).
  Default is `FALSE` (don't check).

- has_total:

  Check that there is at least one "total" category, as defined by
  [`period_is_total()`](https://bayesiandemography.github.io/agetime/reference/period_is_total.md).
  Default is `FALSE` (don't check).

- has_subtotal:

  Check that there is at least one subtotal, as defined by
  [`period_is_subtotal()`](https://bayesiandemography.github.io/agetime/reference/period_is_subtotal.md).
  Default is `FALSE` (don't check).

- has_missing:

  Check that there is at least one "missing" category, as defined by
  [`period_is_missing()`](https://bayesiandemography.github.io/agetime/reference/period_is_missing.md),
  including `NA` values. Default is `FALSE` (don't check).

- has_open_left:

  Check that at least one period is open on the left (has no lower
  limit), as defined by
  [`period_is_open_left()`](https://bayesiandemography.github.io/agetime/reference/period_is_open_left.md).
  Default is `FALSE` (don't check).

- has_open_right:

  Check that at least one period is open on the right (has no upper
  limit), as defined by
  [`period_is_open_right()`](https://bayesiandemography.github.io/agetime/reference/period_is_open_left.md).
  Default is `FALSE` (don't check).

- valid_tree:

  Check that periods form a reporting tree: any two periods either do
  not overlap, or one contains the other, and the most detailed periods
  (those containing no other period) cover the full span of the periods,
  with no gaps. Totals and missing values, as defined by
  [`period_is_total()`](https://bayesiandemography.github.io/agetime/reference/period_is_total.md)
  and
  [`period_is_missing()`](https://bayesiandemography.github.io/agetime/reference/period_is_missing.md),
  are removed before the check. Unlike `no_overlap`, repeated labels,
  and different labels that describe the same interval, are allowed.
  Whether the span is open on the left or right is checked by
  `has_open_left` and `has_open_right`. See the section on reporting
  trees. Default is `FALSE` (don't check).

- interpret_single:

  How to interpret a label for a single year, such as `"2020"`. Choices
  are `"lower"` (the default) and `"upper"`. See below for details.

- interpret_multi:

  How to interpret a label that refers to multiple years, such as
  `"2020-2025"`. Choices are `NULL` (the default), `"at_upper"`, and
  `"below_upper"`. See below for details.

- interpret_fail:

  Action if element of `labels` cannot be interpreted. Choices are
  `"error"` (the default), `"warn"`, and `"silent"`.

- x_arg:

  Name of `labels` to use in error and warning messages, including
  messages about labels that cannot be interpreted. Defaults to the
  expression supplied for `labels`. A function that calls a `diagnose`
  or `assert` function can supply its own name, such as `"data$age"`.

- call:

  Execution environment of the function to be named in error messages
  from the `assert` functions. The default is the `assert` function
  itself, so that errors name, for instance, `period_assert_values()`. A
  function that calls an `assert` function can supply
  `call = rlang::current_env()`, so that errors name that function
  instead.

## Value

- `period_diagnose_levels()` and `period_diagnose_values()` return a
  list with a logical flag called `ok` and a
  [tibble](https://tibble.tidyverse.org/reference/tibble.html) called
  `details`.

- `period_assert_levels()` and `period_assert_values()` return `labels`
  invisibly, or raise an error.

## Presence and absence checks

Arguments starting with `no_` require absence; arguments starting with
`has_` require at least one occurrence. `FALSE` means that the check is
not requested. On empty input, `no_` checks pass and `has_` checks fail.
A subtotal must be fully divided by two or more other intervals in the
labels being checked. For factor levels, this includes unused levels;
for values, unused levels are ignored.

## Reporting trees

In a reporting tree, records are tabulated at different levels of
detail. A census table, for instance, might have detailed periods, some
broader periods for records with less detailed information, and a
category for records with no information. The periods nest: any two
either do not overlap, or one contains the other. The most detailed
periods (the leaves of the tree) cover the full span, so that every
broader period is divided exactly into narrower ones. Leaves do not need
to be the same distance from the root: some broader periods can be
divided further than others.

Some tables use a label such as `"Total"` to mean that the period is not
stated. Recode such labels to `"Missing"`, for instance using
`x[period_is_total(x)] <- "Missing"`, so that they are not treated as
totals (for instance by `no_total`).

To check trees separately for each group, use
[`dplyr::group_by()`](https://dplyr.tidyverse.org/reference/group_by.html).

## Rules for interpreting inputs

**Single-year**

Labels for single-year periods sometimes refer to the lower limits of
periods, and sometimes refer to upper limits. For instance, the label
`"2020"` is sometimes used to refer to the period that starts at
midnight on 1 January 2020 and ends at midnight on 1 January 2021, and
is sometimes used to refer to the period that starts at midnight on 1
July 2019 and ends at midnight on 1 July 2020.

The `interpret_single` argument can be used to distinguish between the
two conventions:

|                    |                  |                         |
|--------------------|------------------|-------------------------|
| `interpret_single` | *Rule*           | *Example*               |
| `"lower"`          | `"a" -> [a,a+1)` | `"2020" -> [2020,2021)` |
| `"upper"`          | `"a" -> [a-1,a)` | `"2020" -> [2019,2020)` |

**Multi-year**

In labels for multi-year periods, the second number is sometimes the
upper limit of the period, and sometimes the upper limit minus 1. For
instance, the period that starts at midnight on 1 January 2020 and ends
at midnight on 1 January 2025 is sometimes labelled `"2020-2025"` and is
sometimes labelled `"2020-2024"`.

The `interpret_multi` argument can be used to distinguish between the
two conventions:

|                   |                    |                              |
|-------------------|--------------------|------------------------------|
| `interpret_multi` | *Rule*             | *Example*                    |
| `"at_upper"`      | `"a-b" -> [a,b)`   | `"2020-2025" -> [2020,2025)` |
| `"below_upper"`   | `"a-b" -> [a,b+1)` | `"2020-2024" -> [2020,2025)` |

If `interpret_multi` is `NULL` (the default), then multi-year labels are
interpreted using the `"at_upper"` convention. If, however, the
`"at_upper"` convention leads to intervals with widths 4, 9, 14, ...,
then agetime emits a message. Supplying an explicit value for
`interpret_multi` silences this message.

**Open**

A period that is open on the left has no lower limit, and a period that
is open on the right has no upper limit. Labels for open periods are not
affected by `interpret_single` or `interpret_multi`.

Some examples of open periods:

|                                                |               |
|------------------------------------------------|---------------|
| *Label*                                        | *Interval*    |
| `"<2000"`, `"before 2000"`, `"under 2000"`     | `(-Inf,2000)` |
| `"2000 or earlier"`, `"up to 2000"`            | `(-Inf,2001)` |
| `"2000+"`, `"2000 or more"`, `"2000 or later"` | `[2000,Inf)`  |

Labels starting with `"-"`, such as `"-2000"`, are not accepted.

## See also

- [`age_assert_values()`](https://bayesiandemography.github.io/agetime/reference/age_diagnose_levels.md),
  [`age_assert_levels()`](https://bayesiandemography.github.io/agetime/reference/age_diagnose_levels.md)

- [`age_diagnose_values()`](https://bayesiandemography.github.io/agetime/reference/age_diagnose_levels.md),
  [`age_diagnose_levels()`](https://bayesiandemography.github.io/agetime/reference/age_diagnose_levels.md)

- [`cohort_assert_values()`](https://bayesiandemography.github.io/agetime/reference/cohort_diagnose_levels.md),
  [`cohort_assert_levels()`](https://bayesiandemography.github.io/agetime/reference/cohort_diagnose_levels.md)

- [`cohort_diagnose_values()`](https://bayesiandemography.github.io/agetime/reference/cohort_diagnose_levels.md),
  [`cohort_diagnose_levels()`](https://bayesiandemography.github.io/agetime/reference/cohort_diagnose_levels.md)

## Examples

``` r
## require totals, subtotals, and missing values
period_assert_values(
  c("2020-2025", "2025-2030", "2020-2030", "Total", "Missing"),
  has_total = TRUE,
  has_subtotal = TRUE,
  has_missing = TRUE
)

## require no subtotals
period_diagnose_values(c("2020-2025", "2025-2030", "2020-2030"), no_subtotal = TRUE)
#> $ok
#> [1] FALSE
#> 
#> $details
#> # A tibble: 1 × 3
#>   condition   passed comment                                      
#>   <chr>       <lgl>  <chr>                                        
#> 1 no_subtotal FALSE  Example of subtotal among values: '2020-2030'
#> 

lab <- period_labels_five(
  lower_first = 2020,
  lower_last = 2030
)
lab
#> [1] "2020-2025" "2025-2030" "2030-2035"

## get info on everything
period_diagnose_values(
  labels = lab,
  no_overlap = TRUE,
  no_gap = TRUE,
  no_total = TRUE,
  no_missing = TRUE
)
#> $ok
#> [1] TRUE
#> 
#> $details
#> # A tibble: 4 × 3
#>   condition  passed comment
#>   <chr>      <lgl>  <chr>  
#> 1 no_overlap TRUE   NA     
#> 2 no_gap     TRUE   NA     
#> 3 no_total   TRUE   NA     
#> 4 no_missing TRUE   NA     
#> 

## throw error if overlap or gap
period_assert_values(
  labels = lab,
  no_overlap = TRUE,
  no_gap = TRUE
)

## repeated labels count as overlapping...
df <- data.frame(
  period = c("2020-2025", "2025-2030", "2020-2025", "2025-2030"),
  sex = c("F", "F", "M", "M")
)
period_diagnose_values(df$period, no_overlap = TRUE)
#> $ok
#> [1] FALSE
#> 
#> $details
#> # A tibble: 1 × 3
#>   condition  passed comment                                                     
#>   <chr>      <lgl>  <chr>                                                       
#> 1 no_overlap FALSE  Example of overlap among values: '2020-2025' appears 2 time…
#> 

## ...so check within groups
library(dplyr, warn.conflicts = FALSE)
df |>
  group_by(sex) |>
  mutate(period = period_assert_values(period, no_overlap = TRUE))
#> # A tibble: 4 × 2
#> # Groups:   sex [2]
#>   period    sex  
#>   <chr>     <chr>
#> 1 2020-2025 F    
#> 2 2025-2030 F    
#> 3 2020-2025 M    
#> 4 2025-2030 M    

## factor with unused level
fac <- factor(
  x = "2020-2025",
  levels = c("2020-2025", "2030-2035")
)
fac
#> [1] 2020-2025
#> Levels: 2020-2025 2030-2035
period_diagnose_levels(fac, no_gap = TRUE)
#> $ok
#> [1] FALSE
#> 
#> $details
#> # A tibble: 1 × 3
#>   condition passed comment                                    
#>   <chr>     <lgl>  <chr>                                      
#> 1 no_gap    FALSE  Example: gap among levels below '2030-2035'
#> 
period_diagnose_values(fac, no_gap = TRUE)
#> $ok
#> [1] TRUE
#> 
#> $details
#> # A tibble: 1 × 3
#>   condition passed comment
#>   <chr>     <lgl>  <chr>  
#> 1 no_gap    TRUE   NA     
#> 
```
