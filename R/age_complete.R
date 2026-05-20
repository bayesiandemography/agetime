#' Complete a Set of Age Groups
#'
#' @description 
#' Convert `x` to a factor, and add
#' extra age groups to its `"levels"`
#' attribute so that the levels
#' have no gaps.
#'
#' - `age_complete` adds the age groups
#'   specified by `breaks`.
#' - `age_complete_one` adds age groups with
#'   width 1.
#' - `age_complete_five` adds age groups with
#'   width 5.
#' - `age_complete_ten` adds age groups with
#'   width 10.
#' - `age_complete_life` adds the age groups
#'   needed by a life table.
#'
#' @inheritParams age_lower
#' @param breaks Boundaries of the
#' the newly-created age groups.
#' (Boundaries supplied by existing
#' age groups can be omitted.)
#'
#' @returns
#' A factor, the same length as `x`.
#' 
#' @examples
#' x <- factor(c("0-4", "20-24"))
#' x
#' age_complete(x) ## uses existing boundaries
#' age_complete(x, breaks = c(8, 12))
#' age_complete_one(x)
#' age_complete_five(x)
#'
#' x <- c("25-29", "0-4")
#' age_complete_ten(x)
#'
#' x <- c("60+", "0")
#' age_complete_life(x)
#' @export
age_complete <- function(x,
                         breaks = NULL,
                         x_fail = c("error", "warn", "silent")) {
  x_fail <- match.arg(x_fail)
  inner_complete(x = x,
                 breaks = breaks,
                 label_type = "age",
                 x_one = "lower",
                 x_multi = "exclude",
                 x_fail = x_fail)
}

#' @rdname age_complete
#' @export
age_complete_one <- function(x,
                             width,
                             x_fail = c("error", "warn", "silent")) {
  x_fail <- match.arg(x_fail)
  inner_complete(x = x,
                 width = 1L,
                 label_type = "age",
                 x_one = "lower",
                 x_multi = "exclude",
                 x_fail = x_fail)
}

#' @rdname age_complete
#' @export
age_complete_five <- function(x,
                              width,
                              x_fail = c("error", "warn", "silent")) {
  x_fail <- match.arg(x_fail)
  inner_complete(x = x,
                 width = 5L,
                 label_type = "age",
                 x_one = "lower",
                 x_multi = "exclude",
                 x_fail = x_fail)
}


#' @rdname age_complete
#' @export
age_complete_ten <- function(x,
                             width,
                             x_fail = c("error", "warn", "silent")) {
  x_fail <- match.arg(x_fail)
  inner_complete(x = x,
                 width = 10L,
                 label_type = "age",
                 x_one = "lower",
                 x_multi = "exclude",
                 x_fail = x_fail)
}

