#' Identify Age Group Labels for Subtotals
#'
#' Find categories representing subtotals in age group labels.
#'
#' A subtotal is an age group that is fully covered by
#' other age groups in the same set of labels.
#' For instance, in the labels `c("0-4", "5-9", "10-14", "0-9", "Total")`,
#' `"0-9"` is a subtotal.
#'
#' Subtotals are distinct from grand total labels
#' such as `"Total"` or `"All"`, which are identified
#' by [age_is_total()].
#'
#' @inheritParams age_lower
#'
#' @return Logical vector with the same length as `labels`.
#'
#' @seealso
#' - [period_is_subtotal()] Period equivalent of `age_is_subtotal()`
#' - [cohort_is_subtotal()] Cohort equivalent of `age_is_subtotal()`
#' - [age_is_total()] Identify grand totals
#' - [age_is_missing()] Identify missing age group labels
#' - [age_is_open_right()] Identify age groups open on right
#'
#' @examples
#' labels <- c(
#'   age_labels_five(),
#'   "0-14",
#'   "15-64",
#'   "65+",
#'   "Total"
#' )
#' age_is_subtotal(labels)
#' age_is_total(labels)
#'
#' ## subtotals must fully cover range
#' labels_no_20_24 <- setdiff(labels, "20-24")
#' age_is_subtotal(labels_no_20_24) ## "15-64" not subtotal
#'
#' ## subtotals can overlap
#' labels_064 <- c(labels, "0-64")
#' age_is_subtotal(labels_064)
#'
#' ## use to filter data
#' library(dplyr, warn.conflicts = FALSE)
#' df <- data.frame(
#'   age = c("0-4", "5-9", "10-14", "0-14"),
#'   value = c(100, 200, 300, 400)
#' )
#' df |>
#'   filter(!age_is_subtotal(age))
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
