# Diagnostics and Assertions for Age Groups

Check whether age group labels meet conditions. The `diagnose` functions
report on each condition, and the `assert` functions throw an error if a
condition is not met.

- `age_diagnose_values()` and `age_assert_values()` check the elements
  of `labels`.

- `age_diagnose_levels()` and `age_assert_levels()` check the levels of
  `labels`, including any unused levels. Both functions require `labels`
  to be a factor.

Conditions include:

- Not overlapping

- Not having gaps

- Having, or not having, totals, subtotals, or missing values

- Having, or not having, open age groups

- Having an age group that starts at zero

- Only including age groups used by an abridged life table

## Usage

``` r
age_diagnose_levels(
  labels,
  no_overlap = FALSE,
  no_gap = FALSE,
  no_total = FALSE,
  no_subtotal = FALSE,
  no_missing = FALSE,
  no_open_right = FALSE,
  has_total = FALSE,
  has_subtotal = FALSE,
  has_missing = FALSE,
  has_open_right = FALSE,
  has_zero = FALSE,
  valid_life = FALSE,
  valid_tree = FALSE,
  interpret_fail = c("error", "warn", "silent"),
  x_arg = rlang::caller_arg(labels)
)

age_assert_levels(
  labels,
  no_overlap = FALSE,
  no_gap = FALSE,
  no_total = FALSE,
  no_subtotal = FALSE,
  no_missing = FALSE,
  no_open_right = FALSE,
  has_total = FALSE,
  has_subtotal = FALSE,
  has_missing = FALSE,
  has_open_right = FALSE,
  has_zero = FALSE,
  valid_life = FALSE,
  valid_tree = FALSE,
  interpret_fail = c("error", "warn", "silent"),
  x_arg = rlang::caller_arg(labels),
  call = rlang::current_env()
)

age_diagnose_values(
  labels,
  no_overlap = FALSE,
  no_gap = FALSE,
  no_total = FALSE,
  no_subtotal = FALSE,
  no_missing = FALSE,
  no_open_right = FALSE,
  has_total = FALSE,
  has_subtotal = FALSE,
  has_missing = FALSE,
  has_open_right = FALSE,
  has_zero = FALSE,
  valid_life = FALSE,
  valid_tree = FALSE,
  interpret_fail = c("error", "warn", "silent"),
  x_arg = rlang::caller_arg(labels)
)

age_assert_values(
  labels,
  no_overlap = FALSE,
  no_gap = FALSE,
  no_total = FALSE,
  no_subtotal = FALSE,
  no_missing = FALSE,
  no_open_right = FALSE,
  has_total = FALSE,
  has_subtotal = FALSE,
  has_missing = FALSE,
  has_open_right = FALSE,
  has_zero = FALSE,
  valid_life = FALSE,
  valid_tree = FALSE,
  interpret_fail = c("error", "warn", "silent"),
  x_arg = rlang::caller_arg(labels),
  call = rlang::current_env()
)
```

## Arguments

- labels:

  Vector of age group labels.

