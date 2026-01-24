# Functions for Working with Age, Period, and Cohort Labels

|                                                                                          |                                                                                            |                     |                            |
|------------------------------------------------------------------------------------------|--------------------------------------------------------------------------------------------|---------------------|----------------------------|
| age                                                                                      | period                                                                                     | cohort              | Description                |
| `age_create()`                                                                           | `period_create()`                                                                          | `cohort_create()`   | Make new label set         |
| `age_open()`                                                                             | `period_open()`                                                                            | `cohort_open()`     | Define open interval       |
| `age_extend()`                                                                           | `period_extend()`                                                                          | `cohort_extend()`   | Append to existing set     |
| `age_standard()`                                                                         | `period_standard()`                                                                        | `cohort_standard()` | Convert to standard format |
| `age_check()`                                                                            | `period_check()`                                                                           | `cohort_check()`    | Label format valid?        |
| [`age_lower()`](https://bayesiandemography.github.io/agetime/reference/age_lower.md)     | [`period_lower()`](https://bayesiandemography.github.io/agetime/reference/period_lower.md) | `cohort_lower()`    | Lower limits of intervals  |
| [`age_upper()`](https://bayesiandemography.github.io/agetime/reference/age_lower.md)     | [`period_upper()`](https://bayesiandemography.github.io/agetime/reference/period_lower.md) | `cohort_upper()`    | Upper limits of intervals  |
| [`age_width()`](https://bayesiandemography.github.io/agetime/reference/age_lower.md)     | [`period_width()`](https://bayesiandemography.github.io/agetime/reference/period_lower.md) | `cohort_width()`    | Widths of intervals        |
| [`age_mid()`](https://bayesiandemography.github.io/agetime/reference/age_lower.md)       | [`period_mid()`](https://bayesiandemography.github.io/agetime/reference/period_lower.md)   | `cohort_mid()`      | Midpoints of intervals     |
| [`age_mapping()`](https://bayesiandemography.github.io/agetime/reference/age_mapping.md) | `period_mapping()`                                                                         | `cohort_mapping()`  | Mapping between label sets |
| `age_is_total()`                                                                         | `period_is_total()`                                                                        | `cohort_is_total()` | Is interval 'total'?       |
| `age_is_open()`                                                                          | `period_is_open()`                                                                         | `cohort_is_open()`  | Is interval open?          |
| `age_coarsen()`                                                                          | `period_coarsen()`                                                                         | `cohort_coarsen()`  | Less detailed label set    |
| `age_complete()`                                                                         | `period_complete()`                                                                        | `cohort_complete()` | Intervals cover range?     |
| `age_disjoint()`                                                                         | `period_disjoint()`                                                                        | `cohort_disjoint()` | Intervals do not overlap?  |
| `age_uniform()`                                                                          | `period_uniform()`                                                                         | `cohort_uniform()`  | Intervals equal width?     |

## See also

Useful links:

- <https://bayesiandemography.github.io/agetime/>

## Author

**Maintainer**: John Bryant <john@bayesiandemography.com>

Authors:

- Junni Zhang <junni@bayesiandemography.com>
