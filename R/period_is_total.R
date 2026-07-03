#' Identify Period Labels for Totals
#'
#' Find period labels that \pkg{agetime} interprets as totals.
#'
#' @inheritParams period_lower
#'
#' @return Logical vector with the same length as `labels`.
#'
#' @seealso
#' - [age_is_total()] Age equivalent of `period_is_total()`
#' - [cohort_is_total()] Cohort equivalent of `period_is_total()`
#'
#' @examples
#' labels <- c("2020-2025", "Total", "1999", "ALL")
#' period_is_total(labels)
#' @export

# When length(labels) == 0, returns logical(0).
period_is_total <- function(labels,
                            interpret_single = c("lower", "upper"),
                            interpret_range = c("include", "exclude"),
                            interpret_fail = c("error", "warn", "silent")) {
  interpret_single <- match.arg(interpret_single)
  interpret_range <- match.arg(interpret_range)
  interpret_fail <- match.arg(interpret_fail)
  inner_is_total(
    labels = labels,
    label_type = "period",
    interpret_single = interpret_single,
    interpret_range = interpret_range,
    interpret_fail = interpret_fail
  )
}
