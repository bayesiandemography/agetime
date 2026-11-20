# Specification: validate values in data frames and levels in vectors

Status: approved and implemented.
Date: 20 November 2026.

## Purpose

Make validation of grouped datasets straightforward without increasing the
number of public assert/diagnose functions. The interface should guide users
towards the appropriate unit of validation:

- **Values:** check observations in a data frame, separately within groups
  when required.
- **Levels:** check the declared classification of a factor vector, including
  unused levels.

The current vector values functions work naturally inside `mutate()` for
assertions, but their diagnostic lists are awkward to combine across groups.
Users must arrange iteration, extract `$details`, and attach grouping keys.
The replacements handle these steps directly and make assertions usable in a
data-frame pipeline.

## Design

The agreed direction is to replace the vector values functions with
data-frame values functions, retain the vector levels functions, and keep
values and levels as separate interfaces. There will be no `use_levels`
argument and no second public family of vector values functions.

Grouping follows the agreed rule: when `by` is omitted, use existing groups
or check the whole dataset if ungrouped. A supplied `by` overrides existing
groups; explicit `by = NULL` checks the whole dataset.

Data-frame diagnostics return a flat tibble, as specified below.

## Public functions

Apply the change consistently to ages, periods, and cohorts.

| Remove | Replace with |
|---|---|
| `age_assert_values()` | `age_df_assert_values()` |
| `age_diagnose_values()` | `age_df_diagnose_values()` |
| `period_assert_values()` | `period_df_assert_values()` |
| `period_diagnose_values()` | `period_df_diagnose_values()` |
| `cohort_assert_values()` | `cohort_df_assert_values()` |
| `cohort_diagnose_values()` | `cohort_df_diagnose_values()` |

Retain `age_assert_levels()`, `age_diagnose_levels()`, and their period and
cohort counterparts. Their arguments and return contracts remain unchanged:
assertions return the factor invisibly; diagnostics return a list containing
`ok` and a `details` tibble. They continue to require a factor.

There are still twelve public validation functions: six values functions
and six levels functions. Vector predicates such as `age_is_subtotal()` and
the data-frame coarsening functions remain unchanged.

## Signatures

The age pair has the following arguments. Both functions have exactly the
same formal arguments, defaults, and argument order.

```r
age_df_diagnose_values(
  data,
  age,
  by = NULL,
  no_overlap = FALSE,
  no_gap = FALSE,
  no_total = FALSE,
  no_subtotal = FALSE,
  no_missing = FALSE,
  no_open_right = FALSE,
  has_total = FALSE,
  has_subtotal = FALSE,
  has_missing = FALSE,
  has_open_right = FALSE,
  has_zero = FALSE,
  valid_life = FALSE,
  valid_tree = FALSE,
  interpret_fail = c("error", "warn", "silent"),
  data_arg = rlang::caller_arg(data),
  call = rlang::current_env()
)
```

`age_df_assert_values()` has the same signature.

The period pair has the following arguments:

```r
period_df_diagnose_values(
  data,
  period,
  by = NULL,
  no_overlap = FALSE,
  no_gap = FALSE,
  no_total = FALSE,
  no_subtotal = FALSE,
  no_missing = FALSE,
  no_open_left = FALSE,
  no_open_right = FALSE,
  has_total = FALSE,
  has_subtotal = FALSE,
  has_missing = FALSE,
  has_open_left = FALSE,
  has_open_right = FALSE,
  valid_tree = FALSE,
  interpret_single = c("lower", "upper"),
  interpret_multi = NULL,
  interpret_fail = c("error", "warn", "silent"),
  data_arg = rlang::caller_arg(data),
  call = rlang::current_env()
)
```

`period_df_assert_values()` has the same signature. The cohort pair has the
same signatures with `cohort` replacing `period` in the function name and
selected-column argument.

