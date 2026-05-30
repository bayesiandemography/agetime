
#' Identify Cohort Labels for Totals
#'
#' Find cohort labels that \pkg{agetime} interprets as totals.
#' 
#' @inheritParams cohort_lower
#'
#' @return Logical vector the same length as `x`.
#'
#' @seealso
#' - [cohort_is_open()] Find open cohorts
#' - [age_is_total()] Age equivalent of `cohort_is_total()`
#' - [period_is_total()] Period equivalent of `cohort_is_total()`
#'
#' @examples
#' x <- c("2020-2025", "Total", "1999", "ALL")
#' cohort_is_total(x)
#' @export

# When length(x) == 0, returns logical(0).
cohort_is_total <- function(x, 
                            x_one = c("lower", "upper"),
                            x_multi = c("include", "exclude"),
                            x_fail = c("error", "warn", "silent")) {
  x_fail <- match.arg(x_fail)
  inner_is_total(x = x,
                 label_type = "cohort",
                 x_one = x_one,
                 x_multi = x_multi,
                 x_fail = x_fail)
}


#' Identify Cohort Labels for Open Cohorts
#'
#' Find cohort labels that \pkg{agetime} interprets as
#' open, ie  having no lower limit.
#' 
#' @inheritParams cohort_lower
#'
#' @return Logical vector the same length as `x`.
#'
#' @seealso
#' - [cohort_is_total()] Find cohort labels for totals
#' - [age_is_open()] Age equivalent of `cohort_is_open()`
#'
#' @examples
#' x <- c("2020", "<1900", "2040-2050", "<2022")
#' cohort_is_open(x)
#' @export

# When length(x) == 0, returns logical(0).
cohort_is_open <- function(x, 
                           x_one = c("lower", "upper"),
                           x_multi = c("include", "exclude"),
                           x_fail = c("error", "warn", "silent")) {
  x_fail <- match.arg(x_fail)
  inner_is_open(x = x,
                label_type = "cohort",
                x_one = x_one,
                x_multi = x_multi,
                x_fail = x_fail,
                check_open_left = TRUE,
                check_open_right = FALSE)
}

