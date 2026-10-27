# agetime 0.3.0

## New features

- New functions `age_interval()`, `period_interval()`, and
  `cohort_interval()` describe labels using interval notation, such as
  `"[2020, 2025)"`, which is useful for checking how labels are being
  interpreted.
- Age labels such as `"Under 16"`, `"less than 5"`, and `"<5"` are now
  recognized, and describe the age group starting at 0. For instance,
  `"Under 16"` becomes `"0-15"`, and `"Under 1"` becomes `"0"`.
  Period and cohort labels such as `"<2000"` are still open on the left.
- Age labels may now start with `"age"`, `"ages"`, or `"aged"`, as in
  `"Age 0-4"` or `"Age not stated"`.
- Age labels may now have year words attached to numbers, as in
  `"5-9yrs"` and `"85yrs+"`, and may end with `"years old"`.
- More words for open intervals are recognized: `"and up"`,
  `"or above"`, `"& over"`, and `"& above"` for intervals that are
  open on the right, and, for periods and cohorts, `"or earlier"`,
  `"and earlier"`, `"or before"`, and `"and before"` for intervals that
  are open on the left.
- Totals written with a qualifier, such as `"Total, all ages"` and
  `"Total (all ages)"`, are now recognized, as is `"All years"`.
- Period labels now recognize words for open intervals, such as
  `"before 2000"` and `"2000 or more"`, and cohort labels now recognize
  words such as `"2000 or more"`.
- Period and cohort labels such as `"2000 or later"` and
  `"2000 and later"` are now recognized, and describe the interval
  starting at 2000.

- `age_diagnose()`, `age_assert()`, and their `_values()` variants
  have a new `no_open_right` check, and the period and cohort
  equivalents have new `no_open_left` and `no_open_right` checks.
  These check that no interval is open, and complement the existing
  `has_open_left` and `has_open_right` checks.

## Changes to behaviour

- `age_coarsen_five()`, `age_coarsen_ten()`, `age_coarsen_life()`,
  and their period and cohort equivalents now always return a factor,
  as `age_coarsen()` and `age_coarsen_to()` already did. Previously
  they returned a character vector when `labels` was a character
  vector.
- `age_lower()`, `age_upper()`, `age_mid()`, `age_width()`, the
  `age_is_*()` functions, and their period and cohort equivalents no
  longer name their results with the label strings. Results keep the
  names of `labels`, if any, as base R functions such as `nchar()` do.
- `age_mid()`, `period_mid()`, and `cohort_mid()` now give an open
  interval a midpoint half the width of the nearest closed interval,
  rather than half the median width of all closed intervals. For
  instance, `age_mid(c("0", "1-4", "5-9", "80+"))` gives `82.5` for
  `"80+"`. If there are no closed intervals, the functions throw an
  error, rather than returning `Inf`.
- The `no_overlap` condition in `age_diagnose()`, `age_assert()`, and
  their variants now fails when different labels describe the same
  interval, such as `"0"` and `"infant"`. Repeated copies of the same
  label still pass.
- Error messages from `age_assert()`, `period_assert()`,
  `cohort_assert()`, and their `_values()` variants now name each
  failed condition and describe the problem, for instance
  "Age group labels fail check `no_gap`.", rather than printing a
  table.
- Clarified that `interpret_single` applies only to single-year
  labels, that is, labels consisting of a year and nothing else, such
  as `"2020"`. Labels for open periods and cohorts are read the same
  way whatever the value of `interpret_single`. For instance,
  `"2000 or more"`, like `"2000+"`, always starts at 2000, and
  `"before 2000"`, like `"<2000"`, always ends at 2000.
- Period and cohort labels starting with `"-"`, such as `"-2000"`, now
  give an error saying that negative values are not accepted.
  Previously `"-2000"` was read as `"<2000"`.
- Errors from `age_coarsen()`, `age_coarsen_to()`, and their variants
  now distinguish labels that would be split from labels that are not
  fully covered by the new intervals, show the range covered by the new
  intervals, and suggest fixes such as setting `open_right = TRUE`.
- The values of `interpret_multi` and `format_multi` in period and
  cohort functions are now `"at_upper"` and `"below_upper"`, which
  replace `"include"` and `"exclude"`. The new names say where the
  second number in a label such as `"2020-2025"` sits relative to the
  upper limit of the interval: with `"at_upper"`, 2025 is the upper
  limit, and with `"below_upper"`, it is one year below. The old
  values are no longer accepted. Labels are interpreted and formatted
  exactly as before.
- The default for `interpret_multi` in period and cohort functions is
  now `NULL`. `NULL` behaves like `"at_upper"`, but gives a message
  when a multi-year label has a width of 4, 9, 14, ... years, such as
  `"1990-1994"`, since the label was probably written using the
  `"below_upper"` convention. Supplying a value for `interpret_multi`
  silences the message.
- The `include_x` argument of `age_extend()`, `period_extend()`, and
  `cohort_extend()` is now called `include_labels`, to match the
  `labels` argument.
- In `age_mapping()`, `period_mapping()`, and `cohort_mapping()`,
  the `relation` values `"is-contained-in"` and `"overlaps-with"` are
  now `"is_contained_in"` and `"overlaps_with"`.
- Errors now report the function the user called, such as
  `age_standard()`, rather than an internal helper.
- Errors and warnings about labels that cannot be parsed now quote
  the label as supplied, such as `"Age not stated4"`, rather than the
  internal normalized form, such as `"notstated4"`.

## Bug fixes

- `age_coarsen_five()`, and other coarsening functions based on
  widths, now give an informative error when all labels are open and
  `open_right` or `open_left` is `FALSE`. Previously they gave the
  error "missing value where TRUE/FALSE needed".

- Labels such as `"2000 or less"`, `"2000 and under"`,
  `"2000 and below"`, and `"up to 2000"` now include 2000. Previously
  they were treated like `"before 2000"`.
- `"or older"`, `"and older"`, and `"or younger"` are no longer
  recognized in period and cohort labels. For cohorts, an older cohort
  is an earlier one, so `"1990 or older"` was previously given the
  opposite of its intended meaning. These words are still recognized
  in age labels.
- agetime no longer needs dplyr, which was used without being listed
  in Imports.
- Labels containing decimals, such as `"5.5"`, now give the error
  "Don't know how to interpret label". Previously `"."` was treated as
  a range separator, so `"5.5"` was read as `"5-5"` and gave a
  misleading error about a one-year age group.

## Dependencies

- agetime now imports vctrs, and no longer imports pillar or stats.
  vctrs was already installed with tibble, so installing agetime
  requires no additional packages.

## Documentation

- The README, `?age_labels`, and the help for `age_standard()`,
  `age_coarsen_to()`, and their period and cohort equivalents now
  explain when to create labels with `age_labels_*()`, clean them with
  `age_standard()`, and map them onto a target with
  `age_coarsen_to()`.
- The help for `period_lower()` and `cohort_lower()` now explains how
  words and symbols for open intervals are interpreted.
