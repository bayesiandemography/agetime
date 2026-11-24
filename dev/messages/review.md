# Message review, November 2026

Step 2 of dev/messages.md. Based on inventory.csv at commit 712b122
(97 sites, 187 bullets). Row numbers below are inventory rows; locations
are `file:text_line`.

Status: for discussion. Conventions become rules (in dev/messages.md) once
agreed; step 3 then applies them.

## Classification

Each bullet other than the header falls into one of five classes.

### H. Interface hints (about 20)

Name an agetime function or a literal agetime argument, or give agetime
code. Meaningless to the user of a calling package. Under the convention,
these are the `i` bullets.

| Rows | Location | Text (abridged) |
|---|---|---|
| 24, 26, 28, 30 | check-functions.R:206, 219 | "`open_left` is FALSE." / "Or unset `open_left`, or pass TRUE?" (and right) |
| 37, 38 (non-age branch) | check-functions.R:305, 310 | "Set `open_right = TRUE` to include ...?" / "Set `open_left = TRUE`, or add a lower break?" |
| 84 | inner_df_coarsen_to.R:126 | "Use `c(source_column = "target_column")` when names differ." |
| 101 | inner_df_diagnose_values.R:96 | "Use `age_df_diagnose_values()` to report checks for every group." |
| 104, 105 | inner_diagnose.R:141 | "To check observed labels in a data frame, use ..." / "... use `factor()`." |
| 111, 113 | inner_extend.R:79, 89 | "Remove totals first with `labels[!age_is_total(labels)]`?" |
| 117 | inner_extend.R:117 | "Supply a value for `width`?" |
| 122, 124, 127, 134 | inner_labels_tree.R | "To include a category for missing values, use `include_missing`." |
| 146 | inner_levels_set_order_tree.R:55 | "... recode it to "Missing" first, e.g. `age[age_is_total(age)] <- "Missing"`." |
| 154, 155 | interpret_multi.R:50 | "... set `interpret_multi` to "below_upper"." / "Supplying a value for `interpret_multi` silences this message." |
| 168 (non-age branch) | parse_label.R:223 | "With `interpret_multi` = ..., "2000-2005" is the interval [...)." |
| 175 | parse_label.R:155 | "Or set `interpret_multi` to "below_upper" if ...?" |

Rows 24, 28 and 168 are statements, not advice, but only make sense to
someone who set the agetime argument, so they go with the hints.

### A. Advice about the data or input (about 28)

Say how to fix the problem without naming agetime's interface (arguments,
if named, come through `x_arg` / `arg_nm()`, so are the caller's names).
Still useful to the user of a calling package.

Rows 4, 6, 9, 14, 16, 25, 29, 38 (age branch: "Add a lower break?"), 39,
41, 43, 47, 51, 53, 55, 57, 59, 66, 68, 71, 73, 75, 95, 109, 147, 169, 174,
178. Typical: "Supply a single value?", "Use a whole number?", "Remove
open-left labels from `labels`?", "Write one-year ages as a single year,
e.g. "5"?", "If a total is a sum over other ages, remove it."

All currently `i`. See Q1.

### F. Problem details (about 24)

What exactly is wrong: offending values, overlaps, classes.

