#' Make Mapping Between Age Labels
#'
#' Include the pair (x_i, y_j) in the mapping
#' if a person or event included in x_i
#' could, in principle, be included in y_j.
#' 
#' If x_i is total or NA,
#' then all pairs involving
#' x_i are included in the mapping.
#'
#' If y_j is total or NA,
#' then all pairs involving
#' y_j are included in the mapping.
#' 
#'
#' @inheritParams age_lower
#' @param x,y Vectors of age group labels.
#' @param x_complete Each label in `x` maps to
#' at least one label in `y`
#' @param y_complete Each label in `y` maps to
#' at least one label in `x`
#' @param x_unique Each label in `x` maps to
#' at most one label in `y`
#' @param y_unique Each label in `y` maps to
#' at most one label in `x`
#' @param check Action if condition specified
#' by `x_complete`, `y_complete`, `x_unique`,
#' or `y_unique` is not met. The choices are
#' `"error"` (the default) or `"warn"`.
#' @param return_val The format of the
#' return value. The choices are `"data.frame"`
#' (the default) or `"matrix"`.
#'
#' @returns A data.frame or matrix
#'
#' @export
age_mapping <- function(x,
                        y,
                        x_complete = NULL,
                        y_complete = NULL,
                        x_unique = NULL,
                        y_unique = NULL,
                        check = c("error", "warn"),
                        return_val = c("data.frame", "matrix"),
                        invalid = c("error", "warn", "silent")) {
  x <- to_character_or_factor(x = x, nm_x = "x")
  y <- to_character_or_factor(x = y, nm_x = "y")
  return_val <- match.arg(return_val)
  invalid <- match.arg(invalid)
  intervals_x <- intervals(labels = x,
                           type = "age",
                           invalid = invalid)
  intervals_y <- intervals(labels = y,
                           type = "age",
                           invalid = invalid)
  make_mapping(obj1 = intervals_x,
               obj2 = intervals_y,
               x_complete = x_complete,
               y_complete = y_complete,
               x_unique = x_unique,
               y_unique = y_unique,
               check = check,
               return_val = return_val)
}
