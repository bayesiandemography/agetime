#' Mapping Between Cohort Labels
#'
#' @description
#'
#' Create a mapping between cohort labels. A mapping
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
#' Tibbles produced by `cohort_mapping()` are sparse
#' in that they only include matches. Matrices
#' produced by `cohort_mapping()` are dense in that
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
#' @inheritSection cohort_lower Controlling how cohort labels are interpreted
#'
#' @inheritParams cohort_lower
#' @param labels_x Vector of cohort labels.
#' @param labels_y Vector of cohort labels. If
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
#' - [age_mapping()] Age equivalent of `cohort_mapping()`
#' - [period_mapping()] Period equivalent of `cohort_mapping()`
#'
#' @examples
#' labels_x <- c("2020-2025", "2030", "2025-2027")
#' labels_y <- c("2025-2030", "2020-2025", "2026-2034")
#' cohort_mapping(labels_x = labels_x, labels_y = labels_y)
#' cohort_mapping(labels_x = labels_x, labels_y = labels_y, format = "matrix")
#' cohort_mapping(labels_x = labels_x, labels_y = labels_y, relation = "contains")
#' cohort_mapping(labels_x = labels_x, labels_y = labels_y, relation = "is-contained-in")
#' cohort_mapping(labels_x = labels_x, labels_y = labels_y, relation = "overlaps-with")
#'
#' # sparse tibble vs dense matrix
#' labels_x <- c("2020-2025", "2030-2035")
#' labels_y <- c("2020-2025", "<2025")
#' cohort_mapping(labels_x = labels_x, labels_y = labels_y) # one match
#' cohort_mapping(labels_x = labels_x, labels_y = labels_y, format = "matrix")
#'
#' # mapping 'labels_x' on to itself
#' labels_x <- c("2020--2025", "2020-2025", "<2030")
#' cohort_mapping(labels_x)
#' @export
# When labels_x or labels_y is character(0), or a factor with no levels, returns
# an empty mapping (zero-row tibble or zero-by-zero matrix, per format).
cohort_mapping <- function(labels_x,
                           labels_y = NULL,
                           relation = c(
                             "equals",
                             "contains",
                             "is-contained-in",
                             "overlaps-with"
                           ),
                           format = c("tibble", "matrix"),
                           interpret_single = c("lower", "upper"),
                           interpret_multi = c("include", "exclude"),
                           interpret_fail = c("error", "warn", "silent")) {
  interpret_single <- match.arg(interpret_single)
  interpret_multi <- match.arg(interpret_multi)
  interpret_fail <- match.arg(interpret_fail)
  relation <- match.arg(relation)
  format <- match.arg(format)
  inner_mapping(
    labels_x = labels_x,
    labels_y = labels_y,
    relation = relation,
    format = format,
    label_type = "cohort",
    interpret_single = interpret_single,
    interpret_multi = interpret_multi,
    interpret_fail = interpret_fail
  )
}
