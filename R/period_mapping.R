#' Mapping Between Period Labels
#'
#' @description
#' 
#' Create a mapping between period labels. The mapping is
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
#' | `"equals"` | `period_lower(x) == period_lower(y) & period_upper(x) == period_upper(y)`   |
#' | `"contains"` | `period_lower(x) <= period_lower(y) & period_upper(y) <= period_upper(x)` |
#' | `"contained"`| `period_lower(y) <= period_lower(x) & period_upper(x) <= period_upper(y)`  |
#' | `"overlaps"` | `(period_lower(y) <= period_lower(x) < period_upper(y))` &#124; `(period_lower(y) <= period_upper(x) < period_upper(y))` |
#' 
#' @inheritParams period_lower
#' @param x Vector of period labels.
#' @param y Vector of period labels. If
#' no value supplied, `x` is mapped onto itself.
#' @param relation Relationship between
#' labels. The choices are `"equals"` (the default),
#' `"contains"`, `"contained"`, and `"overlaps"`.
#' See below for details and examples.
#' @param return_val The format of the
#' return value. The choices are `"data.frame"`
#' (the default) or `"matrix"`.
#' @return A data.frame or matrix.
#'
#' @seealso
#' [age_mapping()] Age equivalent of `period_mapping()`
#' [cohort_mapping()] Cohort equivalent of `period_mapping()`
#'
#' @examples
#' x <- c("2020-2025", "2030", "2025-2027")
#' y <- c("2025-2030", "2020-2025", "2026-2034")
#' period_mapping(x = x, y = y)
#' period_mapping(x, return_val = "matrix")
#' period_mapping(x = x, y = y, relation = "contains")
#' period_mapping(x = x, y = y, relation = "contained")
#' period_mapping(x = x, y = y, relation = "overlaps")
#' @export

# When x or y is character(0), or a factor with no levels, returns an empty
# mapping (zero-row data frame or zero-by-zero matrix, per return_val).
period_mapping <- function(x,
                           y = NULL,
                           relation = c("equals", "contains", "contained", "overlaps"),
                           return_val = c("data.frame", "matrix"),
                           x_one = c("lower", "upper"),
                           x_multi = c("include", "exclude"),
                           x_fail = c("error", "warn", "silent")) {
  x_one <- match.arg(x_one)
  x_multi <- match.arg(x_multi)
  x_fail <- match.arg(x_fail)
  relation <- match.arg(relation)
  return_val <- match.arg(return_val)
  inner_mapping(x = x,
                y = y,
                relation = relation,
                return_val = return_val,
                label_type = "period",
                x_one = x_one,
                x_multi = x_multi,
                x_fail = x_fail)
}
