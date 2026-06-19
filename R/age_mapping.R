#' Mapping Between Age Group Labels
#'
#' @description
#'
#' Create a mapping between age group labels. A mapping
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
#' Tibbles produced by `age_mapping()` are sparse
#' in that they only include matches. Matrices
#' produced by `age_mapping()` are dense in that
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
#' @inheritParams age_lower
#' @param x Vector of age group labels.
#' @param y Vector of age group labels. If
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
#' - [period_mapping()] Period equivalent of `age_mapping()`
#' - [cohort_mapping()] Cohort equivalent of `age_mapping()`
#'
#' @examples
#' x <- c("0-4", "10", "5-7")
#' y <- c("5-9", "0-4", "6-14")
#' age_mapping(x = x, y = y)
#' age_mapping(x = x, format = "matrix")
#' age_mapping(x = x, y = y, relation = "contains")
#' age_mapping(x = x, y = y, relation = "is-contained-in")
#' age_mapping(x = x, y = y, relation = "overlaps-with")
#'
#' # sparse tibble vs dense matrix
#' x <- c("0-4", "10-14")
#' y <- c("0-4", "5-9")
#' age_mapping(x = x, y = y) # one match
#' age_mapping(x = x, y = y, format = "matrix") # 1 match, 3 non-matches
#'
#' # mapping 'x' on to itself
#' x <- c("0--4", "0-4", "5+")
#' age_mapping(x)
#' @export
# When x or y is character(0), or a factor with no levels, returns an empty
# mapping (zero-row tibble or zero-by-zero matrix, per format).
age_mapping <- function(x,
                        y = NULL,
                        relation = c(
                          "equals",
                          "contains",
                          "is-contained-in",
                          "overlaps-with"
                        ),
                        format = c("tibble", "matrix"),
                        x_fail = c("error", "warn", "silent")) {
  x_fail <- match.arg(x_fail)
  relation <- match.arg(relation)
  format <- match.arg(format)
  inner_mapping(
    x = x,
    y = y,
    relation = relation,
    format = format,
    label_type = "age",
    x_one = "lower",
    x_multi = "exclude",
    x_fail = x_fail
  )
}
