# Check Whether Periods Can Be Aggregated to a Target Classification

Check that observations labelled by `labels` can be aggregated to the
periods in `to`, without splitting observations, omitting required
periods, or counting periods more than once.

`period_diagnose_coarsen()` reports the results of the checks.
`period_assert_coarsen()` returns `labels` invisibly if the checks pass,
and throws an error otherwise. Neither function recodes the labels or
aggregates observations.

## Usage

``` r
period_diagnose_coarsen(
  labels,
  to,
  include_equals = TRUE,
  interpret_single = c("lower", "upper"),
  interpret_multi = NULL,
  interpret_fail = c("error", "warn", "silent"),
  x_arg = rlang::caller_arg(labels),
  to_arg = rlang::caller_arg(to)
)

period_assert_coarsen(
  labels,
  to,
  include_equals = TRUE,
  interpret_single = c("lower", "upper"),
  interpret_multi = NULL,
  interpret_fail = c("error", "warn", "silent"),
  x_arg = rlang::caller_arg(labels),
  to_arg = rlang::caller_arg(to),
  call = rlang::current_env()
)
```

## Arguments

- labels:

  Vector of period labels.

- to:

  Vector of period labels giving the target classification.

- include_equals:

  Whether to allow identical classifications. Default is `TRUE`. Set to
  `FALSE` to require at least one genuine merge.

- interpret_single:

  How to interpret a label for a single year, such as `"2020"`. Choices
  are `"lower"` (the default) and `"upper"`. See below for details.

- interpret_multi:

  How to interpret a label that refers to multiple years, such as
  `"2020-2025"`. Choices are `NULL` (the default), `"at_upper"`, and
  `"below_upper"`. See below for details.

- interpret_fail:

  Action if a label cannot be interpreted: `"error"` (the default),
  `"warn"`, or `"silent"`. Uninterpretable labels fail the checks even
  when parsing errors are suppressed.

- x_arg:

  Name of `labels` to use in error and warning messages. Defaults to the
  expression supplied for `labels`. A function that calls this function
  can supply its own name, such as `"data$age"`.

- to_arg:

  Name of `to` to use in error and warning messages. Defaults to the
  expression supplied for `to`.

- call:

  Execution environment of the function to name in errors from
  `period_assert_coarsen()`. Defaults to the assertion itself. A calling
  function can supply `call = rlang::current_env()`.

## Value

- `period_diagnose_coarsen()` returns a list with a logical flag `ok`
  and a tibble `details`, with columns `condition`, `passed`, and
  `comment`, as in
  [`period_diagnose_values()`](https://bayesiandemography.github.io/agetime/reference/period_diagnose_levels.md).
  Checks that depend on earlier failed checks are omitted. Comments give
  an example of each failure.

- `period_assert_coarsen()` returns the original `labels` invisibly, or
  raises an error explaining the failures.

Two empty inputs pass when `include_equals = TRUE`. An empty input
paired with a nonempty input fails.

## Details

Both inputs must consist of period intervals, with no totals, missing
categories, or `NA` values. Within each input, intervals must not
overlap. Repeated labels, and different labels describing the same
interval, count as overlapping.

Every source interval must fit wholly inside exactly one target
interval. The source intervals assigned to each target must cover it
completely, with no gaps. Matching gaps between target intervals are
allowed. Use
[`period_assert_values()`](https://bayesiandemography.github.io/agetime/reference/period_diagnose_levels.md)
with `no_gap = TRUE` if continuous coverage is also required.

By default, identical classifications pass. Equality is based on
intervals, regardless of spelling or ordering. With
`include_equals = FALSE`, at least one target interval must combine two
or more source intervals; other intervals may stay unchanged.

The same interpretation rules apply to `labels` and `to`. Unlike
[`period_coarsen_to()`](https://bayesiandemography.github.io/agetime/reference/period_coarsen_to.md),
these functions also check for overlaps among source observations and
for complete coverage of every target. They do not check the values
being aggregated or other join keys.

## Factors

Both functions check observed values; unused factor levels are ignored.
Supply `levels(x)` explicitly to check all factor levels instead.
[`period_coarsen_to()`](https://bayesiandemography.github.io/agetime/reference/period_coarsen_to.md)
uses all factor levels when recoding. To coarsen only the values checked
here, drop unused levels in both factor inputs, or convert them to
character vectors before recoding.

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

- [`period_coarsen_to()`](https://bayesiandemography.github.io/agetime/reference/period_coarsen_to.md),
  [`period_mapping()`](https://bayesiandemography.github.io/agetime/reference/period_mapping.md),
  [`period_assert_values()`](https://bayesiandemography.github.io/agetime/reference/period_diagnose_levels.md)

- [`age_assert_coarsen()`](https://bayesiandemography.github.io/agetime/reference/age_diagnose_coarsen.md),
  [`age_diagnose_coarsen()`](https://bayesiandemography.github.io/agetime/reference/age_diagnose_coarsen.md)

- [`cohort_assert_coarsen()`](https://bayesiandemography.github.io/agetime/reference/cohort_diagnose_coarsen.md),
  [`cohort_diagnose_coarsen()`](https://bayesiandemography.github.io/agetime/reference/cohort_diagnose_coarsen.md)

## Examples

``` r
labels <- c("2000-2005", "2005-2010", "2010+")
target <- c("2000-2010", "2010+")
period_assert_coarsen(labels, to = target)
period_coarsen_to(labels, to = target)
#> [1] 2000-2010 2000-2010 2010+    
#> Levels: 2000-2010 2010+

## equality is allowed by default
period_assert_coarsen(target, to = target)
period_diagnose_coarsen(target, to = target, include_equals = FALSE)
#> $ok
#> [1] FALSE
#> 
#> $details
#> # A tibble: 7 × 3
#>   condition         passed comment                                              
#>   <chr>             <lgl>  <chr>                                                
#> 1 labels_intervals  TRUE   NA                                                   
#> 2 to_intervals      TRUE   NA                                                   
#> 3 labels_no_overlap TRUE   NA                                                   
#> 4 to_no_overlap     TRUE   NA                                                   
#> 5 contained         TRUE   NA                                                   
#> 6 complete          TRUE   NA                                                   
#> 7 not_equal         FALSE  Source and target describe the same classification; …
#> 

## missing years in a target interval
period_diagnose_coarsen(c("2000-2005", "2010+"), to = target)
#> $ok
#> [1] FALSE
#> 
#> $details
#> # A tibble: 6 × 3
#>   condition         passed comment                                              
#>   <chr>             <lgl>  <chr>                                                
#> 1 labels_intervals  TRUE    NA                                                  
#> 2 to_intervals      TRUE    NA                                                  
#> 3 labels_no_overlap TRUE    NA                                                  
#> 4 to_no_overlap     TRUE    NA                                                  
#> 5 contained         TRUE    NA                                                  
#> 6 complete          FALSE  "Target '2000-2010' in 'target' is not fully covered…
#> 

## an open interval on the left can also be coarsened
period_assert_coarsen(c("<2000", "2000-2005"), to = "<2005")

## specify inclusive upper endpoints for multi-year labels
period_assert_coarsen(
  c("2000-2004", "2005-2009"),
  to = "2000-2009",
  interpret_multi = "below_upper"
)
```
