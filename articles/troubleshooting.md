# Troubleshooting

``` r

library(agetime)
library(dplyr, warn.conflicts = FALSE)
```

This vignette describes errors and difficulties you might encounter when
using `agetime`, and suggests solutions.

## Reading labels

### “Don’t know how to interpret label”

#### Problem

A label is in a format that `agetime` does not recognize.

``` r

x <- c("0-4", "5-9", "Everything", "85+ (a)")
age_standard(x)
#> Error in `age_standard()`:
#> ! Don't know how to interpret 2 labels: "Everything" and "85+ (a)".
```

#### Solution

The error message lists the labels that cannot be interpreted. Clean
these labels before passing them to `agetime`.

``` r

x_clean <- x
x_clean[x_clean == "Everything"] <- "Total"
x_clean[x_clean == "85+ (a)"] <- "85+"
age_standard(x_clean)
#> [1] "0-4"   "5-9"   "Total" "85+"
```

#### Discussion

`agetime` recognizes many common formats, including:

- ranges such as `"5-9"`, `"5 to 9"`, `"5--9"`, and `"5-9 years"`;
- open age groups such as `"85+"`, `"85 and over"`, `"85 or more"`,
  `"85 years and older"`, and `"85 & over"`;
- age groups starting at 0, such as `"Under 5"`, `"less than 5"`,
  `"<5"`, and `"Infant"`;
- ages from 0 up to and including a stated age, such as `"5 or younger"`
  and `"5 and younger"`, which become `"0-5"`;
- totals such as `"Total"` and `"All ages"`, and
- missing values such as `"Not stated"`, `"Unknown"`, and
  `"Age not stated"`.

Case, spaces, and leading zeros are ignored.

### One-year periods written as ranges

#### Problem

A period label such as `"2020-2021"` gives an error.

``` r

period_standard("2020-2021")
#> Error in `period_standard()`:
#> ! Label "2020-2021" describes a one-year period.
#> ℹ With `interpret_multi` = "at_upper", "2020-2021" is the interval [2020,
#>   2021).
#> ℹ Write one-year periods as a single year, e.g. "2020"?
#> ℹ Or set `interpret_multi` to "below_upper" if "2020-2021" is meant to be two
#>   years?
```

#### Solution

By default, period and cohort functions read `"2020-2021"` as the
interval from the start of 2020 to the start of 2021, which is a single
year. `agetime` expects single years to be written as `"2020"`. If
`"2020-2021"` denotes the two-year period consisting of the years 2020
and 2021, then set `interpret_multi` to `"below_upper"`.

``` r

period_standard("2020-2021", interpret_multi = "below_upper")
#> [1] "2020-2022"
```

#### See Also

