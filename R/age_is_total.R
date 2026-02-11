
#' Identify Labels that Refer to Totals
#' 
#' @inheritParams age_lower
#'
#' @returns A logical vector the same
#' length as `x`.
#'
#' @examples
#' x <- c("20-24", "Total", "100+", "ALL")
#' age_is_total(x)
#' @export
age_is_total <- function(x, 
                      invalid = c("error", "warn", "silent")) {
  x <- to_character_or_factor(x = x, nm_x = "x")
  stop("not written yet")
}


#' Identify Labels that Refer to Open Age Groups
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
                        invalid = c("error", "warn", "silent")) {
  x <- to_character_or_factor(x = x, nm_x = "x")
  stop("not written yet")
}

