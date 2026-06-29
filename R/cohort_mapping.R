#' Mapping Between Cohort Labels
#'
#' @description
#'
#' Create a mapping between cohort labels. A mapping
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
#' Tibbles produced by `cohort_mapping()` are sparse
#' in that they only include matches. Matrices
#' produced by `cohort_mapping()` are dense in that
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
#' @inheritParams cohort_lower
#' @param labels Vector of cohort labels.
#' @param y Vector of cohort labels. If
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
#' - [parsing_cohort_labels()] Interpretation details for cohort labels
#' - [age_mapping()] Age equivalent of `cohort_mapping()`
#' - [period_mapping()] Period equivalent of `cohort_mapping()`
#'
#' @examples
#' labels <- c("2020-2025", "2030", "2025-2027")
#' y <- c("2025-2030", "2020-2025", "2026-2034")
#' cohort_mapping(labels = labels, y = y)
#' cohort_mapping(labels = labels, y = y, format = "matrix")
#' cohort_mapping(labels = labels, y = y, relation = "contains")
#' cohort_mapping(labels = labels, y = y, relation = "is-contained-in")
#' cohort_mapping(labels = labels, y = y, relation = "overlaps-with")
#'
#' # sparse tibble vs dense matrix
#' labels <- c("2020-2025", "2030-2035")
#' y <- c("2020-2025", "<2025")
#' cohort_mapping(labels = labels, y = y) # one match
#' cohort_mapping(labels = labels, y = y, format = "matrix")
#'
#' # mapping 'labels' on to itself
#' labels <- c("2020--2025", "2020-2025", "<2030")
#' cohort_mapping(labels)
#' @export
# When labels or y is character(0), or a factor with no levels, returns an empty
# mapping (zero-row tibble or zero-by-zero matrix, per format).
cohort_mapping <- function(labels,
                           y = NULL,
                           relation = c(
                             "equals",
                             "contains",
                             "is-contained-in",
                             "overlaps-with"
                           ),
                           format = c("tibble", "matrix"),
                           interpret_single = c("lower", "upper"),
                           interpret_range = c("include", "exclude"),
                           interpret_fail = c("error", "warn", "silent")) {
  interpret_single <- match.arg(interpret_single)
  interpret_range <- match.arg(interpret_range)
  interpret_fail <- match.arg(interpret_fail)
  relation <- match.arg(relation)
  format <- match.arg(format)
  inner_mapping(
    labels = labels,
    y = y,
    relation = relation,
    format = format,
    label_type = "cohort",
    interpret_single = interpret_single,
    interpret_range = interpret_range,
    interpret_fail = interpret_fail
  )
}
