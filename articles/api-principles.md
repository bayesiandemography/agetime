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
| `*_is_open()`, `*_is_total()` | Identify special labels | Logical vector |
| `*_check()`, `*_assert()` | Validate labels | Diagnostics or error |
| `*_standard()` | Convert labels to standard format | Same shape as `labels` |
| `*_modify()` | Regroup labels into new intervals | Same shape as `labels` |
| `*_extend()` | Continue a label series | Character vector or factor |
| `*_levels_*()` | Work with factor levels | Factor |
| `*_labels_*()` | Create new labels | Character vector |
| `*_mapping()` | Map between interval sets | Matrix or tibble |

The most important return-type distinction is between labels and levels:

- `*_labels_*()` functions create character vectors of labels.
- `*_levels_*()` functions return factors, because their purpose is to
  create or reorder factor levels.

``` r

age_labels_five(lower_last = 20)
#> [1] "0-4"   "5-9"   "10-14" "15-19" "20+"

age_levels_fill_five(c("10-14", "0-4"))
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
- `lower_open` is the lower bound of a right-open age group such as
  `70+`.
- `upper_open` is the upper bound of a left-open cohort such as `<1990`.

``` r

age_labels_five(lower_first = 0, lower_last = 20, open = FALSE)
#> [1] "0-4"   "5-9"   "10-14" "15-19" "20-24"

age_levels_set_open(c("0-4", "60-64"), lower_open = 70)
#> [1] 0-4   60-64
#> Levels: 0-4 60-64 70+

cohort_levels_set_open(
  c("2000-2004", "2010-2014"),
  upper_open = 1990,
  interpret_multi = "exclude"
)
#> [1] 2000-2004 2010-2014
#> Levels: <1990 2000-2004 2010-2014
```

The boolean argument `open` is used where the question is whether to
include an open interval at all. Boundary names such as `lower_open` and
`upper_open` are used where the question is where the open interval
starts or ends.

## Values and levels

Functions that modify values, such as
[`age_modify()`](https://bayesiandemography.github.io/agetime/reference/age_modify.md),
return values with the same length as `labels`. If `labels` is a factor,
they also update levels.

Functions in the `*_levels_*()` family always return a factor. They
preserve observed values where possible, and change or add levels. This
is why
[`age_levels_set_open()`](https://bayesiandemography.github.io/agetime/reference/age_levels_set_open.md)
can add a `70+` level even when no value in `labels` currently belongs
to that open group.

``` r

labels <- c("0-4", "60-64")
age_levels_set_open(labels, lower_open = 70)
#> [1] 0-4   60-64
#> Levels: 0-4 60-64 70+
```

## More information

- See
  [`vignette("agetime")`](https://bayesiandemography.github.io/agetime/articles/agetime.md)
  for a quick start.
- See
  [`?agetime`](https://bayesiandemography.github.io/agetime/reference/agetime-package.md)
  for a complete function list grouped by task.
