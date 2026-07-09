#' Extend a Set of Age Groups
#'
#' Continue an existing set of age group labels.
#'
#' By default, the width of the new age groups
#' is derived from the last element of `labels`,
#' but a value can be specified through the
#' `width` arugment.
#'
#' @inheritParams age_lower
#' @param n Number of age groups to add.
#' Default is `1`.
#' @param width Width of the age groups
#' to be added.
#' @param include_x Should the return value
#' include `labels`? Default is `TRUE`.
#' @return Character vector or factor.
#'
#' @seealso
#' - [period_extend()] Period equivalent of `age_extend()`
#' - [cohort_extend()] Cohort equivalent of `age_extend()`
#'
#' @examples
#' labels <- c("0-4", "5-9")
#' age_extend(labels, n = 2)
#' age_extend(labels, n = 2, width = 10)
#' age_extend(labels, n = 2, include_x = FALSE)
#' @export

# When length(labels) == 0, throws an error (no interval to extend from).
age_extend <- function(labels,
                       n = 1L,
                       width = NULL,
                       include_x = TRUE,
                       interpret_fail = c("error", "warn", "silent")) {
  interpret_fail <- match.arg(interpret_fail)
  inner_extend(
    labels = labels,
    n = n,
    width = width,
    include_x = include_x,
    label_type = "age",
    interpret_single = "lower",
    interpret_multi = "exclude",
    interpret_fail = interpret_fail
  )
}
