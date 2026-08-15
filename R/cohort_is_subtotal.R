#' Identify Cohort Labels for Subtotals
#'
#' Find categories representing subtotals in cohort labels.
#'
#' A subtotal is a label that can be rebuilt from two or more
#' other labels in the set. For instance, in
#' `c("2020-2025", "2025-2030", "2030-2035", "2020-2030", "Total")`,
#' `"2020-2030"` is a subtotal because it covers the same interval as
#' `"2020-2025"` and `"2025-2030"`.
#'
#' Subtotals are distinct from grand total labels
#' such as `"Total"` or `"All"`, which are identified
#' by [cohort_is_total()].
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
#' - [cohort_is_total()] Identify grand totals
#' - [cohort_is_missing()] Identify missing cohort labels
#' - [cohort_is_open_left()] Identify cohorts open on left
#' - [cohort_is_open_right()] Identify cohorts open on right
#'
#' @examples
#' labels <- c(
#'   cohort_labels_five(lower_first = 2000, lower_last = 2035),
#'   "2000-2015",
#'   "2015-2040",
#'   "Total"
#' )
#' cohort_is_subtotal(labels)
#' cohort_is_total(labels)
#'
#' ## subtotals must fully cover range
#' labels_no_2020_2025 <- setdiff(labels, "2020-2025")
#' cohort_is_subtotal(labels_no_2020_2025) ## "2015-2040" not subtotal
#'
#' ## subtotals can overlap
#' labels_2000_2040 <- c(labels, "2000-2040")
#' cohort_is_subtotal(labels_2000_2040)
#'
#' ## use to filter data
#' library(dplyr, warn.conflicts = FALSE)
#' df <- data.frame(
#'   cohort = c("2020-2025", "2025-2030", "2030-2035", "2020-2035"),
#'   value = c(100, 200, 300, 400)
#' )
#' df |>
#'   filter(!cohort_is_subtotal(cohort))
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
