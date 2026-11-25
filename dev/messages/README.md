# Message inventory

Design: dev/messages.md.

## Run

From the package root:

```sh
Rscript dev/messages/inventory.R
```

Needs pkgload and codetools. Writes `inventory.csv` here, prints a
summary, and lists breaches of the conventions (checks: dev/messages.md).
tests/testthat/test-messages.R runs the same checks. Commit the CSV, so that `git diff dev/messages/inventory.csv`
shows messages added, removed or reworded.

## Columns

One row per bullet.

| Column | Content |
|---|---|
| `file`, `line` | Signalling call |
| `fun` | Enclosing top-level function |
| `text_line` | Line where the text is written (differs from `line` when the message was assigned to a variable first) |
| `via` | Variable the text came through, if any |
| `signal` | `abort`, `warn`, `inform` (the wrappers `abort_msg()`, `warn_msg()`, `inform_msg()`); `stored` (`x_label_fail()`, signalled later by `signal_label_fails()`); direct cli, rlang or base signals show as `cli_*`, `rlang_*` or `base_*` |
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
| `n_exported`, `exported` | Exported functions that can reach the site (approximate call graph; overstates reach) |

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
- Does not read: messages from helper functions
  (`msg_i_parsed_interval()`), values built with `if`, `vapply()`, etc.,
  and message text stored in lists (`fails[[1L]]$msg`). These have
  `built_elsewhere = TRUE`.
