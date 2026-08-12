# Spec: `age_is_subtotal()`, `period_is_subtotal()`, `cohort_is_subtotal()`

Design notes for adding helpers to **agetime**. Goal: when a group of rows mixes **detail** labels with **subtotal** labels, identify subtotal rows so they can be dropped before analysis.

Motivation comes from STMF-style mortality data, where a country–year can contain fine ages (`"0"`, `"1-4"`, `"5-9"`, …) alongside rolled-up bands such as `"0-64"`. The same pattern can arise for periods and cohorts in multi-scheme tables.

**Scope (v1):** all three domains, matching the existing age / period / cohort families ([`age_is_total()`](R/age_is_total.R), [`period_is_total()`](R/period_is_total.R), [`cohort_is_total()`](R/cohort_is_total.R), etc.). Shared logic in `inner_is_subtotal()`; thin public wrappers per domain.

This is a **row-selection** tool. It does not replace [`*_mapping()`](R/age_mapping.R), [`*_coarsen()`](R/age_coarsen.R), or [`*_diagnose()`](R/age_diagnose.R).

---

## Problem in plain language

Mortality and census tables often publish both:

- **Detail rows** — e.g. `"0-4"`, `"5-9"`, `"10-14"`, …
- **Subtotal rows** — e.g. `"0-64"`, when the same table also gives five-year bands covering 0–64

If you sum or model without dropping subtotals, you double-count. Users need:

```r
stmf |>
  group_by(country, year) |>
  filter(!age_is_subtotal(age)) |>
  ungroup()
```

A broad label is a subtotal **only when** the **finest** matching labels in the **same group** fully partition its range (intermediate sub-bands such as `"0-1"` are ignored when `"0"` and `"1"` are also present). If detail is incomplete, the broad label is **not** a subtotal and the row is kept.

---

## `age_is_subtotal()` vs `age_is_total()`

| | [`age_is_total()`](R/age_is_total.R) | `age_is_subtotal()` |
|---|--------------------------------------|---------------------|
| **What** | Grand-total labels (`"Total"`, `"All ages"`, …) — **not** an age interval | Age-band label with an **explicit interval**, superseded by finer bands in the **same group** |
| **Detection** | Heuristics on the label alone | Label **plus** other labels in the group |
| **Context** | Same everywhere | Depends on which other ages appear in the group |
| **Typical filter** | `filter(!age_is_total(age))` | `filter(!age_is_subtotal(age))` |

**Mutually exclusive:** a label cannot be both a total and a subtotal. Totals do not denote an explicit age interval; subtotals must. For any label, `age_is_total(x)` and `age_is_subtotal(x)` are never both `TRUE`.

Often used together (two distinct row types to drop):

```r
stmf |>
  group_by(country, year) |>
  filter(!age_is_subtotal(age), !age_is_total(age))
```

---

## Explicit age interval (required for subtotals)

A label **covers an explicit age interval** when it parses as a normal age group in agetime:

- **Closed** — e.g. `"0-4"`, `"0-64"` (finite lower and upper)
- **Open on the right** — e.g. `"80+"`, `"100+"` (finite lower, infinite upper)
- **Single-year** — e.g. `"0"`, `"65"` (finite bounds under `interpret_single`)

and **not**:

- **Grand total** — [`age_is_total()`](R/age_is_total.R) is `TRUE` (`"Total"`, `"All ages"`, …)
- **Missing** — [`age_is_missing()`](R/age_is_total.R) is `TRUE`
- **Unparseable** — no interval endpoints under `interpret_fail`

Subtotals are always **rolled-up age bands** on the number line, not table-level summary rows. This keeps the two functions cleanly separated.

---

## What this function is not