All checks remain explicit formal arguments, not options hidden in `...`.
The check arguments and their defaults are inherited from the corresponding
existing vector values functions. `data_arg` replaces `x_arg`; errors identify
both the supplied data-frame expression and the selected column. Both new
diagnose and assert functions support `call`, consistently with the
data-frame coarsening functions.

## Selecting columns and groups

- `data` must be a data frame or tibble with unique, nonmissing, nonempty
  column names.
- `age`, `period`, or `cohort` is a tidyselect expression selecting exactly
  one existing column. There is no default column name.
- The selected column accepts the same label types and conversions as the
  existing vector values function.
- When supplied, `by` is a tidyselect expression selecting grouping columns.
  Explicit `NULL`, `character(0)`, or any empty selection checks all rows
  together. When omitted, existing data-frame groups are used.
- Support bare column names, `c()`, ranges, exclusions, numeric positions,
  and helpers such as `starts_with()`, `where()`, `all_of()`, and `any_of()`.
  Literal character selections remain valid. Standard tidyselect rules
  apply, including deduplicating repeated selections and errors for missing
  columns (unless an optional selector such as `any_of()` omits them).
- Renaming is not supported: selected columns and report keys retain their
  original names. Source-to-target mappings are not supported by these
  single-frame validation functions. The coarsening functions retain their
  character-vector mappings and do not use tidyselect.
- The label column cannot also be a grouping column.
- Reserve `condition`, `passed`, and `comment` as diagnostic field names;
  reject grouping columns with these names in both members of the pair,
  with advice to rename the columns first. Other unselected columns may
  have these names.

Resolve grouping as follows:

| Call | Groups checked |
|---|---|
| `by` omitted, grouped input | Existing groups from `group_by()` |
| `by` omitted, ungrouped input | Whole dataset |
| `by = c(country, year)` | Groups defined by those columns, replacing existing groups |
| Explicit `by = NULL` or `by = character(0)` | Whole dataset, even for grouped input |

Although the formal default is `NULL`, omitted `by` and explicit
`by = NULL` have different meanings. Preserve that distinction when passing
arguments through the public entry points and private engine. Wrapper
functions that want to retain inferred grouping must likewise avoid
forwarding an omitted `by` as an explicit `NULL`.

Capture selectors at the public entry point with `rlang::enquo()` and
evaluate them once per call with `tidyselect::eval_select()`, with renaming
disabled and the public error context preserved. Do not force selectors
before capturing them. Resolve each selector against the input frame, not
against a group's rows.

Use `all_of()` for column names stored in character vectors. Wrappers can
forward selection expressions with `{{ }}`; they must still distinguish
an omitted `by` from a supplied selection when inferred grouping is wanted.

For a rowwise tibble, omitted `by` uses its existing per-row groups and
retains any rowwise identifier columns as report keys. An explicit `by`
replaces that grouping, as for other grouped input. Each row remains a
separate group even if rowwise identifiers repeat.

For grouping by columns, group rows by equality of the selected keys,
including matching missing keys. Preserve the types of grouping keys in
reports. Process groups in order of first appearance, preserving observation
order within each group. Unused levels of grouping factors do not create
additional groups or a Cartesian product of groups. Ignore empty groups
retained by `group_by(..., .drop = FALSE)`; checks concern observed groups.

The restrictions on grouping-column names apply to inferred as well as
explicit groups. Assertions preserve the input's original grouping metadata
even when an explicit `by` chooses different groups for the checks. This
change does not alter the explicit `by` contract of `*_df_coarsen_to()`.

## Meaning of the checks

For each group, results must agree with calling the old vector values
function on that group's selected-column observations, with the same check
and interpretation arguments. The change concerns the input and reporting
interface, not the definitions of the checks.

In particular:

- Unused label-factor levels are ignored. Actual `NA` observations are
  retained and handled by the missing-value checks.
- Do not deduplicate observations before validation. Repeated interval
  labels within a group fail `no_overlap`, just as they do now; repeats
  across different groups do not interact.
- Different labels for the same interval also count as overlapping.
- Totals and missing categories are excluded from overlap and reporting-tree
  checks, following the existing rules.
