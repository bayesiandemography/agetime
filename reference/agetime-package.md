# Work with Age, Period, and Cohort Labels

Functions for working with labels for age groups, periods, and cohorts.

## Functions

**Extract lower limits, upper limits, widths, midpoints**

|  |  |  |
|----|----|----|
|  |  |  |
| [`age_lower()`](https://bayesiandemography.github.io/agetime/reference/age_lower.md) | [`period_lower()`](https://bayesiandemography.github.io/agetime/reference/period_lower.md) | [`cohort_lower()`](https://bayesiandemography.github.io/agetime/reference/cohort_lower.md) |
| [`age_upper()`](https://bayesiandemography.github.io/agetime/reference/age_lower.md) | [`period_upper()`](https://bayesiandemography.github.io/agetime/reference/period_lower.md) | [`cohort_upper()`](https://bayesiandemography.github.io/agetime/reference/cohort_lower.md) |
| [`age_width()`](https://bayesiandemography.github.io/agetime/reference/age_lower.md) | [`period_width()`](https://bayesiandemography.github.io/agetime/reference/period_lower.md) | [`cohort_width()`](https://bayesiandemography.github.io/agetime/reference/cohort_lower.md) |
| [`age_mid()`](https://bayesiandemography.github.io/agetime/reference/age_lower.md) | [`period_mid()`](https://bayesiandemography.github.io/agetime/reference/period_lower.md) | [`cohort_mid()`](https://bayesiandemography.github.io/agetime/reference/cohort_lower.md) |

**Identify open intervals, totals, and missing values**

|  |  |  |
|----|----|----|
|  |  |  |
|  | [`period_is_open_left()`](https://bayesiandemography.github.io/agetime/reference/period_is_open_left.md) | [`cohort_is_open_left()`](https://bayesiandemography.github.io/agetime/reference/cohort_is_open_left.md) |
| [`age_is_open_right()`](https://bayesiandemography.github.io/agetime/reference/age_is_open_right.md) | [`period_is_open_right()`](https://bayesiandemography.github.io/agetime/reference/period_is_open_left.md) | [`cohort_is_open_right()`](https://bayesiandemography.github.io/agetime/reference/cohort_is_open_left.md) |
| [`age_is_total()`](https://bayesiandemography.github.io/agetime/reference/age_is_total.md) | [`period_is_total()`](https://bayesiandemography.github.io/agetime/reference/period_is_total.md) | [`cohort_is_total()`](https://bayesiandemography.github.io/agetime/reference/cohort_is_total.md) |
| [`age_is_missing()`](https://bayesiandemography.github.io/agetime/reference/age_is_missing.md) | [`period_is_missing()`](https://bayesiandemography.github.io/agetime/reference/period_is_missing.md) | [`cohort_is_missing()`](https://bayesiandemography.github.io/agetime/reference/cohort_is_missing.md) |
| [`age_is_subtotal()`](https://bayesiandemography.github.io/agetime/reference/age_is_subtotal.md) | [`period_is_subtotal()`](https://bayesiandemography.github.io/agetime/reference/period_is_subtotal.md) | [`cohort_is_subtotal()`](https://bayesiandemography.github.io/agetime/reference/cohort_is_subtotal.md) |

**Use agetime default format**

|  |  |  |
|----|----|----|
|  |  |  |
| [`age_standard()`](https://bayesiandemography.github.io/agetime/reference/age_standard.md) | [`period_standard()`](https://bayesiandemography.github.io/agetime/reference/period_standard.md) | [`cohort_standard()`](https://bayesiandemography.github.io/agetime/reference/cohort_standard.md) |

**Coarsen intervals**

|  |  |  |
|----|----|----|
|  |  |  |
| [`age_coarsen()`](https://bayesiandemography.github.io/agetime/reference/age_coarsen.md) | [`period_coarsen()`](https://bayesiandemography.github.io/agetime/reference/period_coarsen.md) | [`cohort_coarsen()`](https://bayesiandemography.github.io/agetime/reference/cohort_coarsen.md) |
| [`age_coarsen_to()`](https://bayesiandemography.github.io/agetime/reference/age_coarsen_to.md) | [`period_coarsen_to()`](https://bayesiandemography.github.io/agetime/reference/period_coarsen_to.md) | [`cohort_coarsen_to()`](https://bayesiandemography.github.io/agetime/reference/cohort_coarsen_to.md) |
| [`age_coarsen_five()`](https://bayesiandemography.github.io/agetime/reference/age_coarsen_five.md) | [`period_coarsen_five()`](https://bayesiandemography.github.io/agetime/reference/period_coarsen_five.md) | [`cohort_coarsen_five()`](https://bayesiandemography.github.io/agetime/reference/cohort_coarsen_five.md) |
| [`age_coarsen_ten()`](https://bayesiandemography.github.io/agetime/reference/age_coarsen_five.md) | [`period_coarsen_ten()`](https://bayesiandemography.github.io/agetime/reference/period_coarsen_five.md) | [`cohort_coarsen_ten()`](https://bayesiandemography.github.io/agetime/reference/cohort_coarsen_five.md) |
| [`age_coarsen_life()`](https://bayesiandemography.github.io/agetime/reference/age_coarsen_five.md) |  |  |

**Continue series**

|  |  |  |
|----|----|----|
|  |  |  |
| [`age_extend()`](https://bayesiandemography.github.io/agetime/reference/age_extend.md) | [`period_extend()`](https://bayesiandemography.github.io/agetime/reference/period_extend.md) | [`cohort_extend()`](https://bayesiandemography.github.io/agetime/reference/cohort_extend.md) |

**Fill in gaps in levels**

|  |  |  |
|----|----|----|
|  |  |  |
| [`age_fill()`](https://bayesiandemography.github.io/agetime/reference/age_fill.md) | [`period_fill()`](https://bayesiandemography.github.io/agetime/reference/period_fill.md) | [`cohort_fill()`](https://bayesiandemography.github.io/agetime/reference/cohort_fill.md) |
| [`age_fill_one()`](https://bayesiandemography.github.io/agetime/reference/age_fill.md) | [`period_fill_one()`](https://bayesiandemography.github.io/agetime/reference/period_fill.md) | [`cohort_fill_one()`](https://bayesiandemography.github.io/agetime/reference/cohort_fill.md) |
| [`age_fill_five()`](https://bayesiandemography.github.io/agetime/reference/age_fill.md) | [`period_fill_five()`](https://bayesiandemography.github.io/agetime/reference/period_fill.md) | [`cohort_fill_five()`](https://bayesiandemography.github.io/agetime/reference/cohort_fill.md) |
| [`age_fill_ten()`](https://bayesiandemography.github.io/agetime/reference/age_fill.md) | [`period_fill_ten()`](https://bayesiandemography.github.io/agetime/reference/period_fill.md) | [`cohort_fill_ten()`](https://bayesiandemography.github.io/agetime/reference/cohort_fill.md) |
| [`age_fill_life()`](https://bayesiandemography.github.io/agetime/reference/age_fill.md) |  |  |

**Define open intervals**

|  |  |  |
|----|----|----|
|  |  |  |
|  | [`period_set_open_left()`](https://bayesiandemography.github.io/agetime/reference/period_set_open_left.md) | [`cohort_set_open_left()`](https://bayesiandemography.github.io/agetime/reference/cohort_set_open_left.md) |
| [`age_set_open_right()`](https://bayesiandemography.github.io/agetime/reference/age_set_open_right.md) | [`period_set_open_right()`](https://bayesiandemography.github.io/agetime/reference/period_set_open_left.md) | [`cohort_set_open_right()`](https://bayesiandemography.github.io/agetime/reference/cohort_set_open_left.md) |

**Put levels in order**

|  |  |  |
|----|----|----|
|  |  |  |
| [`age_set_order()`](https://bayesiandemography.github.io/agetime/reference/age_set_order.md) | [`period_set_order()`](https://bayesiandemography.github.io/agetime/reference/period_set_order.md) | [`cohort_set_order()`](https://bayesiandemography.github.io/agetime/reference/cohort_set_order.md) |

**Create new labels**

|  |  |  |
|----|----|----|
|  |  |  |
| [`age_labels()`](https://bayesiandemography.github.io/agetime/reference/age_labels.md) | [`period_labels()`](https://bayesiandemography.github.io/agetime/reference/period_labels.md) | [`cohort_labels()`](https://bayesiandemography.github.io/agetime/reference/cohort_labels.md) |
| [`age_labels_one()`](https://bayesiandemography.github.io/agetime/reference/age_labels.md) | [`period_labels_one()`](https://bayesiandemography.github.io/agetime/reference/period_labels.md) | [`cohort_labels_one()`](https://bayesiandemography.github.io/agetime/reference/cohort_labels.md) |
| [`age_labels_five()`](https://bayesiandemography.github.io/agetime/reference/age_labels.md) | [`period_labels_five()`](https://bayesiandemography.github.io/agetime/reference/period_labels.md) | [`cohort_labels_five()`](https://bayesiandemography.github.io/agetime/reference/cohort_labels.md) |
| [`age_labels_ten()`](https://bayesiandemography.github.io/agetime/reference/age_labels.md) | [`period_labels_ten()`](https://bayesiandemography.github.io/agetime/reference/period_labels.md) | [`cohort_labels_ten()`](https://bayesiandemography.github.io/agetime/reference/cohort_labels.md) |
| [`age_labels_life()`](https://bayesiandemography.github.io/agetime/reference/age_labels.md) |  |  |

**Characterise labels or make assertions**

|  |  |  |
|----|----|----|
|  |  |  |
| [`age_diagnose()`](https://bayesiandemography.github.io/agetime/reference/age_diagnose.md) | [`period_diagnose()`](https://bayesiandemography.github.io/agetime/reference/period_diagnose.md) | [`cohort_diagnose()`](https://bayesiandemography.github.io/agetime/reference/cohort_diagnose.md) |
| [`age_diagnose_values()`](https://bayesiandemography.github.io/agetime/reference/age_diagnose.md) | [`period_diagnose_values()`](https://bayesiandemography.github.io/agetime/reference/period_diagnose.md) | [`cohort_diagnose_values()`](https://bayesiandemography.github.io/agetime/reference/cohort_diagnose.md) |
| [`age_assert()`](https://bayesiandemography.github.io/agetime/reference/age_diagnose.md) | [`period_assert()`](https://bayesiandemography.github.io/agetime/reference/period_diagnose.md) | [`cohort_assert()`](https://bayesiandemography.github.io/agetime/reference/cohort_diagnose.md) |
| [`age_assert_values()`](https://bayesiandemography.github.io/agetime/reference/age_diagnose.md) | [`period_assert_values()`](https://bayesiandemography.github.io/agetime/reference/period_diagnose.md) | [`cohort_assert_values()`](https://bayesiandemography.github.io/agetime/reference/cohort_diagnose.md) |

**Create mappings between labels**

|  |  |  |
|----|----|----|
|  |  |  |
| [`age_mapping()`](https://bayesiandemography.github.io/agetime/reference/age_mapping.md) | [`period_mapping()`](https://bayesiandemography.github.io/agetime/reference/period_mapping.md) | [`cohort_mapping()`](https://bayesiandemography.github.io/agetime/reference/cohort_mapping.md) |

## See also

Useful links:

- <https://bayesiandemography.github.io/agetime/>

## Author

**Maintainer**: John Bryant <john@bayesiandemography.com>

Authors:

- John Bryant <john@bayesiandemography.com>

- Junni Zhang <junni@bayesiandemography.com>
