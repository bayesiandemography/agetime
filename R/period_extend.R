#' Extend a Set of Periods
#'
#' Continue an existing set of period labels.
#'
#' By default, the width of the new periods
#' is derived from the last element of `labels`,
#' but a value can be specified through the
#' `width` arugment.
#'
#' @inheritSection period_lower Rules for interpreting inputs
#'
#' @inheritParams period_lower
#' @param n Number of periods to add.
#' Default is `1`.
#' @param width Width of the periods
#' to be added.
#' @param include_x Should the return value
#' include `labels`? Default is `TRUE`.
#' @return Character vector or factor.
#'
#' @seealso
#' - [age_extend()] Age equivalent of `period_extend()`
#' - [cohort_extend()] Cohort equivalent of `period_extend()`
#'
#' @examples
#' labels <- c("2020-2025", "2025-2030")
#' period_extend(labels, n = 2)
#' period_extend(labels, n = 2, width = 10)
#' period_extend(labels, n = 2, include_x = FALSE)
#' @export

# When length(labels) == 0, throws an error (no interval to extend from).
period_extend <- function(labels,
                          n = 1L,
                          width = NULL,
                          include_x = TRUE,
                          interpret_single = c("lower", "upper"),
                          interpret_multi = c("include", "exclude"),
                          interpret_fail = c("error", "warn", "silent")) {
  interpret_single <- match.arg(interpret_single)
  interpret_multi <- match.arg(interpret_multi)
  interpret_fail <- match.arg(interpret_fail)
  inner_extend(
    labels = labels,
    n = n,
    width = width,
    include_x = include_x,
    label_type = "period",
    interpret_single = interpret_single,
    interpret_multi = interpret_multi,
    interpret_fail = interpret_fail
  )
}