- The section on rules for interpreting inputs in
  [`?period_lower`](https://bayesiandemography.github.io/agetime/reference/period_lower.md)

### Financial and academic years: “Lower limit greater than upper limit”

#### Problem

Financial and academic years that start part way through the calendar
year are sometimes described using labels such as `"2019/20"` or
`"2019-20"`. `agetime` currently does not know how to interpret these
labels. For instance, it interprets `"2019/20"` as describing a period
that starts in the year 2019 and ends in the year 20.

``` r

period_standard("2019/20")
#> Error in `period_standard()`:
#> ! Label "2019/20" invalid.
#> ℹ Lower limit greater than upper limit.
#> ℹ With `interpret_multi` = "at_upper", "2019/20" is the interval [2019, 20).
```

#### Solution

Calculate the end year and pass it to `agetime` with `interpret_single`
set to `"upper"`.

``` r

fy <- c("2019/20", "2020-21", "1999/00")
fy_end <- as.integer(substr(fy, 1L, 4L)) + 1
fy_end
#> [1] 2020 2021 2000
period_interval(fy_end, interpret_single = "upper")
#> [1] "[2019, 2020)" "[2020, 2021)" "[1999, 2000)"
period_mid(fy_end, interpret_single = "upper")
#> [1] 2019.5 2020.5 1999.5
```

The same approach works for cohorts.

#### See Also

- The section on rules for interpreting inputs in
  [`?period_lower`](https://bayesiandemography.github.io/agetime/reference/period_lower.md)
  and
  [`?cohort_lower`](https://bayesiandemography.github.io/agetime/reference/cohort_lower.md)

### Single-year periods that appear to overlap with open intervals

#### Problem

When the labels for single-year periods are based on the upper limits of
the periods, the labels can appear to overlap with open intervals. In
the series `"2019", "2020", "2020+"`, for instance, the label `"2020"`
appears to overlap with the label `"2020+"`.

#### Solution

Although they look strange, series such as `"2019", "2020", "2020+"` are
in fact valid, if they use the upper-limit convention. To see what is
going on, use
[`period_interval()`](https://bayesiandemography.github.io/agetime/reference/period_lower.md).

``` r

period_interval(c("2019", "2020", "2020+"), interpret_single = "upper")
#> [1] "[2018, 2019)" "[2019, 2020)" "[2020, Inf)"
```

The `"2020"` label might refer, for instance, to the period that starts
at midnight on 1 July 2019 and ends at midnight on 1 July 2020, while
the `"2020+"` label refers to the period that starts at midnight on 1
July 2020.

#### Discussion

Series that use the upper-limit labelling convention and that have open
periods or cohorts are rare.

#### See Also

- [Financial and academic
  years](#financial-and-academic-years-lower-limit-greater-than-upper-limit)
- [`period_interval()`](https://bayesiandemography.github.io/agetime/reference/period_lower.md)
  and
  [`cohort_interval()`](https://bayesiandemography.github.io/agetime/reference/cohort_lower.md)
- The section on rules for interpreting inputs in
  [`?period_lower`](https://bayesiandemography.github.io/agetime/reference/period_lower.md)
  and
  [`?cohort_lower`](https://bayesiandemography.github.io/agetime/reference/cohort_lower.md)

## Checking labels

### Different labels for the same age group

#### Problem

[`age_assert_values()`](https://bayesiandemography.github.io/agetime/reference/age_diagnose_levels.md)
or
[`age_diagnose_values()`](https://bayesiandemography.github.io/agetime/reference/age_diagnose_levels.md)
reports an overlap, even though the age groups look distinct.

``` r

x <- c("0", "infant", "1-4", "5+")
age_assert_values(x, no_overlap = TRUE)
#> Error in `age_assert_values()`:
#> ! Age group labels fail check `no_overlap`.
#> ✖ `no_overlap`: Example of overlap among values: '0' and 'infant' describe the
#>   same interval.
```

#### Solution

Two different labels, `"0"` and `"infant"`, describe the same age group.
Standardizing the labels makes this visible.

``` r

age_standard(x)
#> [1] "0"   "0"   "1-4" "5+"
```

You will then need to decide what to do about the repeated values. See
[Overlaps in a data frame with repeated age groups](#overlap-df) for one
possible approach.

### Overlaps in a data frame with repeated age groups

#### Problem

[`age_assert_values()`](https://bayesiandemography.github.io/agetime/reference/age_diagnose_levels.md)
reports an overlap in a column of a data frame where each age group
appears once for each sex, region, or year.

``` r

df <- tibble(
  age = c("0-4", "5-9", "0-4", "5-9"),
  sex = c("F", "F", "M", "M")
)
df |>
  mutate(age = age_assert_values(age, no_overlap = TRUE))
#> Error in `mutate()`:
#> ℹ In argument: `age = age_assert_values(age, no_overlap = TRUE)`.
#> Caused by error in `age_assert_values()`:
#> ! Age group labels fail check `no_overlap`.
#> ✖ `no_overlap`: Example of overlap among values: '0-4' appears 2 times. To
#>   allow repeats, such as one per sex, check within groups, for instance using
#>   dplyr::group_by().
```

#### Solution

Check within groups.

``` r

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
```

#### See Also

- Cookbook: [Check labels within groups of a data
  frame](https://bayesiandemography.github.io/agetime/articles/cookbook.html#validate-labels-groups)

### Totals and missing values

#### Problem

A check fails, or a function such as
[`age_extend()`](https://bayesiandemography.github.io/agetime/reference/age_extend.md)
or
[`age_coarsen_to()`](https://bayesiandemography.github.io/agetime/reference/age_coarsen_to.md)
gives an error, because the labels include a total or a missing value.

``` r

x <- c("0-4", "5-9", "Total")
age_assert_values(x, no_total = TRUE)
#> Error in `age_assert_values()`:
#> ! Age group labels fail check `no_total`.
#> ✖ `no_total`: Example among values: 'Total'.
```

#### Solution

Use
[`age_is_total()`](https://bayesiandemography.github.io/agetime/reference/age_is_total.md)
and
[`age_is_missing()`](https://bayesiandemography.github.io/agetime/reference/age_is_missing.md)
to find the labels for totals or missing values. If appropriate, remove
the associated rows.

``` r

df <- tibble(
  age = c("0-4", "5-9", "Total", "Not stated"),
  count = c(10, 20, 35, 5)
)

df |>
  filter(!age_is_total(age), !age_is_missing(age))
#> # A tibble: 2 × 2
#>   age   count
#>   <chr> <dbl>
#> 1 0-4      10
#> 2 5-9      20
```

#### Discussion

[`age_coarsen()`](https://bayesiandemography.github.io/agetime/reference/age_coarsen.md),
[`age_coarsen_five()`](https://bayesiandemography.github.io/agetime/reference/age_coarsen_five.md),
and similar functions keep totals and missing values as separate
categories, so they do not need to be removed first.

#### See Also

- Cookbook: [Drop totals from a
  dataset](https://bayesiandemography.github.io/agetime/articles/cookbook.html#drop-totals)
  and [Drop “Not stated” categories from a
  dataset](https://bayesiandemography.github.io/agetime/articles/cookbook.html#drop-missing)

## Transforming labels

### Coarsening fails

#### Problem

[`age_coarsen()`](https://bayesiandemography.github.io/agetime/reference/age_coarsen.md),
[`age_coarsen_to()`](https://bayesiandemography.github.io/agetime/reference/age_coarsen_to.md),
or one of their variants gives an error.

``` r

x <- c("0-4", "5-9", "12")
age_coarsen(x, breaks = c(0, 7, 10))
#> Error in `age_coarsen()`:
#> ! Can't coarsen age groups.
#> ✖ Age group "5-9" would be split by the new age groups.
#> ℹ "5-9" overlaps "0-6" and "7-9".
#> ✖ Age group "12" is not fully covered by the new age groups.
#> ℹ New age groups cover [0, 10).
#> ℹ Set `open_right = TRUE` to include age groups above 10?
```

#### Solution

The error message distinguishes two problems:

- A label *would be split* when it overlaps two or more new age groups.
  In the case above, `"5-9"` overlaps `"0-6"` and `"7-9"`. When a label
  would be split, move the breaks so that they fall between the old age
  groups.
- A label is *not fully covered* when it lies partly or wholly outside
  the new age groups. In the case above, `"12"` lies above 10. When a
  label is not fully covered, add breaks, or, for
  [`age_coarsen()`](https://bayesiandemography.github.io/agetime/reference/age_coarsen.md),
  set `open_right = TRUE`.

``` r

age_coarsen(x, breaks = c(0, 10), open_right = TRUE)
#> [1] 0-9 0-9 10+
#> Levels: 0-9 10+
```

With
[`age_coarsen_to()`](https://bayesiandemography.github.io/agetime/reference/age_coarsen_to.md),
every label must lie inside one of the labels in `to`. Add labels to
`to`, or remove labels that should not be included.

### Unused levels disappear from tables

#### Problem

You used a `fill` function to add age, period, or cohort levels, but
tidyverse functions
[`count()`](https://dplyr.tidyverse.org/reference/count.html) or
[`summarise()`](https://dplyr.tidyverse.org/reference/summarise.html)
drop these levels if they have no observations.

``` r

df <- tibble(
  age = c("0-4", "10-14", "0-4"),
  respondents = c(10, 20, 5)
) |>
  mutate(age = age_fill(age))

levels(df$age)
#> [1] "0-4"   "5-9"   "10-14"

df |>
  count(age)
#> # A tibble: 2 × 2
#>   age       n
#>   <fct> <int>
#> 1 0-4       2
#> 2 10-14     1
```

#### Solution

Tidyverse functions drop unused factor levels by default. Use
`.drop = FALSE` to retain the unused levels.

``` r

df |>
  count(age, .drop = FALSE)
#> # A tibble: 3 × 2
#>   age       n
#>   <fct> <int>
#> 1 0-4       2
#> 2 5-9       0
#> 3 10-14     1

df |>
  group_by(age, .drop = FALSE) |>
  summarise(respondents = sum(respondents))
#> # A tibble: 3 × 2
#>   age   respondents
#>   <fct>       <dbl>
#> 1 0-4            15
#> 2 5-9             0
#> 3 10-14          20
```

#### See Also

- Cookbook: [Include levels that don’t appear in the
  data](https://bayesiandemography.github.io/agetime/articles/cookbook.html#fill-levels)

### Results are factors, not character vectors

#### Problem

[`age_coarsen()`](https://bayesiandemography.github.io/agetime/reference/age_coarsen.md),
[`age_fill()`](https://bayesiandemography.github.io/agetime/reference/age_fill.md),
[`age_set_open_right()`](https://bayesiandemography.github.io/agetime/reference/age_set_open_right.md),
and
[`age_set_order()`](https://bayesiandemography.github.io/agetime/reference/age_set_order.md)
return factors. They do this because factor levels can contain useful
information, such as labels that do not appear in the data. But
sometimes the task calls for a character vector, not a factor.

``` r

x <- c("0", "1-4", "5-9")
x |>
  age_coarsen_five()
#> [1] 0-4 0-4 5-9
#> Levels: 0-4 5-9
```

#### Solution

Call [`as.character()`](https://rdrr.io/r/base/character.html) on the
result.

``` r

x |>
  age_coarsen_five() |>
  as.character()
#> [1] "0-4" "0-4" "5-9"
```

### Midpoints of open age groups

#### Problem

[`age_mid()`](https://bayesiandemography.github.io/agetime/reference/age_lower.md)
gives an error for an open age group within a grouped calculation.

``` r

df <- tibble(
  sex = c("F", "F", "M"),
  age = c("80-84", "85+", "85+")
)

df |>
  group_by(sex) |>
  mutate(mid = age_mid(age))
#> Error in `mutate()`:
#> ℹ In argument: `mid = age_mid(age)`.
#> ℹ In group 2: `sex = "M"`.
#> Caused by error in `age_mid()`:
#> ! Can't calculate midpoint of open age group "85+".
#> ℹ No closed age groups to take a width from.
```

#### Solution

[`age_mid()`](https://bayesiandemography.github.io/agetime/reference/age_lower.md)
gives an open age group a midpoint based on the width of the nearest
closed age group. In the group `sex = "M"`, there is no closed age
group. Calculate midpoints before grouping.

``` r

df |>
  mutate(mid = age_mid(age))
#> # A tibble: 3 × 3
#>   sex   age     mid
#>   <chr> <chr> <dbl>
#> 1 F     80-84  82.5
#> 2 F     85+    87.5
#> 3 M     85+    87.5
```

## More information

- [Get
  started](https://bayesiandemography.github.io/agetime/articles/agetime.md)
  for a quick start
- [Cookbook](https://bayesiandemography.github.io/agetime/articles/cookbook.md)
  for task-oriented recipes
