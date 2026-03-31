
## HAS_TESTS
#' Standardize Period Labels
#'
#' Convert period labels to a 'standard' format.
#'
#' @inheritParams period_lower
#'
#' @return A modified version of `x`.
#'
#' @examples
#' x <- c("2025to2030", "1910--1914", " 2022 ")
#' period_standard(x)
#' @export
period_standard <- function(x,
                            label_one = c("lower", "upper"),
                            label_multi = c("include", "exclude"),
                            unknown_label = c("error", "warn", "silent")) {
  label_one <- match.arg(label_one)
  label_multi <- match.arg(label_multi)
  unknown_label <- match.arg(unknown_label)
  inner_standard(x = x,
                 label_type = "period",
                 label_one = label_one,
                 label_multi = label_multi,
                 unknown_label = unknown_label)
}


