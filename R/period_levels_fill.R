#' Fill in Gaps in Period Levels
#'
#' Fill in gaps in the levels of `x`.
#'
#' If `x` is not a factor, and so does
#' not have levels, convert it to
#' a factor before filling in the levels.
#' 
#' - `period_levels_fill` adds the periods
#'   specified by `breaks`.
#' - `period_levels_fill_one` adds periods with
#'   width 1.
#' - `period_levels_fill_five` adds periods with
#'   width 5.
#' - `period_levels_fill_ten` adds periods with
#'   width 10.
#'
#' @inheritParams period_lower
#' @param breaks Boundaries of the
#' the newly-created periods.
#' (Boundaries supplied by existing
#' periods can be omitted.)
#' @return A factor, the same length as `x`.
#'
#' @seealso
#' [age_levels_fill()] Age equivalent of `period_levels_fill()`
#' [cohort_levels_fill()] Cohort equivalent of `period_levels_fill()`
#'
#' @examples
#' x <- factor(c("2020-2025", "2030-2035"))
#' x
#' period_levels_fill(x) ## uses existing boundaries
#' period_levels_fill(x, breaks = 2028)
#' period_levels_fill_one(x)
#' period_levels_fill_five(x)
#'
#' x <- c("2051-2061", "2021-2031")
#' period_levels_fill_ten(x)
#'
#' ## levels are used by functions
#' ## such as 'table()'
#' x |> table()
#' x |>
#'   period_levels_fill_ten() |>
#'   table()
#'
#' ## sort after filling
#' x |>
#'   period_levels_fill_ten() |>
#'   period_levels_sort() |>
#'   table()
#' @export

# When length(x) == 0 and there are no levels to fill, returns an empty factor.
# If breaks is supplied, levels are built from breaks. When length(x) == 0 but x
# is a factor with levels, levels() are still filled in. The ordered attribute
# is preserved when x is an ordered factor.
period_levels_fill <- function(x,
                               breaks = NULL,
                               x_one = c("lower", "upper"),
                               x_multi = c("include", "exclude"),
                               x_fail = c("error", "warn", "silent")) {
  x_one <- match.arg(x_one)
  x_multi <- match.arg(x_multi)
  x_fail <- match.arg(x_fail)
  inner_levels_fill(x = x,
                    breaks = breaks,
                    width = NULL,
                    label_type = "period",
                    x_one = x_one,
                    x_multi = x_multi,
                    x_fail = x_fail)
}

#' @rdname period_levels_fill
#' @export
period_levels_fill_one <- function(x,
                                   x_one = c("lower", "upper"),
                                   x_multi = c("include", "exclude"),
                                   x_fail = c("error", "warn", "silent")) {
  x_one <- match.arg(x_one)
  x_multi <- match.arg(x_multi)
  x_fail <- match.arg(x_fail)
  inner_levels_fill(x = x,
                    breaks = NULL,
                    width = 1L,
                    label_type = "period",
                    x_one = x_one,
                    x_multi = x_multi,
                    x_fail = x_fail)
}

#' @rdname period_levels_fill
#' @export
period_levels_fill_five <- function(x,
                                    x_one = c("lower", "upper"),
                                    x_multi = c("include", "exclude"),
                                    x_fail = c("error", "warn", "silent")) {
  x_one <- match.arg(x_one)
  x_multi <- match.arg(x_multi)
  x_fail <- match.arg(x_fail)
  inner_levels_fill(x = x,
                    breaks = NULL,
                    width = 5L,
                    label_type = "period",
                    x_one = x_one,
                    x_multi = x_multi,
                    x_fail = x_fail)
}

#' @rdname period_levels_fill
#' @export
period_levels_fill_ten <- function(x,
                                   x_one = c("lower", "upper"),
                                   x_multi = c("include", "exclude"),
                                   x_fail = c("error", "warn", "silent")) {
  x_one <- match.arg(x_one)
  x_multi <- match.arg(x_multi)
  x_fail <- match.arg(x_fail)
  inner_levels_fill(x = x,
                    breaks = NULL,
                    width = 10L,
                    label_type = "period",
                    x_one = x_one,
                    x_multi = x_multi,
                    x_fail = x_fail)
}
