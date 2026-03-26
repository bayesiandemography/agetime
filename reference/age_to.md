# Convert Age Group Labels to New Format

Convert Age Group Labels to New Format

## Usage

``` r
age_to(
  x,
  breaks,
  open = TRUE,
  include_total = NULL,
  include_na = NULL,
  unknown_label = c("error", "warn", "silent")
)
```

## Arguments

- x:

  Vector of age group labels.

- breaks:

  Boundaries between age groups. A numeric vector.

- open:

  Whether the oldest age group is "open", i.e. has no upper limit.
  Default is `TRUE`.

- include_total:

  Whether to include a `"Total"` category.

- include_na:

  Whether to include an `NA` category.

- unknown_label:

  Action if meaning of label unclear. Choices are `"error"` (the
  default), `"warn"`, and `"silent"`.

## Value

A factor with the same length as `x`.

## Examples

``` r
x <- factor(c("1-4", "87-89", "50-54"))
age_to(x, breaks = c(0, 50, 90))
#> [1] 0-49  50-89 50-89
#> Levels: 0-49 50-89 90+
```
