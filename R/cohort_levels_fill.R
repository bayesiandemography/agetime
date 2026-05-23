#' Fill in Gaps in Cohort Levels
#'
#' Fill in gaps in the levels of `x`.
#'
#' If `x` is not a factor, and so does
#' not have levels, convert it to
#' a factor before filling in the levels.
#' 
#' - `cohort_levels_fill` adds the cohorts
#'   specified by `breaks`.
#' - `cohort_levels_fill_one` adds cohorts with
#'   width 1.
#' - `cohort_levels_fill_five` adds cohorts with
#'   width 5.
#' - `cohort_levels_fill_ten` adds cohorts with
#'   width 10.
#'
#' @inheritParams cohort_lower
#' @param breaks Boundaries of the
#' the newly-created cohorts.
#' (Boundaries supplied by existing
#' cohorts can be omitted.)
#'
#' @returns
#' A factor, the same length as `x`.
#' 
#' @examples
#' x <- factor(c("2020-2025", "2030-2035"))
#' x
#' cohort_levels_fill(x) ## uses existing boundaries
#' cohort_levels_fill(x, breaks = 2028)
#' cohort_levels_fill_one(x)
#' cohort_levels_fill_five(x)
#'
#' x <- c("2051-2061", "2021-2031")
#' cohort_levels_fill_ten(x)
#'
#' ## levels are used by functions
#' ## such as 'table()'
#' x |> table()
#' x |>
#'   cohort_levels_fill_ten() |>
#'   table()
#'
#' ## sort after filling
#' x |>
#'   cohort_levels_fill_ten() |>
#'   cohort_levels_sort() |>
#'   table()
#' @export
cohort_levels_fill <- function(x,
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
                    label_type = "cohort",
                    x_one = x_one,
                    x_multi = x_multi,
                    x_fail = x_fail)
}

#' @rdname cohort_levels_fill
#' @export
cohort_levels_fill_one <- function(x,
                                   x_one = c("lower", "upper"),
                                   x_multi = c("include", "exclude"),
                                   x_fail = c("error", "warn", "silent")) {
  x_one <- match.arg(x_one)
  x_multi <- match.arg(x_multi)
  x_fail <- match.arg(x_fail)
  inner_levels_fill(x = x,
                    breaks = NULL,
                    width = 1L,
                    label_type = "cohort",
                    x_one = x_one,
                    x_multi = x_multi,
                    x_fail = x_fail)
}

#' @rdname cohort_levels_fill
#' @export
cohort_levels_fill_five <- function(x,
                                    x_one = c("lower", "upper"),
                                    x_multi = c("include", "exclude"),
                                    x_fail = c("error", "warn", "silent")) {
  x_one <- match.arg(x_one)
  x_multi <- match.arg(x_multi)
  x_fail <- match.arg(x_fail)
  inner_levels_fill(x = x,
                    breaks = NULL,
                    width = 5L,
                    label_type = "cohort",
                    x_one = x_one,
                    x_multi = x_multi,
                    x_fail = x_fail)
}

#' @rdname cohort_levels_fill
#' @export
cohort_levels_fill_ten <- function(x,
                                   x_one = c("lower", "upper"),
                                   x_multi = c("include", "exclude"),
                                   x_fail = c("error", "warn", "silent")) {
  x_one <- match.arg(x_one)
  x_multi <- match.arg(x_multi)
  x_fail <- match.arg(x_fail)
  inner_levels_fill(x = x,
                    breaks = NULL,
                    width = 10L,
                    label_type = "cohort",
                    x_one = x_one,
                    x_multi = x_multi,
                    x_fail = x_fail)
}
