# Proposal: developer-level (dot) functions

Status: agreed (answers 2026-11-24); implementation outline below, for
agreement. Nothing built.
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

## Answers (2026-11-24)

- **A1.** All three domains: age, period and cohort.
- **A2.** List them in the pkgdown reference with the other functions, no
  special header. Each help page says, near the top, that the function is
  for package developers, and points to the user-facing equivalent.
- **A3.** Include diagnose functions as well.
- **A4.** Do both now (error classes and dot functions), before returning
  to popcounts and dac.

So there are six functions:

| Age | Period | Cohort |
|---|---|---|
| `.age_diagnose_values()` | `.period_diagnose_values()` | `.cohort_diagnose_values()` |
| `.age_assert_values()` | `.period_assert_values()` | `.cohort_assert_values()` |

## Implementation outline

Small steps, each with its own tests and commit. No version bump or NEWS
entry (pre-release, user 2026-11-23).

### Step 1. Error classes

Raise classed conditions in the three places that build check and
interpretation messages:

- `throw_assert_error()` (vector engine, used by `*_assert_levels()` and
  the dot functions): class `agetime_error_check`, fields `checks`,
  `comments`, `group = NULL`.
- `inner_df_diagnose_values()` with `assert = TRUE`: class
  `agetime_error_check`, fields as above, `group` a one-row tibble of the
  failing group's keys (zero columns when there are no groups).
- `signal_label_fails()`: `interpret_fail = "error"` gives
  `agetime_error_interpret`, `"warn"` gives `agetime_warning_interpret`,
  both with field `labels` (all labels that failed).
- The data-frame engine wraps interpretation errors ("Can't check labels
  in ...", with `parent`); the wrapper keeps class
  `agetime_error_interpret` and the `labels` field, so callers need not
  inspect the parent.

All raised through `cli::cli_abort(..., class = , <fields>)` /
`cli::cli_warn()`, so messages are unchanged.

### Step 2. Hints only for direct calls

A function is called directly when `call` is left at its default
(`identical(call, environment())` inside the exported function). Pass a
logical `hints` to the engines:

- "Use `age_df_diagnose_values()` to report checks for every group": only
  for direct calls.
- Group line: only when there are groups ("Checking the whole dataset" is
  dropped always; "Input row n" for rowwise data stays, since it is a
  group).
- `*_diagnose_levels()` / `*_assert_levels()` on a non-factor: the hints
  naming `*_df_*()` and `factor()` only for direct calls.

### Step 3. Age dot functions

```r
.age_diagnose_values(labels, <age checks>, interpret_fail,
                     x_arg = rlang::caller_arg(labels),
                     call = rlang::caller_env())
.age_assert_values(labels, <age checks>, interpret_fail,
                   x_arg = rlang::caller_arg(labels),
                   call = rlang::caller_env())
```

- Thin wrappers: `local_caller()`, then `inner_diagnose()` /
  `inner_assert()` with `on = "values"` and `hints = FALSE`.
- `.age_diagnose_values()` returns a tibble with `condition`, `passed`,
  `comment`: the same shape as `age_df_diagnose_values()` with no groups,
  so results can be compared directly. (Not the `list(ok, details)` of
  `age_diagnose_levels()`: a developer wanting `ok` writes
  `all(report$passed)`.)
- `.age_assert_values()` returns `labels` invisibly.
- Tests: for every check, on passing and failing inputs, the dot functions
  agree with `age_df_*_values(data.frame(age = x), age = age, by = NULL)`;
  error classes and fields; snapshot showing the caller's name, `x_arg`,
  and no hints; factors (unused levels ignored, `NA` kept); length zero.

### Step 4. Period and cohort dot functions

As step 3, with the period and cohort check sets and `interpret_single`,
`interpret_multi` arguments, as in `period_df_*_values()` and
`cohort_df_*_values()`. Same agreement tests.

### Step 5. Documentation

- One help page per domain (`.age_assert_values` with
  `@rdname .age_diagnose_values`), opening with "For package developers.
  Users checking data should use `age_df_assert_values()`."
- dev/api-principles.md: "Developer-level functions" section (rules from
  "Proposal" above, criteria from "Future dot functions"); rows in the
  return-types table; error classes and the hints rule.
- Check the pkgdown reference lists the dot functions (no `reference:`
  section in _pkgdown.yml, so all exported topics appear).

### Then

popcounts replaces `assert_age_labels()` with `agetime::.age_assert_values()`;
dac uses the dot functions from the start.

### Questions on the outline

- **Q5.** A warning class for interpretation (`agetime_warning_interpret`)
  as well as the error class? (Leaning yes: `interpret_fail = "warn"` is
  the case a calling package is most likely to want to catch and reword.)
- **Q6.** `.age_diagnose_values()` returns the flat tibble, not
  `list(ok, details)`? (Leaning tibble, as above.)
