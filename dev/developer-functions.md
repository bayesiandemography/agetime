# Proposal: developer-level (dot) functions

Status: proposed, for discussion. Nothing built.
Date: 23 November 2026.

## Purpose

agetime has two audiences:

- **users**, working interactively or in scripts, often with data frames;
- **package developers**, calling agetime from inside their own functions
  (popcounts, dac, and later others), usually on vectors they have already
  extracted, and on behalf of their own users.

The user-facing interface is designed for the first audience. The
data-frame validation spec (dev/df-values-validation-spec.md) removed the
vector values functions (`age_assert_values()` and relatives) because
dividing a vector into groups by hand is easy to get wrong, and the
data-frame functions handle grouping for users. That reasoning holds for
users, and the change stays.

Developers have different needs. They usually hold exactly the vector they
mean to check (one date's age labels, a standard's age column), so grouping
does not arise; and the user-facing messages include hints for agetime's
own users ("Checking the whole dataset", "Use `age_df_diagnose_values()` to
report checks for every group"), which mislead the users of the calling
package, who never called agetime. popcounts currently works around this
with an internal wrapper (`assert_age_labels()`: wraps a vector in a data
frame, calls `age_df_diagnose_values()`, and rebuilds the error); dac would
need the same wrapper. Two copies of one wrapper is a sign it belongs here.

## Proposal

A small, separate tier of **developer-level functions**, marked by a
leading dot:

- **Exported**, so other packages can call them with `agetime::`.
- **Out of beginners' way:** the dot hides them from tab completion and
  `ls()`; their help pages say they are for package developers and point
  to the user-facing equivalent; they are listed in their own section of
  the pkgdown reference ("Developer functions"), or not at all (Q2).
- **Vectors in, vectors out:** no data frames, no grouping, no tidyselect.
- **Messages for the end user of the calling package** (global principle:
  functions that take `call` must not give hints naming agetime's own
  functions unless the user called them directly). Errors name `x_arg` and
  the caller's `call`, and give no hints about agetime's interface.
- **Classed errors** (see "Error classes" below), so that callers can
  handle failures without parsing message text.
- **Thin:** built on the same internals as the user-facing functions, so
  results agree and the maintenance cost is small. A dot function adds an
  interface, not new behaviour.
- **Stable:** once released, developer functions change only with notice,
  since other packages depend on them.

## First function

```r
.age_assert_values(labels,
                   no_overlap = FALSE, no_gap = FALSE, no_total = FALSE,
                   no_subtotal = FALSE, no_missing = FALSE, no_open_right = FALSE,
                   has_total = FALSE, has_subtotal = FALSE, has_missing = FALSE,
                   has_open_right = FALSE, has_zero = FALSE,
                   valid_life = FALSE, valid_tree = FALSE,
                   interpret_fail = c("error", "warn", "silent"),
                   x_arg = rlang::caller_arg(labels),
                   call = rlang::caller_env())
```

- `labels`: character or factor. Observed values are checked, repeats
  included (so `no_overlap` sees repeated labels), as in the removed
  `age_assert_values()`.
- Returns `labels` invisibly, or raises a classed error.
- `call` defaults to the **caller's** environment, not the function's own:
  a developer function is always called from another function, so its
  errors should name that function.
- Messages as in the former vector function: "Age group labels in `age`
  fail check `valid_tree`", one `x` bullet per failed condition, with no
  data-frame hints.

The checks are the same set as `age_df_assert_values()`, with the same
meanings; for each check, `.age_assert_values(x)` must agree with
`age_df_assert_values(data.frame(age = x), age = age, by = NULL)` (a test).

popcounts' `assert_age_labels()` would then be replaced by direct calls.

## Error classes

The user-facing assertion functions and the dot functions raise errors
with classes, for instance:

| Class | When | Fields |
|---|---|---|
| `agetime_error_check` | one or more requested conditions fail | `checks` (names of failed conditions), `comments` (one per failed condition), `group` (group keys, data-frame functions only) |
| `agetime_error_interpret` | labels cannot be parsed | `labels` (the labels that failed) |

Raised with `rlang::abort(message, class = ..., <fields>)`. Callers can
catch them (`tryCatch(..., agetime_error_check = function(cnd) ...)`) and
reword or rethrow; tests use `expect_error(class = ...)`. The user-facing
functions keep their hints, shown only when called directly (when `call`
is left at its default), and only where they help (the group line only when
there are groups). To be done before the first release (user, 2026-11-23).

## Future dot functions

The user expects more developer-level functions later. Criteria for adding
one:

1. At least one other package needs it, and would otherwise write a
   wrapper around a user-facing function.
2. The user-facing function's interface is wrong for developers (data
   frames where developers hold vectors; hints aimed at agetime users;
   checks or parsing a developer has already done), not just inconvenient.
3. It can be a thin layer over existing internals.

Possible candidates, none needed yet: `.period_assert_values()` and
`.cohort_assert_values()` (when a dependant checks periods or cohorts);
functions that take labels already standardised and skip parsing, if
profiling shows parsing matters in a hot loop.

Once agreed, a short "Developer-level functions" section goes into
dev/api-principles.md, with the rules above.

## Questions

- **Q1. Domains.** Add `.age_assert_values()` only (all a dependant needs
  now), or `.period_assert_values()` and `.cohort_assert_values()` as well,
  for symmetry across the three domains (api-principles: domains share
  operation names wherever possible)?
- **Q2. Documentation.** Help pages with `@keywords internal` (exported,
  documented, absent from the pkgdown reference), or a visible
  "Developer functions" section in the reference?
- **Q3. A diagnose version.** Is `.age_diagnose_values()` (returning the
  report, no error) needed, or does the classed error from
  `.age_assert_values()` cover what developers need?
- **Q4. Order.** Error classes first (they shape the dot function's
  errors), then `.age_assert_values()`; or the dot function first, since
  popcounts and dac need it now, with classes added to it and the
  user-facing functions together before release?
