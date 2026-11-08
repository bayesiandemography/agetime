# agetime 1.0.0

- Initial CRAN release.

- New functions `age_set_order_tree()`, `period_set_order_tree()`,
  and `cohort_set_order_tree()` order the levels of labels that form
  a reporting tree, such as census tables with
  detailed ages, broad ages, and age not stated. Levels are ordered
  as leaves (by lower limit), then broader groups (each after the
  groups inside it), then missing values. Leaves can lie at different
  depths. Overlapping labels that do not nest, and totals, are
  errors.
- The diagnose and assert functions for ages, periods, and cohorts
  (for instance `age_diagnose_values()` and `age_assert_levels()`)
  have a new condition, `valid_tree`, which checks that labels form a
  reporting tree: labels nest, and the most detailed labels cover the
  full span with no gaps, so that every broader label is divided
  exactly into narrower ones.
- The assert functions (for instance `age_assert_values()` and
  `cohort_assert_levels()`) have new arguments `x_arg` and `call`,
  for use inside other functions. Error messages now name the labels
  being checked, as in "Age group labels in `age` fail check
  `no_gap`". By default, errors name the assert function; a calling
  function can supply `call = rlang::current_env()` so that errors,
  including errors from parsing labels, name that function instead.
  agetime now imports rlang (previously an indirect dependency).
- New functions `age_labels_tree()`, `period_labels_tree()`, and
  `cohort_labels_tree()` create labels for a reporting tree: detailed
  labels from `breaks`, broader labels given through `nodes` (nesting
  to any depth), and `"Missing"` for not stated (included by
  default). Labels are returned in the same order as
  `*_set_order_tree()`.
