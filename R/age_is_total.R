
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
                         unknown_label = c("error", "warn", "silent")) {
  unknown_label <- match.arg(unknown_label)
  inner_is_total(x = x,
                 label_type = "age",
                 label_one = "lower",
                 label_multi = "exclude",
                 unknown_label = unknown_label)
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
                        unknown_label = c("error", "warn", "silent")) {
  unknown_label <- match.arg(unknown_label)
  inner_is_open(x = x,
                label_type = "age",
                label_one = "lower",
                label_multi = "exclude",
                unknown_label = unknown_label,
                check_open_left = FALSE,
                check_open_right = TRUE)
}

