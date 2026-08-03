#' Mapping Between Period Labels
#'
#' @description
#'
#' Create a mapping between period labels. A mapping
#' depicts a relationship between `labels_x` and `labels_y`.
#' The types of relationship that can be mapped are:
#' - "`labels_x` equals `labels_y`"
#' - "`labels_x` contains `labels_y`"
#' - "`labels_x` is contained in `labels_y`"
#' - "`labels_x` overlaps with `labels_y`".
#'
#' @details
#'
#' If no value for `labels_y` is supplied,
#' `labels_x` is mapped onto itself.
#'
#' Tibbles produced by `period_mapping()` are sparse
#' in that they only include matches. Matrices
#' produced by `period_mapping()` are dense in that
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
#' @inheritSection period_lower Rules for interpreting inputs
#'
#' @inheritParams period_lower
#' @param labels_x Vector of period labels.
#' @param labels_y Vector of period labels. If
#' no value supplied, `labels_x` is mapped onto itself.
#' @param relation Relationship between
#' labels. Choices are `"equals"` (the default),
#' `"contains"`, `"is-contained-in"`, and `"overlaps-with"`.
#' See below for details and examples.
#' @param format Format of
#' return value. Choices are `"tibble"`
#' (the default) or `"matrix"`.
#' @param name_x,name_y Names for the two sides of the mapping
#' in the return value. Defaults are `"x"` and `"y"`.
#' Applied to tibble columns and to matrix dimnames.
#' @return [Tibble][tibble::tibble()] or matrix,
#' depending on the value of `format`.
#'
#' @seealso
#' - [age_mapping()] Age equivalent of `period_mapping()`
#' - [cohort_mapping()] Cohort equivalent of `period_mapping()`
#'
#' @examples
#' x <- c("2020-2025", "2030", "2025-2027")
#' y <- c("2025-2030", "2020-2025", "2026-2034")
#' period_mapping(labels_x = x, labels_y = y)
#' period_mapping(labels_x = x, labels_y = y, format = "matrix")
#' period_mapping(labels_x = x, labels_y = y, relation = "contains")
#' period_mapping(labels_x = x, labels_y = y, relation = "is-contained-in")
#' period_mapping(labels_x = x, labels_y = y, relation = "overlaps-with")
#'
#' # sparse tibble vs dense matrix
#' x <- c("2020-2025", "2030-2035")
#' y <- c("2020-2025", "2025-2030")
#' period_mapping(labels_x = x, labels_y = y) # one match
#' period_mapping(labels_x = x, labels_y = y, format = "matrix")
#'
#' # map labels_x onto itself
#' x <- c("2020--2025", "2020-2025", "2030")
#' period_mapping(x)
#' @export
# When labels_x or labels_y is character(0), or a factor with no levels, returns
# an empty mapping (zero-row tibble or zero-by-zero matrix, per format).
period_mapping <- function(labels_x,
                           labels_y = NULL,
                           relation = c(
                             "equals",
                             "contains",
                             "is-contained-in",
                             "overlaps-with"
                           ),
                           format = c("tibble", "matrix"),
                           name_x = "x",
                           name_y = "y",
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
    name_x = name_x,
    name_y = name_y,
    label_type = "period",
    interpret_single = interpret_single,
    interpret_multi = interpret_multi,
    interpret_fail = interpret_fail
  )
}
