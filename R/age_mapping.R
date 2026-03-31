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
#' @returns A data.frame or matrix
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
                        parse_fail = c("error", "warn", "silent")) {
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
  parse_fail <- match.arg(parse_fail)
  intervals_x <- intervals(labels = x,
                           label_type = "age",
                           parse_one = "lower",
                           parse_multi = "exclude",
                           parse_fail = parse_fail)
  intervals_y <- intervals(labels = y,
                           label_type = "age",
                           parse_one = "lower",
                           parse_multi = "exclude",
                           parse_fail = parse_fail)
  make_mapping(intervals_x = intervals_x,
               intervals_y = intervals_y,
               relation = relation,
               return_val = return_val)
}
