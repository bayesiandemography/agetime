
## HAS_TESTS
#' Standardize Age Group Labels
#'
#' @inheritParams age_lower
#'
#' @return A character vector same the length as `x`.
#'
#' @examples
#' x <- c("5to9", "10--14", "100plus")
#' age_standard(x)
#' @export
age_standard <- function(x,
                         unknown_label = c("error", "warn", "silent")) {
  x <- to_character_or_factor(x = x,
                              nm_x = "x",
                              length_zero_ok = TRUE)
  unknown_label <- match.arg(unknown_label)
  intervals <- intervals(labels = x,
                         label_type = "age",
                         unknown_label = unknown_label)
  labels <- make_labels_intervals(intervals = intervals,
                                  label_one = "lower",
                                  label_multi = "exclude")
  i <- get_i_x_to_xunu(intervals)
  labels[i]
}


