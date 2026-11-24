# Messages: inventory, conventions and checks

Status: proposed (2026-11-24). Nothing built.

## Purpose

Keep agetime's errors, warnings and messages consistently worded, and
separate hints (advice about agetime's own interface) from the rest of a
message, so that hints can be dropped when another package calls agetime
(dev/developer-functions.md).

This is package infrastructure: a script in `dev/messages/` that we run
periodically, not a one-off review. `dev/` is in `.Rbuildignore`.

## Files

- `dev/messages/inventory.R`: builds the inventory and runs the checks.
- `dev/messages/inventory.csv`: the generated inventory, committed, so
  that `git diff` shows every message added, removed or reworded.
- `dev/messages/README.md`: how to run the script and read its output.

Conventions (once settled) go in this note, with a pointer from
dev/api-principles.md.

## The inventory

The script parses each file in `R/` and walks the parsed code to every
`cli::cli_abort()`, `cli::cli_warn()`, `cli::cli_inform()`, `stop()`,
`warning()`, `message()` and `rlang::abort()`. One row per bullet:

| Column | Content |
|---|---|
| `file`, `line` | Location of the call |
| `fun` | Enclosing function |
| `text_line`, `via` | Where the text is written, and the variable it came through, when assigned before signalling |
| `signal` | `abort`, `warn`, `inform`, `stored`, or a base function |
| `bullet` | Position within the message (1 = header) |
| `type` | Bullet name: `""` (header), `x`, `i`, `v`, `!`, `*`, ... |
| `text` | Template text, e.g. `"Can't interpret labels in {.arg {x_arg}}."` |
| `hint` | Whether the bullet is a hint (see below) |
| `literal_arg` | Names an argument literally, not via `x_arg` / `arg_nm()` |
| `internal` | "Internal error: ..." |
| `built_elsewhere` | Text the script could not read (helper functions, `if` values, stored lists) |
| `n_exported`, `exported` | Exported functions that can reach this site |
| `has_call` | Whether `call =` is passed |

Details of what the script sees: dev/messages/README.md.

### Hints

- Before `hint()` exists: a heuristic flag, `TRUE` when a bullet names a
  fixed function (`{.fn age_...}`, `{.fn factor}`) or a literal argument
  (`{.arg open_left}`), and not an argument via `arg_nm()` or `x_arg`.
  Used to find candidates for review.
- After `hint()` exists: `TRUE` exactly when the bullet is a `hint()`
  call. The heuristic then becomes a check: a heuristic hint not wrapped
  in `hint()` is reported.

### Reach from exported functions

An approximate call graph: for each function in the package namespace,
the package functions it calls (`codetools::findGlobals()`), followed
transitively from each exported function. This overstates reach a
little: a helper may be reachable without that path ever raising the
message.

### Messages built elsewhere

Mainly label parsing (`x_label_fail()`, `signal_label_fails()`), where
message text is stored and signalled later. The script reports the
signalling site with `built_elsewhere = TRUE`, and also lists the
`x_label_fail(msg = ...)` sites so their text is in the inventory. If many
messages are built this way, a small refactor that puts the text at the
signalling call is a decision for step 2.

## Checks

Rules the messages should follow; the script reports the rows that break
each one. Rules come from the first inventory: look at what agetime
already does, choose where it varies, and write the choice here.
Candidates:

- Every bullet ends with `.` or `?`.
- The header states the problem; suggestions go in `i` bullets.
- "Can't", not "Cannot" or "Unable to".
- Arguments with `{.arg}`, values with `{.val}`, classes with `{.cls}`,
  functions with `{.fn}`.
- `cli` functions, not `stop()` or `warning()`.
- Every signalling call passes `call =`.
- Suggestions phrased consistently (questions, "Supply ...?", or
  imperatives, "Supply ...": pick one).
- Hints go through `hint()` (after step 3).

Once a check is stable, it can move into a test that is skipped on CRAN,
so `devtools::test()` catches a new message that breaks it.

## Order of work

1. **Inventory script**, with the heuristic hint flag and no checks.
   Run it, commit the CSV.
2. **Review the inventory.** Classify each bullet (fact, advice about the
   data, hint); note inconsistencies; settle conventions and record them
   above.
3. **`hint()`** (dev/developer-functions.md): `local_caller()` records
   whether the call is direct; route every hint through `hint()`; drop
   "Checking the whole dataset"; update the `call` docs and
   api-principles. The inventory's `hint` column becomes exact.
4. **Checks**: add them to the script; fix the messages that break them;
   promote stable checks to a test.

## Answers (2026-11-24)

- **A1.** No snapshot links: the inventory holds templates only.
- **A2.** All messages use `cli`; base-R `stop()`, `warning()` and
  `message()` with message text are converted. This is a check.
  On inspection agetime has none: its 11 base-R calls are re-signals,
  `stop(cnd)` or `warning(cnd)` inside a condition handler, after changing
  `cnd$call`. They carry no text of their own, so the inventory skips
  them (a base-R call whose argument is the handler's condition object).
