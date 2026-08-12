#' Identify Subtotal Cohort Labels
#'
#' Test whether each cohort label is a **subtotal**: a cohort with an
#' explicit interval that is already fully represented by finer cohorts
#' in the same data.
#'
#' Grand-total labels ([`cohort_is_total()`]) are never subtotals.
#'
#' Intended for grouped `filter()` / `mutate()` so each group is assessed
#' separately.
#'
#' @inheritSection cohort_lower Rules for interpreting inputs
#'
#' @inheritParams cohort_lower
#'
#' @return Logical vector with the same length as `labels`.
#'
#' @seealso
#' - [age_is_subtotal()] Age equivalent of `cohort_is_subtotal()`
#' - [period_is_subtotal()] Period equivalent of `cohort_is_subtotal()`
#' - [cohort_is_total()] Grand totals
#' - [cohort_is_missing()] Missing cohort labels
#' - [cohort_mapping()] Interval containment between label sets
#'
#' @examples
#' # Incomplete detail — broad cohort kept
#' cohort_is_subtotal(c("2020-2025", "2025-2030", "2020-2035"))
#'
#' labels <- c("2020-2025", "2025-2030", "2020-2035", "Total")
#' cohort_is_subtotal(labels)
#' cohort_is_total(labels)
#' @export

# When length(labels) == 0, returns logical(0).
cohort_is_subtotal <- function(labels,
                               interpret_single = c("lower", "upper"),
                               interpret_multi = c("include", "exclude"),
                               interpret_fail = c("error", "warn", "silent")) {
  interpret_single <- match.arg(interpret_single)
  interpret_multi <- match.arg(interpret_multi)
  interpret_fail <- match.arg(interpret_fail)
  inner_is_subtotal(
    labels = labels,
    label_type = "cohort",
    interpret_single = interpret_single,
    interpret_multi = interpret_multi,
    interpret_fail = interpret_fail
  )
}
