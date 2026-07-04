#' Mapping Between Age Group Labels
#'
#' @description
#'
#' Create a mapping between age group labels. A mapping
#' depicts a relationship between the labels of `labels`
#' and the labels of `y`. The types of relationship
#' that can be mapped are:
#' - "labels equals y"
#' - "labels contains y"
#' - "labels is contained in y"
#' - "labels overlaps with y".
#'
#' @details
#'
#' If no value for `y` is supplied,
#' `labels` is mapped onto itself.
#'
#' Tibbles produced by `age_mapping()` are sparse
#' in that they only include matches. Matrices
#' produced by `age_mapping()` are dense in that
#' they include matches and non-matches. See the
#' example below.
#'
#' @section The `relation` argument:
#'
#' | `relation` | Endpoints of `labels` and `y`                   |
#' |:--------|-----------------------------------------------|
#' | `"equals"` | Endpoints equal  |
#' | `"contains"` | Endpoints of `y` inside endpoints of `labels`  |
#' | `"is-contained-in"`| Endpoints of `labels` inside endpoints of `y`  |
#' | `"overlaps-with"` | Endpoint of `labels` in `y`, or reverse |
#'
#' @inheritParams age_lower
#' @param labels Vector of age group labels.
#' @param y Vector of age group labels. If
#' no value supplied, `labels` is mapped onto itself.
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
#' labels <- c("0-4", "10", "5-7")
#' y <- c("5-9", "0-4", "6-14")
#' age_mapping(labels = labels, y = y)
#' age_mapping(labels = labels, format = "matrix")
#' age_mapping(labels = labels, y = y, relation = "contains")
#' age_mapping(labels = labels, y = y, relation = "is-contained-in")
#' age_mapping(labels = labels, y = y, relation = "overlaps-with")
#'
#' # sparse tibble vs dense matrix
#' labels <- c("0-4", "10-14")
#' y <- c("0-4", "5-9")
#' age_mapping(labels = labels, y = y) # one match
#' age_mapping(labels = labels, y = y, format = "matrix")
#'
#' # mapping 'labels' on to itself
#' labels <- c("0--4", "0-4", "5+")
#' age_mapping(labels)
#' @export
# When labels or y is character(0), or a factor with no levels, returns an empty
# mapping (zero-row tibble or zero-by-zero matrix, per format).
age_mapping <- function(labels,
                        y = NULL,
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
    labels = labels,
    y = y,
    relation = relation,
    format = format,
    label_type = "age",
    interpret_single = "lower",
    interpret_multi = "exclude",
    interpret_fail = interpret_fail
  )
}
