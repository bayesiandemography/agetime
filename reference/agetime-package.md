# Work with Age, Period, and Cohort Labels

Functions for cleaning, manipulating, and extracting information from
labels for age groups, periods, and cohorts.

## Get information about existing labels

**Extract lower limits, upper limits, widths, midpoints**

|  |  |  |
|----|----|----|
|  |  |  |
| [`age_lower()`](https://bayesiandemography.github.io/agetime/reference/age_lower.md) | [`period_lower()`](https://bayesiandemography.github.io/agetime/reference/period_lower.md) | [`cohort_lower()`](https://bayesiandemography.github.io/agetime/reference/cohort_lower.md) |
| [`age_upper()`](https://bayesiandemography.github.io/agetime/reference/age_lower.md) | [`period_upper()`](https://bayesiandemography.github.io/agetime/reference/period_lower.md) | [`cohort_upper()`](https://bayesiandemography.github.io/agetime/reference/cohort_lower.md) |
| [`age_width()`](https://bayesiandemography.github.io/agetime/reference/age_lower.md) | [`period_width()`](https://bayesiandemography.github.io/agetime/reference/period_lower.md) | [`cohort_width()`](https://bayesiandemography.github.io/agetime/reference/cohort_lower.md) |
| [`age_mid()`](https://bayesiandemography.github.io/agetime/reference/age_lower.md) | [`period_mid()`](https://bayesiandemography.github.io/agetime/reference/period_lower.md) | [`cohort_mid()`](https://bayesiandemography.github.io/agetime/reference/cohort_lower.md) |

**Identify open intervals and totals**

|  |  |  |
|----|----|----|
|  |  |  |
| [`age_is_open()`](https://bayesiandemography.github.io/agetime/reference/age_is_open.md) |  | [`cohort_is_open()`](https://bayesiandemography.github.io/agetime/reference/cohort_is_open.md) |
| [`age_is_total()`](https://bayesiandemography.github.io/agetime/reference/age_is_total.md) | [`period_is_total()`](https://bayesiandemography.github.io/agetime/reference/period_is_total.md) | [`cohort_is_total()`](https://bayesiandemography.github.io/agetime/reference/cohort_is_total.md) |

**Characterise or make assertions**

|  |  |  |
|----|----|----|
|  |  |  |
| [`age_check()`](https://bayesiandemography.github.io/agetime/reference/age_check.md) | [`period_check()`](https://bayesiandemography.github.io/agetime/reference/period_check.md) | [`cohort_check()`](https://bayesiandemography.github.io/agetime/reference/cohort_check.md) |
| [`age_assert()`](https://bayesiandemography.github.io/agetime/reference/age_check.md) | [`period_assert()`](https://bayesiandemography.github.io/agetime/reference/period_check.md) | [`cohort_assert()`](https://bayesiandemography.github.io/agetime/reference/cohort_check.md) |

**Create mappings between intervals**

|  |  |  |
|----|----|----|
|  |  |  |
| [`age_mapping()`](https://bayesiandemography.github.io/agetime/reference/age_mapping.md) | [`period_mapping()`](https://bayesiandemography.github.io/agetime/reference/period_mapping.md) | [`cohort_mapping()`](https://bayesiandemography.github.io/agetime/reference/cohort_mapping.md) |

## Clean or modify existing labels

**Use standard format**

|  |  |  |
|----|----|----|
|  |  |  |
| [`age_standard()`](https://bayesiandemography.github.io/agetime/reference/age_standard.md) | [`period_standard()`](https://bayesiandemography.github.io/agetime/reference/period_standard.md) | [`cohort_standard()`](https://bayesiandemography.github.io/agetime/reference/cohort_standard.md) |

**Modify boundaries**

|  |  |  |
|----|----|----|
|  |  |  |
| [`age_modify()`](https://bayesiandemography.github.io/agetime/reference/age_modify.md) | [`period_modify()`](https://bayesiandemography.github.io/agetime/reference/period_modify.md) | [`cohort_modify()`](https://bayesiandemography.github.io/agetime/reference/cohort_modify.md) |
| [`age_modify_five()`](https://bayesiandemography.github.io/agetime/reference/age_modify_five.md) | [`period_modify_five()`](https://bayesiandemography.github.io/agetime/reference/period_modify_five.md) | [`cohort_modify_five()`](https://bayesiandemography.github.io/agetime/reference/cohort_modify_five.md) |
| [`age_modify_ten()`](https://bayesiandemography.github.io/agetime/reference/age_modify_five.md) | [`period_modify_ten()`](https://bayesiandemography.github.io/agetime/reference/period_modify_five.md) | [`cohort_modify_ten()`](https://bayesiandemography.github.io/agetime/reference/cohort_modify_five.md) |
| [`age_modify_life()`](https://bayesiandemography.github.io/agetime/reference/age_modify_five.md) |  |  |

**Continue series**

|  |  |  |
|----|----|----|
|  |  |  |
| [`age_extend()`](https://bayesiandemography.github.io/agetime/reference/age_extend.md) | [`period_extend()`](https://bayesiandemography.github.io/agetime/reference/period_extend.md) | [`cohort_extend()`](https://bayesiandemography.github.io/agetime/reference/cohort_extend.md) |

**Fill in gaps in levels**

|  |  |  |
|----|----|----|
|  |  |  |
| [`age_levels_fill()`](https://bayesiandemography.github.io/agetime/reference/age_levels_fill.md) | [`period_levels_fill()`](https://bayesiandemography.github.io/agetime/reference/period_levels_fill.md) | [`cohort_levels_fill()`](https://bayesiandemography.github.io/agetime/reference/cohort_levels_fill.md) |
| [`age_levels_fill_one()`](https://bayesiandemography.github.io/agetime/reference/age_levels_fill.md) | [`period_levels_fill_one()`](https://bayesiandemography.github.io/agetime/reference/period_levels_fill.md) | [`cohort_levels_fill_one()`](https://bayesiandemography.github.io/agetime/reference/cohort_levels_fill.md) |
| [`age_levels_fill_five()`](https://bayesiandemography.github.io/agetime/reference/age_levels_fill.md) | [`period_levels_fill_five()`](https://bayesiandemography.github.io/agetime/reference/period_levels_fill.md) | [`cohort_levels_fill_five()`](https://bayesiandemography.github.io/agetime/reference/cohort_levels_fill.md) |
| [`age_levels_fill_ten()`](https://bayesiandemography.github.io/agetime/reference/age_levels_fill.md) | [`period_levels_fill_ten()`](https://bayesiandemography.github.io/agetime/reference/period_levels_fill.md) | [`cohort_levels_fill_ten()`](https://bayesiandemography.github.io/agetime/reference/cohort_levels_fill.md) |
| [`age_levels_fill_life()`](https://bayesiandemography.github.io/agetime/reference/age_levels_fill.md) |  |  |
| [`age_levels_set_open()`](https://bayesiandemography.github.io/agetime/reference/age_levels_set_open.md) |  | [`cohort_levels_set_open()`](https://bayesiandemography.github.io/agetime/reference/cohort_levels_set_open.md) |

**Put levels in order**

|  |  |  |
|----|----|----|
|  |  |  |
| [`age_levels_sort()`](https://bayesiandemography.github.io/agetime/reference/age_levels_sort.md) | [`period_levels_sort()`](https://bayesiandemography.github.io/agetime/reference/period_levels_sort.md) | [`cohort_levels_sort()`](https://bayesiandemography.github.io/agetime/reference/cohort_levels_sort.md) |

## Make new labels

**New labels with standard format**

|  |  |  |
|----|----|----|
|  |  |  |
| [`age_labels()`](https://bayesiandemography.github.io/agetime/reference/age_labels.md) | [`period_labels()`](https://bayesiandemography.github.io/agetime/reference/period_labels.md) | [`cohort_labels()`](https://bayesiandemography.github.io/agetime/reference/cohort_labels.md) |
| [`age_labels_one()`](https://bayesiandemography.github.io/agetime/reference/age_labels.md) | [`period_labels_one()`](https://bayesiandemography.github.io/agetime/reference/period_labels.md) | [`cohort_labels_one()`](https://bayesiandemography.github.io/agetime/reference/cohort_labels.md) |
| [`age_labels_five()`](https://bayesiandemography.github.io/agetime/reference/age_labels.md) | [`period_labels_five()`](https://bayesiandemography.github.io/agetime/reference/period_labels.md) | [`cohort_labels_five()`](https://bayesiandemography.github.io/agetime/reference/cohort_labels.md) |
| [`age_labels_ten()`](https://bayesiandemography.github.io/agetime/reference/age_labels.md) | [`period_labels_ten()`](https://bayesiandemography.github.io/agetime/reference/period_labels.md) | [`cohort_labels_ten()`](https://bayesiandemography.github.io/agetime/reference/cohort_labels.md) |
| [`age_labels_life()`](https://bayesiandemography.github.io/agetime/reference/age_labels.md) |  |  |

## See also

Useful links:

- <https://bayesiandemography.github.io/agetime/>

## Author

**Maintainer**: John Bryant <john@bayesiandemography.com>

Authors:

- John Bryant <john@bayesiandemography.com>

- Junni Zhang <junni@bayesiandemography.com>
