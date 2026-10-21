## HAS_TESTS
#' Standardize Period Labels
#'
#' Convert period labels to the default \pkg{agetime} format for periods.
#'
#' @section Rules for formatting output:
#' 
#' | *Interval type* | *Rule*       | *Example* |
#' |---------------|-------------|-------------|
#' | single | `[a,a+1) -> "a"` | `[2020,2021) -> "2020"` |
#' | multi | `[a,a+n) -> "a-<a+n>"` | `[2020,2025) -> "2020-2025"` |
#' | open on left | `(-Inf,a) -> "<a"` | `(-Inf,2020) -> "<2020"` |
#' | open on right | `[a,Inf) -> "a+"` | `[2020,Inf) -> "2020+"` |
#' 
#' @inheritSection period_lower Rules for interpreting inputs
#'
#' @inheritParams period_lower
#' @inherit age_standard return
#'
#' @seealso
#' To create a new set of period labels, use
#' [period_labels_one()], [period_labels_five()], [period_labels_ten()],
#' or [period_labels()]. To clean existing labels, use
#' [period_standard()]. To map labels onto an existing set of
#' labels, use [period_coarsen_to()].
#'
#' - [age_standard()] Age equivalent of `period_standard()`
#' - [cohort_standard()] Cohort equivalent of `period_standard()`
#' - [period_labels()] Create period labels
#'
#' @examples
#' labels <- c("2025to2030", "1910--1914", " 2022 ", "all")
#' period_standard(labels)
#' @export
period_standard <- function(labels,
                            interpret_single = c("lower", "upper"),
                            interpret_multi = c("at_upper", "below_upper"),
                            interpret_fail = c("error", "warn", "silent")) {
  interpret_single <- match.arg(interpret_single)
  interpret_multi <- match.arg(interpret_multi)
  interpret_fail <- match.arg(interpret_fail)
  inner_standard(
    labels = labels,
    label_type = "period",
    interpret_single = interpret_single,
    interpret_multi = interpret_multi,
    interpret_fail = interpret_fail
  )
}
