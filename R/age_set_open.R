
#' Define Open Age Group
#'
#' Set an open age group, i.e. an age group
#' with no upper limit. Replace existing
#' age groups where necessary.
#' 
#' @inheritParams age_lower
#' @param open Lower limit of open age group.
#'
#' @returns Modified version of `x`.
#'
#' @examples
#' x <- c("20-24", "80-84", "100+")
#' age_set_open(x, open = 80)
#' age_set_open(x, open = 50)
#' @export
age_set_open <- function(x,
                         open,
                         parse_fail = c("error", "warn", "silent")) {
  parse_fail <- match.arg(parse_fail)
  inner_set_open(x = x,
                 open = open,
                 make_open_left = FALSE,
                 make_open_right = TRUE,
                 label_type = "age",
                 parse_one = "lower",
                 parse_multi = "exclude",
                 parse_fail = parse_fail)
}
