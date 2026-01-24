# Make a Mapping Between Two Sets of Labels

Include the pair (x_i, y_j) in the mapping if a person or event included
in x_i could, in principle, be included in y_j.

## Usage

``` r
make_mapping(
  obj1,
  obj2,
  x_complete,
  y_complete,
  x_unique,
  y_unique,
  check,
  return_val
)
```

## Arguments

- obj1, obj2:

  Objects of class "agetime_intervals" constructed from two label
  vectors

- return_val:

  "data.frame" or "

- relationship:

  Type of relationship expected, or NULL

## Details

If x_i is total or na, then all pairs involving x_i are included in the
mapping.

If y_j is total or na, then all pairs involving y_j are included in the
mapping.
