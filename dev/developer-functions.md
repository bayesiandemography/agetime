# Calling agetime from other packages

Status: hints rule built (2026-11-25; dev/messages.md, steps 3a-3c).
Dot functions and error classes deferred (below); popcounts follow-up
pending.
Date: 23 November 2026; rewritten 24 November 2026.

## Problem

agetime has two audiences:

- **users**, working interactively or in scripts, often with data frames;
- **package developers**, calling agetime from inside their own functions
  (popcounts, dac, and later others), on behalf of their own users.

Exported functions take `call` so that a developer's function can be named
in errors. But some messages also contain hints aimed at agetime's own
users ("Use `age_df_diagnose_values()` to report checks for every group",
"Or set `interpret_multi` to ...", "Checking the whole dataset"). The
end user of the calling package never called agetime, and may have no such
function or argument, so these hints mislead.

popcounts currently works around this with an internal wrapper
(`assert_age_labels()`) that calls `age_df_diagnose_values()` and rebuilds
the error.

## Decision: hints only for direct calls

A function is **called directly** when `call` is left at its default.
Every exported agetime function that takes `call` defaults it to
`rlang::current_env()`, so this is a reliable signal throughout the
package. Hints appear only in direct calls.

### What counts as a hint

A hint names agetime's interface by its agetime name: a function
(`age_df_diagnose_values()`, `factor()`), or an argument by its literal
name (`open_left`, `width`, `include_missing`, `interpret_multi`).

Not hints, and kept in every case:

- facts about the input ("`x` has class <list>", "Also can't interpret 3
  other labels");
- advice about the data ("Write one-year ages as a single year, e.g.
  "5"?");
- bullets naming an argument through `arg_nm()` or `x_arg`, since these
  are already the caller's names for its own arguments ("Add labels to
  `to` ...").

### Encoding: `i` bullets are hints

Decided 2026-11-24 (replacing a proposed `hint()` helper):

- A bullet named `i` is a **hint**, and may be dropped.
- Everything else (facts about the input, advice about the data, context
  such as group lines) uses any other bullet type that fits: `x` for what
  is wrong, `" "` or `*` for context, `!`, `v`. No stronger rule than
  "not `i`".
- The same convention covers errors, warnings and messages (e.g. "Supplying
  a value for `interpret_multi` silences this message" is an `i` bullet).
- It applies to agetime now, to dac and popcounts in the short run, and to
  all packages in the long run (proposed for the global CLAUDE.md). In
  packages that never drop hints, `i` still means "hint".

### Mechanism

- `local_caller()` already receives `call` and the exported function's
  frame. It also records `caller_env$direct <- identical(call, frame)`.
  Only the outermost agetime function registers, so `direct` describes the
  call the user made. With nothing registered (internal use), the call
  counts as direct.
- Internal wrappers around `cli::cli_abort()`, `cli::cli_warn()` and
  `cli::cli_inform()` drop bullets named `i` when the call is not direct,
  then signal as before (passing `call` and `.envir` through, so `{...}`
  is interpolated in the caller's environment). All agetime messages go
  through the wrappers; converting the existing calls is mechanical.
- The message inventory (dev/messages.md) reports hints exactly
  (`type == "i"`), and checks for likely misclassifications.

### Group lines in data-frame functions

A separate rule: "Checking the whole dataset" is dropped always (it says
nothing). Real group lines ("Group: country = "A"", "Input row 3") stay,
since they describe the user's data.

### Developers pass `by` explicitly

A rule for functions called from other packages: always pass `by`, even
when it is `NULL`. Leaving it out picks up the grouping of a grouped
tibble, which the developer did not choose.

### Documentation and tests

- The shared `call` documentation (man-roxygen templates) gains:
  "Supplying `call` also drops hints that name agetime functions and
  arguments, which may not make sense to users of the calling function."
- dev/api-principles.md: the rule, the definition of a hint, and the `by`
  rule, pointing to dev/messages.md.
- Tests: the wrappers and `local_caller()`'s `direct`; snapshots of
  representative messages called directly and from a wrapper that
  supplies `call`.

### Known limitation

A dependant that passes an agetime argument straight through to its users
(e.g. exposing `interpret_multi`) loses a hint that would be valid. Rare;
the dependant can add its own hint.

## Deferred: developer-level (dot) functions

Proposed on 2026-11-23: exported `.age_assert_values()`,
`.age_diagnose_values()` and period and cohort equivalents, taking vectors.
Deferred on 2026-11-24, because:

- In practice developers check data-frame columns. All three label checks
  in popcounts start from one (`standard$age`; a column of `prior`; the
  user's age column, one date at a time), and dac's series are data frames.
  The data-frame functions handle them, and grouping by time in popcounts
  gives better errors than splitting by hand.
- The real problem was messages, which the hints rule fixes.
- A raw vector can be wrapped in `data.frame()`; the only cost is that
  messages name `x$age` rather than `x`.
- The tier would add six exported functions, with docs, tests, and a
  stability promise.

Revisit when:

1. at least one other package needs to check a vector that is not a
   data-frame column, and would otherwise write a wrapper;
2. the user-facing interface is wrong for developers, not just
   inconvenient;
3. the function can be a thin layer over existing internals
   (`inner_diagnose()` with `on = "values"` already does the work).

If built: dot names, exported, listed in the reference without a special
header, help pages saying they are for package developers; all three
domains; both diagnose and assert versions (answers of 2026-11-24).

## Deferred: error classes

Proposed: `agetime_error_check` (fields `checks`, `comments`, `group`) and
`agetime_error_interpret` (field `labels`). Deferred on 2026-11-24, because:

- Classed conditions are used much less in R than in Python. Most R code
  catches all errors; classes are used mainly in tests and within package
  families (vctrs, purrr, httr2).
- With the hints rule, dependants rarely need to catch and reword agetime
  errors.
- Adding a class later is not a breaking change; renaming or removing one
  is. Waiting costs nothing.

Revisit when a dependant needs to handle a particular failure in code.

## Follow-up in popcounts

Once agetime has the hints rule:

- Replace `assert_age_labels()` with `agetime::age_df_assert_values()`,
  passing `by`, `data_arg` and `call`.
- Move the per-date check in `tree_build()` into the constructor, as one
  call grouped by the time variable.
