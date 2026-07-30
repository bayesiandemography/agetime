## HAS_TESTS
#' Standardize Age Group Labels
#'
#' Convert age group labels to the default \pkg{agetime} format for age.
#'
#' @section Rules for formatting output:
#' 
#' | *Interval type* | *Rule*        | *Example*     |
#' |---------------|-------------|-------------|
#' | single | `[a,a+1) -> "a"` | `[10,11) -> "10"` |
#' | multi | `[a,a+n) -> "a-<a+n-1>"` | `[10,15) -> "10-14"` |
#' | open on right | `[a,Inf) -> "a+"` | `[85,Inf) -> "85+"` |
#'
#' @inheritParams age_lower
#' @return Character vector or factor with the same length as `labels`.
#'
#' @seealso
#' - [period_standard()] Period equivalent of `age_standard()`
#' - [cohort_standard()] Cohort equivalent of `age_standard()`
#' - [age_labels()] Create age group labels
#'
#' @examples
#' labels <- c("5to9", "10--14", "100plus", "all")
#' age_standard(labels)
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
    interpret_multi = "exclude",
    interpret_fail = interpret_fail
  )
}
