#' Fill in Gaps in Age Group Levels
#'
#' Fill in gaps in the levels of `x`.
#'
#' If `x` is not a factor, and so does
#' not have levels, convert it to
#' a factor before filling in the levels.
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
#' @return A factor, the same length as `x`.
#'
#' @seealso
#' - [period_levels_fill()] Period equivalent of `age_levels_fill()`
#' - [cohort_levels_fill()] Cohort equivalent of `age_levels_fill()`
#'
#' @examples
#' x <- factor(c("0-4", "20-24"))
#' x
#' age_levels_fill(x) ## uses existing boundaries
#' age_levels_fill(x, breaks = c(8, 12))
#' age_levels_fill_one(x)
#' age_levels_fill_five(x)
#'
#' x <- c("25-29", "0-4")
#' age_levels_fill_ten(x)
#'
#' x <- c("60+", "0")
#' age_levels_fill_life(x)
#'
#' ## levels are used by functions
#' ## such as 'table()'
#' x <- c("30-39", "0-9")
#' x |> table()
#' x |>
#'   age_levels_fill() |>
#'   table()
#'
#' ## sort after filling
#' x |>
#'   age_levels_fill() |>
#'   age_levels_sort() |>
#'   table()
#' @export

# When length(x) == 0 and there are no levels to fill, returns an empty factor.
# If breaks is supplied, levels are built from breaks. When length(x) == 0 but x
# is a factor with levels, levels() are still filled in. The ordered attribute
# is preserved when x is an ordered factor.
age_levels_fill <- function(x,
                            breaks = NULL,
                            x_fail = c("error", "warn", "silent")) {
  x_fail <- match.arg(x_fail)
  inner_levels_fill(x = x,
                    breaks = breaks,
                    width = NULL,
                    label_type = "age",
                    x_one = "lower",
                    x_multi = "exclude",
                    x_fail = x_fail)
}

#' @rdname age_levels_fill
#' @export
age_levels_fill_one <- function(x,
                                x_fail = c("error", "warn", "silent")) {
  x_fail <- match.arg(x_fail)
  inner_levels_fill(x = x,
                    breaks = NULL,
                    width = 1L,
                    label_type = "age",
                    x_one = "lower",
                    x_multi = "exclude",
                    x_fail = x_fail)
}

#' @rdname age_levels_fill
#' @export
age_levels_fill_five <- function(x,
                                 x_fail = c("error", "warn", "silent")) {
  x_fail <- match.arg(x_fail)
  inner_levels_fill(x = x,
                    breaks = NULL,
                    width = 5L,
                    label_type = "age",
                    x_one = "lower",
                    x_multi = "exclude",
                    x_fail = x_fail)
}

#' @rdname age_levels_fill
#' @export
age_levels_fill_ten <- function(x,
                                x_fail = c("error", "warn", "silent")) {
  x_fail <- match.arg(x_fail)
  inner_levels_fill(x = x,
                    breaks = NULL,
                    width = 10L,
                    label_type = "age",
                    x_one = "lower",
                    x_multi = "exclude",
                    x_fail = x_fail)
}


#' @rdname age_levels_fill
#' @export
age_levels_fill_life <- function(x,
                                 x_fail = c("error", "warn", "silent")) {
  x_fail <- match.arg(x_fail)
  inner_levels_fill_life(x = x,
                         x_fail = x_fail)
}
  
   
