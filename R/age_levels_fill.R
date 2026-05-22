#' Complete a Set of Age Groups
#'
#' @description 
#' If `x` is not a factor, convert
#' it to one, then  add
#' extra age groups to its `"levels"`
#' attribute so that there are no gaps.
#'
#' - `age_levels_fill` adds the age groups
#'   specified by `breaks`.
#' - `age_levels_fill_one` adds age groups with
#'   width 1.
#' - `age_levels_fill_five` adds age groups with
#'   width 5.
#' - `age_levels_fill_ten` adds age groups with
#'   width 10.
#' - `age_levels_fill_life` adds age groups
#'   used by a life table.
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
#' age_levels_fill(x) ## uses existing boundaries
#' table(age_levels_fill(x))
#' age_levels_fill(x, breaks = c(8, 12))
#' age_levels_fill_one(x)
#' age_levels_fill_five(x)
#'
#' x <- c("25-29", "0-4")
#' age_levels_fill_ten(x)
#'
#' x <- c("60+", "0")
#' age_levels_fill_life(x)
#' @export
age_levels_fill <- function(x,
                         breaks = NULL,
                         x_fail = c("error", "warn", "silent")) {
  x_fail <- match.arg(x_fail)
  inner_levels_fill(x = x,
                 breaks = breaks,
                 label_type = "age",
                 x_one = "lower",
                 x_multi = "exclude",
                 x_fail = x_fail)
}

#' @rdname age_levels_fill
#' @export
age_levels_fill_one <- function(x,
                             width,
                             x_fail = c("error", "warn", "silent")) {
  x_fail <- match.arg(x_fail)
  inner_levels_fill(x = x,
                 width = 1L,
                 label_type = "age",
                 x_one = "lower",
                 x_multi = "exclude",
                 x_fail = x_fail)
}

#' @rdname age_levels_fill
#' @export
age_levels_fill_five <- function(x,
                              width,
                              x_fail = c("error", "warn", "silent")) {
  x_fail <- match.arg(x_fail)
  inner_levels_fill(x = x,
                 width = 5L,
                 label_type = "age",
                 x_one = "lower",
                 x_multi = "exclude",
                 x_fail = x_fail)
}


#' @rdname age_levels_fill
#' @export
age_levels_fill_ten <- function(x,
                             width,
                             x_fail = c("error", "warn", "silent")) {
  x_fail <- match.arg(x_fail)
  inner_levels_fill(x = x,
                 width = 10L,
                 label_type = "age",
                 x_one = "lower",
                 x_multi = "exclude",
                 x_fail = x_fail)
}

