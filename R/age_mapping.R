#' Mapping Between Age Group Labels
#'
#' @description
#'
#' Create a mapping between age group labels. A mapping
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
#' @param name_x,name_y Names for the two sides of the mapping
#' in the return value. Defaults are `"x"` and `"y"`.
#' Applied to tibble columns and to matrix dimnames.
#' @return [Tibble][tibble::tibble()] or matrix,
#' depending on the value of `format`.
#'
#' @seealso
#' - [age_coarsen_to()] Recode labels into another classification
#' - [period_mapping()] Period equivalent of `age_mapping()`
#' - [cohort_mapping()] Cohort equivalent of `age_mapping()`
#'
#' @examples
#' x <- c("0-4", "10", "5-7")
#' y <- c("5-9", "0-4", "6-14")
#' age_mapping(labels_x = x, labels_y = y)
#' age_mapping(labels_x = x, labels_y = y, format = "matrix")
#' age_mapping(labels_x = x, labels_y = y, relation = "contains")
#' age_mapping(labels_x = x, labels_y = y, relation = "is-contained-in")
#' age_mapping(labels_x = x, labels_y = y, relation = "overlaps-with")
#'
#' # sparse tibble vs dense matrix
#' x <- c("0-4", "10-14")
#' y <- c("0-4", "5-9")
#' age_mapping(labels_x = x, labels_y = y) # one match
#' age_mapping(labels_x = x, labels_y = y, format = "matrix")
#'
#' # map labels_x onto itself
#' x <- c("0--4", "0-4", "5+")
#' age_mapping(x)
#'
#' ## recode a data-frame column into categories from labels_y
#' library(dplyr, warn.conflicts = FALSE)
#' df <- tibble(
#'   age = c("0", "1", "5", "10", "11"),
#'   n = c(3, 1, 4, 6, 7)
#' )
#' y <- c("0-4", "5-9", "10-14")
#' map <- age_mapping(
#'   df$age,
#'   y,
#'   relation = "is-contained-in",
#'   name_x = "age"
#' )
#' df <- df |>
#'   left_join(map, by = "age")
#' df
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
                        name_x = "x",
                        name_y = "y",
                        interpret_fail = c("error", "warn", "silent")) {
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
    label_type = "age",
    interpret_single = "lower",
    interpret_multi = "exclude",
    interpret_fail = interpret_fail
  )
}
