# Convert to New Age Groups

Modify the age groups used by `x`. The the new age groups must contain
the old ones.

## Usage

``` r
age_modify(x, breaks, open = TRUE, x_fail = c("error", "warn", "silent"))
```

## Arguments

- x:

  Vector of age group labels.

- breaks:

  Boundaries between age groups. A numeric vector.

- open:

  Whether the oldest age group is "open", i.e. has no upper limit.
  Default is `TRUE`.

- x_fail:

  Action if element of `x` cannot be parsed: `"error"` (the default),
  `"warn"`, or `"silent"`.

## Value

Character vector or factor with the same length as `x`.

## See also

- [`age_modify_five()`](https://bayesiandemography.github.io/agetime/reference/age_modify_five.md)
  Convert to 5-year age groups

- [`age_modify_ten()`](https://bayesiandemography.github.io/agetime/reference/age_modify_five.md)
  Convert to 10-year age groups

- [`age_modify_life()`](https://bayesiandemography.github.io/agetime/reference/age_modify_five.md)
  Convert to life table age groups

- [`period_modify()`](https://bayesiandemography.github.io/agetime/reference/period_modify.md)
  Period equivalent of `age_modify()`

- [`cohort_modify()`](https://bayesiandemography.github.io/agetime/reference/cohort_modify.md)
  Cohort equivalent of `age_modify()`

## Examples

``` r
x <- c("1-4", "87-89", "0", "50-54")
age_modify(x, breaks = c(0, 10, 40, 90))
#> [1] "0-9"   "40-89" "0-9"   "40-89"
age_modify(x, breaks = c(0, 10, 40, 90), open = FALSE)
#> [1] "0-9"   "40-89" "0-9"   "40-89"

## factor input: factor in, factor out
age_modify(factor(c("0-4", "5-9")), breaks = c(0, 10, 90))
#> [1] 0-9 0-9
#> Levels: 0-9 10-89 90+
```
