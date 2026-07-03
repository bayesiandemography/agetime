## HAS_TESTS
#' Standardize Age Group Labels
#'
#' Convert age group labels to the default \pkg{agetime} format.
#'
#' @inheritParams age_lower
#'
#' @return Character vector or factor with the same length as `labels`.
#'
#' @seealso
#' - [period_standard()] Period equivalent of `age_standard()`
#' - [cohort_standard()] Cohort equivalent of `age_standard()`
#'
#' @examples
#' labels <- c("5to9", "10--14", "100plus")
#' age_standard(labels)
#'
#' ## factor input: factor in, factor out
#' age_standard(factor(c("5to9", "10--14")))
#' @export

# Character input returns character; factor input returns factor with the same
# length and ordered attribute. Element values and levels(labels)
# are standardized.
# When length(labels) == 0, returns character(0); for factors, standardized
# levels are still applied. With interpret_fail = "silent", unparseable labels
# become NA.
age_standard <- function(labels,
                         interpret_fail = c("error", "warn", "silent")) {
  interpret_fail <- match.arg(interpret_fail)
  inner_standard(
    labels = labels,
    label_type = "age",
    interpret_single = "lower",
    interpret_range = "exclude",
    interpret_fail = interpret_fail
  )
}
