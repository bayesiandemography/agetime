#' Mapping Between Cohort Labels
#'
#' @description
#' 
#' Create a mapping between cohort labels. The mapping is
#' based on one of four types of relationship:
#  "equals", "contains", "is contained by",
#  and "overlaps with".
#'
#' @details
#'
#' If no value for `y` is supplied,
#' `x` is mapped onto itself.
#' 
#' @section The `relation` argument:
#' 
#' | `relation` | Endpoints of `x` and `y`                   |
#' |:--------|-----------------------------------------------|
#' | `"equals"` | `cohort_lower(x) == cohort_lower(y) & cohort_upper(x) == cohort_upper(y)`   |
#' | `"contains"` | `cohort_lower(x) <= cohort_lower(y) & cohort_upper(y) <= cohort_upper(x)` |
#' | `"contained"`| `cohort_lower(y) <= cohort_lower(x) & cohort_upper(x) <= cohort_upper(y)`  |
#' | `"overlaps"` | `(cohort_lower(y) <= cohort_lower(x) < cohort_upper(y))` &#124; `(cohort_lower(y) <= cohort_upper(x) < cohort_upper(y))` |
#' 
#' @inheritParams cohort_lower
#' @param x Vector of cohort labels.
#' @param y Vector of cohort labels. If
#' no value supplied, `x` is mapped onto itself.
#' @param relation Relationship between
#' labels. The choices are `"equals"` (the default),
#' `"contains"`, `"contained"`, and `"overlaps"`.
#' See below for details and examples.
#' @param return_val The format of the
#' return value. The choices are `"data.frame"`
#' (the default) or `"matrix"`.
#'
#' @returns A data.frame or matrix
#'
#' @examples
#' x <- c("2020-2025", "2030", "2025-2027")
#' y <- c("2025-2030", "2020-2025", "2026-2034")
#' cohort_mapping(x = x, y = y)
#' cohort_mapping(x, return_val = "matrix")
#' cohort_mapping(x = x, y = y, relation = "contains")
#' cohort_mapping(x = x, y = y, relation = "contained")
#' cohort_mapping(x = x, y = y, relation = "overlaps")
#' @export
cohort_mapping <- function(x,
                           y = NULL,
                           relation = c("equals", "contains", "contained", "overlaps"),
                           return_val = c("data.frame", "matrix"),
                           x_one = c("lower", "upper"),
                           x_multi = c("include", "exclude"),
                           x_fail = c("error", "warn", "silent")) {
  x <- to_character_or_factor(x = x,
                              nm_x = "x",
                              length_zero_ok = FALSE)
  if (is.null(y))
    y <- x
  else
    y <- to_character_or_factor(x = y,
                                nm_x = "y",
                                length_zero_ok = FALSE)
  relation <- match.arg(relation)
  return_val <- match.arg(return_val)
  x_one <- match.arg(x_one)
  x_multi <- match.arg(x_multi)
  x_fail <- match.arg(x_fail)
  intervals_x <- intervals(labels = x,
                           label_type = "cohort",
                           x_one = x_one,
                           x_multi = x_multi,
                           x_fail = x_fail)
  intervals_y <- intervals(labels = y,
                           label_type = "cohort",
                           x_one = x_one,
                           x_multi = x_multi,
                           x_fail = x_fail)
  make_mapping(intervals_x = intervals_x,
               intervals_y = intervals_y,
               relation = relation,
               return_val = return_val)
}
