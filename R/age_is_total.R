
#' Identify Labels that Refer to Totals
#'
#' Return a logical vector the same length as `x` with
#' `TRUE` for labels that \pkg{agetime} interprets as
#' totals, and `FALSE` otherwise.
#' 
#' @inheritParams age_lower
#'
#' @returns A logical vector
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
#' Return a logical vector the same length as `x` with
#' `TRUE` for labels that \pkg{agetime} interprets as
#' open age groups, and `FALSE` otherwise.
#' An open age group is one with no upper limit, eg `"100+"`.
#' 
#' @inheritParams age_lower
#'
#' @returns `TRUE` or `FALSE`
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
                open = "right")
}

