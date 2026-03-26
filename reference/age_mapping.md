# Make Mapping Between Age Labels

Make Mapping Between Age Labels

## Usage

``` r
age_mapping(
  x,
  y = NULL,
  relation = c("equals", "contains", "contained", "overlaps"),
  return_val = c("data.frame", "matrix"),
  unknown_label = c("error", "warn", "silent")
)
```

## Arguments

- x:

  Vector of age group labels.

- y:

  Vector of age group labels. If no value supplied, `x` is mapped with
  itself.

- relation:

  `"equals"` (the default), `"contains"` `"contained"`, or `"overlaps"`

- return_val:

  The format of the return value. The choices are `"data.frame"` (the
  default) or `"matrix"`.

- unknown_label:

  Action if meaning of label unclear. Choices are `"error"` (the
  default), `"warn"`, and `"silent"`.

## Value

A data.frame or matrix

## The `relation` argument

- `"equals"`. `x` equals `y`. Lower limit of `x` = lower limit `y`, and
  upper limit of `x` = upper limit of `y`.

- `"contains"`. `x` contains `y`. Lower limit of `x` \<= lower limit of
  `y`, and upper limit of `x` \>= upper limit of `y`.

- `"contained"`. `x` is contained by `y`. Lower limit of `x` \>= lower
  limit of `y`, and Upper limit of `x` \<= upper limit of `y`.

- `"overlaps"`. `x` overlaps `y`. Lower limit of `y` \<= lower limit of
  `x` \< upper limit of `y`, or lower limit of `y` \<= upper limit of
  `x` \< upper limit of `y`, or both.
