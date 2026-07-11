# API principles

**agetime** functions are designed around label vectors. A label such as
`"5-9"`, `"2020-2025"`, or `"<1990"` is a character value, but it also
implies an interval. The API tries to make this distinction explicit:
some functions read intervals from existing labels, some functions
create new labels, and some functions work with factor levels.

## Domain prefixes

Most functions start with a domain:

- `age_*()` for age groups.
- `period_*()` for time periods.
- `cohort_*()` for birth cohorts.

The three domains usually share the same operation names. For example,
[`age_lower()`](https://bayesiandemography.github.io/agetime/reference/age_lower.md),
[`period_lower()`](https://bayesiandemography.github.io/agetime/reference/period_lower.md),
and
[`cohort_lower()`](https://bayesiandemography.github.io/agetime/reference/cohort_lower.md)
all extract lower limits from labels.

``` r

library(agetime)

age_lower(c("0-4", "5-9"))
#> 0-4 5-9 
#>   0   5
period_lower(c("2020-2025", "2025-2030"))
#> 2020-2025 2025-2030 
#>      2020      2025
cohort_lower(c("<1990", "1990-1995"))
#>     <1990 1990-1995 
#>      -Inf      1990
```

## Operation families

Function names use the domain prefix plus an operation family.

| Family | Purpose | Return type |
|----|----|----|
| `*_lower()`, `*_upper()`, `*_width()`, `*_mid()` | Extract interval properties | Numeric vector |
| `*_is_open_left()`, `*_is_open_right()`, `*_is_total()` | Identify special labels | Logical vector |
| `*_check()`, `*_assert()` | Validate labels | Diagnostics or error |
| `*_standard()` | Convert labels to standard format | Same shape as `labels` |
| `*_modify()` | Regroup labels into new intervals | Factor |
| `*_extend()` | Continue a label series | Character vector or factor |
| `*_fill()`, `*_set_open_*()`, `*_sort()` | Work with factor levels | Factor |
| `*_labels_*()` | Create new labels | Character vector |
| `*_mapping()` | Map between interval sets | Matrix or tibble |

The most important return-type distinction is between labels and levels:

- `*_labels_*()` functions create character vectors of labels.
- `*_modify()`, `*_fill()`, `*_set_open_*()`, and `*_sort()` functions
  return factors, because their purpose is to recode values and shape
  factor levels.

``` r

age_labels_five(lower_last = 20)
#> [1] "0-4"   "5-9"   "10-14" "15-19" "20+"

age_modify(c("10-14", "0-4"), breaks = c(0, 10, 20))
#> [1] 10-19 0-9  
#> Levels: 0-9 10-19
age_fill_five(c("10-14", "0-4"))
#> [1] 10-14 0-4  
#> Levels: 0-4 5-9 10-14
```

## Input parsing and output rendering

The main input argument is called `labels` when it is a vector of age,
period, or cohort labels. Arguments beginning with `interpret_` describe
how existing input labels should be parsed. They do not describe how
newly generated output labels should be rendered.

Age labels follow a strong demographic convention: one-year labels use
the lower boundary, and multi-year labels exclude the upper boundary.
Age functions therefore do not expose `interpret_single` or
`interpret_multi` arguments. Period and cohort labels do not have the
same universal convention, so period and cohort functions let you
specify how input labels should be parsed.

For example,
[`period_standard()`](https://bayesiandemography.github.io/agetime/reference/period_standard.md)
uses `interpret_multi` to interpret the input:

``` r

period_standard("2020-2025", interpret_multi = "exclude")
#> [1] "2020-2026"
```

Arguments beginning with `format_` describe how new output labels should
be rendered. For example,
[`period_labels_ten()`](https://bayesiandemography.github.io/agetime/reference/period_labels.md)
uses `format_multi` to decide whether the displayed upper limit is
included or excluded:

``` r

period_labels_ten(
  lower_first = 2000,
  lower_last = 2020,
  format_multi = "exclude"
)
#> [1] "2000-2009" "2010-2019" "2020-2029"
```

This convention is intended to keep input interpretation separate from
output formatting.

## Boundary names

Boundary arguments name the boundary they represent.

- `breaks` are boundaries between intervals.
- `lower_first` is the lower bound of the first generated interval.
- `lower_last` is the lower bound of the last generated interval.
- `at` is the breakpoint at which intervals become open, e.g. `70` in
  `70+` or `1990` in `<1990`. The function name specifies whether
  intervals open on the left or right.

``` r

age_labels_five(lower_first = 0, lower_last = 20, open_right = FALSE)
#> [1] "0-4"   "5-9"   "10-14" "15-19" "20-24"

age_set_open_right(c("0-4", "60-64"), at = 70)
#> [1] 0-4   60-64
#> Levels: 0-4 60-64 70+

cohort_set_open_left(
  c("2000-2004", "2010-2014"),
  at = 1990,
  interpret_multi = "exclude"
)
#> [1] 2000-2004 2010-2014
#> Levels: <1990 2000-2004 2010-2014
```

The boolean arguments `open_left` and `open_right` control whether to
include open intervals at the start or end of a generated label
sequence. Age groups support `open_right` only; periods and cohorts
support both directions.

In `*_labels_*()` functions, these arguments default to explicit boolean
values because you are constructing a new label grid. In `*_modify()`
functions, the defaults are `NULL`, which preserves the open/closed
topology of `labels`: open ends are kept when present, and omitted when
not. Use `open_left = TRUE` or `open_right = TRUE` to add a structural
open level even when no value in `labels` currently belongs to that
group.

## Values and levels

Functions such as
[`age_modify()`](https://bayesiandemography.github.io/agetime/reference/age_modify.md),
[`age_fill()`](https://bayesiandemography.github.io/agetime/reference/age_fill.md),
[`age_set_open_right()`](https://bayesiandemography.github.io/agetime/reference/age_set_open_right.md),
and
[`age_sort()`](https://bayesiandemography.github.io/agetime/reference/age_sort.md)
always return a factor. They preserve observed values where possible,
and change or add levels. By default,
[`age_modify()`](https://bayesiandemography.github.io/agetime/reference/age_modify.md)
infers whether to include an open top from `labels`. Use
`open_right = TRUE` to add a `90+` level even when no value in `labels`
currently belongs to that open group, as
[`age_set_open_right()`](https://bayesiandemography.github.io/agetime/reference/age_set_open_right.md)
does for `70+`.

``` r

labels <- c("0-4", "60-64")
age_modify(labels, breaks = c(0, 50, 70), open_right = TRUE)
#> [1] 0-49  50-69
#> Levels: 0-49 50-69 70+
```

## More information

- See
  [`vignette("agetime")`](https://bayesiandemography.github.io/agetime/articles/agetime.md)
  for a quick start.
- See
  [`?agetime`](https://bayesiandemography.github.io/agetime/reference/agetime-package.md)
  for a complete function list grouped by task.
