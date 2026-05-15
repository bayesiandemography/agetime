
#' Identify Cohort Labels that Refer to Totals
#'
#' Find cohort labels that \pkg{agetime} interprets as totals.
#' 
#' @inheritParams cohort_lower
#'
#' @returns A logical vector the same length as `x`.
#'
#' @examples
#' x <- c("2020-2025", "Total", "1999", "ALL")
#' cohort_is_total(x)
#' @export
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


#' Identify Labels that Refer to Open Cohorts
#'
#' Find cohort labels that \pkg{agetime} interprets as
#' open, ie as having no lower limit.
#' 
#' @inheritParams cohort_lower
#'
#' @returns A logical vector the same length as `x`.
#'
#' @examples
#' x <- c("2020", "<1900", "2040-2050", "<2022")
#' cohort_is_open(x)
#' @export
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