- Subtotals remain distinct from grand totals. A subtotal must be fully
  divided by at least two other intervals in the group.
- `no_gap` checks coverage between the earliest and latest observed
  intervals. It does not require the same span or classification across
  groups, and cannot detect an absent group or an absent end category.
- `FALSE` means a check is not requested; it does not request the opposite
  condition. Retain the existing treatment of conflicting requested checks.

Period and cohort interpretation rules are applied consistently throughout
the call. Resolve default `interpret_multi = NULL` against observed labels
in the selected column, excluding unused factor levels, and emit its
interpretation advice at most once per call. The resolved rule is then used
for all groups. Explicit interpretation settings retain their current
meaning.

`interpret_fail` retains its existing behavior. With the default `"error"`,
uninterpretable labels abort either function, identifying the affected
column and group. `"warn"` and `"silent"` retain the existing handling of
unparsed labels; passing structural checks under those settings is not a
guarantee that every label was interpretable. Do not add a new parsing check
or turn parsing errors into ordinary failed-condition rows in this change.

## Diagnostic result

Return an ordinary, ungrouped tibble, with one row per requested condition
per observed group. Include successful checks as well as failures.

| Columns | Contract |
|---|---|
| Grouping columns | Names and order from the resolved grouping; original key types |
| `condition` | Character; existing check names such as `"no_gap"` |
| `passed` | Logical result for that group and condition |
| `comment` | Character explanation on failure; `NA_character_` on success |

Use the existing condition order within each group. Return the tibble
directly, without an `ok` wrapper, list-column, or additional attributes.
Overall success is available as `all(report$passed)`, and failures as
`dplyr::filter(report, !passed)`.

When checking the whole dataset, the report contains just the three
diagnostic fields. Rowwise groups without identifier columns likewise have
no key columns, but retain separate rows for each group's checks.
Input argument errors and parsing errors configured to abort still raise
errors; a failed requested condition is reported as a row.

## Assertion result and errors

On success, return `data` invisibly and identically: preserve all columns,
values, types, factor levels, row order, class, and grouping metadata. Do not
recode, aggregate, join, or modify the selected column.

On failure, stop at the first failing group in input order. Identify the
public function, data frame, selected column, grouping-key values, and all
failed requested conditions for that group, with the existing explanatory
comments. Direct users to the corresponding data-frame diagnose function
for a report covering every group. When checking the whole dataset, explain
that scope rather than inventing a group identifier. For a rowwise group
without identifier columns, identify the input row number.

Honor `data_arg` and `call` for wrapper functions, including errors raised
while parsing or checking input. Diagnostics and assertions should share a
checking engine so their condition results cannot diverge.

## Empty inputs and no requested checks

- When checking the whole dataset, even a zero-row frame represents one empty set of
  values. Retain existing empty-vector semantics: `no_*` and `valid_*`
  checks pass, while `has_*` checks fail.
- With inferred or explicit groups and zero rows, there are no observed
  groups. Return a correctly typed zero-row diagnostic tibble; assertions
  succeed. Do not manufacture groups from unused key-factor levels.
- With no checks requested, return a correctly typed zero-row diagnostic
  tibble; assertions return the input. Retain input validation and parsing
  behavior rather than treating this as a new way to bypass parsing errors.

## Examples and migration

### Diagnose every group, then correct a failure

```r
deaths <- data.frame(
  country = c("A", "A", "B", "B"),
  age = c("0-4", "10-14", "0-4", "5-9"),
  deaths = c(1, 3, 2, 4)
)

report <- age_df_diagnose_values(
  deaths, age = age, by = country,
  no_overlap = TRUE, no_gap = TRUE
)
report |> dplyr::filter(!passed)
# One failure: country A, condition no_gap (ages 5-9 are absent).

deaths <- rbind(
  deaths,
  data.frame(country = "A", age = "5-9", deaths = 2)
)
deaths |>
  age_df_assert_values(
    age = age, by = country,
    no_overlap = TRUE, no_gap = TRUE
  ) |>
  dplyr::summarise(total = sum(deaths), .by = country)
```

