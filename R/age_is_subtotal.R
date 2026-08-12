#' Identify Subtotal Age Group Labels
#'
#' Test whether each age label is a **subtotal**: an age band with an
#' explicit interval that is already fully represented by finer age groups
#' in the same data.
#'
#' Grand-total labels ([`age_is_total()`]) are never subtotals.
#' A label like `"0-64"` is a subtotal only when the finest matching
#' labels in the group fully partition its range. If detail is incomplete,
#' the broad band is kept.
#'
#' Intended for grouped `filter()` / `mutate()` so each group
#' (e.g. country–year) is assessed separately. Calling
#' `age_is_subtotal(df$age)` on an ungrouped column mixes schemes across
#' groups and is usually wrong.
#'
#' @inheritParams age_lower
#'
#' @return Logical vector with the same length as `labels`.
#'
#' @seealso
#' - [age_is_total()] Grand totals (`"Total"`, `"All ages"`, ...)
#' - [age_is_missing()] Missing age group labels
#' - [age_mapping()] Interval containment between label sets
#'
#' @examples
#' # Coarse-only — nothing is a subtotal
#' age_is_subtotal(c("0-64", "65-79", "80+"))
#'
#' # Incomplete detail — "0-64" is not a subtotal
#' labels <- c("0-4", "5-9", "0-64", "Total")
#' age_is_subtotal(labels)
#' age_is_total(labels)
#'
#' # Nested hierarchy — finest detail drives the test
#' age_is_subtotal(c("0", "1", "2", "3", "0-1", "2-3", "0-3"))
#'
#' # Complete fine bands + redundant "0-64"
#' labs <- c(
#'   "0", "1-4", "5-9", "10-14", "15-19",
#'   "20-24", "25-29", "30-34", "35-39", "40-44",
#'   "45-49", "50-54", "55-59", "60-64", "0-64", "Total"
#' )
#' age_is_subtotal(labs)
#' age_is_total(labs)
#' @export

# When length(labels) == 0, returns logical(0).
age_is_subtotal <- function(labels,
                            interpret_fail = c("error", "warn", "silent")) {
  interpret_fail <- match.arg(interpret_fail)
  inner_is_subtotal(
    labels = labels,
    label_type = "age",
    interpret_single = "lower",
    interpret_multi = "exclude",
    interpret_fail = interpret_fail
  )
}
