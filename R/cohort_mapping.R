#' Mapping Between Cohort Labels
#'
#' @description
#'
#' Create a mapping between cohort labels. A mapping
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
#' Tibbles produced by `cohort_mapping()` are sparse
#' in that they only include matches. Matrices
#' produced by `cohort_mapping()` are dense in that
#' they include matches and non-matches. See the
#' example below.
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
#' @inheritParams cohort_lower
#' @param x Vector of cohort labels.
#' @param y Vector of cohort labels. If
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
#' - [parsing_cohort_labels()] Details for `x_one`, `x_multi`, and `x_fail`
#' - [age_mapping()] Age equivalent of `cohort_mapping()`
#' - [period_mapping()] Period equivalent of `cohort_mapping()`
#'
#' @examples
#' x <- c("2020-2025", "2030", "2025-2027")
#' y <- c("2025-2030", "2020-2025", "2026-2034")
#' cohort_mapping(x = x, y = y)
#' cohort_mapping(x = x, y = y, format = "matrix")
#' cohort_mapping(x = x, y = y, relation = "contains")
#' cohort_mapping(x = x, y = y, relation = "is-contained-in")
#' cohort_mapping(x = x, y = y, relation = "overlaps-with")
#'
#' # sparse tibble vs dense matrix
#' x <- c("2020-2025", "2030-2035")
#' y <- c("2020-2025", "<2025")
#' cohort_mapping(x = x, y = y) # one match
#' cohort_mapping(x = x, y = y, format = "matrix") # 1 match and 3 non-matches
#'
#' # mapping 'x' on to itself
#' x <- c("2020--2025", "2020-2025", "<2030")
#' cohort_mapping(x)
#' @export
# When x or y is character(0), or a factor with no levels, returns an empty
# mapping (zero-row tibble or zero-by-zero matrix, per format).
cohort_mapping <- function(x,
                           y = NULL,
                           relation = c(
                             "equals",
                             "contains",
                             "is-contained-in",
                             "overlaps-with"
                           ),
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
    label_type = "cohort",
    x_one = x_one,
    x_multi = x_multi,
    x_fail = x_fail
  )
}