- Currently `x` (5): 33, 35, 40, 100, 107.
- Currently `i` (19): 11 ("`x` is 120."), 18, 45, 165 ("has class
  <list>"), 34 ("... overlaps ..."), 61, 62, 120, 129, 138, 145, 149, 150,
  171, 172, 177, 182 ("Also can't interpret 2 other labels: ...").

### C. Context and explanation (about 8)

Background that helps read the problem, but is not itself the problem.

- 12, 13 ("Lowest interval: "0-4"."), 36 ("New ages cover ..."), 126 ("A
  total is not part of a reporting tree."), 131, 133, 152, 168 (age
  branch: ""0-4" is the interval [0, 5).").

All currently `i`.

### G. Group lines (4)

78, 80, 97, 99: `df_coarsen_group()` / `df_values_group()`, giving the
group ("Group: country = "A"."), the row (rowwise data), or "Checking the
whole dataset." All currently `i`. The last is dropped (decided).

## Other findings

1. **Hint phrasing.** Most hints and advice are questions ending in `?`
   ("Supply a single value?"), as in the tidyverse style guide. Twelve are
   statements: rows 84, 95, 104, 105, 122, 124, 127, 134, 146, 147, 154,
   155.
2. **"Don't know how to interpret"** (179, 180) beside **"Can't
   interpret"** (176, 183).
3. **Terse header**: row 170, "Label "x" invalid." (no verb).
4. **Internal errors** (8: rows 118, 139, 143, 156-159, 166): "Internal
   error: ..." prefix; some quote arguments with `'...'` rather than
   `{.arg}`; capitalisation after the colon varies; none passes `call`.
   `cli::cli_abort(..., .internal = TRUE)` (via rlang) adds a standard
   line asking users to report the bug at the `BugReports` URL, which
   agetime's DESCRIPTION has.
5. **Header style.** Most headers state a fact ("`x` has length 3.",
   "`labels` is a data frame."). Eight use "must" (rows 1, 2, 81, 82, 83,
   85, 86, 102), mainly in the data-frame code. The tidyverse style guide
   prefers "must" for input problems ("`x` must be a data frame, not a
   list."). See Q2.
6. **Literal argument names outside hints.** Headers and problem details
   name some arguments literally: `nodes` (119-136), `breaks` (3, 128),
   `by` (76, 93), `name_x` / `name_y` (72), `call` (2). In an indirect call
   the user may have supplied none of these. Only the label arguments
   (`x_arg`, `to_arg`, `data_arg`) are renamed. See Q4.
7. **Check names** in assertion errors (98, 100, 106, 107: "Age group
   labels in `age` fail check `valid_tree`. ✖ `valid_tree`: ..."). The
   check name is an agetime argument chosen by the developer, so in an
   indirect call it is interface. See Q3.
8. **The one message** (`cli_inform()`, rows 153-155): with hints dropped,
   it reads "Interpreting "2000-2005" as [2000, 2005), which has width
   5.", which still makes sense.

## Proposed conventions

- **K1. Bullet types.** `i`: interface hints (H). `x`: problem details
  (F). `*`: context and explanation (C), and group lines (G). Advice (A):
  see Q1.
- **K2. Hints and advice are questions**, ending in `?` (finding 1).
- **K3. "Can't ..."** for failures: "Can't interpret", not "Don't know how
  to interpret"; no verbless headers (findings 2, 3).
- **K4. Internal errors** use `.internal = TRUE`, no "Internal error:"
  prefix, cli formatting for arguments and values (finding 4).
- **K5. Header style**: see Q2.
- **K6. Every bullet ends with `.` or `?`.** (Already true of the literal
  text; a check.)

## Questions

- **Q1. Advice about the data (class A).** Keep it for indirect calls
  (a non-`i` type, e.g. `*`), or treat it as a hint (`i`, dropped)?
  Leaning keep: "Write one-year ages as a single year, e.g. "5"?" is often
  the most useful line for a popcounts user, and names nothing of
  agetime's. That narrows the CLAUDE.md wording from "advice on how to
  fix the problem" to "advice that refers to the package's own functions
  or arguments".
- **Q2. Header style.** Fact ("`labels` is a data frame.") with the
  requirement in a hint, or the tidyverse "must" form ("`labels` must be a
  character vector or factor, not a data frame.")? Leaning "must" for type
  and shape problems of an argument (it states the requirement once, and
  needs no hint), facts for everything else (overlaps, gaps, values out of
  range).
- **Q3. Check names in indirect calls.** Keep "fail check `valid_tree`"
  and the `valid_tree:` prefix on each detail, or, for indirect calls,
  "Age group labels in `age` fail a check." with only the comments?
  Leaning keep: the developer chose the check, and the name is a fair
  summary even for a user who never saw the argument.
- **Q4. Literal argument names (finding 6).** Rule now ("headers and
  details name only arguments registered with `local_caller()`"), or
  defer until a dependant needs it? popcounts calls `age_labels()` and
  `age_set_order_tree()`, but with `breaks` it computes itself (so a
  `breaks` error would be a popcounts bug, not a user error), and the
  tree messages name no arguments. Neither package calls
  `age_labels_tree()` or the data-frame coarsening functions. Leaning
  defer.
