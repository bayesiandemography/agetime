# Make Mapping Between Age Labels

Include the pair (x_i, y_j) in the mapping if a person or event included
in x_i could, in principle, be included in y_j.

## Usage

``` r
age_mapping(
  x,
  y,
  x_complete = NULL,
  y_complete = NULL,
  x_unique = NULL,
  y_unique = NULL,
  check = c("error", "warn"),
  return_val = c("data.frame", "matrix"),
  invalid = c("error", "warn", "silent")
)
```

## Arguments

- x, y:

  Vectors of age group labels.

- x_complete:

  Each label in `x` maps to at least one label in `y`

- y_complete:

  Each label in `y` maps to at least one label in `x`

- x_unique:

  Each label in `x` maps to at most one label in `y`

- y_unique:

  Each label in `y` maps to at most one label in `x`

- check:

  Action if condition specified by `x_complete`, `y_complete`,
  `x_unique`, or `y_unique` is not met. The choices are `"error"` (the
  default) or `"warn"`.

- return_val:

  The format of the return value. The choices are `"data.frame"` (the
  default) or `"matrix"`.

- invalid:

  Action if a label cannot be interpreted. Choices are `"error"` (the
  default), `"warn"`, and `"silent"`.

## Value

A data.frame or matrix

## Details

If x_i is total or NA, then all pairs involving x_i are included in the
mapping.

If y_j is total or NA, then all pairs involving y_j are included in the
mapping.
