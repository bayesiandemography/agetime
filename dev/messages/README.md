# Message inventory

Source: bayesiandemography/bdtools, `dev/messages/`. Copy these files into
a package; don't edit the copies.

| File | Goes in the package at |
|---|---|
| `inventory.R` | `dev/messages/inventory.R` |
| `README.md` (this file) | `dev/messages/README.md` |
| `test-messages.R` | `tests/testthat/test-messages.R` |

The package also needs `^dev$` in `.Rbuildignore`, and codetools and
pkgload installed. Package-specific settings, if any, go in
`dev/messages/config.R` (see the "Settings" section of `inventory.R`).

## Run

From the package root:

```sh
Rscript dev/messages/inventory.R
```

Writes `dev/messages/inventory.csv`, prints a summary, and lists breaches
of the conventions. `tests/testthat/test-messages.R` runs the same
checks, and fails on any breach (skipped on CRAN, and wherever `dev/` is
absent, as in the built package). Commit the CSV, so that
`git diff dev/messages/inventory.csv` shows messages added, removed or
reworded.

## Conventions

From the global CLAUDE.md ("Messages in functions other packages call",
"Message wording"), first settled in agetime (2026-11-25):

1. **Bullet types.** `i`: hints about the package's own interface
   (advice naming one of its functions or arguments, or giving code using
   them), dropped when a function is called from another function. `x`:
   what exactly is wrong. `*`: context, explanation, and advice about the
   data that names nothing of the package's. A message without its `i`
   bullets must still make sense.
2. **Headers state the problem as a short fact**, not "must"; one
   sentence, no ";".
3. **Hints and advice are questions**, ending in "?".
4. **"Can't ..."** for failures, not "Don't know how to" or "Cannot";
   every header has a verb.
5. **Internal errors** use `.internal = TRUE`, with no "Internal error:"
   prefix.
6. **Every bullet ends with "." or "?".**

Also: cli markup (`{.arg}`, `{.val}`, `{.cls}`, `{.fn}`); every signal
through the wrappers (`abort_msg()`, `warn_msg()`, `inform_msg()`, from
bdtools' `standalone-messages.R`); `call =` on every error and warning
other than internal errors.

## Checks

| Check | Breach |
|---|---|
| `hint_not_interface` | An `i` bullet that does not name a function, an argument (literally, or through a variable such as `{.arg {x_arg}}`) or code |
| `interface_not_hint` | A `*` bullet that does (headers and `x` bullets may name arguments literally) |
| `must_header` | A header using "must" (convention 2) |
| `header_semicolon` | A header joining two sentences with ";" (convention 2) |
| `advice_not_question` | An `i` or `*` bullet starting "Use", "Supply", "Set", "Add", "Remove", "Rename", "Select", "Give", "Write", "Recode", "Or", "To" or "If" that does not end in "?" (convention 3) |
| `wording` | "Don't know", "Cannot", "Unable to", "Internal error" (conventions 4, 5) |
| `bullet_ending` | A bullet not ending in "." or "?" (convention 6); bullets that are a single interpolation, such as `{group}`, are skipped |
| `base_signal` | A base-R signal with text of its own |
| `direct_signal` | A cli or rlang signal outside the wrappers |
| `no_call` | An error or warning without `call =`, other than internal errors |

Text the script can't read (`built_elsewhere`) escapes the checks.

## Columns

One row per bullet.

| Column | Content |
|---|---|
| `file`, `line` | Signalling call |
| `fun` | Enclosing top-level function |
| `text_line` | Line where the text is written (differs from `line` when the message was assigned to a variable first) |
| `via` | Variable the text came through, if any |
| `signal` | `abort`, `warn`, `inform` (the wrappers `abort_msg()`, `warn_msg()`, `inform_msg()`); `stored` (functions that store text to signal later, set in `config.R`); direct cli, rlang or base signals show as `cli_*`, `rlang_*` or `base_*` |
| `bullet` | Position within the message (within the alternative, if any) |
| `alternative` | Version of the message, when a variable holding message text is assigned in more than one place (`if (...) x <- "a" else x <- "b"`); empty otherwise |
| `type` | `""` (header), `i`, `x`, ... |
| `text` | Template text. `<...>` is an expression the script could not read as text |
| `hint` | Bullet is a hint: `type == "i"` |
| `looks_like_hint` | Heuristic: a non-header bullet naming a function (`{.fn}`), a literal argument (`{.arg width}`), or giving code (`{.code}`). Disagreement with `hint` flags a possible misclassification |
| `literal_arg` | Names an argument by its literal name rather than via `x_arg` / `arg_nm()` |
| `internal` | Internal error: signalled with `.internal = TRUE` |
| `built_elsewhere` | Text not read (shown as `<...>`); read these by hand |
| `has_call` | `call =` passed |
| `n_exported`, `exported` | Entry points that can reach the site: exported functions and registered S3 methods (approximate call graph; overstates reach) |

## What the script does and does not see

- Follows messages assigned to local variables in the same function
  (`msg <- c(...)`, `names(bullets) <- rep("x", ...)`), using assignments
  before the signalling call. Text from one assignment used at several
  sites of the same signal type is listed once, at the first site.
- Several assignments to the variable give alternative versions of the
  message (`alternative`). An assignment that refers to the variable
  (`msg <- c(msg, x = ...)`) adds bullets instead. Assignments with no
  text (`problem <- NULL`) are skipped. The script does not follow
  control flow, so appends in `if`/`else` branches are listed one after
  the other.
- Skips re-signals (`stop(cnd)` / `warning(cnd)` inside a handler), and
  the cli calls inside the signalling wrappers themselves.
- Treats `cli::format_inline("...")` as its text.
- Does not read: messages from helper functions, values built with `if`,
  `vapply()`, etc., and message text stored in lists. These have
  `built_elsewhere = TRUE`: read them by hand.
- Misses text chosen by an `if` expression in an assignment
  (`msg <- if (...) "a" else "b"`): the assignment is skipped, so the
  header is missing from the inventory without any flag, and only the
  bullets added later (`msg <- c(msg, x = ...)`) are listed. Check such
  sites by eye, or assign in each branch (`if (...) msg <- "a" else
  msg <- "b"`), which the script reads as alternatives.
- Skips the standalone copies (`R/import-standalone-*.R`), whose
  messages are checked in bdtools.
