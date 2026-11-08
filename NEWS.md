# agetime 1.0.0

- Initial CRAN release.

- New function `age_set_order_tree()` orders the levels of age group
  labels that form a reporting tree, such as census tables with
  detailed ages, broad ages, and age not stated. Levels are ordered
  as leaves (by lower limit), then broader groups (each after the
  groups inside it), then missing values. Leaves can lie at different
  depths. Overlapping labels that do not nest, and totals, are
  errors.
