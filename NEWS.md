# agetime 1.0.0

- Initial CRAN release.

- New function `age_set_order_tree()` orders the levels of age group
  labels that form a reporting tree, such as census tables with
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
- New function `age_labels_tree()` creates labels for a reporting
  tree: detailed age groups from `breaks`, broader age groups given
  as labels (nesting to any depth), and `"Missing"` for age not
  stated (included by default). Labels are returned in the same
  order as `age_set_order_tree()`.
