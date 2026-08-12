#' Identify Subtotal Period Labels
#'
#' Test whether each period label is a **subtotal**: a period with an
#' explicit interval that is already fully represented by finer periods
#' in the same data.
#'
#' Grand-total labels ([`period_is_total()`]) are never subtotals.
#'
#' Intended for grouped `filter()` / `mutate()` so each group is assessed
#' separately.
#'
#' @inheritSection period_lower Rules for interpreting inputs
#'
#' @inheritParams period_lower
#'
#' @return Logical vector with the same length as `labels`.
#'
#' @seealso
#' - [age_is_subtotal()] Age equivalent of `period_is_subtotal()`
#' - [cohort_is_subtotal()] Cohort equivalent of `period_is_subtotal()`
#' - [period_is_total()] Grand totals
#' - [period_is_missing()] Missing period labels
#' - [period_mapping()] Interval containment between label sets
#'
#' @examples
#' # Incomplete detail — broad period kept
#' period_is_subtotal(c("2020-2025", "2025-2030", "2020-2035"))
#'
#' labels <- c("2020-2025", "2025-2030", "2020-2035", "Total")
#' period_is_subtotal(labels)
#' period_is_total(labels)
#' @export

# When length(labels) == 0, returns logical(0).
period_is_subtotal <- function(labels,
                               interpret_single = c("lower", "upper"),
                               interpret_multi = c("include", "exclude"),
                               interpret_fail = c("error", "warn", "silent")) {
  interpret_single <- match.arg(interpret_single)
  interpret_multi <- match.arg(interpret_multi)
  interpret_fail <- match.arg(interpret_fail)
  inner_is_subtotal(
    labels = labels,
    label_type = "period",
    interpret_single = interpret_single,
    interpret_multi = interpret_multi,
    interpret_fail = interpret_fail
  )
}
