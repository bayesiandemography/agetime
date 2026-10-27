## HAS_TESTS
#' Standardize Cohort Labels
#'
#' Convert cohort labels to the default \pkg{agetime} format for cohorts.
#'
#' @section Rules for formatting output:
#'
#' | *Interval type* | *Rule*       | *Example* |
#' |---------------|------------|----------|
#' | single | `[a,a+1) -> "a"` | `[2020,2021) -> "2020"` |
#' | multi | `[a,a+n) -> "a-<a+n>"` | `[2020,2025) -> "2020-2025"` |
#' | open on left | `(-Inf,a) -> "<a"` | `(-Inf,2020) -> "<2020"` |
#' | open on right | `[a,Inf) -> "a+"` | `[2020,Inf) -> "2020+"` |
#' 
#' @inheritSection cohort_lower Rules for interpreting inputs
#'
#' @inheritParams cohort_lower
#' @inherit age_standard return
#'
#' @seealso
#' - [age_standard()] Age equivalent of `cohort_standard()`
#' - [period_standard()] Period equivalent of `cohort_standard()`
#' - [cohort_labels()] Create cohort labels
#' - [cohort_coarsen_to()] Map labels onto an existing set of labels
#'
#' @examples
#' labels <- c("2025to2030", "1910--1915", " < 2022 ", "all")
#' cohort_standard(labels)
#' @export
cohort_standard <- function(labels,
                            interpret_single = c("lower", "upper"),
                            interpret_multi = NULL,
                            interpret_fail = c("error", "warn", "silent")) {
  interpret_single <- match.arg(interpret_single)
  interpret_multi <- resolve_interpret_multi(
    interpret_multi = interpret_multi,
    labels = labels,
    labels_other = NULL,
    label_type = "cohort",
    interpret_single = interpret_single
  )
  interpret_fail <- match.arg(interpret_fail)
  inner_standard(
    labels = labels,
    label_type = "cohort",
    interpret_single = interpret_single,
    interpret_multi = interpret_multi,
    interpret_fail = interpret_fail
  )
}