- **Not** `distinct()` — duplicate detail rows (`"0-4"` twice) are all kept or all dropped together, based on the label, not row duplication.
- **Not** `age_diagnose()` — does not require a complete life table or a single coherent scheme across the whole column.
- **Not** `age_coarsen()` — does not create new age labels.
- **Not** safe on an ungrouped column — see [Grouped use](#grouped-use) below.

---

## 1. `age_is_subtotal()` (and period / cohort equivalents)

### Period and cohort equivalents

Same definition and algorithm, with domain-specific wrappers:

| | Age | Period | Cohort |
|---|-----|--------|--------|
| **Function** | `age_is_subtotal()` | `period_is_subtotal()` | `cohort_is_subtotal()` |
| **vs total** | [`age_is_total()`](R/age_is_total.R) | [`period_is_total()`](R/period_is_total.R) | [`cohort_is_total()`](R/cohort_is_total.R) |
| **vs missing** | [`age_is_missing()`](R/age_is_total.R) | [`period_is_missing()`](R/period_is_total.R) | [`cohort_is_missing()`](R/cohort_is_total.R) |
| **Mapping** | [`age_mapping()`](R/age_mapping.R) | [`period_mapping()`](R/period_mapping.R) | [`cohort_mapping()`](R/cohort_mapping.R) |
| **Interpret args** | `interpret_fail` only (via `age_lower`) | `interpret_single`, `interpret_multi`, `interpret_fail` (via `period_lower`) | same as period (via `cohort_lower`) |

**Explicit interval** for period/cohort: parseable period or cohort bounds (closed, open-left, or open-right per domain), not grand total or missing.

**Mutual exclusivity** holds in each domain: `period_is_total(x)` and `period_is_subtotal(x)` are never both `TRUE`; same for cohort.

**Examples (period):**

```r
# Incomplete detail — broad period kept
labs <- c("2020-2025", "2025-2030", "2020-2035")
period_is_subtotal(labs)
# FALSE FALSE FALSE

# Complete five-year bands + redundant decade-style parent (when partition holds)
labs <- c("2020-2025", "2025-2030", "2030-2035", "2035-2040", "2020-2040", "Total")
period_is_subtotal(labs)  # TRUE for "2020-2040" only if children fully partition it
period_is_total(labs)     # TRUE for "Total" only
```

Implement `period_is_subtotal()` and `cohort_is_subtotal()` in `R/period_is_subtotal.R` and `R/cohort_is_subtotal.R` (or alongside age in one file per domain). Each calls `inner_is_subtotal(..., label_type = "period" | "cohort")`.

---

### Purpose (age)

Return a logical vector indicating whether each element of `labels` is a **subtotal** given the other labels in the same vector (typically one country–year group).

### Signature

```r
age_is_subtotal(
  labels,
  interpret_fail = c("error", "warn", "silent")
)
```

### Arguments

| Argument | Meaning |
|----------|---------|
| `labels` | Character or factor vector of age labels. Length preserved in the output. |
| `interpret_fail` | How to handle unparsable labels, consistent with other agetime parsers. |

No `age_diagnose()` condition flags in v1 — keep the mental model simple (subtotal vs detail only).

### Value

Logical vector of length `length(labels)`.

| Value | Meaning |
|-------|---------|
| `TRUE` | This row's label is a subtotal: finest detail labels in the same vector fully partition its interval. |
| `FALSE` | Detail row, coarse-only band, incomplete subtotal candidate, missing, total, empty, or unparseable (when excluded from comparison). |

### Definition: subtotal label

Fix the set **U** of unique labels in one call (one group). Label **P ∈ U** is a **subtotal** when **all** of the following hold:

0. **P covers an explicit age interval** — parseable as a normal age group (closed, open-right, or single-year); not a grand total, missing value, or unparseable label (see [Explicit age interval](#explicit-age-interval-required-for-subtotals)). Equivalently: **P** is eligible for [`age_mapping(..., relation = "contains")`](R/age_mapping.R) as an interval endpoint, and [`age_is_total(P)`](R/age_is_total.R) is `FALSE`.
1. **P has at least one strict child in U** — another label strictly contained in **P** ([`age_mapping(U, U, relation = "contains")`](R/age_mapping.R), row **P**, column ≠ **P**). Let **C(P)** be this set.
2. **Finest detail in C(P) fully partitions P** — let **F(P) ⊆ C(P)** be labels that are **not** strict parents of any other label in **C(P)** (i.e. drop intermediate sub-bands such as `"0-1"` when `"0"` and `"1"` are also present). **F(P)** must form a gap-free, non-overlapping cover of **P**'s interval (interval algebra consistent with agetime; respect open endpoints).

In plain language: *ignore rolled-up bands that sit between **P** and the most detailed labels; if the most detailed labels in the group fully cover **P**, then **P** is a subtotal.*

If **P** has strict children but **F(P)** does not fully partition **P** → **P is not a subtotal** (incomplete detail → keep **P**).

Labels with no explicit interval, no strict children in **U**, or whose finest detail does not fully partition them, return `FALSE`.

### Algorithm

1. **Coerce** — `labels_chr <- as.character(labels)`.
2. **Build pool U** — unique labels that cover an explicit age interval:
   - Exclude `""`, [`age_is_missing()`](R/age_is_total.R), [`age_is_total()`](R/age_is_total.R), and unparseable labels (per `interpret_fail`).
   - **U** contains only labels satisfying condition (0) above; corresponding excluded rows return `FALSE`.
3. **Containment** — `map <- age_mapping(U, U, relation = "contains")`. For each **P ∈ U**, let **C(P)** = strict children of **P** in **U**. If **C(P)** is empty, **P** is not a subtotal.
4. **Finest detail** — **F(P) ← { y ∈ C(P) : no z ∈ C(P), z ≠ y, y contains z }** (labels in **C(P)** that are not strict parents of another member of **C(P)**).
5. **Partition test** — For each **P** with non-empty **F(P)**, test that **F(P)** covers **P**'s interval with no gaps and no overlaps within **P**'s range (same interval pipeline as [`age_diagnose()`](R/age_diagnose.R), restricted to the sub-range).
6. **Mark subtotals** — `subtotal_labels <- { P : partition test passes }`.
7. **Map to rows** — `labels_chr %in% subtotal_labels`.

**Single pass on original U** — nested labels can all be subtotals in one pass when each has finest detail that partitions it (e.g. `"0"`, `"1"`, `"0-1"`, `"2-3"`, `"0-3"` together → `"0-1"`, `"2-3"`, and `"0-3"` are subtotals; singles are not).

### Grouped use

The function must see **only one group's labels** at a time. With dplyr:

```r
stmf |>
  group_by(country, year) |>
  filter(!age_is_subtotal(age))
```

Calling `age_is_subtotal(df$age)` on an **ungrouped** column mixes schemes across countries/years and is usually wrong. Document this prominently in roxygen.

### Examples

```r
# Coarse-only — nothing is a subtotal
labs <- c("0-64", "65-79", "80+")
age_is_subtotal(labs)
# FALSE FALSE FALSE

# Complete fine bands + redundant "0-64"
labs <- c("0", "1-4", "5-9", "10-14", "15-19",
          "20-24", "25-29", "30-34", "35-39", "40-44",
          "45-49", "50-54", "55-59", "60-64",
          "0-64", "65-79", "80+")
age_is_subtotal(labs)
# ... FALSE for detail, TRUE for "0-64" only

# Incomplete fine — "0-64" is NOT a subtotal
labs <- c("0-4", "5-9", "0-64", "65-79", "80+")
age_is_subtotal(labs)
# FALSE FALSE FALSE FALSE FALSE

# Nested hierarchy — finest detail drives the test
labs <- c("0", "1", "2", "3", "0-1", "2-3", "0-3")
age_is_subtotal(labs)
# FALSE FALSE FALSE FALSE  TRUE  TRUE  TRUE
# "0-3": F = {0,1,2,3}; "0-1": F = {0,1}; "2-3": F = {2,3}

# Same bands without singles — mid-level pair partitions "0-3"
labs <- c("0-1", "2-3", "0-3")
age_is_subtotal(labs)
# FALSE FALSE TRUE

# Grand total — never a subtotal (no explicit interval)
labs <- c("0-4", "5-9", "Total")
age_is_subtotal(labs)
# FALSE FALSE FALSE
age_is_total(labs)
# FALSE FALSE TRUE
```

### Roxygen blurb

**Title:** Identify subtotal age group labels

**Description:** `age_is_subtotal()` tests whether each age label is a **subtotal** — an age band with an explicit interval that is already fully represented by finer age groups in the same data. Grand-total labels ([`age_is_total()`](R/age_is_total.R)) are never subtotals. Intended for grouped `filter()` / `mutate()` so each group (e.g. country–year) is assessed separately.

---

## 2. Relationship to other agetime functions

| Function | Role |
|----------|------|
| [`age_mapping()`](R/age_mapping.R) | `relation = "contains"` for parent–child edges |
| [`age_diagnose()`](R/age_diagnose.R) | Optional **post-filter** validation; not used to define subtotals |
| [`age_is_total()`](R/age_is_total.R) | Grand totals; complementary filter |
| [`age_is_missing()`](R/age_is_missing.R) | Exclude from partition pool |
| Cookbook mapping join | Recode onto another scheme; different problem |

**Precursor:** `finest_stmf_ages` / `drop_containing_parents` in multi-covid-data (`src/shared/deaths.R`). This spec adds the **full partition** guard so incomplete detail does not treat a broad band as a subtotal.

---

## 3. Edge cases to test

1. **Coarse-only group** — no subtotals; all `FALSE`.
2. **Complete detail + parent** — parent is subtotal (`TRUE` for parent rows only).
3. **Incomplete detail + parent** — parent **not** subtotal (all `FALSE` for that label).
4. **Nested bands** — e.g. `c("0","1","2","3","0-1","2-3","0-3")`: `"0-3"`, `"0-1"`, `"2-3"` subtotal; singles not (see §1 examples).
5. **Nested without singles** — `c("0-1","2-3","0-3")`: only `"0-3"` subtotal.
6. **Open-right parent** — e.g. `"80+"` with `"80-84"`, …, `"95-99"` fully covering 80+ → subtotal if **F(P)** partitions it.
7. **Duplicate rows** — logical length matches input; all copies of a subtotal label are `TRUE`.
8. **Factor input** — match on `as.character(labels)`, not integer codes; unused levels irrelevant.
9. **Missing / total / empty** — excluded from **U**; rows return `FALSE`; never subtotals.
10. **Mutual exclusivity** — for every label, `!(age_is_total(x) & age_is_subtotal(x))`; e.g. `"Total"` is never a subtotal.
11. **Unparseable** — per `interpret_fail`; excluded from **U** when silent/warn; rows `FALSE`.
12. **Length-0 input** — returns `logical(0)` (consistent with other `age_is_*` helpers).

---

## 4. Cookbook recipe (draft)

**Remove subtotal age rows**

### Problem

The same country–year includes both five-year age groups and a rolled-up band such as `"0-64"`. Summing counts would double-count.

### Solution

```r
stmf |>
  group_by(country, year) |>
  filter(!age_is_subtotal(age), !age_is_total(age)) |>
  ungroup()
```

### Discussion

`age_is_subtotal()` looks at **all age labels in the group**. A broad band is dropped only when finer labels fully account for its range. If detail is incomplete, the broad band is kept.

Always `group_by()` the dimensions that define one published table (e.g. country, year, sex) before filtering.

### See also

- [`age_is_total()`](R/age_is_total.R)
- [`age_diagnose()`](R/age_diagnose.R) — check the remaining scheme if needed
- [`age_mapping()`](R/age_mapping.R) — recode onto another classification

---

## 5. Documentation

**Separate help pages** — `age_is_subtotal()` gets its own `\name{age_is_subtotal}` page (not shared `@rdname` with `age_is_total()`). Same pattern as [`age_is_total()`](R/age_is_total.R) / [`age_is_missing()`](R/age_is_missing.R): related functions, distinct pages.

**Cross-links** — each page `@seealso` the other.

**Contrasting examples on both pages** — use the **same label vector** on each help page so users see the difference at a glance, not only via links.

Draft examples (adjust wording in roxygen):

```r
# Shared vector for both help pages
labels <- c("0-4", "5-9", "0-64", "Total")

# On ?age_is_total — label-intrinsic grand totals
age_is_total(labels)
# FALSE FALSE FALSE TRUE

# On ?age_is_subtotal — context-dependent; group must include finer bands
# (when run alone on this vector, "0-64" is not a subtotal — detail incomplete)
age_is_subtotal(labels)
# FALSE FALSE FALSE FALSE

# On ?age_is_subtotal — complete detail in same group
labs <- c("0", "1-4", "5-9", "10-14", "15-19",
          "20-24", "25-29", "30-34", "35-39", "40-44",
          "45-49", "50-54", "55-59", "60-64", "0-64", "Total")
age_is_subtotal(labs)   # TRUE only for "0-64"
age_is_total(labs)      # TRUE only for "Total"
```

On **`age_is_total`**: add a short note + the shared `labels` example above; point to `age_is_subtotal()` for rolled-up age bands.

On **`age_is_subtotal`**: include incomplete-fine and complete-fine examples from §1; end with combined filter:

```r
stmf |>
  group_by(country, year) |>
  filter(!age_is_subtotal(age), !age_is_total(age))
```

**When implementing:** update roxygen in [`R/age_is_total.R`](R/age_is_total.R), [`R/period_is_total.R`](R/period_is_total.R), and [`R/cohort_is_total.R`](R/cohort_is_total.R) (seealso + contrasting examples) plus new `R/*_is_subtotal.R` files; run `devtools::document()`.

Add a row to the package overview **Identify open intervals, totals, and missing** table in [`R/agetime-package.R`](R/agetime-package.R):

```r
#' | [age_is_subtotal()] | [period_is_subtotal()] | [cohort_is_subtotal()] |
```

---

## 6. Implementation notes

- **Internal:** `inner_is_subtotal()` in `R/inner_subtotal.R` (or `R/inner_is_subtotal.R`), parameterized by `label_type` (`"age"`, `"period"`, `"cohort"`) — same pattern as [`inner_is_total()`](R/inner_is_total.R).
- **Public:** `R/age_is_subtotal.R`, `R/period_is_subtotal.R`, `R/cohort_is_subtotal.R`.
- Internal helper: `inner_partition_covers(parent_interval, child_intervals)` — gap/overlap test on a sub-range; respect open-left (cohort/period) and open-right endpoints per domain.
- Export all three from NAMESPACE; add to package overview table.
- Tests: `tests/testthat/test-is-subtotal.R` (age), plus period/cohort cases or shared parameterized tests.
- No version bump required until release; document in NEWS when implemented.

---

## 7. Deferred

- **`age_set_finest()`** — choosing the finest *complete* partition from a label bag (advanced; separate spec if needed).
