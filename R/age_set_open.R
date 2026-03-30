
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
                         unknown_label = c("error", "warn", "silent")) {
  unknown_label <- match.arg(unknown_label)
  inner_set_open(x = x,
                 open = open,
                 make_open_left = FALSE,
                 make_open_right = TRUE,
                 label_type = "age",
                 label_one = "lower",
                 label_multi = "exclude",
                 unknown_label = unknown_label)
}
