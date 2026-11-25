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

Convention (2026-11-24; dev/developer-functions.md): a bullet named `i`
is a hint, and may be dropped; every other type is not.

- Until messages follow the convention: a heuristic flag, `TRUE` when a
  non-header bullet names a fixed function (`{.fn age_...}`, `{.fn factor}`)
  or a literal argument (`{.arg open_left}`). Used to find candidates in
  the review.
- After: `hint` is exactly `type == "i"`. The heuristic becomes a check
  for misclassification: a non-`i` bullet that looks like a hint, or an
  `i` bullet that does not.

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

## Conventions

Agreed 2026-11-25, from the review (dev/messages/review.md). They apply
to errors, warnings and messages.

1. **Bullet types.**
   - `i`: hints about agetime's interface: advice that names an agetime
     function or a literal agetime argument, or gives code using them.
     Dropped when a function is called from another function.
   - `x`: problem details: what exactly is wrong (offending values,
     overlaps, classes).
   - `*`: context and explanation, group lines, and advice about the data
     or input that names nothing of agetime's ("Supply a single value?",
     "Write one-year ages as a single year, e.g. "5"?"). Kept in every
     call.
   A message with its `i` bullets removed must still make sense.
2. **Headers state the problem as a fact**, short ("`labels` is a data
   frame.", "`x` has length 3."), not "must". What is required goes in
   later bullets.
3. **Hints and advice are questions**, ending in `?`.
4. **"Can't ..."** for failures ("Can't interpret", not "Don't know how
   to interpret" or "Cannot"); no headers without a verb.
5. **Internal errors** use `.internal = TRUE` (rlang adds a line asking
   users to report the bug at the `BugReports` URL); no "Internal error:"
   prefix; cli formatting for arguments and values.
6. **Every bullet ends with `.` or `?`.**

Also: arguments with `{.arg}`, values with `{.val}`, classes with
`{.cls}`, functions with `{.fn}`; `cli` only, no base-R signals with text
of their own; every signalling call outside internal errors passes
`call =`; all messages go through the package's signalling wrappers
(after step 3).

## Checks

The script reports the rows that break each convention it can test
mechanically:

- bullet types: an `i` bullet that does not look like an interface hint,
  or a non-`i` bullet that does (heuristic: `{.fn}`, literal `{.arg}`,
  `{.code}` naming an agetime function);
- headers using "must";
- hints and advice not ending in `?` (`i` and `*` bullets that look like
  advice: starting "Use", "Supply", "Set", "Add", "Remove", "To ...");
- "Don't know", "Cannot", "Unable to";
- "Internal error:" text, or `.internal = TRUE` missing on internal
  errors;
- bullets not ending in `.` or `?`;
- base-R signals with text; signalling calls without `call =`; direct
  `cli::cli_abort()` etc. rather than the wrappers (after step 3).

Once a check is stable, it can move into a test that is skipped on CRAN,
so `devtools::test()` catches a new message that breaks it.

## Order of work

1. **Inventory script**, with the heuristic hint flag and no checks.
   Run it, commit the CSV.
2. **Review the inventory.** Classify each bullet (fact, advice about the
   data, hint); note inconsistencies; settle conventions and record them
   above. Done 2026-11-25: dev/messages/review.md.
3. **The `i` convention** (dev/developer-functions.md): re-type bullets
   so that `i` means hint; `local_caller()` records whether the call is
   direct; wrappers around the cli signalling functions drop `i` bullets
   for indirect calls; drop "Checking the whole dataset"; update the
   `call` docs and api-principles. The inventory's `hint` column becomes
   exact.
   In three commits:
   - **3a** (done 2026-11-25): `local_caller()` records whether the call
     is direct; `abort_msg()`, `warn_msg()`, `inform_msg()` drop `i`
     bullets for indirect calls; all messages go through them; bullets
     re-typed (`i` → `x` or `*`) so that only interface hints are `i`.
     Re-typing went into 3a so that no commit drops group lines or advice.
   - **3b**: rewording to conventions 2-6 ("must" headers, hints as
     questions, "Can't", internal errors); drop "Checking the whole
     dataset".
   - **3c**: `call` docs, api-principles.

   Afterwards (user, 2026-11-25): once we are happy with the changes,
   consider adding the Conventions section to the global CLAUDE.md.
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
