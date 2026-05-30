#' Mapping Between Age Group Labels
#'
#' @description
#' 
#' Create a mapping between age group labels. The mapping is
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
#' | `"equals"` | `age_lower(x) == age_lower(y) & age_upper(x) == age_upper(y)`   |
#' | `"contains"` | `age_lower(x) <= age_lower(y) & age_upper(y) <= age_upper(x)` |
#' | `"contained"`| `age_lower(y) <= age_lower(x) & age_upper(x) <= age_upper(y)`  |
#' | `"overlaps"` | `(age_lower(y) <= age_lower(x) < age_upper(y))` &#124; `(age_lower(y) <= age_upper(x) < age_upper(y))` |
#' 
#' @inheritParams age_lower
#' @param x Vector of age group labels.
#' @param y Vector of age group labels. If
#' no value supplied, `x` is mapped onto itself.
#' @param relation Relationship between
#' labels. The choices are `"equals"` (the default),
#' `"contains"`, `"contained"`, and `"overlaps"`.
#' See below for details and examples.
#' @param return_val The format of the
#' return value. The choices are `"data.frame"`
#' (the default) or `"matrix"`.
#'
#' @return A data.frame or matrix.
#'
#' When `x` or `y` is `character(0)`, or a factor with no levels, returns an
#' empty mapping (a zero-row data frame or zero-by-zero matrix, according to
#' `return_val`).
#'
#' @examples
#' x <- c("0-4", "10", "5-7")
#' y <- c("5-9", "0-4", "6-14")
#' age_mapping(x = x, y = y)
#' age_mapping(x, return_val = "matrix")
#' age_mapping(x = x, y = y, relation = "contains")
#' age_mapping(x = x, y = y, relation = "contained")
#' age_mapping(x = x, y = y, relation = "overlaps")
#' @export
age_mapping <- function(x,
                        y = NULL,
                        relation = c("equals", "contains", "contained", "overlaps"),
                        return_val = c("data.frame", "matrix"),
                        x_fail = c("error", "warn", "silent")) {
  x_fail <- match.arg(x_fail)
  relation <- match.arg(relation)
  return_val <- match.arg(return_val)
  inner_mapping(x = x,
                y = y,
                relation = relation,
                return_val = return_val,
                label_type = "age",
                x_one = "lower",
                x_multi = "exclude",
                x_fail = x_fail)
}