- no_overlap:

  Check that no age groups overlap. Different labels that describe the
  same interval, such as `"0"` and `"infant"`, count as overlapping.
  Totals and missing values, as defined by
  [`age_is_total()`](https://bayesiandemography.github.io/agetime/reference/age_is_total.md)
  and
  [`age_is_missing()`](https://bayesiandemography.github.io/agetime/reference/age_is_missing.md),
  are removed before checks for overlaps are performed. Default is
  `FALSE` (don't check).

- no_gap:

  Check that all ages between the youngest and oldest age groups are
  included. Default is `FALSE` (don't check).

- no_total:

  Check that there is no "total" category, as defined by
  [`age_is_total()`](https://bayesiandemography.github.io/agetime/reference/age_is_total.md).
  Default is `FALSE` (don't check).

- no_subtotal:

  Check that there are no subtotals, as defined by
  [`age_is_subtotal()`](https://bayesiandemography.github.io/agetime/reference/age_is_subtotal.md).
  Subtotals are distinct from grand totals checked by `no_total`.
  Default is `FALSE` (don't check).

- no_missing:

  Check that there is no "missing" category, as defined by
  [`age_is_missing()`](https://bayesiandemography.github.io/agetime/reference/age_is_missing.md).
  Default is `FALSE` (don't check).

- no_open_right:

  Check that no age group is open on the right (has no upper limit), as
  defined by
  [`age_is_open_right()`](https://bayesiandemography.github.io/agetime/reference/age_is_open_right.md).
  Default is `FALSE` (don't check).

- has_total:

  Check that there is at least one "total" category, as defined by
  [`age_is_total()`](https://bayesiandemography.github.io/agetime/reference/age_is_total.md).
  Default is `FALSE` (don't check).

- has_subtotal:

  Check that there is at least one subtotal, as defined by
  [`age_is_subtotal()`](https://bayesiandemography.github.io/agetime/reference/age_is_subtotal.md).
  Default is `FALSE` (don't check).

- has_missing:

  Check that there is at least one "missing" category, as defined by
  [`age_is_missing()`](https://bayesiandemography.github.io/agetime/reference/age_is_missing.md),
  including `NA` values. Default is `FALSE` (don't check).

- has_open_right:

  Check that at least one age group is open on the right (has no upper
  limit), as defined by
  [`age_is_open_right()`](https://bayesiandemography.github.io/agetime/reference/age_is_open_right.md).
  Default is `FALSE` (don't check).

- has_zero:

  Check that at least one age group has a lower limit of zero. Default
  is `FALSE` (don't check).

- valid_life:

  Check that all labels are valid for an abridged life table. Default is
  `FALSE` (don't check).

- valid_tree:

  Check that age groups form a reporting tree: any two age groups either
  do not overlap, or one contains the other, and the most detailed age
  groups (those containing no other age group) cover the full span of
  the age groups, with no gaps. Totals and missing values, as defined by
  [`age_is_total()`](https://bayesiandemography.github.io/agetime/reference/age_is_total.md)
  and
  [`age_is_missing()`](https://bayesiandemography.github.io/agetime/reference/age_is_missing.md),
  are removed before the check. Unlike `no_overlap`, repeated labels,
  and different labels that describe the same interval, are allowed.
  Whether the span starts at zero, or ends with an open age group, is
  checked by `has_zero` and `has_open_right`. See the section on
  reporting trees. Default is `FALSE` (don't check).

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
  itself, so that errors name, for instance, `age_assert_values()`. A
  function that calls an `assert` function can supply
  `call = rlang::current_env()`, so that errors name that function
  instead.

## Value

- `age_diagnose_levels()` and `age_diagnose_values()` return a list with
  a logical flag called `ok` and a
  [tibble](https://tibble.tidyverse.org/reference/tibble.html) called
  `details`.

- `age_assert_levels()` and `age_assert_values()` return `labels`
  invisibly, or raise an error.

## Abridged and complete life tables

- An abridged life table uses age groups `"0"` and `"1-4"`, followed by
  5-year age groups such as `"5-9"` and `"10-14"`.

- A complete life table uses single-year age groups such as `"0"`,
  `"1"`, and `"2"`.

- Both types of life table usually have an open age group such as
  `"85+"` or `"100+"`.

## Reporting trees

In a reporting tree, records are tabulated at different levels of
detail. A census table, for instance, might have detailed age groups,
some broader age groups for records with less detailed information, and
a category for records with no information. The age groups nest: any two
either do not overlap, or one contains the other. The most detailed age
groups (the leaves of the tree) cover the full span, so that every
broader age group is divided exactly into narrower ones. Leaves do not
need to be the same distance from the root: some broader age groups can
be divided further than others.

Some tables use a label such as `"Total"` to mean that the age is not
stated. Recode such labels to `"Missing"`, for instance using
`x[age_is_total(x)] <- "Missing"`, so that they are not treated as
totals (for instance by `no_total`).

To check a complete age reporting tree, use `valid_tree = TRUE`,
`has_zero = TRUE`, `has_open_right = TRUE`, and `no_total = TRUE`. To
check trees separately for each sex or date, use
[`dplyr::group_by()`](https://dplyr.tidyverse.org/reference/group_by.html).

## Presence and absence checks

Arguments starting with `no_` require absence; arguments starting with
`has_` require at least one occurrence. `FALSE` means that the check is
not requested. On empty input, `no_` checks pass and `has_` checks fail.
A subtotal must be fully divided by two or more other intervals in the
labels being checked. For factor levels, this includes unused levels;
for values, unused levels are ignored.

## See also

- [`period_assert_values()`](https://bayesiandemography.github.io/agetime/reference/period_diagnose_levels.md),
  [`period_assert_levels()`](https://bayesiandemography.github.io/agetime/reference/period_diagnose_levels.md)

- [`period_diagnose_values()`](https://bayesiandemography.github.io/agetime/reference/period_diagnose_levels.md),
  [`period_diagnose_levels()`](https://bayesiandemography.github.io/agetime/reference/period_diagnose_levels.md)

- [`cohort_assert_values()`](https://bayesiandemography.github.io/agetime/reference/cohort_diagnose_levels.md),
  [`cohort_assert_levels()`](https://bayesiandemography.github.io/agetime/reference/cohort_diagnose_levels.md)

- [`cohort_diagnose_values()`](https://bayesiandemography.github.io/agetime/reference/cohort_diagnose_levels.md),
  [`cohort_diagnose_levels()`](https://bayesiandemography.github.io/agetime/reference/cohort_diagnose_levels.md)

## Examples

``` r
## require totals, subtotals, and missing values
age_assert_values(
  c("0-4", "5-9", "0-9", "Total", "Missing"),
  has_total = TRUE,
  has_subtotal = TRUE,
  has_missing = TRUE
)

## require no subtotals
age_diagnose_values(c("0-4", "5-9", "0-9"), no_subtotal = TRUE)
#> $ok
#> [1] FALSE
#> 
#> $details
#> # A tibble: 1 × 3
#>   condition   passed comment                                
#>   <chr>       <lgl>  <chr>                                  
#> 1 no_subtotal FALSE  Example of subtotal among values: '0-9'
#> 

lab <- age_labels_life()
lab
#>  [1] "0"     "1-4"   "5-9"   "10-14" "15-19" "20-24" "25-29" "30-34" "35-39"
#> [10] "40-44" "45-49" "50-54" "55-59" "60-64" "65-69" "70-74" "75-79" "80-84"
#> [19] "85-89" "90-94" "95-99" "100+" 

## get info on everything
age_diagnose_values(
  labels = lab,
  no_overlap = TRUE,
  no_gap = TRUE,
  no_total = TRUE,
  no_missing = TRUE,
  has_open_right = TRUE,
  has_zero = TRUE,
  valid_life = TRUE
)
#> $ok
#> [1] TRUE
#> 
#> $details
#> # A tibble: 7 × 3
#>   condition      passed comment
#>   <chr>          <lgl>  <chr>  
#> 1 no_overlap     TRUE   NA     
#> 2 no_gap         TRUE   NA     
#> 3 no_total       TRUE   NA     
#> 4 no_missing     TRUE   NA     
#> 5 has_open_right TRUE   NA     
#> 6 has_zero       TRUE   NA     
#> 7 valid_life     TRUE   NA     
#> 

## throw error if overlap or gap
age_assert_values(
  labels = lab,
  no_overlap = TRUE,
  no_gap = TRUE
)

## check a complete reporting tree: detailed
## ages, broad ages, and age not stated
tree <- c("0-4", "5-9", "10-14", "15+", "0-14", "Missing")
age_assert_values(
  labels = tree,
  valid_tree = TRUE,
  has_zero = TRUE,
  has_open_right = TRUE,
  no_total = TRUE
)

## broad age group not fully divided
age_diagnose_values(c("0-4", "5-9", "0-14"), valid_tree = TRUE)
#> $ok
#> [1] FALSE
#> 
#> $details
#> # A tibble: 1 × 3
#>   condition  passed comment                                                     
#>   <chr>      <lgl>  <chr>                                                       
#> 1 valid_tree FALSE  Example: most detailed age groups do not reach upper limit …
#> 

## repeated labels count as overlapping...
df <- data.frame(
  age = c("0-4", "5-9", "0-4", "5-9"),
  sex = c("F", "F", "M", "M")
)
age_diagnose_values(df$age, no_overlap = TRUE)
#> $ok
#> [1] FALSE
#> 
#> $details
#> # A tibble: 1 × 3
#>   condition  passed comment                                                     
#>   <chr>      <lgl>  <chr>                                                       
#> 1 no_overlap FALSE  Example of overlap among values: '0-4' appears 2 times. To …
#> 

## ...so check within groups
library(dplyr, warn.conflicts = FALSE)
df |>
  group_by(sex) |>
  mutate(age = age_assert_values(age, no_overlap = TRUE))
#> # A tibble: 4 × 2
#> # Groups:   sex [2]
#>   age   sex  
#>   <chr> <chr>
#> 1 0-4   F    
#> 2 5-9   F    
#> 3 0-4   M    
#> 4 5-9   M    

## factor with unused level
fac <- factor(
  x = "0-4",
  levels = c("0-4", "3-7")
)
fac
#> [1] 0-4
#> Levels: 0-4 3-7
age_diagnose_levels(fac, no_overlap = TRUE)
#> $ok
#> [1] FALSE
#> 
#> $details
#> # A tibble: 1 × 3
#>   condition  passed comment                                         
#>   <chr>      <lgl>  <chr>                                           
#> 1 no_overlap FALSE  Example of overlap among levels: '0-4' and '3-7'
#> 
age_diagnose_values(fac, no_overlap = TRUE)
#> $ok
#> [1] TRUE
#> 
#> $details
#> # A tibble: 1 × 3
#>   condition  passed comment
#>   <chr>      <lgl>  <chr>  
#> 1 no_overlap TRUE   NA     
#> 
```
