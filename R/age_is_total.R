
#' Identify Age Group Labels that Refer to Totals
#'
#' Find age group labels that \pkg{agetime} interprets as totals.
#' 
#' @inheritParams age_lower
#'
#' @returns A logical vector the same length as `x`.
#'
#' @examples
#' x <- c("20-24", "Total", "100+", "ALL")
#' age_is_total(x)
#' @export
age_is_total <- function(x, 
                         x_fail = c("error", "warn", "silent")) {
  x_fail <- match.arg(x_fail)
  inner_is_total(x = x,
                 label_type = "age",
                 x_one = "lower",
                 x_multi = "exclude",
                 x_fail = x_fail)
}


#' Identify Labels that Refer to Open Age Groups
#'
#' Find age group labels that \pkg{agetime} interprets as
#' open, ie as having no upper limit.
#' 
#' @inheritParams age_lower
#'
#' @returns A logical vector the same length as `x`.
#'
#' @examples
#' x <- c("20+", "infant", "100+", "60to79")
#' age_is_open(x)
#' @export
age_is_open <- function(x, 
                        x_fail = c("error", "warn", "silent")) {
  x_fail <- match.arg(x_fail)
  inner_is_open(x = x,
                label_type = "age",
                x_one = "lower",
                x_multi = "exclude",
                x_fail = x_fail,
                check_open_left = FALSE,
                check_open_right = TRUE)
}

