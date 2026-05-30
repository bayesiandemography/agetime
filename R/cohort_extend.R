
#' Extend a Set of Cohorts
#'
#' Add new cohorts at the end of `x`.
#'
#' By default, the width of the new cohorts
#' is derived from the last element of `x`,
#' but a value can be specified through the
#' `width` arugment.
#' 
#' @inheritParams cohort_lower
#' @param n Number of cohorts to add.
#' Default is `1`.
#' @param width Width of the cohorts
#' to be added.
#' @param include_x Should the return value
#' include `x`? Default is `TRUE`.
#' @return A factor if `x` is a factor; otherwise a character vector.
#'
#' @seealso
#' - [age_extend()] Age equivalent of `cohort_extend()`
#' - [period_extend()] Period equivalent of `cohort_extend()`
#'
#' @examples
#' x <- c("2020-2025", "2025-2030")
#' cohort_extend(x, n = 2)
#' cohort_extend(x, n = 2, width = 10)
#' cohort_extend(x, n = 2, include_x = FALSE)
#' @export

# When length(x) == 0, throws an error (no interval to extend from). If width
# is NULL, the error suggests supplying width explicitly.
cohort_extend <- function(x,
                          n = 1L,
                          width = NULL,
                          include_x = TRUE,
                          x_one = c("lower", "upper"),
                          x_multi = c("include", "exclude"),
                          x_fail = c("error", "warn", "silent")) {
  x_one <- match.arg(x_one)
  x_multi <- match.arg(x_multi)
  x_fail <- match.arg(x_fail)
  inner_extend(x = x,
               n = n,
               width = width,
               include_x = include_x,
               label_type = "cohort",
               x_one = x_one,
               x_multi = x_multi,
               x_fail = x_fail)
}



