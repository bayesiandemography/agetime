# API principles for agetime

Notes for developers. This file describes the conventions that the
`agetime` interface follows, so that new functions and changes stay
consistent with existing ones. It is not part of the installed package.
User-facing explanations belong in help pages and vignettes.

## Domains and operations

Function names combine a domain prefix (`age`, `period`, `cohort`) with an
operation (`lower`, `standard`, `coarsen`, ...). The three domains share
operation names wherever possible.

Some operations exist only in some domains:

- Open-left intervals (`is_open_left`, `set_open_left`, `open_left`) exist
  for periods and cohorts only.
- Life-table helpers (`labels_life`, `coarsen_life`, `fill_life`,
  `valid_life`) exist for ages only.

## Return types

| Operation | Return type |
|---|---|
| `lower`, `upper`, `width`, `mid` | Numeric, same length as `labels` |
| `is_*` | Logical, same length as `labels` |
| `standard`, `extend` | Same type as `labels` (character or factor) |
| `labels` | Character |
| `coarsen`, `coarsen_to`, `fill`, `set_open_*`, `set_order` | Factor |
| `diagnose`, `diagnose_values` | List with `ok` and a `details` tibble |
| `assert`, `assert_values` | `labels`, invisibly, or an error |
| `mapping` | Tibble or matrix |

- Functions that set or recode levels always return factors, so that
  levels, including unused ones, are kept in order.
- Element-wise results (`lower`, `is_*`, and so on) keep the names of
  `labels`, if any, as base R functions such as `nchar()` do. They do not
  add names.

## Labels and levels

For factors, `diagnose` and `assert` check levels, including unused
levels. The `_values` variants check only the values present.

## Arguments

- The main input is `labels`.
- `interpret_*` arguments describe how input labels are parsed.
  `format_*` arguments describe how new labels are written. Age labels
  follow a fixed convention, so age functions have neither.
- `interpret_fail` (`"error"`, `"warn"`, `"silent"`) controls unparsable
  labels in every function that reads labels.
- Boundary arguments are named after the boundary: `breaks`,
  `lower_first`, `lower_last`, and `at` (where intervals become open).
- `open_left` and `open_right` default to explicit values in `labels`
  functions, and to `NULL` in `coarsen` functions, where `NULL` keeps the
  open ends that `labels` already has.
- `interpret_multi` defaults to `NULL`, which behaves like `"at_upper"`
  but gives a message for multi-year labels with widths of 4, 9, 14, ...
  years. Exported functions resolve it with `resolve_interpret_multi()`,
  passing every set of labels the call reads, so the message appears
  at most once per call. Internal functions always receive
  `"at_upper"` or `"below_upper"`.

## Parsing labels

Parsing has two stages: a chain of normalizers rewrites the text, and a
small set of parsers converts the result to intervals. Each domain turns
normalizers on or off with flags in `make_labels_normalizers_*()`. New
formats should normally be supported by adding a normalizer or widening a
pattern, not by changing the parsers.

Rules that new formats must follow:

- Words for open intervals refer to the one-year label next to them;
  symbols refer to boundaries. So `"before 2000"` ends at the lower limit
  of `"2000"`, `"2000 or earlier"` and `"up to 2000"` end at its upper
  limit, and `"2000 or more"` starts at its lower limit, while `"<2000"`
  and `"2000+"` are always the boundary 2000. For periods and cohorts, the
  limits of `"2000"` depend on `interpret_single`.
- For ages, `"Under N"`, `"less than N"`, and `"<N"` are the closed
  interval `[0, N)`, since ages cannot be negative.
- `"older"` and `"younger"` are recognized for ages only. For cohorts, an
  older cohort is an earlier one.
- Different labels for the same interval, such as `"0"` and `"infant"`, are
  synonyms. They are merged when parsing, and count as overlapping in
  `no_overlap`.
- Labels with decimals are not recognized.

## Open intervals

- The width of an open interval is `Inf`.
- The midpoint of an open interval uses half the width of the nearest
  closed interval. If there are no closed intervals, `mid` functions throw
  an error.

## Errors

- Errors report the function the user called. Internal helpers pass
  `call = user_frame()` to `cli::cli_abort()`.
- Messages name the problem and suggest a fix, using cli bullets. For
  instance, coarsening errors say whether a label would be split or is not
  fully covered, and assertion errors list each failed condition.
- Parse messages quote labels as the user supplied them, not their
  normalized forms. `intervals_inner()` passes the original label to
  `x_label()` as `label_orig`.

## Implementation conventions

- Use vctrs functions, such as `vctrs::vec_rbind()`, rather than base
  equivalents, so that code works with rvecs.
- Pass information between functions as arguments, not as attributes.
- Imports are kept to cli, tibble, and vctrs.
- Examples, vignettes, and tests use packages in Suggests unconditionally.