The two countries may repeat age labels because checks are separate. Their
spans need not match; this example validates each observed span only.

### Use existing groups or override them

```r
grouped <- deaths |> dplyr::group_by(country)

# Omitted by: check separately within each country.
grouped |>
  age_df_diagnose_values(age = age, no_overlap = TRUE)

# Explicit NULL: check all observations together, reporting repeated ages.
grouped |>
  age_df_diagnose_values(age = age, by = NULL, no_overlap = TRUE)
```

An explicit character vector instead selects replacement grouping columns.
The same rules apply to assertions, which preserve the input grouping.

### Replace a grouped mutate assertion

```r
# Before
deaths |>
  dplyr::mutate(
    age = age_assert_values(
      age, no_gap = TRUE, no_total = TRUE,
      no_subtotal = TRUE, no_missing = TRUE
    ),
    .by = c(country, year, sex)
  )

# After
deaths |>
  age_df_assert_values(
    age = age, by = c(country, year, sex),
    no_gap = TRUE, no_total = TRUE,
    no_subtotal = TRUE, no_missing = TRUE
  )
```

Here `deaths` stands for the user's full dataset containing those keys.
Data-frame diagnostics replace `reframe(...$details)` in the same way.

### Retain the factor-level workflow

```r
age <- factor("0-4", levels = c("0-4", "3-7"))
age_diagnose_levels(age, no_overlap = TRUE)$details
# Fails: the declared levels overlap, although only 0-4 is observed.

age_df_diagnose_values(
  data.frame(age = age), age = age, by = NULL,
  no_overlap = TRUE
)
# Passes: the only observed age value is 0-4.
```

A user intentionally checking a standalone vector's observations can wrap
it in a one-column frame and use `by = NULL`. Converting the vector to a
factor and checking levels is not an equivalent replacement when repeated
observations matter.

## Implementation and documentation scope

1. Add the six data-frame entry points and a shared private checking engine.
   Reuse existing vector checks privately, keeping regression coverage of
   their semantics.
2. Remove the six old vector values exports and their public definitions.
   Replace directly without compatibility wrappers or a deprecation family,
   to avoid retaining the interface being removed.
3. Keep the six levels functions and their public contracts. Update their
   help and error guidance to point observed-value checks towards the new
   data-frame functions.
4. Provide help for the data-frame pairs, including inferred and explicit grouping,
   flat reports, factor behavior, empty inputs, and examples for each domain.
   Separate the values and levels help topics while preserving inherited
   reporting-tree and life-table documentation used by other functions.
5. Update the package overview and function table, cookbook recipes,
   cross-references, and any pkgdown configuration or other examples that
   refer to the removed functions. Show assertions directly in pipelines.
6. Update `dev/api-principles.md`, whose current validation descriptions
   predate even the explicit `_levels` names, to describe the final API.
7. Regenerate Rd and NAMESPACE. Do not add a NEWS item, following the
   existing project decision for the unreleased package.

Add `tidyselect` to Imports; its selection engine does not require importing
dplyr. Avoid a full data-frame split or copying unrelated columns for each
group.

## Reuse classifications within a call

Use the same temporary-reuse approach as `*_df_coarsen_to()`: groups with
identical inputs can reuse parsing and completed condition results within
the current call. This is part of the implementation requirements for both
the assert and diagnose functions, across all three domains.

Unlike coarsening coverage checks, values checks must retain repeated
observations. For example, `c("0-4", "5-9")` and
`c("0-4", "5-9", "5-9")` have the same distinct classification but different
`no_overlap` results. Do not use only `unique(labels)` as the result-cache
key or reuse interval objects that contain another group's occurrence
mapping.

