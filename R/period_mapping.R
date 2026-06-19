#' Mapping Between Period Labels
#'
#' @description
#'
#' Create a mapping between period labels. A mapping
#' depicts a relationship between the labels of `x`
#' and the labels of `y`. The types of relationship
#' that can be mapped are:
#' - "x equals y"
#' - "x contains y"
#' - "x is contained in y"
#' - "x overlaps with y".
#'
#' @details
#'
#' If no value for `y` is supplied,
#' `x` is mapped onto itself.
#'
#' Tibbles produced by `period_mapping()` are sparse, while matrices are dense. See the example below.
#'
#' @section The `relation` argument:
#'
#' | `relation` | Endpoints of `x` and `y`                   |
#' |:--------|-----------------------------------------------|
#' | `"equals"` | Endpoints equal  |
#' | `"contains"` | Endpoints of `y` inside endpoints of `x`  |
#' | `"is-contained-in"`| Endpoints of `x` inside endpoints of `y`  |
#' | `"overlaps-with"` | Endpoint of `x` in `y` or endpoint of `y` in `x` |
#'
#' @inheritParams period_lower
#' @param x Vector of period labels.
#' @param y Vector of period labels. If
#' no value supplied, `x` is mapped onto itself.
#' @param relation Relationship between
#' labels. Choices are `"equals"` (the default),
#' `"contains"`, `"is-contained-in"`, and `"overlaps-with"`.
#' See below for details and examples.
#' @param format Format of
#' return value. Choices are `"tibble"`
#' (the default) or `"matrix"`.
#' @return [Tibble][tibble::tibble()] or matrix, depending on `format`.
#'
#' @seealso
#' - [parsing_period_labels()] Details for `x_one`, `x_multi`, and `x_fail`
#' - [age_mapping()] Age equivalent of `period_mapping()`
#' - [cohort_mapping()] Cohort equivalent of `period_mapping()`
#'
#' @examples
#' x <- c("2020-2025", "2030", "2025-2027")
#' y <- c("2025-2030", "2020-2025", "2026-2034")
#' period_mapping(x = x, y = y)
#' period_mapping(x = x, y = y, format = "matrix")
#' period_mapping(x = x, y = y, relation = "contains")
#' period_mapping(x = x, y = y, relation = "is-contained-in")
#' period_mapping(x = x, y = y, relation = "overlaps-with")
#'
#' # sparse tibble vs dense matrix
#' x <- c("2020-2025", "2030-2035")
#' y <- c("2020-2025", "2025-2030")
#' period_mapping(x = x, y = y) # one match
#' period_mapping(x = x, y = y, format = "matrix") # one match and three non-matches
#'
#' # mapping 'x' on to itself
#' x <- c("2020--2025", "2020-2025", "2030")
#' period_mapping(x)
#' @export
# When x or y is character(0), or a factor with no levels, returns an empty
# mapping (zero-row tibble or zero-by-zero matrix, per format).
period_mapping <- function(x,
                           y = NULL,
                           relation = c("equals", "contains", "is-contained-in", "overlaps-with"),
                           format = c("tibble", "matrix"),
                           x_one = c("lower", "upper"),
                           x_multi = c("include", "exclude"),
                           x_fail = c("error", "warn", "silent")) {
  x_one <- match.arg(x_one)
  x_multi <- match.arg(x_multi)
  x_fail <- match.arg(x_fail)
  relation <- match.arg(relation)
  format <- match.arg(format)
  inner_mapping(
    x = x,
    y = y,
    relation = relation,
    format = format,
    label_type = "period",
    x_one = x_one,
    x_multi = x_multi,
    x_fail = x_fail
  )
}
