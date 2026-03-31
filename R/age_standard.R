
## HAS_TESTS
#' Standardize Age Group Labels
#'
#' Convert age group labels to a 'standard' format.
#'
#' @inheritParams age_lower
#'
#' @return A modified version of `x`.
#'
#' @examples
#' x <- c("5to9", "10--14", "100plus")
#' age_standard(x)
#' @export
age_standard <- function(x,
                         unknown_label = c("error", "warn", "silent")) {
  unknown_label <- match.arg(unknown_label)
  inner_standard(x = x,
                 label_type = "age",
                 label_one = "lower",
                 label_multi = "exclude",
                 unknown_label = unknown_label)
}