A simple sufficient key is the ordered vector of observed labels after the
existing input conversion, including repeated labels and actual missing
values. Keep original spellings and order: normalizing or sorting labels
could change the example reported in a diagnostic comment. Unused factor
levels are not part of the key. The label domain, requested checks, and
resolved interpretation settings are fixed throughout one call, so they
need not be repeated in each group's key.

Cache group-independent check results, then attach the current group's
keys when constructing its report or assertion error. Diagnostics can reuse
both passing and failing condition results, but must still return separate
rows for every group. Assertions must still stop at the first failing group.
Do not cache errors with an earlier group's context attached.

Reuse must preserve parsing warnings and their current group context. It
is acceptable to bypass reuse for inputs that produce warnings. Period and
cohort default interpretation advice remains at most once per call, as
specified above; resolving the rule before group checking permits reuse
with default as well as explicit interpretation settings.

There must be no persistent cache or state between calls. Benchmark many
small groups with repeated classifications, mixed classifications, and
entirely different classifications. Record correctness and timings against
uncached per-group checks; no particular speedup is assumed in advance.

## Acceptance criteria

- Tests cover all three domains and every existing check, with equivalence
  to the previous per-group vector results.
- Reports include every requested condition for every observed group, with
  stable ordering, correct key types, and successful rows included.
- Tests distinguish repeated values within groups from repeated values
  across groups, unused label levels from observations, missing keys from
  missing labels, and gaps from absent endpoints or entire groups.
- Tests cover ungrouped, grouped, and rowwise tibbles, plain data frames,
  omitted `by`, explicit replacement groups, explicit `by = NULL` and
  `character(0)`, zero rows, unused key-factor levels, empty groups retained
  by `.drop = FALSE`, no requested checks, invalid column selections, and
  reserved diagnostic key names. Test that wrappers preserve the distinction
  between omitted `by` and explicit `NULL`.
- Assertions preserve the input identically and invisibly on success;
  failures identify the right group and honor wrapper error context.
- All six functions support bare selectors, helpers, ranges, exclusions,
  numeric positions, literal strings, and programmatic `all_of()` selections.
  Test wrapper forwarding, column precedence over external variables,
  single-column enforcement, prohibited renaming, and selection errors.
  Selectors are evaluated once per call, independently of group count.
- Parsing errors, warnings, and default period/cohort interpretation
  messages follow the contracts above.
- Repeated identical group inputs reuse parsing and check results within a
  call. Tests verify that different occurrence counts, label order,
  spellings, or missing values cannot share inappropriate results; reused
  failures identify each group's own keys. No results leak between calls,
  including calls with different checks or interpretation settings.
- The levels API and results remain unchanged apart from updated guidance.
- Old vector values functions are no longer exported or referenced as
  current public functions in help, examples, or vignettes.
- Full tests, documentation generation, cookbook rendering, and package
  checks pass. Record grouped-data timings without a machine-specific
  performance threshold.


## Implementation validation

On 20 November 2026, the full package check, including tests and vignette
rendering, completed with zero errors, warnings, or notes.

After adding tidyselect support, all 2,300 tests passed without errors,
warnings, or skips. Package checks, including regenerated help, examples,
and vignette rendering, again completed with zero errors, warnings, or notes.

The initial benchmarks below, recorded before tidyselect support was added,
compare the flat data-frame diagnostics with uncached calls
to the previous vector diagnostic function for each group. Checks were
`no_gap`, `no_total`, `no_subtotal`, and `no_missing`, all enabled. Diagnostic
conditions, results, and comments were identical after excluding grouping
keys. Times are medians of three alternating runs on the development
machine, rather than portable performance guarantees.

| Classification pattern | Groups | Rows | Uncached | New | Speedup |
|---|---:|---:|---:|---:|---:|
| One repeated classification | 1,000 | 21,000 | 5.853 s | 0.040 s | 146.3x |
| Ten recurring classifications | 1,000 | 21,000 | 4.977 s | 0.080 s | 62.2x |
| Every classification different | 250 | 5,250 | 1.343 s | 1.174 s | 1.1x |
