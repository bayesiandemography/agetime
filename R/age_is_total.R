#' Identify Age Group Labels for Totals
#'
#' Find age group labels that \pkg{agetime} interprets as totals.
#'
#' @inheritParams age_lower
#'
#' @return Logical vector with the same length as `x`.
#'
#' @seealso
#' - [age_is_open()] Find open age groups
#' - [period_is_total()] Period equivalent of `age_is_total()`
#' - [cohort_is_total()] Cohort equivalent of `age_is_total()`
#'
#' @examples
#' x <- c("20-24", "Total", "100+", "ALL")
#' age_is_total(x)
#' @export

# When length(x) == 0, returns logical(0).
age_is_total <- function(x,
                         x_fail = c("error", "warn", "silent")) {
  x_fail <- match.arg(x_fail)
  inner_is_total(
    x = x,
    label_type = "age",
    x_one = "lower",
    x_multi = "exclude",
    x_fail = x_fail
  )
}


#' Identify Age Labels for Open Age Groups
#'
#' Find age group labels that \pkg{agetime} interprets as
#' open, ie having no upper limit.
#'
#' @inheritParams age_lower
#'
#' @return Logical vector with the same length as `x`.
#'
#' @seealso
#' - [age_is_total()] Find age labels for totals
#' - [cohort_is_open()] Cohort equivalent of `age_is_open()`
#'
#' @examples
#' x <- c("20+", "infant", "100+", "60to79")
#' age_is_open(x)
#' @export

# When length(x) == 0, returns logical(0).
age_is_open <- function(x,
                        x_fail = c("error", "warn", "silent")) {
  x_fail <- match.arg(x_fail)
  inner_is_open(
    x = x,
    label_type = "age",
    x_one = "lower",
    x_multi = "exclude",
    x_fail = x_fail,
    check_open_left = FALSE,
    check_open_right = TRUE
  )
}
