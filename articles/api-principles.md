# API principles

`agetime` functions are designed around label vectors. A label such as
`"5-9"`, `"2020-2025"`, or `"<1990"` is a character value, but it also
implies an interval. The API tries to make this distinction explicit:
some functions read intervals from existing labels, some functions
create new labels, and some functions work with factor levels.

## Domain prefixes

Most functions start with a domain:

- `age` for age groups
- `period` for time periods
- `cohort` for birth cohorts

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

A few operations are domain-specific:

- Open intervals on the left (`is_open_left`, `set_open_left`) exist for
  periods and cohorts only. Ages open on the right only.
- Life-table helpers (`labels_life`, `coarsen_life`, `fill_life`, and
  the `valid_life` diagnose check) exist for ages only.

See
[`?agetime`](https://bayesiandemography.github.io/agetime/reference/agetime-package.md)
for the full inventory, including blank cells where a domain has no
equivalent.

## Operation families

Function names use the domain prefix plus an operation family.

| Family | Purpose | Return type |
|----|----|----|
| `lower`, `upper`, `width`, `mid` | Extract interval properties | Numeric vector |
| `is_open_left`, `is_open_right`, `is_total`, `is_missing`, `is_subtotal` | Identify special labels | Logical vector |
| `diagnose`, `assert` | Validate labels (factor levels by default) | List with `ok`, or `labels` / error |
| `diagnose_values`, `assert_values` | Validate observed values only | List with `ok`, or `labels` / error |
| `standard` | Convert labels to standard format | Same type and length as `labels` |
| `coarsen`, `coarsen_to` | Regroup labels into new intervals | Factor |
| `extend` | Continue a label series | Character vector or factor |
| `fill`, `set_open_left`, `set_open_right`, `set_order` | Work with factor levels | Factor |
| `labels` | Create new labels | Character vector |
| `mapping` | Map between interval sets | Tibble or matrix |

The most important return-type distinction is between labels and levels:

- The `labels` functions create character vectors of labels.
- The `coarsen`, `fill`, `set_open_left`, `set_open_right`, and
  `set_order` functions return factors, because their purpose is to
  recode values and shape factor levels.

``` r

age_labels_five(lower_last = 20)
#> [1] "0-4"   "5-9"   "10-14" "15-19" "20+"

age_coarsen(c("10-14", "0-4"), breaks = c(0, 10, 20))
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
same universal convention, so period and cohort functions that *consume*
labels (for example
[`period_standard()`](https://bayesiandemography.github.io/agetime/reference/period_standard.md)
or
[`cohort_coarsen()`](https://bayesiandemography.github.io/agetime/reference/cohort_coarsen.md))
let you specify how inputs should be parsed. The period and cohort
`labels` constructors do not take `interpret_` arguments; they create
new labels instead.

For example,
[`period_standard()`](https://bayesiandemography.github.io/agetime/reference/period_standard.md)
uses `interpret_multi` to interpret the input:

``` r

period_standard("2020-2025", interpret_multi = "exclude")
#> [1] "2020-2026"
```

Label-consuming functions also take `interpret_fail`, which controls
what happens when a label cannot be parsed (`"error"`, `"warn"`, or
`"silent"`).

Arguments beginning with `format_` describe how new output labels should
be rendered. Only the period and cohort `labels` constructors expose
`format_single` and `format_multi`. Age `labels` functions hard-code the
usual demographic conventions. For example,
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

This convention keeps input interpretation separate from output
formatting. (The `mapping` functions use a different argument named
`format`, which chooses between a tibble and a matrix return value.)

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

In the `labels` functions, these arguments default to explicit boolean
values because you are constructing a new label grid. In the `coarsen`
functions, the defaults are `NULL`, which preserves the open/closed
topology of `labels`: open ends are kept when present, and omitted when
not. Use `open_left = TRUE` or `open_right = TRUE` to add a structural
open level even when no value in `labels` currently belongs to that
group.

## Values and levels

Functions such as
[`age_coarsen()`](https://bayesiandemography.github.io/agetime/reference/age_coarsen.md),
[`age_fill()`](https://bayesiandemography.github.io/agetime/reference/age_fill.md),
[`age_set_open_right()`](https://bayesiandemography.github.io/agetime/reference/age_set_open_right.md),
and
[`age_set_order()`](https://bayesiandemography.github.io/agetime/reference/age_set_order.md)
always return a factor. They preserve observed values where possible,
and change or add levels. By default,
[`age_coarsen()`](https://bayesiandemography.github.io/agetime/reference/age_coarsen.md)
infers whether to include an open top from `labels`. Use
`open_right = TRUE` to add an open level even when no value in `labels`
currently belongs to that open group, as
[`age_set_open_right()`](https://bayesiandemography.github.io/agetime/reference/age_set_open_right.md)
does:

``` r

labels <- c("0-4", "60-64")
age_coarsen(labels, breaks = c(0, 50, 70), open_right = TRUE)
#> [1] 0-49  50-69
#> Levels: 0-49 50-69 70+
```

The `diagnose` and `assert` functions follow the same levels contract:
for a factor they validate levels, including unused ones. Use the
`diagnose_values` and `assert_values` functions when you want to check
only observed values (for example in a grouped pipeline). The `assert`
functions return `labels` invisibly when checks pass, so they can sit in
a pipeline.

## More information

- See
  [`vignette("agetime")`](https://bayesiandemography.github.io/agetime/articles/agetime.md)
  for a quick start.
- See
  [`vignette("cookbook")`](https://bayesiandemography.github.io/agetime/articles/cookbook.md)
  for task-oriented recipes.
- See
  [`?agetime`](https://bayesiandemography.github.io/agetime/reference/agetime-package.md)
  for a complete function list grouped by task.
