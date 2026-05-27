
#' Define Open Age Group
#'
#' Set an open age group, i.e. an age group
#' with no upper limit. Replace existing
#' age groups where necessary.
#' 
#' @inheritParams age_lower
#' @param open Lower limit of open age group.
#'
#' @returns
#' A factor if `x` is a factor; otherwise a character vector.
#'
#' @examples
#' x <- c("20-24", "80-84", "100+")
#' age_set_open(x, open = 80)
#' age_set_open(x, open = 50)
#' @export
age_set_open <- function(x,
                         open,
                         x_fail = c("error", "warn", "silent")) {
  x_fail <- match.arg(x_fail)
  inner_set_open(x = x,
                 open = open,
                 make_open_left = FALSE,
                 make_open_right = TRUE,
                 label_type = "age",
                 x_one = "lower",
                 x_multi = "exclude",
                 x_fail = x_fail)
}
