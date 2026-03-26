#' Make Mapping Between Age Labels
#'
#' @section The `relation` argument:
#'
#' - `"equals"`. `x` equals `y`. Lower limit of `x`
#'   = lower limit `y`, and upper limit of `x` =
#'   upper limit of `y`.
#' - `"contains"`. `x` contains `y`.
#'   Lower limit of `x` <= lower limit of `y`,
#'   and upper limit of `x` >= upper limit of `y`.
#' - `"contained"`. `x` is contained by `y`.
#'   Lower limit of `x` >= lower limit of `y`, and
#'   Upper limit of `x` <= upper limit of `y`.
#' - `"overlaps"`. `x` overlaps `y`.
#'   Lower limit of `y` <= lower limit
#'   of `x` <  upper limit of `y`, or
#'   lower limit of `y` <= upper limit of `x` <
#'   upper limit of `y`, or both.
#'
#' @inheritParams age_lower
#' @param x Vector of age group labels.
#' @param y Vector of age group labels. If
#' no value supplied, `x` is mapped with itself.
#' @param relation `"equals"` (the default),
#' `"contains"` `"contained"`, or `"overlaps"`
#' @param return_val The format of the
#' return value. The choices are `"data.frame"`
#' (the default) or `"matrix"`.
#'
#' @returns A data.frame or matrix
#'
#' @export
age_mapping <- function(x,
                        y = NULL,
                        relation = c("equals", "contains", "contained", "overlaps"),
                        return_val = c("data.frame", "matrix"),
                        unknown_label = c("error", "warn", "silent")) {
  x <- to_character_or_factor(x = x,
                              nm_x = "x",
                              length_zero_ok = FALSE)
  if (is.null(y))
    y <- x
  else
    y <- to_character_or_factor(x = y,
                                nm_x = "y",
                                length_zero_ok = FALSE)
  relation <- match.arg(relation)
  return_val <- match.arg(return_val)
  unknown_label <- match.arg(unknown_label)
  intervals_x <- intervals(labels = x,
                           label_type = "age",
                           unknown_label = unknown_label)
  intervals_y <- intervals(labels = y,
                           label_type = "age",
                           unknown_label = unknown_label)
  make_mapping(intervals_x = intervals_x,
               intervals_y = intervals_y,
               relation = relation,
               return_val = return_val)
}
