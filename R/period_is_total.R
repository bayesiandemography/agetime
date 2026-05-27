
#' Identify Period Labels for Totals
#'
#' Find period labels that \pkg{agetime} interprets as totals.
#' 
#' @inheritParams period_lower
#'
#' @returns
#' Logical vector the same length as `x`.
#'
#' @seealso
#' [age_is_total()] Age equivalent of `[period_is_total()`
#' [cohort_is_total()] Cohort equivalent of `period_is_total()`
#'
#' @examples
#' x <- c("2020-2025", "Total", "1999", "ALL")
#' period_is_total(x)
#' @export
period_is_total <- function(x,
                            x_one = c("lower", "upper"),
                            x_multi = c("include", "exclude"),
                            x_fail = c("error", "warn", "silent")) {
  x_one <- match.arg(x_one)
  x_multi <- match.arg(x_multi)
  x_fail <- match.arg(x_fail)
  inner_is_total(x = x,
                 label_type = "period",
                 x_one = x_one,
                 x_multi = x_multi,
                 x_fail = x_fail)
}
