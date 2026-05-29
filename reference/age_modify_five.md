# Convert to Specialised Age Groups

Modify the age groups used by `x`. The new age groups must contain the
old age groups, and follow a regular pattern:

- `age_modify_five` Five-year age groups

- `age_modify_ten` Ten-year age groups

- `age_modify_life` Age groups used in 'abridged' life tables

## Usage

``` r
age_modify_five(x, x_fail = c("error", "warn", "silent"))

age_modify_ten(x, x_fail = c("error", "warn", "silent"))

age_modify_life(x, x_fail = c("error", "warn", "silent"))
```

## Arguments

- x:

  Vector of age group labels.

- x_fail:

  Action if element of `x` cannot be parsed: `"error"` (the default),
  `"warn"`, or `"silent"`.

## Value

A vector the same length as `x` with modified labels.

If `x` is a character vector, returns a character vector. When
`length(x) == 0`, returns `character(0)`.

If `x` is a factor, returns a factor with the same length and `ordered`
attribute as `x`. Element values are mapped to the new age groups and
[`levels()`](https://rdrr.io/r/base/levels.html) is the full label set
defined by `breaks` (and `open`, where relevant). When `length(x) == 0`,
`levels(x)` are still modified.

## Details

When `length(x) == 0` and `x` is a factor with no levels, `x` is
returned unchanged (there is no range from which to infer new groups).

## See also

[`age_modify()`](https://bayesiandemography.github.io/agetime/reference/age_modify.md)
Convert to general age groups
[`period_modify_five()`](https://bayesiandemography.github.io/agetime/reference/period_modify_five.md)
Period equivalent of `age_modify_five()`
[`period_modify_ten()`](https://bayesiandemography.github.io/agetime/reference/period_modify_five.md)
Period equivalent of `age_modify_ten()`
[`cohort_modify_five()`](https://bayesiandemography.github.io/agetime/reference/cohort_modify_five.md)
Cohort equivalent of `age_modify_five()`
[`cohort_modify_ten()`](https://bayesiandemography.github.io/agetime/reference/cohort_modify_five.md)
Cohort equivalent of `age_modify_ten()` age_levels_fill()\] Add levels
for intermediate age groups

## Examples

``` r
x <- c("1-3", "87-89", "0", "91+", "total", "52")
age_modify_five(x)
#> [1] "0-4"   "85-89" "0-4"   "90+"   "Total" "50-54"
age_modify_ten(x)
#> [1] "0-9"   "80-89" "0-9"   "90+"   "Total" "50-59"
age_modify_life(x)
#> [1] "1-4"   "85-89" "0"     "90+"   "Total" "50-54"
```
