#' Mapping Between Age Group Labels
#'
#' @description
#'
#' Create a mapping between age group labels. A mapping
#' depicts a relationship between the labels of `labels_x`
#' and the labels of `labels_y`. The types of relationship
#' that can be mapped are:
#' - "labels_x equals labels_y"
#' - "labels_x contains labels_y"
#' - "labels_x is contained in labels_y"
#' - "labels_x overlaps with labels_y".
#'
#' @details
#'
#' If no value for `labels_y` is supplied,
#' `labels_x` is mapped onto itself.
#'
#' Tibbles produced by `age_mapping()` are sparse
#' in that they only include matches. Matrices
#' produced by `age_mapping()` are dense in that
#' they include matches and non-matches. See the
#' example below.
#'
#' @section The `relation` argument:
#'
#' | `relation` | Endpoints of `labels_x` and `labels_y`                   |
#' |:--------|-----------------------------------------------|
#' | `"equals"` | Endpoints equal  |
#' | `"contains"` | Endpoints of `labels_y` inside endpoints of `labels_x`  |
#' | `"is-contained-in"`| Endpoints of `labels_x` inside endpoints of `labels_y`  |
#' | `"overlaps-with"` | Endpoint of `labels_x` in `labels_y`, or reverse |
#'
#' @inheritParams age_lower
#' @param labels_x Vector of age group labels.
#' @param labels_y Vector of age group labels. If
#' no value supplied, `labels_x` is mapped onto itself.
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
#' labels_x <- c("0-4", "10", "5-7")
#' labels_y <- c("5-9", "0-4", "6-14")
#' age_mapping(labels_x = labels_x, labels_y = labels_y)
#' age_mapping(labels_x = labels_x, format = "matrix")
#' age_mapping(labels_x = labels_x, labels_y = labels_y, relation = "contains")
#' age_mapping(labels_x = labels_x, labels_y = labels_y, relation = "is-contained-in")
#' age_mapping(labels_x = labels_x, labels_y = labels_y, relation = "overlaps-with")
#'
#' # sparse tibble vs dense matrix
#' labels_x <- c("0-4", "10-14")
#' labels_y <- c("0-4", "5-9")
#' age_mapping(labels_x = labels_x, labels_y = labels_y) # one match
#' age_mapping(labels_x = labels_x, labels_y = labels_y, format = "matrix")
#'
#' # mapping 'labels_x' on to itself
#' labels_x <- c("0--4", "0-4", "5+")
#' age_mapping(labels_x)
#' @export
# When labels_x or labels_y is character(0), or a factor with no levels, returns
# an empty mapping (zero-row tibble or zero-by-zero matrix, per format).
age_mapping <- function(labels_x,
                        labels_y = NULL,
                        relation = c(
                          "equals",
                          "contains",
                          "is-contained-in",
                          "overlaps-with"
                        ),
                        format = c("tibble", "matrix"),
                        interpret_fail = c("error", "warn", "silent")) {
  interpret_fail <- match.arg(interpret_fail)
  relation <- match.arg(relation)
  format <- match.arg(format)
  inner_mapping(
    labels_x = labels_x,
    labels_y = labels_y,
    relation = relation,
    format = format,
    label_type = "age",
    interpret_single = "lower",
    interpret_multi = "exclude",
    interpret_fail = interpret_fail
  )
}
