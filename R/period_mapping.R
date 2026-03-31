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
#'
#' @returns A data.frame or matrix
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
period_mapping <- function(x,
                           y = NULL,
                           relation = c("equals", "contains", "contained", "overlaps"),
                           return_val = c("data.frame", "matrix"),
                           parse_one = c("lower", "upper"),
                           parse_multi = c("include", "exclude"),
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
  parse_one <- match.arg(parse_one)
  parse_multi <- match.arg(parse_multi)
  parse_fail <- match.arg(parse_fail)
  intervals_x <- intervals(labels = x,
                           label_type = "period",
                           parse_one = parse_one,
                           parse_multi = parse_multi,
                           parse_fail = parse_fail)
  intervals_y <- intervals(labels = y,
                           label_type = "period",
                           parse_one = parse_one,
                           parse_multi = parse_multi,
                           parse_fail = parse_fail)
  make_mapping(intervals_x = intervals_x,
               intervals_y = intervals_y,
               relation = relation,
               return_val = return_val)
}
